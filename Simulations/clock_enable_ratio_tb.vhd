----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 07:39:38 PM
-- Design Name: 
-- Module Name: clock_enable_ratio_tb - Behavioral
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


-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 31.3.2024 11:16:44 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_clock_enable_ratio is
end tb_clock_enable_ratio;

architecture tb of tb_clock_enable_ratio is

    component clock_enable_ratio
        generic (
            PERIOD : integer := 6;
            RATIO : integer := 5
        );
        port (clk    : in std_logic;
              rst    : in std_logic;
              switch : in std_logic;
              pulse  : out std_logic);
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal switch : std_logic;
    signal pulse  : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clock_enable_ratio
    generic map (PERIOD => 2,
        RATIO => 2)
    port map (clk    => clk,
              rst    => rst,
              switch => switch,
              pulse  => pulse);

    -- Clock
    TbClock <= not TbClock after TbPeriod/4 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        -- Start
        switch <= '0';
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        -- Function
        wait for 20 ns;
        wait for 10 * TbPeriod;
        switch <= '1';
        wait for 10 * TbPeriod;
        -- Stop 
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_clock_enable_ratio of tb_clock_enable_ratio is
    for tb
    end for;
end cfg_tb_clock_enable_ratio;
