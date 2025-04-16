----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 05:27:17 PM
-- Design Name: 
-- Module Name: medium_1_tb - Behavioral
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

entity tb_medium_1 is
end tb_medium_1;

architecture behavior of tb_medium_1 is

    -- Component under test
    component medium_1
        port (
            BTNC     : in STD_LOGIC;
            BTNL     : in STD_LOGIC;
            BTNR     : in STD_LOGIC;
            CLK_10kHz: in STD_LOGIC;
            CLK_20Hz : in STD_LOGIC;
            CLK      : in STD_LOGIC;
            RST      : in STD_LOGIC;
            SW_1     : in STD_LOGIC;
            PWM      : out STD_LOGIC;
            SEG_1    : out STD_LOGIC_VECTOR(6 downto 0);
            SEG_10   : out STD_LOGIC_VECTOR(6 downto 0);
            SEG_100  : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signals
    signal BTNC     : STD_LOGIC := '0';
    signal BTNL     : STD_LOGIC := '0';
    signal BTNR     : STD_LOGIC := '0';
    signal CLK_10kHz: STD_LOGIC := '0';
    signal CLK_20Hz : STD_LOGIC := '0';
    signal CLK      : STD_LOGIC := '0';
    signal RST      : STD_LOGIC := '0';
    signal SW_1     : STD_LOGIC := '0';
    signal PWM      : STD_LOGIC;
    signal SEG_1    : STD_LOGIC_VECTOR(6 downto 0);
    signal SEG_10   : STD_LOGIC_VECTOR(6 downto 0);
    signal SEG_100  : STD_LOGIC_VECTOR(6 downto 0);

    -- Clock periods
    constant CLK_PERIOD      : time := 10 ns;
    constant CLK_10kHz_PERIOD: time := 100 us;
    constant CLK_20Hz_PERIOD : time := 50 ms;

begin

    -- Instantiate DUT
    uut: medium_1
        port map (
            BTNC      => BTNC,
            BTNL      => BTNL,
            BTNR      => BTNR,
            CLK_10kHz => CLK_10kHz,
            CLK_20Hz  => CLK_20Hz,
            CLK       => CLK,
            RST       => RST,
            SW_1      => SW_1,
            PWM       => PWM,
            SEG_1     => SEG_1,
            SEG_10    => SEG_10,
            SEG_100   => SEG_100
        );

    -- Main CLK
    clk_proc: process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- 10kHz CLK
    clk_10k_proc: process
    begin
        while true loop
            CLK_10kHz <= '0';
            wait for CLK_10kHz_PERIOD / 2;
            CLK_10kHz <= '1';
            wait for CLK_10kHz_PERIOD / 2;
        end loop;
    end process;

    -- 20Hz CLK
    clk_20_proc: process
    begin
        while true loop
            CLK_20Hz <= '0';
            wait for CLK_20Hz_PERIOD / 2;
            CLK_20Hz <= '1';
            wait for CLK_20Hz_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        -- Initial reset
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        BTNC <= '1';  -- reset servo to middle
        wait for 50 ns;
        BTNC <= '0';

        -- Simulate enable switch
        SW_1 <= '1';
wait for 50 ns;
        -- Move servo right
        BTNR <= '1';
        wait for 100 ns;
        BTNR <= '0';

        -- Move servo left
        wait for 200 ns;
        BTNL <= '1';
        wait for 150 ns;
        BTNL <= '0';

        -- Wait and observe
        wait for 1 sec;

        -- End simulation
        wait;
    end process;

end behavior;

