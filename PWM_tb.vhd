----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 04:08:57 PM
-- Design Name: 
-- Module Name: PWM_tb - Behavioral
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

entity PWM_gen_tb is
end PWM_gen_tb;

architecture tb of PWM_gen_tb is

    component PWM_gen
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

    dut : PWM_gen
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


