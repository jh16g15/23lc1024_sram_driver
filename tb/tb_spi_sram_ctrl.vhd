----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2020 22:38:36
-- Design Name: 
-- Module Name: tb_spi_sram_ctrl - Behavioral
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

entity tb_spi_sram_ctrl is
--  Port ( );
end tb_spi_sram_ctrl;

architecture tb of tb_spi_sram_ctrl is
    signal clk          : std_logic := '0';
    signal reset        :  STD_LOGIC;
    signal cmd_ready    :  STD_LOGIC;
    signal cmd_valid    :  STD_LOGIC;
    signal cmd_address  :  STD_LOGIC_VECTOR(32-1 downto 0);
    signal cmd_rw       :  STD_LOGIC;
    signal cmd_wdata    : STD_LOGIC_VECTOR(32-1 downto 0);
    
 

    -- 6 pins, plus power and ground to make 8 on a 23LC1024
    signal SI_SIO0      : std_logic;
    signal SCK          : std_logic;
    signal CS_N         : std_logic;
    signal SIO2         : std_logic;
    signal HOLD_N_SIO3  : std_logic;
    signal SO_SIO1      : std_logic;
    
    signal rsp_rdata    : std_logic_vector(32-1 downto 0);
    signal rsp_valid    : std_logic;
    signal rsp_ready    : std_logic;
        
begin
    
    clk <= not clk after 25ns; -- 50 ns period for 20MHz clock
    
  

--    u_spi_sram_ctrl : entity work.spi_sram_ctrl
--    port map(
--        spi_clk         => clk,         -- : in STD_LOGIC;
--        reset           => reset,       -- : in STD_LOGIC;
--        spi_cs_n        => CS_N,        -- : out STD_LOGIC;
--        spi_miso        => SO_SIO1,     -- : in STD_LOGIC;
--        spi_mosi        => SI_SIO0,     -- : out STD_LOGIC;
--        spi_hold_n      => HOLD_N_SIO3, -- : out STD_LOGIC;
                      
--        SCK             => SCK,         -- : out STD_LOGIC; -- clock that goes out to the SRAM chip
                     
--        cmd_ready_out   =>  cmd_ready,  -- : out STD_LOGIC;
--        cmd_valid_in    =>  cmd_valid,  -- : in STD_LOGIC;
--        cmd_address_in  =>  cmd_address(16 downto 0),-- : in STD_LOGIC_VECTOR(ADDR_W-1 downto 0);
--        cmd_rw_in       =>  cmd_rw,     -- : in STD_LOGIC;
--        cmd_wdata_in    =>  cmd_wdata,  -- : in STD_LOGIC_VECTOR(DATA_W-1 downto 0);
--        rsp_rdata_out   =>  rsp_rdata,  -- : out STD_LOGIC_VECTOR(DATA_W-1 downto 0);
--        rsp_ready_in    =>  rsp_ready,  -- : in STD_LOGIC;
--        rsp_valid_out   =>  rsp_valid   -- : out STD_LOGIC
    
--    );

     u_spi_sram_ctrl : entity work.qspi_sram_23lc1024_ctrl
             port map(
            spi_clk     => clk     ,
            reset       => reset   ,
            
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
        NUM_COMMANDS => 16
    )
    port map(
        clk        => clk,
        reset      => reset,
        cmd_ready_in   => cmd_ready,
        cmd_valid_out  => cmd_valid,
        cmd_address_out=> cmd_address,
        cmd_rw_out     => cmd_rw, 
        cmd_data_out   => cmd_wdata,
        
        rsp_rdata_in => rsp_rdata,
        rsp_valid_in => rsp_valid,
        rsp_ready_out => rsp_ready,
        
        error_count_out => open
    );     
    
    u_sram : entity work.M23LC1024
    port map(
        SI_SIO0 => SI_SIO0,
        SCK => SCK,
        CS_N => CS_N,
        SIO2 => SIO2,
        HOLD_N_SIO3 => HOLD_N_SIO3,
        RESET => reset,
        SO_SIO1 => SO_SIO1
    );


end architecture tb; 
