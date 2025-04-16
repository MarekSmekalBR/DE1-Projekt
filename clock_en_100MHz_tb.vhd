library ieee;
  use ieee.std_logic_1164.all;

entity clock_en_100MHz_tb is
end entity clock_en_100MHz_tb;

architecture tb of clock_en_100MHz_tb is

  component clock_en_100MHz is
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

  constant tbperiod : time := 10 ns;  -- 100MHz
  signal tbsimended : std_logic := '0';

begin

  dut : clock_en_100MHz
    generic map (
      n_periods => 1
    )
    port map (
      clk   => clk,
      rst   => rst,
      pulse => pulse
    );

  clk <= not clk after tbperiod / 2 when tbsimended /= '1' else '0';

  stimuli : process
  begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    
    wait for 100 ms;

    tbsimended <= '1';
    wait;
  end process;

end architecture tb;

configuration cfg_clock_en_100MHz_tb of clock_en_100MHz_tb is
  for tb
  end for;
end cfg_clock_en_100MHz_tb;
