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
        ADDR_W : integer := 32;
        DATA_W : integer := 32;
        CMD_W  : integer := 4;
        NUM_COMMANDS : integer := 16;
        DATA_FILE : string := "../software/cmds.hex"
    );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           valid_out : out STD_LOGIC;
           address_out : out STD_LOGIC_VECTOR(ADDR_W-1 downto 0);
           rw_out : out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(DATA_W-1 downto 0)
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
    
    signal rom_addr : integer := 0;
    signal rom_data : std_logic_vector(ROM_W-1 downto 0);
    
    signal valid : std_logic := '0';
    
begin

    -- output assignments
    rw_out <= rom_data(ADDR_W + DATA_W);    -- we have CMD_W bits reserved for this, but we just need the bottom one
    address_out <= rom_data(ADDR_W + DATA_W -1 downto DATA_W);
    data_out <= rom_data(DATA_W-1 downto 0);
    valid_out <= valid;

    process(clk, reset)    
    begin
        if rising_edge(clk) then
        
        
            -- axi (master) handshake - we can't wait on a ready before we assert Valid
            
            valid <= '1';                               -- next word valid 
            rom_data <= to_stdlogicvector(RAM(rom_addr));   -- get the next word from the ROM
            if ready_in = '1' then                              -- transaction accepted
                rom_addr <= rom_addr + 1;                       -- set up the address for the word after that
            end if;
        end if;
        if reset = '1' then
            valid <= '0';
            rom_data <= (others => '1');
            rom_addr <= 0;
        end if;
    end process;



end Behavioral;