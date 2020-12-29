----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2020 20:14:55
-- Design Name: 
-- Module Name: tb_basys3_top_spi_ram - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_basys3_top_spi_ram is
--  Port ( );
end tb_basys3_top_spi_ram;

architecture Behavioral of tb_basys3_top_spi_ram is
    signal CLK :  	std_logic := '0';
     -- Switches
    signal SW	:  	std_logic_vector(15 downto 0);
     -- LEDs
    signal LED :  	std_logic_vector(15 downto 0);
     
     -- Seven Seg Display
    signal SSEG_CA :  std_logic_vector(7 downto 0);
    signal SSEG_AN :  std_logic_vector(3 downto 0);
     
             
     -- Buttons
    signal BTN :  std_logic_vector(4 downto 0);
     
     -- 23LC1024 SRAM
    signal CS_N          :  std_logic;    -- Chip Select
    signal SO_SIO1       :  std_logic;  -- Serial Out/Serial Inout 1
    signal SIO2          :  std_logic;  -- Serial Inout 2
    signal SI_SIO0       :  std_logic;  -- Serial In/Serial Inout 0
    signal SCK           :  std_logic;    -- Clock (Max 20MHz)
    signal HOLD_N_SIO3   :  std_logic;  -- Serial Inout3/Hold
    
    constant CLK_PERIOD  : time := 10 ns;   -- 100MHz SYSCLK oscillator
    	 
    constant NUM_COMMANDS : integer := 16;
    constant DATA_FILE    : string := "../software/cmds.hex";
--    constant NUM_COMMANDS : integer := 16384;
--    constant DATA_FILE    : string := "../software/rand_test_cmds.hex";
begin

    SW <= (others => '0');
    BTN <= (others => '0');
    
    clk <= not clk after CLK_PERIOD/2; -- sysclk
    

    u_basys3_top_spi_ram : entity work.basys3_top_spi_ram
    generic map(
        NUM_COMMANDS => NUM_COMMANDS, -- 32768 uses 98% of BRAM
        DATA_FILE => DATA_FILE
    )
    port map(
        CLK       => CLK    ,
        SW        => SW     ,
        LED       => LED    ,
        SSEG_CA   => SSEG_CA,
        SSEG_AN   => SSEG_AN,
        BTN       => BTN    ,
        
        SI_SIO0 => SI_SIO0,
        SCK => SCK,
        CS_N => CS_N,
        SIO2 => SIO2,
        HOLD_N_SIO3 => HOLD_N_SIO3,
        SO_SIO1 => SO_SIO1
    
            
            
        );
        
    u_sram : entity work.M23LC1024
        port map(
        SI_SIO0 => SI_SIO0,
        SCK => SCK,
        CS_N => CS_N,
        SIO2 => SIO2,
        HOLD_N_SIO3 => HOLD_N_SIO3,
        RESET => '0',       -- no reset
        SO_SIO1 => SO_SIO1
    );


end Behavioral;
