----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 05:15:16 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( 
        BTNL         : in STD_LOGIC; -- intesity LED down
        BTNR         : in STD_LOGIC; -- intesity LED up
        BTNC         : in STD_LOGIC; -- intenisty to 50 (reset)
        BTND         : in STD_LOGIC; -- turn off the component
        CLK100MHZ    : in STD_LOGIC; -- clock 100 MHZ
        SW           : in STD_LOGIC; -- switch high and low intensity
        SW_LED       : in STD_LOGIC_VECTOR (1 downto 0); -- enable/disable LED
        LED16_G      : out STD_LOGIC; -- green LED - low intensity
        LED16_R      : out STD_LOGIC; -- red LED - high intensity
        LED          : out STD_LOGIC_VECTOR (1 downto 0); -- LEDs for switches
        CA           : out STD_LOGIC; -- cathode signals for 7-seg display
        CB           : out STD_LOGIC; -- cathode signals for 7-seg display
        CC           : out STD_LOGIC; -- cathode signals for 7-seg display
        CD           : out STD_LOGIC; -- cathode signals for 7-seg display 
        CE           : out STD_LOGIC; -- cathode signals for 7-seg display
        CF           : out STD_LOGIC; -- cathode signals for 7-seg display
        CG           : out STD_LOGIC; -- cathode signals for 7-seg display
        DP           : out STD_LOGIC; -- cathode signals for 7-seg display
        AN           : out STD_LOGIC_VECTOR (7 downto 0); -- 7-seg anode
        PWMOut       : out STD_LOGIC_VECTOR (1 downto 0) -- PWM output signals for each LED
    );
end top_level;

architecture Behavioral of top_level is
    component segm_control is
        Port (
            CLK      : in STD_LOGIC; -- main clock
            RST      : in STD_LOGIC; -- reset 
            EN       : in STD_LOGIC; -- enable signal
            SEGM1    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            SEGM2    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            SEGM3    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            SEGM4    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            SEGM5    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            SEGM6    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            SEGM7    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            SEGM8    : in STD_LOGIC_VECTOR (6 downto 0);-- segment  CG, CF, CE, CD, CC, CB, CA
            CA       : out STD_LOGIC;-- Cathode
            CB       : out STD_LOGIC;-- Cathode
            CC       : out STD_LOGIC;-- Cathode
            CD       : out STD_LOGIC;-- Cathode
            CE       : out STD_LOGIC;-- Cathode
            CF       : out STD_LOGIC;-- Cathode
            CG       : out STD_LOGIC;-- Cathode
            DP       : out STD_LOGIC; -- Decimal point
            AN       : out STD_LOGIC_VECTOR (7 downto 0) -- Anodes
        );
    end component;
    component medium_1 is
        port (
            EN              : in STD_LOGIC; -- enable LED control
            BTNC            : in STD_LOGIC; -- reset luminosity to the middle
            BTNL            : in STD_LOGIC; -- turn intensity low
            BTNR            : in STD_LOGIC; -- turn intensity high
            CLK_POS         : in STD_LOGIC; -- enable signal with low frequency for reading 
            CLK_PWM_COUNTER : in STD_LOGIC; -- enable signal with high frequency for pwm counter (300*PWM frequency)
            CLK             : in STD_LOGIC; -- main clock
            RST             : in STD_LOGIC; -- reset
            PWM             : out STD_LOGIC; -- PWM out
            SEG1            : out STD_LOGIC_VECTOR (6 downto 0); -- intensity percentage number in ones place for 7-seg display
            SEG10           : out STD_LOGIC_VECTOR (6 downto 0); -- intensity percentage number in tens place for 7-seg display
            SEG100          : out STD_LOGIC_VECTOR (6 downto 0) -- intensity percentage number in hundreds place for 7-seg display
        );
    end component;
    component clock_enable is
        generic (
            PERIOD  : integer := 6 -- clock cycles per pulse
        );
        Port ( 
            clk     : in STD_LOGIC; -- in clock 
            rst     : in STD_LOGIC; -- reset 
            pulse   : out STD_LOGIC -- out pulse 
        );
    end component;
    component clock_enable_ratio is
        generic (
            PERIOD  : integer := 6; -- input clock cycles per pulse
            RATIO   : integer := 5  -- multiplier increase (period)
        );
        Port ( 
            clk     : in STD_LOGIC; -- input clock
            rst     : in STD_LOGIC; -- reset 
            switch  : in STD_LOGIC; -- enable/disable ratio * period
            pulse   : out STD_LOGIC -- output 
        );
    end component;
    
    signal sig_en_100k      : STD_LOGIC; -- enable PWM counter
    signal sig_en_luminosity  : STD_LOGIC; -- enable position
    signal sig_en_segm      : STD_LOGIC; -- enable 7-seg displays
    signal sig_seg1_1       : STD_LOGIC_VECTOR (6 downto 0); --  first LED percentage of intensity value in ones 
    signal sig_seg10_1      : STD_LOGIC_VECTOR (6 downto 0); --  first LED percentage of intensity value in tens 
    signal sig_seg100_1     : STD_LOGIC_VECTOR (6 downto 0); --  first LED percentage of intensity value in hundreds 
    signal sig_seg1_2       : STD_LOGIC_VECTOR (6 downto 0); --  second LED percentage of intensity value in ones 
    signal sig_seg10_2      : STD_LOGIC_VECTOR (6 downto 0); --  second LED percentage of intensity value in tens 
    signal sig_seg100_2     : STD_LOGIC_VECTOR (6 downto 0); --  second LED percentage of intensity value in hundreds 
