library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axis_cmd_driver is
    generic(
        DEBUG_ILAS : boolean := false;
        ADDR_W : integer := 32;
        DATA_W : integer := 32;
        CMD_W  : integer := 4;
        NUM_COMMANDS : integer := 16;
        DATA_FILE : string := "../software/cmds.hex"
    );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           cmd_ready_in     : in STD_LOGIC;
           cmd_valid_out    : out STD_LOGIC;
           cmd_address_out  : out STD_LOGIC_VECTOR(ADDR_W-1 downto 0);
           cmd_rw_out       : out STD_LOGIC;
           cmd_data_out     : out STD_LOGIC_VECTOR(DATA_W-1 downto 0);
           
           rsp_rdata_in     : in STD_LOGIC_VECTOR(DATA_W-1 downto 0);
           rsp_valid_in     : in STD_LOGIC;
           rsp_ready_out    : out STD_LOGIC;
           
           command_count_out : out STD_LOGIC_VECTOR(16-1 downto 0);
           error_count_out : out STD_LOGIC_VECTOR(16-1 downto 0);
           all_cmds_done_out : out std_logic
   );
end axis_cmd_driver;

architecture Behavioral of axis_cmd_driver is
    
    constant ROM_W : integer := CMD_W + ADDR_W + DATA_W; 
    
    -- uses files generated from software/cmd_mem_gen.py
    
    -- Bits
    -- 67:65    Reserved
    -- 64       Read=0 Write=1
    -- 63:32    Address
    -- 31:0     Data (0000_0000 if read)


    -- Inferring Block RAM from an External Data File
    -- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_1/ug901-vivado-synthesis.pdf
    -- Page 157
    type RamType is array (0 to NUM_COMMANDS-1) of bit_vector(ROM_W-1 downto 0);
    
    impure function InitRamFromFile(RamFileName : in string) return RamType is
        FILE RamFile : text is in RamFileName;
        variable RamFileLine : line;
        variable RAM : RamType;
    begin
        for I in RamType'range loop
            readline(RamFile, RamFileLine);
            hread(RamFileLine, RAM(I));
        end loop;
        return RAM;
    end function;
    
    signal RAM : RamType := InitRamFromFile(DATA_FILE);
    -- this doesn't do anything
    attribute ram_style : string;
    attribute ram_style of RAM : signal is "bram";
    
    signal rom_en : std_logic;
    signal rom_addr : integer := 0;
    signal rom_data : std_logic_vector(ROM_W-1 downto 0);
    
    
    type t_state is (SEND_CMD, AWAIT_RESPONSE, DONE);
    signal state : t_state; 
    
    signal error_counter : unsigned(15 downto 0):= (others => '0'); 
    signal command_counter : unsigned(15 downto 0):= (others => '0'); 
    
    attribute MARK_DEBUG : boolean;
    attribute MARK_DEBUG of error_counter : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of command_counter : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of state : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of all_cmds_done_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of rom_addr : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of rom_en : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of rom_data : signal is DEBUG_ILAS;
   
    
    attribute MARK_DEBUG of cmd_ready_in : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of cmd_valid_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of cmd_address_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of cmd_rw_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of cmd_data_out : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of rsp_rdata_in : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of rsp_valid_in : signal is DEBUG_ILAS;
    attribute MARK_DEBUG of rsp_ready_out : signal is DEBUG_ILAS;
    
    
begin

    -- output assignments
    cmd_rw_out <= rom_data(ADDR_W + DATA_W);    -- we have CMD_W bits reserved for this, but we just need the bottom one
    cmd_address_out <= rom_data(ADDR_W + DATA_W -1 downto DATA_W);
    cmd_data_out <= rom_data(DATA_W-1 downto 0);
--    valid_out <= valid;

    error_count_out <= std_logic_vector(error_counter);
    command_count_out <= std_logic_vector(command_counter);
    

    -- TODO: This currently does not infer into BRAMs 
    --
    process(clk, reset)
    begin 
        if rising_edge(clk) then
            case(state) is
                when SEND_CMD => 
                    cmd_valid_out   <= '1';
                    -- this now handled in a separate seq process & combinationally above to split rom_data
--                    cmd_rw_out      <= to_stdlogicvector(RAM(rom_addr))(ADDR_W + DATA_W); -- we have CMD_W bits reserved for this, but we just need the bottom one ('1' for write, '0' for read)
--                    cmd_address_out    <= to_stdlogicvector(RAM(rom_addr))(ADDR_W + DATA_W -1 downto DATA_W); 
--                    cmd_data_out      <= to_stdlogicvector(RAM(rom_addr))(DATA_W-1 downto 0); -- this is expected rdata if this is a "read" operation, else wdata
                    
                    -- if slave can accept command
                    if cmd_ready_in = '1' then
                        state <= AWAIT_RESPONSE;
                        rsp_ready_out <= '1';
                    end if;
                    
                when AWAIT_RESPONSE => 
                    cmd_valid_out <= '0';
                    
                    if rsp_valid_in = '1' then
                        rsp_ready_out <= '0';
                        
                        command_counter <= command_counter + 1;
                        
                        if cmd_rw_out = '0' then -- if read response
                            if rsp_rdata_in /= cmd_data_out then    -- if there is a mismatch
                                error_counter <= error_counter + 1;
                            end if;
                        end if;
                        
                        if rom_addr = NUM_COMMANDS-1 then
                            state <= DONE;
                            all_cmds_done_out <= '1';
                        else
                            rom_addr <= rom_addr + 1; -- move to next command
                            state <= SEND_CMD;
                            
                        end if;
                        
                    end if;
                    
                when DONE => 
                    
                    
                    
            end case;
        end if;
        if reset = '1' then
            cmd_valid_out <= '0';
            rsp_ready_out <= '0';
            rom_addr <= 0;
            state <= SEND_CMD;
            error_counter <= (others => '0');
            command_counter <= (others => '0');
            all_cmds_done_out <= '0';
        end if;
    end process;

-- move to a separate RAM process to help synthesis correctly infer BRAMs 



-- from UG901 Single Port Block RAM No-Change Mode (pg 123)
-- modified to remove WRITE

-- does this need to be gated by the above process?
rom_en <= '1';


 process(clk)
 begin
     if rising_edge(clk) then
        if rom_en = '1' then
            rom_data <= to_std_logic_vector(RAM(rom_addr));
        end if;
    end if;
 end process;



--    process(clk, reset)    
--    begin
--        if rising_edge(clk) then
        
        
--            -- axi (master) handshake - we can't wait on a ready before we assert Valid
            
--            valid <= '1';                               -- next word valid 
--            rom_data <= to_stdlogicvector(RAM(rom_addr));   -- get the next word from the ROM
--            if ready_in = '1' then                              -- transaction accepted
--                rom_addr <= rom_addr + 1;                       -- set up the address for the word after that
--            end if;
--        end if;
--        if reset = '1' then
--            valid <= '0';
--            rom_data <= (others => '1');
--            rom_addr <= 0;
--        end if;
--    end process;



end Behavioral;
