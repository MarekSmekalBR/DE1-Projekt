----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 04:44:25 PM
-- Design Name: 
-- Module Name: clock_enable - Behavioral
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
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;

entity clock_enable is
    generic (
        PERIOD  : integer := 6 -- input clock cycles per pulse
    );
    Port ( 
        clk     : in STD_LOGIC; -- clock 
        rst     : in STD_LOGIC; -- reset 
        pulse   : out STD_LOGIC -- output signal 
    );
end clock_enable;

architecture Behavioral of clock_enable is
    constant bits_needed    : integer := integer(ceil(log2(real(PERIOD + 1)))); -- required bits for internal counter
    
    signal sig_count        : std_logic_vector(bits_needed - 1 downto 0) := (others => '0'); -- internal value
    signal sig_pulse        : std_logic; -- internal out signal

begin
    lum_clk_enable : process (clk) is
    begin
        if (rising_edge(clk)) then
            if rst = '1' then -- on reset
                sig_count <= (others => '0');
                sig_pulse <= '0';
                
            elsif sig_count = PERIOD - 1 then -- if counter overflow
                sig_count <= (others => '0');
                sig_pulse <= '1';
                
            else
                sig_count <= sig_count + 1;
                sig_pulse <= '0';
                
            end if;
        end if;
    end process lum_clk_enable;
    
    pulse <= sig_pulse; --  out 
    
end Behavioral;
