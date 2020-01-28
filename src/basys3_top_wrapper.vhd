-- Basys 3 top (VHDL)
-- This file will contain all the IP and primitive instantiations 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spi_sram_23LC1024_lib;
use spi_sram_23LC1024_lib.spi_pkg.all;

-- for Xilinx 7-series primitives
Library UNISIM;
use UNISIM.vcomponents.all;

entity basys3_top_wrapper is
	port(
		CLK : in 	std_logic;
		-- Switches
		SW	: in 	std_logic_vector(15 downto 0);
		-- LEDs
		LED : out 	std_logic_vector(15 downto 0);
		
		-- Seven Seg Display
		SSEG_CA : out std_logic_vector(7 downto 0);
		SSEG_AN : out std_logic_vector(3 downto 0);
		
			-- Temporary testbench access ports
--        dir : in std_logic;	
		
		-- Buttons
		BTN : in std_logic_vector(4 downto 0);
		
		-- 23LC1024 SRAM
		CS_N          : out std_logic;    -- Chip Select
		SO_SIO1       : inout std_logic;  -- Serial Out/Serial Inout 1
		SIO2          : inout std_logic;  -- Serial Inout 2
		SI_SIO0       : inout std_logic;  -- Serial In/Serial Inout 0
		SCK           : out std_logic;    -- Clock (Max 20MHz)
		SIO3_HOLD_N   : inout std_logic  -- Serial Inout3/Hold	
		

	);
	end basys3_top_wrapper;
	
architecture rtl of basys3_top_wrapper is
    -- Pinout of 23LC1024 Serial SRAM (see Datasheet @ https://docs.rs-online.com/5f59/0900766b8114ca33.pdf)

    signal dir : std_logic; -- temp
    
    -- signals for IOBUF buffers
    -- I and O are relative to the IOBUF 
    -- so I is the signal to be output to the pad
    -- and O is the signal from the pad
    signal I  : std_logic_vector(3 downto 0);
    signal O  : std_logic_vector(3 downto 0);
    signal IO : std_logic_vector(3 downto 0);
    signal T  : std_logic_vector(3 downto 0);
    
    signal sdi_sqi_direction : t_dir;
    signal spi_mode : t_spi_mode;
    
    -- 1 bit for Extended, 2 bits for SDI and 4 bits for SQI
    signal serial_in : std_logic_vector(3 downto 0); 
    signal serial_out : std_logic_vector(3 downto 0);
    
begin
    -- Testbench temporary access assignments
    sdi_sqi_direction <= READ when dir = '1' else WRITE;

    serial_out <= x"F"; -- temp
	
	-- this needs to update based on the SPI mode of the chip
    T <= (others => '1') when sdi_sqi_direction = READ else (others => '0'); -- this might be the wrong way round


    SIO0_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "SLOW")
        port map(
            O => serial_in(0), -- buffer output
            IO => SI_SIO0, -- buffer inout port (connect directly to top level pin)
            I => serial_out(0), -- buffer input
            T => T(0) -- 3-state enable input - high=input, low=output 
        );
    SIO1_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "SLOW")
        port map(
            O => serial_in(1), -- buffer output
            IO => SO_SIO1, -- buffer inout port (connect directly to top level pin)
            I => serial_out(1), -- buffer input
            T => T(1) -- 3-state enable input - high=input, low=output 
        );
    SIO2_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "SLOW")
        port map(
            O => serial_in(2), -- buffer output
            IO => SIO2, -- buffer inout port (connect directly to top level pin)
            I => serial_out(2), -- buffer input
            T => T(2) -- 3-state enable input - high=input, low=output 
        );
    SIO3_IOBUF : IOBUF
        generic map (drive => 12, iostandard => "DEFAULT", slew => "SLOW")
        port map(
            O => serial_in(3), -- buffer output
            IO => SIO3_HOLD_N, -- buffer inout port (connect directly to top level pin)
            I => serial_out(3), -- buffer input
            T => T(3) -- 3-state enable input - high=input, low=output 
        );

    
    
	-- Output Dual Data Rate Flip Flop to output a clock
    clk_output_buffer: ODDR
	port map(
        Q  => SCK, -- output to pin 6 of JA PMOD
		C  => CLK, -- input from clock tree PLL
		CE => '1', -- always enable
		D1 => '1',
		D2 => '0'
	);
	
	
	u_seven_seg : entity spi_sram_23LC1024_lib.quad_seven_seg_driver
	port map(clk => CLK, sw => SW, sseg_ca => SSEG_CA, sseg_an => SSEG_AN);
	
        


end architecture rtl;