----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2025 23:37:45
-- Design Name: 
-- Module Name: top_level_tb - Behavioral
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

entity tb_top_level is
end tb_top_level;

architecture sim of tb_top_level is

    signal BTNL       : std_logic := '0';
    signal BTNR       : std_logic := '0';
    signal BTNC       : std_logic := '0';
    signal BTND       : std_logic := '0';
    signal CLK100MHZ  : std_logic := '0';
    signal SW         : std_logic := '0';
    signal SW_LED     : std_logic_vector(1 downto 0) := (others => '0');
    signal LED16_G    : std_logic;
    signal LED16_R    : std_logic;
    signal CA, CB, CC, CD, CE, CF, CG, DP : std_logic;
    signal AN         : std_logic_vector(7 downto 0);
    signal PWMOut     : std_logic_vector(1 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: entity work.top_level
        port map (
            BTNL       => BTNL,
            BTNR       => BTNR,
            BTNC       => BTNC,
            BTND       => BTND,
            CLK100MHZ  => CLK100MHZ,
            SW         => SW,
            SW_LED     => SW_LED,
            LED16_G    => LED16_G,
            LED16_R    => LED16_R,
            CA         => CA,
            CB         => CB,
            CC         => CC,
            CD         => CD,
            CE         => CE,
            CF         => CF,
            CG         => CG,
            DP         => DP,
            AN         => AN,
            PWMOut     => PWMOut
        );

    -- Generování hodin
    clk_gen: process
    begin
        while now < 5 ms loop
            CLK100MHZ <= '0';
            wait for CLK_PERIOD / 2;
            CLK100MHZ <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- Start and reset
        BTND <= '1';
        wait for 100 ns;
        BTND <= '0';
        -- Function
        SW_LED(0) <= '1';
        wait for 500 ns;
        BTNL <= '1';
        wait for 20 ns;
        BTNL <= '0';
        wait for 200 ns;
        BTNR <= '1';
        wait for 20 ns;
        BTNR <= '0';
        wait for 200 ns;
        BTNC <= '1';
        wait for 20 ns;
        BTNC <= '0';
        wait for 200 ns;
        SW <= '1';
        wait for 500 ns;
        SW_LED(1) <= '1';
        wait for 10 ns;
        BTNL <= '1'; wait for 20 ns; BTNL <= '0'; wait for 100 ns;
        BTNR <= '1'; wait for 20 ns; BTNR <= '0'; wait for 100 ns;
        BTNL <= '1'; wait for 20 ns; BTNL <= '0'; wait for 100 ns;
        SW <= '0';
        wait for 50 ns;
        -- Reset
        BTND <= '1';
        wait for 50 ns;
        BTND <= '0';
        wait for 1 ms;
        --Stop
        wait;
    end process;

end sim;
