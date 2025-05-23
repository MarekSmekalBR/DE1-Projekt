----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 04:10:40 PM
-- Design Name: 
-- Module Name: PWM_LED - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

entity PWM_LED is
    generic (
        C_END   : integer := 100 -- counter end
    );
    Port ( 
        clk     : in STD_LOGIC; -- main clock
        rst     : in STD_LOGIC; -- reset
        en      : in STD_LOGIC; -- component enable 
        POS     : in STD_LOGIC_VECTOR(7 downto 0); -- position
        pwm_out : out STD_LOGIC -- PWM output 
    );
end PWM_LED;

architecture Behavioral of PWM_LED is

    constant N    : integer := integer(ceil(log2(real(C_END + 1)))); -- number of bits needed

    signal sig_count    : STD_LOGIC_VECTOR (N - 1 downto 0) := (others => '0'); -- internal counter value
    signal sig_pwm_out  : STD_LOGIC := '1'; -- internal PWM signal
    
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst='1' then -- on reset
                sig_count <= (others => '0');
                sig_pwm_out <= '1';
                
            elsif en='1' then -- on enable
                if sig_count = C_END -1 then -- on pwm overflow
                    sig_count <= (others => '0');
                    sig_pwm_out <= '1';
                    
                else
                    if sig_count >= POS then -- position hit
                        sig_pwm_out <= '0';
                        
                    end if;
                    sig_count <= sig_count + 1;
                    
                end if;
            end if;
        end if;
    end process;
    
    pwm_out <= sig_pwm_out; -- out

end Behavioral;
