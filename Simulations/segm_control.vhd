----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 07:12:05 PM
-- Design Name: 
-- Module Name: segm_control_tb - Behavioral
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

entity segm_control_tb is
end segm_control_tb;

architecture tb of segm_control_tb is

    component segm_control
        port (CA    : out std_logic;
              CB    : out std_logic;
              CC    : out std_logic;
              CD    : out std_logic;
              CE    : out std_logic;
              CF    : out std_logic;
              CG    : out std_logic;
              DP    : out std_logic;
              AN    : out std_logic_vector (7 downto 0);
              SEGM1 : in std_logic_vector (6 downto 0);
              SEGM2 : in std_logic_vector (6 downto 0);
              SEGM3 : in std_logic_vector (6 downto 0);
              SEGM4 : in std_logic_vector (6 downto 0);
              SEGM5 : in std_logic_vector (6 downto 0);
              SEGM6 : in std_logic_vector (6 downto 0);
              SEGM7 : in std_logic_vector (6 downto 0);
              SEGM8 : in std_logic_vector (6 downto 0);
              CLK   : in std_logic;
              RST   : in std_logic;
              EN    : in std_logic);
    end component;

    signal CA    : std_logic;
    signal CB    : std_logic;
    signal CC    : std_logic;
    signal CD    : std_logic;
    signal CE    : std_logic;
    signal CF    : std_logic;
    signal CG    : std_logic;
    signal DP    : std_logic;
    signal AN    : std_logic_vector (7 downto 0);
    signal SEGM1 : std_logic_vector (6 downto 0);
    signal SEGM2 : std_logic_vector (6 downto 0);
    signal SEGM3 : std_logic_vector (6 downto 0);
    signal SEGM4 : std_logic_vector (6 downto 0);
    signal SEGM5 : std_logic_vector (6 downto 0);
    signal SEGM6 : std_logic_vector (6 downto 0);
    signal SEGM7 : std_logic_vector (6 downto 0);
    signal SEGM8 : std_logic_vector (6 downto 0);
    signal CLK   : std_logic;
    signal RST   : std_logic;
    signal EN    : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : segm_control
    port map (CA    => CA,
              CB    => CB,
              CC    => CC,
              CD    => CD,
              CE    => CE,
              CF    => CF,
              CG    => CG,
              DP    => DP,
              AN    => AN,
              SEGM1 => SEGM1,
              SEGM2 => SEGM2,
              SEGM3 => SEGM3,
              SEGM4 => SEGM4,
              SEGM5 => SEGM5,
              SEGM6 => SEGM6,
              SEGM7 => SEGM7,
              SEGM8 => SEGM8,
              CLK   => CLK,
              RST   => RST,
              EN    => EN);

    -- Clock
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    CLK <= TbClock;

    stimuli : process
    begin
        -- Start
        SEGM1 <= b"1010101";
        SEGM2 <= b"0101010";
        SEGM3 <= b"1010101";
        SEGM4 <= b"0101010";
        SEGM5 <= b"1010101";
        SEGM6 <= b"0101010";
        SEGM7 <= b"1010101";
        SEGM8 <= b"0101010";
        EN <= '0';
        -- Reset 
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;
        EN <= '1';
        wait for 100 * TbPeriod;
        --Stop
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_segm_control_tb of segm_control_tb is
    for tb
    end for;
end cfg_segm_control_tb;