-- Basys 3 top (VHDL)
-- This file will contain all the IP and primitive instantiations 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- for Xilinx 7-series primitives
Library UNISIM;
use UNISIM.vcomponents.all;

entity basys3_top_spi_ram is
    generic(
--        NUM_COMMANDS : integer := 16;
--        DATA_FILE    : string  := "../software/cmds.hex";
        NUM_COMMANDS : integer := 16384;    -- 50% BRAM
--        NUM_COMMANDS : integer := 32768;    -- 97% BRAM
        DATA_FILE    : string  := "../software/rand_test_cmds.hex"; -- "../software/cmds.hex" -- "../software/rand_test_cmds.hex"
        DEBUG_ILAS : boolean := false
    );
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
		HOLD_N_SIO3   : inout std_logic  -- Serial Inout3/Hold	
		

	);
	end basys3_top_spi_ram;
	
architecture rtl of basys3_top_spi_ram is
    
    -- Pinout of 23LC1024 Serial SRAM (see Datasheet @ https://docs.rs-online.com/5f59/0900766b8114ca33.pdf)  


    component clk_wiz_0 
    port (   
        clk_out100 : out std_logic ;      
        clk_out22  : out std_logic;
        reset      : in  std_logic ;      
        locked     : out std_logic ;      
        
        clk_in1    : in  std_logic   
    );
    end component;

    signal spi_clk    : std_logic;
    signal locked       : std_logic;
    signal ext_reset        :  STD_LOGIC;
    signal sys_reset      : std_logic;   
    signal cmd_ready    :  STD_LOGIC;
    signal cmd_valid    :  STD_LOGIC;
    signal cmd_address  :  STD_LOGIC_VECTOR(32-1 downto 0);
    signal cmd_rw       :  STD_LOGIC;
    signal cmd_wdata    : STD_LOGIC_VECTOR(32-1 downto 0);
    
    signal rsp_rdata    : std_logic_vector(32-1 downto 0);
    signal rsp_valid    : std_logic;
    signal rsp_ready    : std_logic;
    
    signal all_cmds_done : std_logic;
    signal command_count  : std_logic_vector(16-1 downto 0);
    signal error_count  : std_logic_vector(16-1 downto 0);
    
    signal sseg_display_data : std_logic_vector(16-1 downto 0);
    
    attribute MARK_DEBUG : boolean;
    attribute MARK_DEBUG of sys_reset : signal is True;     -- used to trigger ILAs
    
begin
    
    ext_reset <= BTN(4);
    
    sys_reset <= ext_reset or (not locked);
    
    LED(0) <= all_cmds_done;
    LED(15) <= ext_reset;
    LED(14) <= sys_reset;
    
    LED(13 downto 1) <= (others => '0'); 

    sseg_display_data <= command_count when SW(0) = '1' else error_count;


    u_qspi_sram_ctrl : entity work.qspi_sram_23lc1024_ctrl
        generic map (
            DEBUG_ILAS => DEBUG_ILAS
        )
        port map(
            spi_clk     => spi_clk,
            reset       =>  sys_reset,
            
            SCK         => SCK     ,
            CS_N        => CS_N    ,
            SI_SIO0     => SI_SIO0      ,
            SO_SIO1     => SO_SIO1      ,
            SIO2        => SIO2,
            HOLD_N_SIO3 => HOLD_N_SIO3,
            
            
            cmd_ready_out   => cmd_ready, 
            cmd_valid_in    => cmd_valid,
            cmd_address_in  => cmd_address(16 downto 0),
            cmd_rw_in       => cmd_rw,
            cmd_wdata_in    => cmd_wdata,
            rsp_rdata_out   => rsp_rdata,
            rsp_ready_in    => rsp_ready,
            rsp_valid_out   => rsp_valid
                
             
        );

    
    u_axis_cmd_driver : entity work.axis_cmd_driver
    generic map(
        DEBUG_ILAS => DEBUG_ILAS,
        NUM_COMMANDS => NUM_COMMANDS, -- 32768 uses 98% of BRAM
        DATA_FILE => DATA_FILE
    )
    port map(
        clk        => spi_clk,
        reset      => sys_reset,
        cmd_ready_in   => cmd_ready,
        cmd_valid_out  => cmd_valid,
        cmd_address_out=> cmd_address,
        cmd_rw_out     => cmd_rw, 
        cmd_data_out   => cmd_wdata,
        
        rsp_rdata_in => rsp_rdata,
        rsp_valid_in => rsp_valid,
        rsp_ready_out => rsp_ready,
        
        all_cmds_done_out => all_cmds_done,
        command_count_out => command_count,
        error_count_out => error_count
    );     

    -- displays a count of the number of errors
	u_seven_seg : entity work.quad_seven_seg_driver
	port map(clk => spi_clk, display_data_in => sseg_display_data, sseg_ca => SSEG_CA, sseg_an => SSEG_AN);
	
       
   -- reduce SPI clkrate to 10MHz to improve timing
	u_clk_wiz : clk_wiz_0  
	port map(
        clk_out100 => open,     
        clk_out22  => spi_clk,
        
        reset      => ext_reset,     
        locked     => locked,     
        clk_in1    => CLK 
    );


end architecture rtl;