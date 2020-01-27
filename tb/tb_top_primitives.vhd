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
		-- Switches
	signal	SW	:  std_logic_vector(15 downto 0):= (others=>'0');
		-- LEDs
	signal	LED :	std_logic_vector(15 downto 0);
		
		-- Seven Seg Display
	signal	SSEG_CA :  std_logic_vector(6 downto 0);
	signal	SSEG_AN :  std_logic_vector(3 downto 0);
		
		-- Buttons
	signal	BTN :  std_logic_vector(4 downto 0):= (others=>'0');
		
		-- PMOD Header A
		-- pinout of this follows the 23LC1024:
		-- Pin 1=>JA(1), Pin2=>JA(2) ... , Pin8=>JA(0)
	signal	JA :  std_logic_vector(7 downto 0); -- These are all buffered with IOBUF primtives		


    signal dir : std_logic := '1';
    
begin

    dir <= not dir after 200 ns;

    CLK <= not CLK after 50 ns; -- 20MHz
	
	dut : entity spi_sram_23LC1024_lib.basys3_top_wrapper
	port map(
	   CLK => CLK,
	   SW => SW,
	   LED => LED,
	   SSEG_CA => SSEG_CA,
	   SSEG_AN => SSEG_AN,
	   BTN => BTN,
	   JA => JA,
	   dir => dir
	);


end architecture tb;

