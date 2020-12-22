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
-- Description: 
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

entity spi_sram_ctrl is
    Generic(
        SERDES_WORD_SIZE : integer := 8;
        DATA_W : integer := 32; -- must be a multiple of SERDES_WORD_SIZE
        ADDR_W : integer := 17 -- not reparameterisable, some padding logic depends on this
    );
    Port ( 
        spi_clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        spi_cs_n : out STD_LOGIC;
        spi_miso : in STD_LOGIC;
        spi_mosi : out STD_LOGIC;
        spi_hold_n : out STD_LOGIC;
        
        SCK : out STD_LOGIC; -- clock that goes out to the SRAM chip
        
        cmd_ready_out   : out STD_LOGIC;
        cmd_valid_in    : in STD_LOGIC;
        cmd_address_in  : in STD_LOGIC_VECTOR(ADDR_W-1 downto 0);
        cmd_rw_in       : in STD_LOGIC;
        cmd_wdata_in    : in STD_LOGIC_VECTOR(DATA_W-1 downto 0);
        rsp_rdata_out   : out STD_LOGIC_VECTOR(DATA_W-1 downto 0);
        rsp_ready_in    : in STD_LOGIC;
        rsp_valid_out   : out STD_LOGIC
                        
    );
           
end spi_sram_ctrl;

architecture rtl of spi_sram_ctrl is

    -- 4 byte transfers for a 32-bit word
    constant TRANSFERS_PER_WORD : integer := DATA_W/SERDES_WORD_SIZE;


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
    
    -- serdes control flags   
    signal serdes_req_valid       : std_logic;
    signal serdes_req_ready       : std_logic;
    signal serdes_word_to_send    : std_logic_vector(SERDES_WORD_SIZE-1 downto 0);
    signal serdes_word_received   : std_logic_vector(SERDES_WORD_SIZE-1 downto 0);
    signal serdes_transfer_done   : std_logic;
 
    -- state machine for commands
    type t_startup_state is (RESET_S, SET_MODE_S, RUN_S);
    
    type t_state is (IDLE, ADDR0, ADDR1, ADDR2, DATA_MAIN, DATA_LAST, DUMMY, CHANGE_MODE, READ_MODE_REG, WRITE_MODE_REG, FINISH_CS, GAP);
    
    signal startup_state : t_startup_state;
    signal state : t_state;
    
    signal SCK_en : std_logic;
    
    signal word_counter : integer := 0;
    
    -- register commands as they come in
    signal cmd_address_reg : std_logic_vector(ADDR_W-1 downto 0);
    signal cmd_rw_reg      : std_logic;
    signal cmd_wdata_reg   : std_logic_vector(DATA_W-1 downto 0);
    
    -- we need to register the CS_N signal to match the 1 cycle delay from the SERDES
    signal cs_n_pre_delay : std_logic;
       
