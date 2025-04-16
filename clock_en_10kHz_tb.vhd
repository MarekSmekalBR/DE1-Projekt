  library ieee;
  use ieee.std_logic_1164.all;

entity clock_en_10kHz_tb is
end entity clock_en_10kHz_tb;

architecture tb of clock_en_10kHz_tb is

  component clock_en_10kHz is
    generic (
      n_periods : integer
    );
    port (
      clk   : in    std_logic;
      rst   : in    std_logic;
      pulse : out   std_logic
    );
  end component;

  signal clk        : std_logic := '0';
  signal rst        : std_logic;
  signal pulse      : std_logic;

  constant tbperiod : time := 10 ns;  -- 100MHz clock
  signal tbsimended : std_logic := '0';

begin

  dut : clock_en_10kHz
    generic map (
      n_periods => 10_000  -- 100MHz / 10kHz
    )
    port map (
      clk   => clk,
      rst   => rst,
      pulse => pulse
    );

  -- Clock generation
  clk <= not clk after tbperiod / 2 when tbsimended /= '1' else '0';

  -- Stimuli
  stimuli : process
  begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    -- Simulate long enough to see a few pulses
    wait for 100 ms;  -- 10kHz => 1 pulse per 100us

    tbsimended <= '1';
    wait;
  end process;

end architecture tb;

configuration cfg_clock_en_10kHz_tb of clock_en_10kHz_tb is
  for tb
  end for;
end cfg_clock_en_10kHz_tb;
