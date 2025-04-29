----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2025 07:20:17 PM
-- Design Name: 
-- Module Name: PWM_LED_tb - Behavioral
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

entity PWM_LED_tb is
end PWM_LED_tb;

architecture tb of PWM_LED_tb is

    component PWM_LED
        generic (
            C_END : integer := 300
        );
        port (clk     : in std_logic;
              rst     : in std_logic;
              en      : in std_logic;
              POS     : in std_logic_vector (7 downto 0);
              pwm_out : out std_logic);
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal en      : std_logic;
    signal POS     : std_logic_vector (7 downto 0);
    signal pwm_out : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PWM_LED
    generic map (
        C_END => 12)
    port map (clk     => clk,
              rst     => rst,
              en      => en,
              POS     => POS,
              pwm_out => pwm_out);

    -- Clock 
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;
    en <= '1';

    stimuli : process
    begin
            
        POS <= b"0001_0000";

        -- Reset
        rst <= '1';
        wait for 40 ns;
        rst <= '0';
        --Function
        wait for 40 ns;
        wait for 40 * TbPeriod;
        POS <= b"0000_0101";
        wait for 40 * TbPeriod;
        -- Stop
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_PWM_LED_tb of PWM_LED_tb is
    for tb
    end for;
end cfg_PWM_LED_tb;