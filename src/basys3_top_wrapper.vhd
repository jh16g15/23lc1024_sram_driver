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
		SSEG_CA : out std_logic_vector(6 downto 0);
		SSEG_AN : out std_logic_vector(3 downto 0);
		
		-- Buttons
		BTN : in std_logic_vector(4 downto 0);
		
		-- PMOD Header A
		-- pinout of this follows the 23LC1024:
		-- Pin 1=>JA(1), Pin2=>JA(2) ... , Pin8=>JA(0)
		JA : inout std_logic_vector(7 downto 0); -- These are all buffered with IOBUF primtives
		
		-- Temporary testbench access ports
        dir : in std_logic
	);
	end basys3_top_wrapper;
	
architecture rtl of basys3_top_wrapper is
    -- Pinout of 23LC1024 Serial SRAM (see Datasheet @ https://docs.rs-online.com/5f59/0900766b8114ca33.pdf)
    
    -- pin 1
    signal sram_cs_n : std_logic; -- chip select (active low)
    
    -- pin 2: also serial out (SO) in Extended Mode
    signal sram_sdi_serial_in_1 : std_logic; 
    signal sram_sdi_serial_out_1 : std_logic;
    -- This is for Extended SPI mode (1 bit wide accesses) 
    signal sram_extended_serial_out : std_logic;
    
    -- pin 3:
    signal sram_sqi_serial_in_2 : std_logic; 
    signal sram_sqi_serial_out_2 : std_logic;
    
    -- pin 4 is Vss/GND
    
    -- pin 5 (also Serial In (SI) in Extended Mode)
    signal sram_sdi_serial_in_0 : std_logic; 
    signal sram_sdi_serial_out_0 : std_logic;    
    -- This is for Extended SPI mode (1 bit wide accesses) 
    signal sram_extended_serial_in : std_logic;
    
    -- pin 6
    signal sram_sck : std_logic; -- max 20MHz
    
    -- pin 7  (also hold in Extended mode)      
    signal sram_extended_hold_n : std_logic; -- Hold (active low)
    signal sram_sqi_serial_in_3 : std_logic; 
    signal sram_sqi_serial_out_3 : std_logic;
    
    -- pin 8 is Vcc
    
    
    -- signals for IOBUF buffers for PMOD Header A
    -- I and O are relative to the IOBUF 
    -- so I is the signal to be output to the pad
    -- and O is the signal from the pad
    signal I  : std_logic_vector(7 downto 0);
    signal O  : std_logic_vector(7 downto 0);
    signal IO : std_logic_vector(7 downto 0);
    signal T : std_logic_vector(7 downto 0);
    
    signal sdi_sqi_direction : t_dir;
    signal spi_mode : t_spi_mode;
    
    signal sqi_serial_in : std_logic_vector(3 downto 0);
    signal sqi_serial_out : std_logic_vector(3 downto 0);
    
begin
    -- Testbench temporary access assignments
    sdi_sqi_direction <= READ when dir = '1' else WRITE;

    sqi_serial_out <= x"F";

    -- Mapping PMOD Jumper A	
    JA(5 downto 0) <= IO(5 downto 0); -- map all buffered IO to pins
	--JA(6) is the SCK and is mapped by the ODDR
	JA(7) <= IO(7);
	
	-- this needs to update based on the SPI mode of the chip
    T <= (others => '1') when sdi_sqi_direction = READ else (others => '0'); -- this might be the wrong way round
    
    -- map to output pins from buffers (=inputs to FPGA)
    sqi_serial_in(0) <= O(5);
    sqi_serial_in(1) <= O(2);
    sqi_serial_in(2) <= O(3);
    sqi_serial_in(3) <= O(7);
    
    -- map to input pins in the buffers (=output from the FPGA)
    I(5) <= sqi_serial_out(0);
    I(2) <= sqi_serial_out(1);
    I(3) <= sqi_serial_out(2);
    I(7) <= sqi_serial_out(3);
    

    
    -- we don't really need this many IOBUFS as some pins are unidirectional anyway
    -- and for outputting the clock we will want to use an ODDR primitive to buffer it.
    sram_pin_buffers : for x in 7 downto 0 generate
        bidirectional_buffer : IOBUF
            generic map (
                drive => 12,
                iostandard => "DEFAULT",
                slew => "SLOW")
            port map(
                O => O(x), -- buffer output
                IO => IO(x), -- buffer inout port (connect directly to top level pin)
                I => I(x), -- buffer input
                T => T(x) -- 3-state enable input - high=input, low=output 
            );
    end generate sram_pin_buffers;
    
    sram_sck <= CLK; -- for now no need for PLL
    
	-- Output Dual Data Rate Flip Flop to output a clock
    clk_output_buffer: ODDR
	port map(
		Q  => JA(6),          -- output to pin 6 of JA PMOD
		C  => sram_sck,       -- input from clock tree PLL
		CE => '1',            -- always enable (could use a signal here
		D1 => '1',            --
		D2 => '0'
	);
	
	
        


end architecture rtl;