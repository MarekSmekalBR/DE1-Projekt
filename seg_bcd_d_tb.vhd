----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 04:36:21 PM
-- Design Name: 
-- Module Name: seg_bcd_d_tb - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seg_bcd_d_tb is
end seg_bcd_d_tb;

architecture test of seg_bcd_d_tb is
    -- Deklarace komponenty
    component seg_bcd_d
        Port (
            bin    : in  STD_LOGIC_VECTOR(3 downto 0);
            clear  : in  STD_LOGIC;
            seg    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signály pro test
    signal bin    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal clear  : STD_LOGIC := '0';
    signal seg    : STD_LOGIC_VECTOR(6 downto 0);
begin
    -- Instance testované jednotky
    uut: seg_bcd_d
        Port map (
            bin   => bin,
            clear => clear,
            seg   => seg
        );

    -- Testovací proces
    stim_proc: process
    begin
        clear <= '0';  -- testujeme bez mazání
        bin <= "0000"; wait for 10 ns; -- 0
        bin <= "0001"; wait for 10 ns; -- 1
        bin <= "0010"; wait for 10 ns; -- 2
        bin <= "0011"; wait for 10 ns; -- 3
        bin <= "0100"; wait for 10 ns; -- 4
        bin <= "0101"; wait for 10 ns; -- 5
        bin <= "0110"; wait for 10 ns; -- 6
        bin <= "0111"; wait for 10 ns; -- 7
        bin <= "1000"; wait for 10 ns; -- 8
        bin <= "1001"; wait for 10 ns; -- 9
        bin <= "1010"; wait for 10 ns; -- 10
        bin <= "1011"; wait for 10 ns; -- 11
        bin <= "1100"; wait for 10 ns; -- 12
        bin <= "1101"; wait for 10 ns; -- 13
        bin <= "1110"; wait for 10 ns; -- 14
        bin <= "1111"; wait for 10 ns; -- 15
        wait;  -- konec testu
    end process;
end test;
