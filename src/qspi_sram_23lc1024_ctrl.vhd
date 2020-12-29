----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2020 16:47:11
-- Design Name: 
-- Module Name: spi_sram_ctrl - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:     This version merges the SERDES into the spi_sram_ctrl
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity qspi_sram_23lc1024_ctrl is
    Generic(
        DEBUG_ILAS : boolean := false;
        
        --        SERDES_WORD_SIZE : integer := 8;
        DATA_W : integer := 32; -- must be a multiple of SERDES_WORD_SIZE
        ADDR_W : integer := 17 -- not reparameterisable, some padding logic depends on this
    );
    Port ( 
        spi_clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        
        -- Pins for 23LC1024
        -- NOTE Directions are "from the chips perspective": NOT the FPGA perspective
        SCK         : out std_logic := '0'; -- clock that goes out to the SRAM chip
        CS_N        : out std_logic;
        SI_SIO0     : inout std_logic;
        SO_SIO1     : inout std_logic;
        SIO2        : inout std_logic;
        HOLD_N_SIO3 : inout std_logic;
        
        cmd_ready_out   : out STD_LOGIC;
        cmd_valid_in    : in STD_LOGIC;
        cmd_address_in  : in STD_LOGIC_VECTOR(ADDR_W-1 downto 0);
        cmd_rw_in       : in STD_LOGIC;
        cmd_wdata_in    : in STD_LOGIC_VECTOR(DATA_W-1 downto 0);
        rsp_rdata_out   : out STD_LOGIC_VECTOR(DATA_W-1 downto 0);
        rsp_ready_in    : in STD_LOGIC;
        rsp_valid_out   : out STD_LOGIC
                        
    );
           
end qspi_sram_23lc1024_ctrl;

