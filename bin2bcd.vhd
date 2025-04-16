----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 04:45:37 PM
-- Design Name: 
-- Module Name: bin2bcd - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity bin2bcd is
    Port (
        BIN     : in  STD_LOGIC_VECTOR(7 downto 0);
        CLK     : in  STD_LOGIC;
        RST     : in  STD_LOGIC;
        BCD_1    : out STD_LOGIC_VECTOR(3 downto 0);  -- jednotky
        BCD_10   : out STD_LOGIC_VECTOR(3 downto 0);  -- desítky
        BCD_100  : out STD_LOGIC_VECTOR(3 downto 0)   -- stovky
    );
end bin2bcd;

architecture Behavioral of bin2bcd is
    signal bin_int    : integer := 0;
    signal bcd_1s     : integer := 0;
    signal bcd_10s    : integer := 0;
    signal bcd_100s   : integer := 0;
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            BCD_1   <= (others => '0');
            BCD_10  <= (others => '0');
            BCD_100 <= (others => '0');
        elsif rising_edge(CLK) then
            bin_int    <= to_integer(unsigned(BIN));
            bcd_100s   <= bin_int / 100;
            bcd_10s    <= (bin_int mod 100) / 10;
            bcd_1s     <= bin_int mod 10;

            BCD_1   <= std_logic_vector(to_unsigned(bcd_1s, 4));
            BCD_10  <= std_logic_vector(to_unsigned(bcd_10s, 4));
            BCD_100 <= std_logic_vector(to_unsigned(bcd_100s, 4));
        end if;
    end process;
end Behavioral;
