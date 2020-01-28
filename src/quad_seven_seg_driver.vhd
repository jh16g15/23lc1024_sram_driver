-- quad_seven_seg_driver.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quad_seven_seg_driver is
    generic(
        G_DECIMAL_DISPLAY : boolean := false
    );
    port(
        clk     : in    std_logic;
--        data_in : in    std_logic_vector(15 downto 0);
        
        sw      : in    std_logic_vector(15 downto 0);
        
        sseg_ca : out   std_logic_vector(7 downto 0); -- segment select
        sseg_an : out   std_logic_vector(3 downto 0) := x"1" -- char select
    );
end entity quad_seven_seg_driver;
        
architecture rtl of quad_seven_seg_driver is 
    signal char_data : std_logic_vector(3 downto 0);
    
    -- anode char control
    signal one_hot_char_sel_n : std_logic_vector(3 downto 0) := b"0111";
    
    signal slowclk : std_logic;
    signal clk_div_counter : unsigned(16 downto 0) := (others => '0'); 
    
    -- for counter
    signal display_data : unsigned(15 downto 0) := (others=>'0');
    signal super_slow_counter : unsigned(10 downto 0); 
    signal super_slow_clk : std_logic;
    
    
begin

    slowclk <= clk_div_counter(16);
    
    clk_div : process(clk) is
    begin
        if rising_edge(clk) then
            clk_div_counter <= clk_div_counter + 1;
        end if;
    end process clk_div;

    sseg_an <= one_hot_char_sel_n;
--    sseg_an <= b"0000";

    -- selects the active digit
    char_counter : process(slowclk) is 
    begin
        if rising_edge(slowclk) then
            case(one_hot_char_sel_n) is
                when b"0111" => one_hot_char_sel_n <= b"1011"; char_data <= std_logic_vector(display_data( 3 downto  0));
                when b"1011" => one_hot_char_sel_n <= b"1101"; char_data <= std_logic_vector(display_data( 7 downto  4));
                when b"1101" => one_hot_char_sel_n <= b"1110"; char_data <= std_logic_vector(display_data(11 downto  8));
                when b"1110" => one_hot_char_sel_n <= b"0111"; char_data <= std_logic_vector(display_data(15 downto 12));
                when others  => one_hot_char_sel_n <= b"0111"; char_data <= x"F"; -- TODO add error response
            end case;
        end if;
    end process char_counter;

    display_data(15 downto 12) <= x"3";
    display_data(11 downto  8) <= x"2";
    display_data( 7 downto  4) <= x"1";
    display_data( 3 downto  0) <= x"0";
    
    -- the above displays in this order: 3012
    


--    char_data <= sw(3 downto 0);
    
--    -- increment data to be displayed
--    data_counter : process(super_slow_clk) is
--    begin
--        if rising_edge(super_slow_clk) then
--            display_data <= display_data + 1;        
--        end if;
--    end process data_counter;
    
    super_slow_clk <= super_slow_counter(8);
        
    super_slowclk : process(slowclk) is    
    begin
        if rising_edge(slowclk) then
            super_slow_counter <= super_slow_counter + 1;
        end if;
    end process super_slowclk;
    
    -- character to segment decoder
    -- sseg_ca(0:6) are segments A to G
    -- sseg_ca(7) is the decimal point
    --  A
    -- F B
    --  G
    -- E C
    --  D  .
    char_decode : process(char_data) is
    begin                                  --    Active low:
        case(char_data) is                 --    ".GFEDCBA"   
            when x"0" => sseg_ca(7 downto 0) <= b"11000000"; 
            when x"1" => sseg_ca(7 downto 0) <= b"11111001"; 
            when x"2" => sseg_ca(7 downto 0) <= b"10100100"; 
            when x"3" => sseg_ca(7 downto 0) <= b"10110000"; 
            when x"4" => sseg_ca(7 downto 0) <= b"10011001"; 
            when x"5" => sseg_ca(7 downto 0) <= b"10010010"; 
            when x"6" => sseg_ca(7 downto 0) <= b"10000010"; 
            when x"7" => sseg_ca(7 downto 0) <= b"11111000"; 
            when x"8" => sseg_ca(7 downto 0) <= b"10000000"; 
            when x"9" => sseg_ca(7 downto 0) <= b"10010000"; 
            when x"A" => sseg_ca(7 downto 0) <= b"10001000"; 
            when x"B" => sseg_ca(7 downto 0) <= b"10000011"; 
            when x"C" => sseg_ca(7 downto 0) <= b"11000110"; 
            when x"D" => sseg_ca(7 downto 0) <= b"10100001"; 
            when x"E" => sseg_ca(7 downto 0) <= b"10000110"; 
            when x"F" => sseg_ca(7 downto 0) <= b"10001110"; 
        end case;
    end process char_decode;    
  
    
end architecture rtl;