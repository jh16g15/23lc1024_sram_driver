-- Basys 3 top (VHDL)
-- This file will contain all the IP and primitive instantiations 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spi_pkg.all;

-- for Xilinx 7-series primitives
Library UNISIM;
use UNISIM.vcomponents.all;

entity basys3_top_spi_ram is
	port(
		CLK : in 	std_logic;
		-- Switches
		SW	: in 	std_logic_vector(15 downto 0);
		-- LEDs
		LED : out 	std_logic_vector(15 downto 0);
		
		-- Seven Seg Display
		SSEG_CA : out std_logic_vector(7 downto 0);
		SSEG_AN : out std_logic_vector(3 downto 0);
		
				
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
	end basys3_top_spi_ram;
	
architecture rtl of basys3_top_spi_ram is
    -- Pinout of 23LC1024 Serial SRAM (see Datasheet @ https://docs.rs-online.com/5f59/0900766b8114ca33.pdf)

    -- the quick borwn fox jumped over hte lAxu fgo.
    
    
    
    
-----------------------
-- use CE clock enable on ODDR primitive to give us enough time for the chip select to go through before we start sending data
         -- Why hell othte  
--    signal dir : std_logic; -- temp
    
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
    
    -- signals to the controller
    signal si : std_logic;
    signal so : std_logic;
    
    -- cmd driver
    signal reset : std_logic;
    signal cmd_ready : std_logic;
    signal cmd_valid : std_logic;
    signal cmd_addr  : std_logic_vector(31 downto 0);
    signal cmd_data  : std_logic_vector(31 downto 0);
    signal cmd_rw    : std_logic; 
    
    signal rsp_rdata  : std_logic_vector(31 downto 0);
    signal rsp_valid  : std_logic;
    signal rsp_ready  : std_logic;
    
begin
    
    reset <= BTN(4); -- centre button?
    LED(0) <= reset;
    
    
    -- SPI extended mode
    
    SIO2 <= '0';        -- unused
    
    u_cmd_driver : entity work.axis_cmd_driver
        port map(
           clk          => clk        ,
           reset        => reset      ,
           ready_in     => cmd_ready  ,
           valid_out    => cmd_valid  ,
           address_out  => cmd_addr   ,
           rw_out       => cmd_rw     ,
           data_out     => cmd_data   
   );
   
    u_spi_sram_ctrl : entity work.spi_sram_ctrl
        port map(
            spi_clk  => clk     ,
            SCK      => SCK     , 
            reset    => reset   ,
            spi_cs_n => CS_N    ,
            spi_miso => SI_SIO0      ,
            spi_mosi => SO_SIO1      ,
            spi_hold_n => SIO3_HOLD_N,
            
            
            cmd_ready_out   => cmd_ready, 
            cmd_valid_in    => cmd_valid,
            cmd_address_in  => cmd_addr,
            cmd_rw_in       => cmd_rw,
            cmd_wdata_in    => cmd_data,
            rsp_rdata_out   => rsp_rdata,
            rsp_ready_in    => rsp_ready,
            rsp_valid_out   => rsp_valid
                
             
        );
            

     




	u_seven_seg : entity work.quad_seven_seg_driver
	port map(clk => CLK, sw => SW, sseg_ca => SSEG_CA, sseg_an => SSEG_AN);
	
       
	
        


end architecture rtl;