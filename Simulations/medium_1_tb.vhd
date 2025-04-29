----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 04:15:15 PM
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


library ieee;
use ieee.std_logic_1164.all;

entity medium_1_tb is
end medium_1_tb;

architecture tb of medium_1_tb is

    component medium_1
        port (EN                : in std_logic;
              BTNC              : in std_logic;
              BTNL              : in std_logic;
              BTNR              : in std_logic;
              CLK_POS           : in std_logic;
              CLK_PWM_COUNTER   : in std_logic;
              CLK               : in std_logic;
              PWM               : out std_logic;
              RST               : in STD_LOGIC;
              SEG1              : out STD_LOGIC_VECTOR (6 downto 0);
              SEG10             : out STD_LOGIC_VECTOR (6 downto 0);
              SEG100            : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    component clock_enable_ratio
        generic (
            PERIOD      : integer := 6;
            RATIO       : integer := 5
        );
        Port ( clk      : in STD_LOGIC;
               rst      : in STD_LOGIC;
               switch   : in STD_LOGIC;
               pulse    : out STD_LOGIC);
    end component;
    
    component clock_enable
        generic (
            PERIOD      : integer := 6
        );
        Port ( clk      : in STD_LOGIC;
               rst      : in STD_LOGIC;
               pulse    : out STD_LOGIC);
    end component;

    signal SW               : std_logic;
    signal BTNC             : std_logic;
    signal BTNL             : std_logic;
    signal BTNR             : std_logic;
    signal CLK_POS          : std_logic := '0';
    signal CLK_PWM_COUNTER  : std_logic := '0';
    signal CLK100MHZ        : std_logic := '0';
    signal PWM              : std_logic;
    signal SWPeriod         : std_logic;
    signal RST              : std_logic;
    signal SEG1             : std_logic_vector (6 downto 0);
    signal SEG10            : std_logic_vector (6 downto 0);
    signal SEG100           : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbClock100k : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : medium_1
    port map (EN                => SW,
              BTNC              => BTNC,
              BTNL              => BTNL,
              BTNR              => BTNR,
              CLK_POS           => CLK_POS,
              CLK_PWM_COUNTER   => '1',
              CLK               => CLK100MHZ,
              PWM               => PWM,
              SEG1              => SEG1,
              SEG10             => SEG10,
              SEG100            => SEG100,
              RST               => RST);
              
    clock_en : clock_enable
    generic map (PERIOD => 1000)
    port map (
        clk     => CLK100MHZ,
        rst     => BTNC,
        pulse   => open
    );
    
    clock_en_ratio : clock_enable_ratio
    generic map (
        PERIOD  => 5_000,
        RATIO   => 5
        )
    port map (
        clk     => CLK100MHZ,
        rst     => BTNC,
        switch  => SWPeriod,
        pulse   => CLK_POS);

    -- Clock
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- Start
        SW <= '0';
        BTNC <= '0';
        BTNL <= '0';
        BTNR <= '0';
        SWPeriod <= '0';

        -- Reset 
        BTNC <= '1';
        RST <= '1';
        wait for 100 us;
        BTNC <= '0';
        RST <= '0';
        -- Function
        SW <= '1';
        wait for 100 us;
        BTNL <= '1';
        wait for 4000 us;
        BTNC <= '1';
        wait for 100 us;
        BTNC <= '0';
        wait for 200 us;
        SW <= '0';
        wait for 200 us;
        BTNR <= '1';
        wait for 200 us;
        SW <= '1';
        wait for 400 us;
        BTNL <= '0';
        wait for 1000 us;
        SWPeriod <= '1';
        wait for 2000 us;
        -- Stop
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_medium_1_tb of medium_1_tb is
    for tb
    end for;
end cfg_medium_1_tb;
