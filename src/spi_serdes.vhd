----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2020 17:31:32
-- Design Name: 
-- Module Name: spi_serdes - rtl
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

entity spi_serdes is
    generic(
        WORD_SIZE : integer := 8
    );
    Port ( spi_clk      : in STD_LOGIC;
           reset        : in STD_LOGIC;
           spi_miso     : in STD_LOGIC;
           spi_mosi     : out STD_LOGIC;
                      
           -- cmd in
           req_valid     : in STD_LOGIC;
           req_ready    : out std_logic;
           word_to_send : in STD_LOGIC_VECTOR (WORD_SIZE-1 downto 0);
           -- resp out
           word_received : out STD_LOGIC_VECTOR (WORD_SIZE-1 downto 0);
           transfer_done : out STD_LOGIC
           
       );

end spi_serdes;

architecture rtl of spi_serdes is
    
    type t_state is (IDLE, TRANSFER);
    signal state : t_state;
    signal clk_counter : integer; -- count cycles
    
    signal spi_shift_reg : std_logic_vector(WORD_SIZE-1 downto 0);
    
    signal current_rdata : std_logic_vector(WORD_SIZE-1 downto 0);
begin

    spi_mosi <= spi_shift_reg(WORD_SIZE-1);
    
    current_rdata <= spi_shift_reg(WORD_SIZE-2 downto 0) & spi_miso;
    
    spi_serdes_comb : process(state, clk_counter) is 
    begin
        case(state) is 
            when IDLE => 
                req_ready <= '1';
            when TRANSFER => 
                if clk_counter = WORD_SIZE-1 then
                    req_ready <= '1';
                else
                    req_ready <= '0';
                end if;        
        end case;
    end process;
    -- spi_serdes
    spi_serdes : process(spi_clk) is
    begin
        if rising_edge(spi_clk) then
            if reset = '1' then
                state <= IDLE;
            else
                case state is
                    when IDLE => 
                        if req_valid = '1' then
                            state <= TRANSFER;
                            -- perform a LOAD
                            clk_counter <= 1;
                            spi_shift_reg <= word_to_send;
                            
                            transfer_done <= '0'; -- now deassert this
                        end if;
                    when TRANSFER => 
                        
                        transfer_done <= '0'; -- default
                    
                        if clk_counter = 0 then 
                            -- Load/Save
                            spi_shift_reg <= word_to_send;
                            word_received <= spi_shift_reg(WORD_SIZE-2 downto 0) & spi_miso;
                        else 
                            -- shift the next bit in
                            spi_shift_reg(0) <= spi_miso;
                            spi_shift_reg(WORD_SIZE-1 downto 1) <= spi_shift_reg(WORD_SIZE-2 downto 0);
                        end if;
                        -- when we have shifted 8 bits
                        if clk_counter = WORD_SIZE-1 then
                            clk_counter <= 0;
                            transfer_done <= '1';
                             if req_valid = '0' then 
                                state <= IDLE;
                            end if;
                        else
                            clk_counter <= clk_counter + 1;        
                        end if;
                end case;
            end if; 
        end if;
    end process;
end rtl;