begin
    spi_hold_n <= '1';


    

    u_serdes : entity work.spi_serdes
        generic map( WORD_SIZE => SERDES_WORD_SIZE)
        port map(
            spi_clk         => spi_clk,
            reset           => reset,
            spi_miso        => spi_miso,
            spi_mosi        => spi_mosi,
            -- cmd in       
            req_valid       => serdes_req_valid    ,
            req_ready       => serdes_req_ready    ,
            word_to_send    => serdes_word_to_send ,
            -- resp out     
            word_received   => serdes_word_received,
            transfer_done   => serdes_transfer_done
        );
   
   
    -- this is the setup state machines, controlling the overall state (ie, reset then put into SQI mode (currently not supported))
    -- TODO: roll this into the main state machine below
    setup_proc : process(spi_clk) is 
    begin
        if rising_edge(spi_clk) then 
            if reset = '1' then
                startup_state  <= RESET_S;
            else 
                case startup_state is 
                    when RESET_S =>
                    
                    when SET_MODE_S =>
                    
                    when RUN_S => 
                end case;
            end if;
        end if;
    
    end process;
    
    -- NOTE ABOUT SCK, spi_clk and CS_n
    --
    -- To make sure CS_n is asserted before the data arrives, the ODDR SCK output inverts the spi_clk to make SCK
    -- this has the effect of "delaying" the data clock by half a cycle, so we can set CS and data on the same cycle of spi_clk
    -- to make our state machine easier
    -- We need to make sure that we keep the CS asserted for one additional cycle beyond our final data bit to prevent it from deasserting too soon
    --
    -- Do we want to consider moving CS_n control into the SERDES?
    --
    
    SCK_en <= '1'; -- free running SPI clock
    
    spi_proc : process(spi_clk) is 
    begin
        if rising_edge(spi_clk) then 
            if reset = '1' then
                state  <= IDLE;
                spi_cs_n <= '1'; -- deassert chip select
                serdes_req_valid <= '0'; -- no request to SERDES
            else 
            
                spi_cs_n <= cs_n_pre_delay;
             
            
                case state is 
                    when IDLE =>
                        cmd_ready_out <= '1'; -- default ready to receive new command
                        
                        if cmd_valid_in = '1' then -- when new command is ready
                            -- accept command and block further commands being accepted 
                            cmd_ready_out <= '0';   
                            cmd_rw_reg <= cmd_rw_in;
                            cmd_address_reg <= cmd_address_in;
                            cmd_wdata_reg <= cmd_wdata_in;
                            
                            -- start a new transaction
                            cs_n_pre_delay <= '0';    -- assert chip select for transaction (1/2 cycle ahead) -- this needs to be delayed one cycle to match the SERDES delay
                            
                            state <= ADDR0;     -- first byte of address, regardless of command.
                            
                            serdes_req_valid <= '1';   -- start the SERDES
                            
                            if cmd_rw_in = '1' then -- TODO still use unregistered copy this cycle? only on first run-through of this
                                serdes_word_to_send <= x"02"; -- WRITE command byte
                            else
                                serdes_word_to_send <= x"03"; -- READ command byte
                            end if;
                            
                            if serdes_req_ready = '1' then -- when the SERDES can start our transfer
                                state <= GAP;
                            end if;
                            
                        end if;
                        
                    -- we skip through this state too fast - need to rework based on serdes completion
                    -- as when SERDES transitions from IDLE the READY stays asserted for one more cycle 
                    -- we temp fix this by adding another GAP state in here
                    when GAP =>
                        state <= ADDR0;
                    
                    when ADDR0 => 
                        serdes_req_valid <= '1'; -- keep the SERDES going
                        serdes_word_to_send <= b"0000_000" & cmd_address_reg(ADDR_W-1 downto ADDR_W-1); -- top bit of 17 bit address only - parameterise for larger memories?
                        
                        if serdes_req_ready = '1' then -- when the SERDES can start our transfer
                            state <= ADDR1;
                        end if;
                       
                    when ADDR1 => 
                        serdes_req_valid <= '1'; -- keep the SERDES going
                        serdes_word_to_send <= cmd_address_reg(16-1 downto 8); -- second byte of 17 bit address
                        
                        if serdes_req_ready = '1' then -- when the SERDES can start our transfer
                            state <= ADDR2;
                        end if;
                    when ADDR2 => 
                        serdes_req_valid <= '1'; -- keep the SERDES going
                        serdes_word_to_send <= cmd_address_reg(8-1 downto 0); -- final byte of address
                        
                        if serdes_req_ready = '1' then -- when the SERDES can start our transfer
                            state <= DATA_MAIN;
                            word_counter <= 0;
                        end if;
                     
                    
                    when DATA_MAIN =>
                        -- address increases byte-wise, so send least significant byte first
                        -- if this is a read command, we are sending junk so might as well send whatever wdata is reporting (0000_0000 from python generator on reads)
                        if word_counter <= TRANSFERS_PER_WORD-1 then            -- 0,1,2,3     
                            serdes_req_valid <= '1'; -- keep the SERDES going
                            
                            -- word=0  7:0      (8*word)+8-1    8*word
                            -- word=1 15:8      (8*word)+8-1    8*word
                            -- word=2 23:16     (8*word)+8-1    8*word
                            -- word=3 31:24     (8*word)+8-1    8*word
                                                        
                            -- (SERDES_WORD_SIZE * word_counter)+SERDES_WORD_SIZE-1 downto SERDES_WORD_SIZE * word_counter 
                            
                            serdes_word_to_send <= cmd_wdata_reg((SERDES_WORD_SIZE * word_counter)+SERDES_WORD_SIZE-1 downto SERDES_WORD_SIZE * word_counter); -- lowest byte of wdata 
                            
                        end if;
                        
                        if serdes_req_ready = '1' then  -- after we have completed a transfer
                            word_counter <= word_counter + 1;
                            
                            -- fill in RDATA response
                            rsp_rdata_out((SERDES_WORD_SIZE * word_counter)+SERDES_WORD_SIZE-1 downto SERDES_WORD_SIZE * word_counter) <= serdes_word_received;
                            
                            if word_counter = TRANSFERS_PER_WORD - 1 then -- 3 - last byte transfer to serdes
                                state <= FINISH_CS;
                                rsp_valid_out <= '1';
                            end if;
                        end if;
                        
                    when FINISH_CS => 
                        
                        cs_n_pre_delay <= '1'; -- deassert SRAM Chip Select (add extra 1 cycle delay separately to account for serdes)
                        -- 
                        if rsp_ready_in = '1' then
                            rsp_valid_out <= '0';
                            state <= IDLE;
                        end if;
                        
                        
                    when CHANGE_MODE => 
                        state <= IDLE;
                    when READ_MODE_REG => 
                        state <= IDLE;
                    
                    when WRITE_MODE_REG => 
                        state <= IDLE;
                    
                    when others =>
                        state <= IDLE;
                end case;
            end if;
        end if;
    
    end process;   
    
    	-- Output Dual Data Rate Flip Flop to output a clock
    clk_output_buffer: ODDR
	port map(
        Q  => SCK, -- output to pin 6 of JA PMOD
		C  => spi_clk, -- input from clock tree PLL
		CE => SCK_en, -- always enable
		D1 => '0',    -- invert the clock
		D2 => '1'     -- invert the clock
	);

end rtl;
