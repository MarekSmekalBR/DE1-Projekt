----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 04:46:47 PM
-- Design Name: 
-- Module Name: bin2seg_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity tb_bin2bcd is
end tb_bin2bcd;

architecture test of tb_bin2bcd is
    component bin2bcd
        Port (
            BIN     : in  STD_LOGIC_VECTOR(7 downto 0);
            CLK     : in  STD_LOGIC;
            RST     : in  STD_LOGIC;
            BCD1    : out STD_LOGIC_VECTOR(3 downto 0);
            BCD10   : out STD_LOGIC_VECTOR(3 downto 0);
            BCD100  : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal BIN     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal CLK     : STD_LOGIC := '0';
    signal RST     : STD_LOGIC := '1';
    signal BCD1    : STD_LOGIC_VECTOR(3 downto 0);
    signal BCD10   : STD_LOGIC_VECTOR(3 downto 0);
    signal BCD100  : STD_LOGIC_VECTOR(3 downto 0);

    -- Hodiny: 10 ns perioda
    constant clk_period : time := 10 ns;

begin
    -- Propojení komponenty
    uut: bin2bcd
        port map (
            BIN     => BIN,
            CLK     => CLK,
            RST     => RST,
            BCD1    => BCD1,
            BCD10   => BCD10,
            BCD100  => BCD100
        );

    -- Generátor hodin
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for clk_period / 2;
            CLK <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimula?ní proces
    stim_proc : process
    begin
        -- Reset
        RST <= '1';
        wait for 20 ns;
        RST <= '0';

        -- Testované hodnoty
        BIN <= "00000000"; wait for clk_period; -- 0
        BIN <= "00000001"; wait for clk_period; -- 1
        BIN <= "00000101"; wait for clk_period; -- 5
        BIN <= "00001010"; wait for clk_period; -- 10
        BIN <= "00101010"; wait for clk_period; -- 42
        BIN <= "01100011"; wait for clk_period; -- 99
        BIN <= "01111011"; wait for clk_period; -- 123
        BIN <= "11111111"; wait for clk_period; -- 255


        wait;
    end process;
end test;


