  library ieee;
  use ieee.std_logic_1164.all;

entity clock_en_20Hz_tb is
end entity clock_en_20Hz_tb;

architecture tb of clock_en_20Hz_tb is

  component clock_en_20Hz is
    generic (
      n_periods : integer
    );
    port (
      clk   : in    std_logic;
      rst   : in    std_logic;
      pulse : out   std_logic
    );
  end component clock_en_20Hz;

  signal clk   : std_logic;
  signal rst   : std_logic;
  signal pulse : std_logic;

  constant tbperiod   : time      := 10 ns; -- 100 MHz clock
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin

  dut : component clock_en_20Hz
    generic map (
      n_periods => 5000000  -- 100MHz / 20Hz 
    )
    port map (
      clk   => clk,
      rst   => rst,
      pulse => pulse
    );

  -- Clock generation
  tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
             '0';

  clk <= tbclock;

  stimuli : process is
  begin
    -- Reset
    rst <= '1';
    wait for 10 ns;
    rst <= '0';

    -- Simulace
    wait for 100 ms;  -- 5 pulzu

    tbsimended <= '1';
    wait;
  end process stimuli;

end architecture tb;

configuration cfg_clock_en_20Hz_tb of clock_en_20Hz_tb is
    for tb
    end for;
end cfg_clock_en_20Hz_tb;
