----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 04:34:32 PM
-- Design Name: 
-- Module Name: seg_bcd_j - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seg_bcd_j is
    Port (
        bin    : in  STD_LOGIC_VECTOR(3 downto 0);
        clear  : in  STD_LOGIC;
        seg    : out STD_LOGIC_VECTOR(6 downto 0)  -- a-g segments
    );
end seg_bcd_j;

architecture Behavioral of seg_bcd_j is
begin
    process(bin, clear)
    begin
        if clear = '1' then
            seg <= "1111111";  -- everything off
        else
            case bin is
                when "0000" => seg <= "0000001"; -- 0
                when "0001" => seg <= "1001111"; -- 1
                when "0010" => seg <= "0010010"; -- 2
                when "0011" => seg <= "0000110"; -- 3
                when "0100" => seg <= "1001100"; -- 4
                when "0101" => seg <= "0100100"; -- 5
                when "0110" => seg <= "0100000"; -- 6
                when "0111" => seg <= "0001111"; -- 7
                when "1000" => seg <= "0000000"; -- 8
                when "1001" => seg <= "0000100"; -- 9
                when others => seg <= "1111111"; -- default - lights off
            end case;
        end if;
    end process;
end Behavioral;

