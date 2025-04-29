----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 05:35:12 PM
-- Design Name: 
-- Module Name: bin2seg - Behavioral
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

entity bin2seg is
    Port ( 
        clear   : in STD_LOGIC; -- display off 
        bin     : in STD_LOGIC_VECTOR (3 downto 0); -- input (bin)
        seg     : out STD_LOGIC_VECTOR (6 downto 0) -- segment signal
    );
end bin2seg;

architecture Behavioral of bin2seg is

begin
    lum_7seg_decoder : process (bin, clear) is
    begin
    
        if (clear = '1') then
            seg <= "1111111";  -- Clear display
            
        else
        -- binary numbers to segments
            case bin is  
                when x"0" => 
                    seg <= "0000001";
                when x"1" =>
                    seg <= "1001111";
                when x"2" =>
                    seg <= "0010010";
                when x"3" =>
                    seg <= "0000110";
                when x"4" =>
                    seg <= "1001100";
                when x"5" =>
                    seg <= "0100100";
                when x"6" =>
                    seg <= "0100000";
                when x"7" =>
                    seg <= "0001111";
                when x"8" =>
                    seg <= "0000000";
                when x"9" =>
                    seg <= "0000100";
                when x"A" =>
                    seg <= "0001000";
                when x"B" =>
                    seg <= "1100000";
                when x"C" =>
                    seg <= "0110001";
                when x"D" =>
                    seg <= "1000010";
                when x"E" =>
                    seg <= "0110000";
                when x"F" =>
                    seg <= "0111000";
                when others =>
                    seg <= "0000001";
            end case;
        end if;    
    end process lum_7seg_decoder;
    
end Behavioral;
