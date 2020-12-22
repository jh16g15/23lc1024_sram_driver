----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2020 17:59:33
-- Design Name: 
-- Module Name: tb_spi_serdes - Behavioral
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

entity tb_spi_serdes is
--  Port ( );
end tb_spi_serdes;

architecture Behavioral of tb_spi_serdes is
    signal spi_clk       : std_logic := '0';
    signal reset         : std_logic;
    signal spi_cs_n      : std_logic;
    signal spi_miso      : std_logic;
    signal spi_mosi      : std_logic;
    signal spi_hold_n    : std_logic;
    -- cmd in     
    signal req_valid     : std_logic;
    signal req_ready     : std_logic;
    signal word_to_send  : std_logic_vector(7 downto 0);
    -- resp out 
    signal word_received : std_logic_vector(7 downto 0);
    signal done          : std_logic;
    
    constant TCLK : time := 50 ns; 
    
    -- test peripheral
    signal slave_shift_reg : std_logic_vector(7 downto 0) := x"00";
    signal slave_sel       : std_logic;
begin
    
    spi_clk <= not spi_clk after TCLK/2;


    
    stim : process is 
    begin
        slave_sel <= '0';
        reset <= '1';
        wait for TCLK * 2;
        reset <= '0';
        word_to_send <= x"FF";
        req_valid <= '1';
        wait for TCLK;
        slave_sel <= '1';
        wait until req_ready = '1';
        word_to_send <= x"01";
        wait until req_ready = '1';
        word_to_send <= x"02";
        wait until req_ready = '1';
        word_to_send <= x"03";
        wait until req_ready = '1';
        word_to_send <= x"04";
        wait until req_ready = '1';
        word_to_send <= x"05";
        wait until req_ready = '1';
        word_to_send <= x"06";
        wait until req_ready = '1';
        word_to_send <= x"07";
        
        
        wait;
    end process;
    
    spi_miso <= slave_shift_reg(7);
    
    slave : process(spi_clk) is 
    begin
        if rising_edge(spi_clk) then
            if slave_sel = '1' then
                slave_shift_reg(0) <= spi_mosi;
                slave_shift_reg(7 downto 1) <= slave_shift_reg(6 downto 0);
            end if;
        end if;
    end process;

    u_spi_serdes : entity work.spi_serdes
        port map(
            spi_clk        =>  spi_clk    ,
            reset          =>  reset      ,
--            spi_cs_n       =>  spi_cs_n   ,
            spi_miso       =>  spi_miso   ,
            spi_mosi       =>  spi_mosi   ,
--            spi_hold_n     =>  spi_hold_n ,
            -- cmd in      
            req_valid            => req_valid        ,
            req_ready            => req_ready        ,

            word_to_send   => word_to_send ,
            -- resp out   
            word_received  => word_received     
     
            );
            
            
            end Behavioral;
