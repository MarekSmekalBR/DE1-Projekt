-------------------------------------------------
--! @brief Clock enable 10kHz
--! @version 1.0
--! Generates 10kHz enable pulse from 100MHz clock
--! Each pulse is one clock wide
-------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity clock_en_10kHz is
  generic (
    n_periods : integer := 10_000  -- 100MHz / 10kHz = 10_000
  );
  port (
    clk   : in    std_logic; -- Main clock
    rst   : in    std_logic; -- High-active synchronous reset
    pulse : out   std_logic  -- Clock enable pulse
  );
end entity clock_en_10kHz;

architecture behavioral of clock_en_10kHz is
  signal sig_count : integer range 0 to n_periods - 1 := 0;
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        sig_count <= 0;
      elsif sig_count < (n_periods - 1) then
        sig_count <= sig_count + 1;
      else
        sig_count <= 0;
      end if;
    end if;
  end process;

  pulse <= '1' when sig_count = n_periods - 1 else '0';

end architecture behavioral;
