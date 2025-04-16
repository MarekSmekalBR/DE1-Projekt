-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 3.4.2024 11:22:44 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_pwm_generator is
end tb_pwm_generator;

architecture tb of tb_pwm_generator is

    component pwm_generator
        generic (
            C_END : integer := 300
        );
        port (clk     : in std_logic;
              rst     : in std_logic;
              en      : in std_logic;
              lum     : in std_logic_vector (7 downto 0);
              pwm_out : out std_logic);
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal en      : std_logic;
    signal lum     : std_logic_vector (7 downto 0);
    signal pwm_out : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : pwm_generator
    generic map (
        C_END => 12)
    port map (clk     => clk,
              rst     => rst,
              en      => en,
              lum     => lum,
              pwm_out => pwm_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;
    en <= '1';

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        
        lum <= b"0000_1000";

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 30 ns;
        wait for 36 * TbPeriod;
        lum <= b"0000_0011";
        -- EDIT Add stimuli here
        wait for 36 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_pwm_generator of tb_pwm_generator is
    for tb
    end for;
end cfg_tb_pwm_generator;