begin
    clock_en_ratio : clock_enable_ratio -- clock for lum. intensity, 100 Hz, with ratio 10 Hz
        generic map (
            PERIOD  => 1_000_000,
            RATIO   => 10
        )
        port map (
            clk     => CLK100MHZ,
            rst     => BTND,
            switch  => SW,
            pulse   => sig_en_luminosity
        );
    
    clock_en : clock_enable -- clock for PWM 100 kHz
        generic map (
            PERIOD  => 1000
        )
        port map (
            clk     => CLK100MHZ,
            rst     => BTND,
            pulse   => sig_en_100k
        );
        
    clock_en_segm : clock_enable -- clock enable for 7-segm displays on 500 Hz
        generic map (
            PERIOD  => 200_000
        )
        port map (
            clk     => CLK100MHZ,
            RST     => BTND,
            pulse   => sig_en_segm
        );
            
    segment_control: segm_control -- 7-segm display 
        port map (
            CLK     => CLK100MHZ,
            RST     => BTND,
            EN      => sig_en_segm,
            SEGM1   => sig_seg1_1,
            SEGM2   => sig_seg10_1,
            SEGM3   => sig_seg100_1,
            SEGM4   => b"1111111",
            SEGM5   => b"1111111",
            SEGM6   => sig_seg1_2,
            SEGM7   => sig_seg10_2,
            SEGM8   => sig_seg100_2,
            CA      => CA,
            CB      => CB,
            CC      => CC,
            CD      => CD,
            CE      => CE,
            CF      => CF,
            CG      => CG,
            DP      => DP,
            AN      => AN
       );
       
    LED1 : medium_1 -- first LED controller
        port map (
            EN              => SW_LED(0),
            BTNC            => BTNC,
            BTNL            => BTNL,
            BTNR            => BTNR,
            CLK_POS         => sig_en_luminosity,
            CLK_PWM_COUNTER => sig_en_100k,
            CLK             => CLK100MHZ,
            RST             => BTND,
            PWM             => PWMOut(0),
            SEG1            => sig_seg1_1,
            SEG10           => sig_seg10_1,
            SEG100          => sig_seg100_1
        );
    
    LED2 : medium_1 -- second LED controller
        port map (
            EN              => SW_LED(1),
            BTNC            => BTNC,
            BTNL            => BTNL,
            BTNR            => BTNR,
            CLK_POS         => sig_en_luminosity,
            CLK_PWM_COUNTER => sig_en_100k,
            CLK             => CLK100MHZ,
            RST             => BTND,
            PWM             => PWMOut(1),
            SEG1            => sig_seg1_2,
            SEG10           => sig_seg10_2,
            SEG100          => sig_seg100_2
        );
    LED     <= SW_LED; -- switch LEDs            
    LED16_R <= '1' when SW = '1' else '0'; -- red LED when low sensitivity 
    LED16_G <= '1' when SW = '0' else '0'; -- green LED when high sensitivity 
end Behavioral;
