----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2020 14:12:16
-- Design Name: 
-- Module Name: tb_axis_cmd_driver - tb
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

entity tb_axis_cmd_driver is
--  Port ( );
end tb_axis_cmd_driver;

architecture tb of tb_axis_cmd_driver is
    signal clk          : std_logic := '0';
    signal reset        :  STD_LOGIC;
    signal ready_in     :  STD_LOGIC;
    signal valid_out    :  STD_LOGIC;
    signal address_out  :  STD_LOGIC_VECTOR(32-1 downto 0);
    signal rw_out       :  STD_LOGIC;
    signal data_out     : STD_LOGIC_VECTOR(32-1 downto 0);
    
    type t_state is (READY, NOT_READY);
    signal state : t_state := NOT_READY;
    
begin
    
    clk <= not clk after 50ns;
    
--    ready_in <= '1';
      
    process(clk)    
    begin
        if rising_edge(clk) then
            case(state) is 
                when READY =>
                    if valid_out = '1' then
                        state <= NOT_READY;
                        ready_in <= '0';
                    end if;
                
                when NOT_READY =>
                    state <= READY;
                    ready_in <= '1';
                
            end case;
        end if;
    end process;
    
    dut : entity work.axis_cmd_driver
    port map(
       clk        => clk        ,
       reset      => reset      ,
       ready_in   => ready_in   ,
       valid_out  => valid_out  ,
       address_out=> address_out,
       rw_out     => rw_out     , 
     data_out   => data_out   
    );
    

end tb;