architecture rtl of qspi_sram_23lc1024_ctrl is


    -- begin read/write by bringing CS_N LOW 
    -- end read/write by  bringing CS_N HIGH
    
    -- READ Sequence
        -- select device by bringing CS_N LOW
        -- send 8-bit READ instruction
        -- send 24-bit address (first 7 MSBs are don't care)
        -- data then gets shifted out on the SO pin
        -- if in sequential mode, keep clocking with CS_N enabled to continue the read
        -- deselect device by  bringing CS_N HIGH
        
    -- WRITE Sequence
        -- select device by bringing CS_N LOW 
        -- send 8-bit WRITE instruction
        -- send 24-bit address (first 7 MSBs are don't care)
        -- send data byte to write
        -- (can shift in additional write bytes if in page/sequential mode)
        
    -- Instructions
        -- 0000_0011    0x03    READ    Read Command
        -- 0000_0010    0x02    WRITE   Write Command
        -- 0011_1011    0x3B    EDIO    Enter SDI Mode
        -- 0011_1000    0x38    EQIO    Enter SQI Mode
        -- 1111_1111    0xFF    RSTIO   Reset to SPI Extended Mode
        -- 0000_0101    0x05    RDMR    Read 'Mode Register'
        -- 0000_0001    0x01    WRMR    Write 'Mode Register'
    
    -- Mode Register    
        -- 0000_0000    0x00    BYTE
        -- 1000_0000    0x80    PAGE 
        -- 0100_0000    0x40    SEQUENTIAL (default)
        -- 1100_0000    0xC0    Reserved
    
    -- 23LC1024 has an 8-bit instruction register, and never uses full-duplex communication, which makes the controller easier
        -- Simplex: one-way communication
        -- Half Duplex: two-way communication, only one way at a time (SPI, SDI, SQI)
        -- Full Duplex: simultaneous two-way communication (SPI only)
        
    -- 23LC1024 Address is 17-bit byte addressable 
    -- bytes 0x00000 - 0x1FFFF 
    -- These are sent as 24-bit addresses, with the first 7 bits as dummmy bits 
    
     
    -- state machine for commands
    type t_state is (SRESET, START, RESET_MODE_SPI, DEASSERT_CS_0, SET_MODE_SQI, DEASSERT_CS_1, IDLE, SEND_CMD_ADDR_WDATA, DUMMY, RDATA, DEASSERT_CS);
    signal state : t_state := SRESET;
    
    type t_mode is (SPI, SQI);
    signal spi_mode : t_mode := SPI;
    
    signal SCK_EN : std_logic := '0';
    
    -- from the IO buffers
    
    signal sqi_pin_direction : std_logic; -- 1 for write, 0 for read
    
    signal io_buf_output_disable : std_logic_vector(3 downto 0);    -- T
    
    signal serial_in : std_logic_vector(3 downto 0);
    signal serial_out : std_logic_vector(3 downto 0);
    
    -- register commands as they come in
    signal cmd_address_reg : std_logic_vector(ADDR_W-1 downto 0);
    signal cmd_rw_reg      : std_logic;
    signal cmd_wdata_reg   : std_logic_vector(DATA_W-1 downto 0);
    
    
    -- we are switching to oversize Data Shifters to make the state machine quicker to construct
    -- may separate out CMD and ADDR sending later to make it easier to follow on a waveform
    
    constant SPI_CMD_W : integer := 8;      -- 8 bit 23lc1024 command
    constant SPI_ADDR_W  : integer := 24;   -- 3 byte addressing
    constant SPI_SHIFT_OUT_W : integer := SPI_CMD_W + SPI_ADDR_W + DATA_W; 
    
    constant SPI_CMD_H  : integer := 63;
    constant SPI_CMD_L  : integer := 56;
    constant SPI_ADDR_PAD_H : integer := 55;
    constant SPI_ADDR_PAD_L : integer := 49;
    constant SPI_ADDR_H : integer := 48;
    constant SPI_ADDR_L : integer := 32;
    constant SPI_WDATA_H  : integer := 31;
    constant SPI_WDATA_L  : integer := 0;
    constant SPI_DUMMY_H  : integer := 31;  -- only need 1 dummy byte but we might as well 0 the rest of the register
    constant SPI_DUMMY_L  : integer := 0;
        
    -- TODO: allow runtime changing of burst length
    signal data_shifter_in  : std_logic_vector(DATA_W-1 downto 0);      -- Read data, max 1 data word for now
    signal data_shifter_out : std_logic_vector(SPI_SHIFT_OUT_W-1 downto 0);   -- Command (8), Address (24), Write Data
       
    signal clk_counter : integer;   -- counts cycles of SPI transmission

   
    constant SPI_CMD_READ   : std_logic_vector(SPI_CMD_W-1 downto 0) := x"03";
    constant SPI_CMD_WRITE  : std_logic_vector(SPI_CMD_W-1 downto 0) := x"02";
    constant SPI_CMD_EDIO   : std_logic_vector(SPI_CMD_W-1 downto 0) := x"3B";
    constant SPI_CMD_EQIO   : std_logic_vector(SPI_CMD_W-1 downto 0) := x"38";
    constant SPI_CMD_RSTIO  : std_logic_vector(SPI_CMD_W-1 downto 0) := x"FF";
    constant SPI_CMD_RDMR   : std_logic_vector(SPI_CMD_W-1 downto 0) := x"05";
    constant SPI_CMD_WRMR   : std_logic_vector(SPI_CMD_W-1 downto 0) := x"01";
     
    constant BYTES_TO_TRANSFER : integer := 4; 

    attribute MARK_DEBUG : boolean;
    attribute MARK_DEBUG of CS_N : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of serial_in : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of serial_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of clk_counter : signal is DEBUG_ILAS;

    attribute MARK_DEBUG of rsp_rdata_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of rsp_valid_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of data_shifter_in : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of data_shifter_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of io_buf_output_disable : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of SCK_EN : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of cmd_address_reg : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of cmd_rw_reg : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of cmd_wdata_reg : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of state : signal is DEBUG_ILAS;
    
   
begin
    
    -- NOTE ABOUT SCK, spi_clk and CS_n
    --
    -- To make sure CS_n is asserted before the data arrives, the ODDR SCK output inverts the spi_clk to make SCK
    -- this has the effect of "delaying" the data clock by half a cycle, so we can set CS and data on the same cycle of spi_clk
    -- to make our state machine easier
    -- We need to make sure that we keep the CS asserted for one additional cycle beyond our final data bit to prevent it from deasserting too soon
    --

    -- we send MSB first
    
    
    -- T is '1' when we use the inout as an input pin, '0' when we are using the inout as an output pin
    -- as 'T' disables the output buffer
    
    --  Signal      : Direction SPI : Function SPI  : Direction SQI : Function SQI
    ----------------------------------------------------------------------------------------
    --  SI_SIO0     : output (T=0)  : MOSI          : T             : MOSI/MISO 0
    --  SO_SIO1     : input  (T=1)  : MISO          : T             : MOSI/MISO 1
    --  SIO2        : output (T=0)  : N/A (Keep 0)  : T             : MOSI/MISO 2
    --  SIO3_HOLD_N : output (T=0)  : Hold (Keep 1) : T             : MOSI/MISO 3

    spi_mode_comb_proc : process(all) is 
    begin
        -- defaults to prevent latches
        -- data_shifter_in(3 downto 0) <= x"0"; -- this won't work as depending on SPI or SQI
        -- serial_out(3 downto 0) <= x"0";
          
        case(spi_mode) is
            when SPI => 
                io_buf_output_disable <= b"0010";   -- set T
                
                
                -- TODO: These infer latches when synthesised
                
                serial_out(0) <= data_shifter_out(DATA_W-1+32); -- this goes to MOSI pin SI_SIO0
--                data_shifter_in(0) <= serial_in(1);             -- this comes from the MISO pin SO_SIO1
                
                
                serial_out(1) <= '0'; --    unused, but needed to avoid latch
                serial_out(2) <= '0'; --    SIO2, keep '0'
                serial_out(3) <= '1'; --    HOLD_N, keep '1'
            when SQI => 
                io_buf_output_disable <= (others => not sqi_pin_direction); -- set T
                serial_out(3 downto 0) <= data_shifter_out(SPI_SHIFT_OUT_W-1 downto SPI_SHIFT_OUT_W-1-3);   -- output the top 4 bits of the output data shifter 
--                data_shifter_in(3 downto 0) <= serial_in(3 downto 0);                           -- take the serial_in as the bottom 4 bits of the input data_shifter
            
        end case;
    end process spi_mode_comb_proc;
    
    
    spi_proc : process(spi_clk) is 
    begin
        if rising_edge(spi_clk) then 
            -- when we reset, the RAM chip won't be reset, so it will remain in whatever state it was in before - so we set all the output pins to '1' 
            -- and clock out 8 times to make sure we are in a known state  
            if reset = '1' then
                state  <= SRESET;
                CS_N <= '1'; -- deassert chip select
                SCK_EN <= '0'; -- stop SCK
                cmd_ready_out <= '0'; -- not ready to receive new command
            else 
           
            
            
                case state is 
                    when SRESET => 
                        state <= START;
                        
                    when START => 
                        -- make sure the RAM chip is in a known state
                        state <= RESET_MODE_SPI;
                        sqi_pin_direction <= '1';   -- write
                        spi_mode <= SQI;
                        
                        -- assert chip select (half cycle ahead of data)
                        CS_N <= '0';
                        SCK_EN <= '1'; -- and start SCK
                        
                        -- load top 8 bits with command
                        data_shifter_out(SPI_CMD_H downto SPI_CMD_L) <= SPI_CMD_RSTIO;
                        
                        -- reset clk_counter
                        clk_counter <= 0; 
                    
                    when RESET_MODE_SPI =>
                        -- if we have had 8 cycles out outputting SPI_CMD_RSTIO (FF)
                        
                        clk_counter <= clk_counter + 1;
                        
                        if clk_counter = 8-1 then
                            state <= DEASSERT_CS_0;
                            -- note: CS_N is half a cycle ahead of this state machine, so deassert it one cycle later to make sure it lines up with our data
                            CS_N <= '1'; -- 1/2 cycle after data has gone
                            SCK_EN <= '0'; -- and stop SCK
                        end if;       
                        
                        
                    when DEASSERT_CS_0 => 
                        spi_mode <= SPI;    -- we are now in SPI mode
                        
                        
                        
                        -- after that is finished, start sending the next command to move us into Quad mode
                        if CS_N = '1' then  -- deasserted
                            state <= SET_MODE_SQI;
                            
                            CS_N <= '0'; -- assert CS_N again 
                            SCK_EN <= '1'; -- and start SCK
                                   
                            -- load top 8 bits with command
                            data_shifter_out(SPI_CMD_H downto SPI_CMD_L) <= SPI_CMD_EQIO; --0x38 
                            clk_counter <= 0;
                        end if;
                    
                        
                        
                    when SET_MODE_SQI => 
                        -- we know we are in SPI mode, so we need 8 cycles to shift out the whole word into the SRAM
                        
                        clk_counter <= clk_counter + 1;
                        data_shifter_out(SPI_SHIFT_OUT_W-1 downto 0) <= data_shifter_out(SPI_SHIFT_OUT_W-2 downto 0) & b"0";
                                                
                        if clk_counter = 8-1 then
                            state <= DEASSERT_CS_1;
                            -- note: CS_N is half a cycle ahead, so deassert it one cycle later to make sure it lines up with our data
                            CS_N <= '1'; -- 1/2 cycle after data has gone
                            SCK_EN <= '0'; -- and stop SCK
                        end if;     
                
                    when DEASSERT_CS_1 => 
                        spi_mode <= SQI;    -- we are now in SQI mode
                        
                        -- after that is finished, start sending the next command to move us into Quad mode
                        if CS_N = '1' then  -- deasserted
                            state <= IDLE;
                            cmd_ready_out <= '1'; -- default ready to receive new command
                        end if;
                
                
                    when IDLE =>
                        cmd_ready_out <= '1'; -- default ready to receive new command
                        
                        if cmd_valid_in = '1' then -- when new command is ready
                            -- accept command and block further commands being accepted 
                            cmd_ready_out <= '0';   
                            cmd_rw_reg <= cmd_rw_in;
                            cmd_address_reg <= cmd_address_in;
                            cmd_wdata_reg <= cmd_wdata_in;
                            
                            
                            -- start a new transaction (use unregistered cmd as same clock cycle)
                            state <= SEND_CMD_ADDR_WDATA;
                            sqi_pin_direction <= '1'; -- write
                            CS_N <= '0'; -- note: CS_N is half a cycle ahead, so deassert it one cycle later to make sure it lines up with our data
                            SCK_EN <= '1'; -- and start SCK
                            
                            clk_counter <= 0;
                            
                            -- Set up data shifter to write all components out over SQI
                            if cmd_rw_in = '1' then 
                                -- write
                                data_shifter_out(SPI_CMD_H downto SPI_CMD_L)            <= SPI_CMD_WRITE;
                                data_shifter_out(SPI_ADDR_PAD_H downto SPI_ADDR_PAD_L)  <= (others=>'0');
                                data_shifter_out(SPI_ADDR_H downto SPI_ADDR_L)          <= cmd_address_in;
                                data_shifter_out(SPI_WDATA_H downto SPI_WDATA_L)        <= cmd_wdata_in;
                            else -- read
                                data_shifter_out(SPI_CMD_H downto SPI_CMD_L)            <= SPI_CMD_READ;
                                data_shifter_out(SPI_ADDR_PAD_H downto SPI_ADDR_PAD_L)  <= (others=>'0');
                                data_shifter_out(SPI_ADDR_H downto SPI_ADDR_L)          <= cmd_address_in;
                                data_shifter_out(SPI_DUMMY_H downto SPI_DUMMY_L)        <= (others => '0');
                            
                            end if;
                            
                            
                        end if;
                            
                        
                    when SEND_CMD_ADDR_WDATA => 
                        
                        clk_counter <= clk_counter + 1;
                        -- shift data out 4 bits (SQI)
                        data_shifter_out(SPI_SHIFT_OUT_W-1 downto 0) <= data_shifter_out(SPI_SHIFT_OUT_W-1-4 downto 0) & b"0000";
                        
                        if cmd_rw_reg = '1' then -- write
                            -- we shift out cmd, addr and wdata so there is nothing left to do
                            if clk_counter = 2+6+BYTES_TO_TRANSFER*2-1 then -- command, address and wdata (8 clocks then 2 clocks per byte as required) 
                                state <= DEASSERT_CS;
                                CS_N <= '1'; -- 1/2 cycle after data has gone
                                SCK_EN <= '0'; -- and stop SCK
                                rsp_valid_out <= '1';
                                
                            end if;
                        else -- read
                            if clk_counter = 2+6+2-1 then -- command, address and dummy byte (10 clocks total)
                                state <= RDATA;
                                sqi_pin_direction <= '0'; -- read
                                clk_counter <= 0;   -- reset to send out 
                            end if;
                            
                        end if;
                                                
                    when DUMMY => 
                    
                    when RDATA =>
                        clk_counter <= clk_counter+1;
                        -- old, relied on latch
                         -- data_shifter_in(DATA_W-1 downto 4) <= data_shifter_in(DATA_W-1-4 downto 0); -- bottom 4 bits are assigned combinationally to serial_in(3 downto 0) (from SIO3-SIO0)
                        data_shifter_in(DATA_W-1 downto 0) <= data_shifter_in(DATA_W-1-4 downto 0) & serial_in (3 downto 0);
                        
                        if clk_counter = BYTES_TO_TRANSFER*2-1 then
                            state <= DEASSERT_CS;
                            CS_N <= '1';    -- 1/2 cycle after data has gone
                            SCK_EN <= '0';  -- and stop SCK
                            -- old, relied on latch
--                            rsp_rdata_out <= data_shifter_in;
                            rsp_rdata_out <= data_shifter_in(DATA_W-1-4 downto 0) & serial_in (3 downto 0);
                            rsp_valid_out <= '1';
                            
                        end if;
                        
                    when DEASSERT_CS =>
                        sqi_pin_direction <= '1'; -- write
                        --  wait for response to be accepted and go back to IDLE ready to receive a new command
                        -- 
                        if rsp_ready_in = '1' then
                            rsp_valid_out <= '0';
                            state <= IDLE;
                            cmd_ready_out <= '1'; -- default ready to receive new command
                        end if;
                 
          
                    
                    when others =>
                        state <= SRESET;
                end case;
            end if;
        end if;
    
    end process;   
    
    -- Output Dual Data Rate Flip Flop to output a clock
    clk_output_buffer: ODDR
	port map(
        Q  => SCK, -- output to pin 6 of JA PMOD
		C  => spi_clk, -- input from clock tree PLL
		CE => SCK_EN, -- always enable
		D1 => '0',    -- invert the clock
		D2 => '1'     -- invert the clock
	);
	
	-- IO Buffers
	
    SIO0_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "FAST")
        port map(
            O => serial_in(0), -- buffer output
            IO => SI_SIO0, -- buffer inout port (connect directly to top level pin)
            I => serial_out(0), -- buffer input
            T => io_buf_output_disable(0) -- 3-state enable input - high=input, low=output 
        );
    SIO1_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "FAST")
        port map(
            O => serial_in(1), -- buffer output
            IO => SO_SIO1, -- buffer inout port (connect directly to top level pin)
            I => serial_out(1), -- buffer input
            T => io_buf_output_disable(1) -- 3-state enable input - high=input, low=output 
        );
    SIO2_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "FAST")
        port map(
            O => serial_in(2), -- buffer output
            IO => SIO2, -- buffer inout port (connect directly to top level pin)
            I => serial_out(2), -- buffer input
            T => io_buf_output_disable(2) -- 3-state enable input - high=input, low=output 
        );
    SIO3_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "FAST")
        port map(
            O => serial_in(3), -- buffer output
            IO => HOLD_N_SIO3, -- buffer inout port (connect directly to top level pin)
            I => serial_out(3), -- buffer input
            T => io_buf_output_disable(3) -- 3-state enable input - high=input, low=output 
        );

end rtl;
