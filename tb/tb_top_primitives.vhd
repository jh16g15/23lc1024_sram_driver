-- Testbench for Artix-7 primitives ODDR and IOBUF

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spi_sram_23LC1024_lib;
use spi_sram_23LC1024_lib.spi_pkg.all;

entity tb_top_primitives is 
end entity tb_top_primitives;

architecture tb of tb_top_primitives is
	signal CLK : std_logic := '1';
	signal	SW	:  std_logic_vector(15 downto 0):= (others=>'0');
	signal	LED :	std_logic_vector(15 downto 0);
	signal	SSEG_CA :  std_logic_vector(7 downto 0);
	signal	SSEG_AN :  std_logic_vector(3 downto 0);
	signal	BTN :  std_logic_vector(4 downto 0):= (others=>'0');

    -- 23LC1024 SRAM
    signal CS_N          : std_logic;    -- Chip Select
    signal SO_SIO1       : std_logic;  -- Serial Out/Serial Inout 1
    signal SIO2          : std_logic;  -- Serial Inout 2
    signal SI_SIO0       : std_logic;  -- Serial In/Serial Inout 0
    signal SCK           : std_logic;    -- Clock (Max 20MHz)
    signal SIO3_HOLD_N   : std_logic;  -- Serial Inout3/Hold	
	
	-- testbench
    signal dir : std_logic := '1';
    
begin

    dir <= not dir after 200 ns;

    SI_SIO0     <= '0' when dir = '1' else 'Z';
    SO_SIO1     <= '0' when dir = '1' else 'Z';
    SIO2        <= '0' when dir = '1' else 'Z';
    SIO3_HOLD_N <= '0' when dir = '1' else 'Z';


    CLK <= not CLK after 50 ns; -- 20MHz
	
	dut : entity spi_sram_23LC1024_lib.basys3_top_wrapper
	port map(
	   CLK         => CLK,
	   SW          => SW,
	   LED         => LED,
	   SSEG_CA     => SSEG_CA,
	   SSEG_AN     => SSEG_AN,
	   BTN         => BTN,
	   CS_N        => CS_N,      
	   SO_SIO1     => SO_SIO1,   
	   SIO2        => SIO2,        
	   SI_SIO0     => SI_SIO0,     
	   SCK         => SCK,         
	   SIO3_HOLD_N => SIO3_HOLD_N,
	   dir         => dir
	);


end architecture tb;

