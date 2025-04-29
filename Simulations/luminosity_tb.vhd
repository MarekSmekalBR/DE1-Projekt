----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 03:14:44 PM
-- Design Name: 
-- Module Name: luminosity_tb - Behavioral
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

entity luminosity_tb is
end luminosity_tb;

architecture tb of luminosity_tb is

    component luminosity
        port (rst     : in std_logic;
              down    : in std_logic;
              up   : in std_logic;
              lum     : out std_logic_vector (7 downto 0);
              clk     : in std_logic;
              en      : in std_logic;
              comp_en : in std_logic);
    end component;

    signal rst     : std_logic;
    signal down    : std_logic;
    signal up   : std_logic;
    signal lum     : std_logic_vector (7 downto 0);
    signal clk     : std_logic;
    signal en      : std_logic;
    signal comp_en : std_logic;

    constant TbPeriod : time := 5 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : luminosity
    port map (rst     => rst,
              down    => down,
              up      => up,
              lum     => lum,
              clk     => clk,
              en      => en,
              comp_en => comp_en);

    -- Clock
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        -- Start
        down <= '0';
        up <= '0';
        en <= '0';
        comp_en <= '1';
        -- Reset
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        -- Function
        en <= '1';
        wait for 40 ns;
        down <= '1';
        wait for 30 ns;
        down <= '0';
        wait for 20 ns;
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        up <= '1';
        wait for 300 ns;
        down <= '1';
        wait for 40 ns;
        up <= '0';
        wait for 30 ns;
        up <= '1';
        wait for 20 ns;
        up <= '0';
        wait for 100 ns;
        -- Stop 
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_luminosity_tb of luminosity_tb is
    for tb
    end for;
end cfg_luminosity_tb;


