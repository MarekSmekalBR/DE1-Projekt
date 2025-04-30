----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 04:08:19 PM
-- Design Name: 
-- Module Name: clock_en_ratio - Behavioral
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

entity clock_enable_ratio is
    generic (
        PERIOD  : integer := 6; -- input clock (cycles per pulse)
        RATIO   : integer := 5  -- period multiplier
    );
    Port ( 
        clk     : in STD_LOGIC; -- clock 
        rst     : in STD_LOGIC; -- reset 
        switch  : in STD_LOGIC; -- switch to enable/disable ratio * period
        pulse   : out STD_LOGIC -- output pulse
    );
end clock_enable_ratio;

architecture Behavioral of clock_enable_ratio is
    constant bits_needed    : integer := integer(ceil(log2(real(PERIOD * RATIO + 1)))); -- bits required for counter
    
    signal sig_count        : std_logic_vector(bits_needed - 1 downto 0) := (others => '0'); -- internal counter value
    signal sig_period       : integer; -- period in use
    signal sig_pulse        : STD_LOGIC := '0'; -- internal output
    
begin
    lum_clk_enable : process (clk) is
    begin
        if (rising_edge(clk)) then
            if rst = '1' then -- reset
                sig_count <= (others => '0');
                sig_pulse <= '0';
                
            elsif sig_count = sig_period - 1 then --counter overflow
                sig_count <= (others => '0');
                sig_pulse <= '1';
                
            else
                sig_count <= sig_count + 1;
                sig_pulse <= '0';
                
            end if;
        end if;
    end process lum_clk_enable;
    
    sig_period  <= PERIOD when switch = '0' else PERIOD * RATIO; -- setting counter period
    pulse       <= sig_pulse; -- out signal
    
end Behavioral;
