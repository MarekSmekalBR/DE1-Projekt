----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2025 23:00:30
-- Design Name: 
-- Module Name: clock_en_500Hz - Behavioral
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



library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity clock_en_500Hz is
    generic (
      n_periods : integer := 200_000  --! 100MHz / 500Hz
    );
  port (
    clk   : in    std_logic; 
    rst   : in    std_logic;
    pulse : out   std_logic  
  );
end entity clock_en_500Hz;

-------------------------------------------------

architecture behavioral of clock_en_500Hz is

  signal sig_count : integer range 0 to n_periods - 1;

begin

  p_clk_enable : process (clk) is
  begin

    if (rising_edge(clk)) then                   
      if (rst = '1') then                        
        sig_count <= 0;
      elsif (sig_count < (n_periods - 1)) then
        sig_count <= sig_count + 1;         
      else
        sig_count <= 0;
      end if;                       
    end if;

  end process p_clk_enable;
  
  pulse <= '1' when (sig_count = n_periods - 1) else
           '0';

end architecture behavioral; 
