----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 05:04:49 PM
-- Design Name: 
-- Module Name: luminosity - Behavioral
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

entity luminosity is
   
Port (  
        rst     : in STD_LOGIC; -- reset 
        down    : in STD_LOGIC; -- intensity decrement
        up   : in STD_LOGIC;    -- intenisty increment
        clk     : in STD_LOGIC; -- main clock 
        en      : in STD_LOGIC; -- enable 
        comp_en : in STD_LOGIC; -- component enable 
        lum     : out STD_LOGIC_VECTOR (7 downto 0) -- output position
    );
end luminosity;

architecture Behavioral of luminosity is
    
    signal sig_count : std_logic_vector(7 downto 0) := b"0011_0010"; -- default value is 50
begin
    lum_clk_enable : process (clk) is
    begin
        if (rising_edge(clk)) then
            if comp_en = '1' then -- if  component enabled
                if rst = '1' then -- reset
                    sig_count <= b"0011_0010"; -- reset to 50
                    
                elsif en = '1' then -- on enable
                    if not (down = '1' and up = '1') then -- values between 1 and 100
                        if down ='1' and sig_count > b"0000_0001" then -- min 1
                            sig_count <= sig_count - 1;
                        end if;
                        
                        if up = '1' and sig_count < b"0110_0100" then -- max 100
                            sig_count <= sig_count + 1;
                            
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process lum_clk_enable;
    
    lum <= sig_count; --output

end Behavioral;