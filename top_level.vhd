----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2025 22:47:27
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
        BTNL         : in STD_LOGIC; -- left button - turns servos left
        BTNR         : in STD_LOGIC; -- right button - turns servos right
        BTNC         : in STD_LOGIC; -- center button - centers servos
        BTND         : in STD_LOGIC; -- down button - turns off the entire controller
        CLK100MHZ    : in STD_LOGIC; -- clock 100 MHZ
        SW_LED       : in STD_LOGIC; -- switches to enable/disable servos - locks/unlocks servo to change its position
        LED16_G      : out STD_LOGIC; -- LED1
        LED16_R      : out STD_LOGIC; -- LED2
        CA           : out STD_LOGIC; -- cathode signals for 7-segm displays
        CB           : out STD_LOGIC;
        CC           : out STD_LOGIC;
        CD           : out STD_LOGIC;
        CE           : out STD_LOGIC;
        CF           : out STD_LOGIC;
        CG           : out STD_LOGIC;
        DP           : out STD_LOGIC;
        AN           : out STD_LOGIC_VECTOR (7 downto 0); -- 7-segm anode
        PWMOut_LED   : out STD_LOGIC_VECTOR (1 downto 0) -- PWM output signals for each servo motor
    );
end top_level;

architecture Behavioral of top_level is
component seg_7c is
        Port (
            CLK      : in STD_LOGIC; -- main clock signal
            RST      : in STD_LOGIC; -- reset signal
            EN       : in STD_LOGIC; -- enable component signal
            SEG1    : in STD_LOGIC_VECTOR (6 downto 0); -- Input segment values CG, CF, CE, CD, CC, CB, CA
            SEG2    : in STD_LOGIC_VECTOR (6 downto 0);
            SEG3    : in STD_LOGIC_VECTOR (6 downto 0);
            SEG4    : in STD_LOGIC_VECTOR (6 downto 0);
            SEG5    : in STD_LOGIC_VECTOR (6 downto 0);
            SEG6    : in STD_LOGIC_VECTOR (6 downto 0);
            SEG7    : in STD_LOGIC_VECTOR (6 downto 0);
            SEG8    : in STD_LOGIC_VECTOR (6 downto 0);
            CA       : out STD_LOGIC; -- Cathodes
            CB       : out STD_LOGIC;
            CC       : out STD_LOGIC;
            CD       : out STD_LOGIC;
            CE       : out STD_LOGIC;
            CF       : out STD_LOGIC;
            CG       : out STD_LOGIC;
            DP       : out STD_LOGIC; -- Decimal point
            AN       : out STD_LOGIC_VECTOR (7 downto 0) -- Anodes
        );
    end component;
    
     component medium_1 is
        port (
        BTNC            : in STD_LOGIC; -- reset servo position to the middle
        BTNL            : in STD_LOGIC; -- turn servo left
        BTNR            : in STD_LOGIC; -- turn servo right
        CLK_10kHz       : in STD_LOGIC; -- enable signal with high frequency for pwm counter (300*PWM frequency)
        CLK_20Hz        : in STD_LOGIC; -- enable signal with low frequency for reading 
        CLK             : in STD_LOGIC; -- main clock
        RST             : in STD_LOGIC; -- reset
        SW_1            : in STD_LOGIC;
        PWM             : out STD_LOGIC; -- PWM output
        SEG_1           : out STD_LOGIC_VECTOR (6 downto 0); -- rotation percentage number in ones place for 7-segm display
        SEG_10          : out STD_LOGIC_VECTOR (6 downto 0); -- rotation percentage number in tens place for 7-segm display
        SEG_100         : out STD_LOGIC_VECTOR (6 downto 0) -- rotation percentage number in hundreds place for 7-segm display
        );
    end component;
    
  component medium_2 is
        port (

        BTNC            : in STD_LOGIC; -- reset servo position to the middle
        BTNL            : in STD_LOGIC; -- turn servo left
        BTNR            : in STD_LOGIC; -- turn servo right
        CLK_10kHz       : in STD_LOGIC; -- enable signal with low frequency for reading 
        CLK_20Hz        : in STD_LOGIC; -- enable signal with high frequency for pwm counter (300*PWM frequency)
        CLK             : in STD_LOGIC; -- main clock
        RST             : in STD_LOGIC; -- reset
        SW_2            : in STD_LOGIC;
        PWM             : out STD_LOGIC; -- PWM output
        SEG_1           : out STD_LOGIC_VECTOR (6 downto 0); -- rotation percentage number in ones place for 7-segm display
        SEG_10          : out STD_LOGIC_VECTOR (6 downto 0); -- rotation percentage number in tens place for 7-segm display
        SEG_100         : out STD_LOGIC_VECTOR (6 downto 0) -- rotation percentage number in hundreds place for 7-segm display
        );
    end component;
    
    component clock_en_10kHz is
        generic (
            n_periods  : integer := 6 -- number of input clock cycles per pulse
        );
        Port ( 
            clk     : in STD_LOGIC; -- input clock signal
            rst     : in STD_LOGIC; -- reset signal
            pulse   : out STD_LOGIC -- output pulse signal
        );
    end component;
    
        component clock_en_20Hz is
        generic (
            n_periods  : integer := 6 -- number of input clock cycles per pulse
        );
        Port ( 
            clk     : in STD_LOGIC; -- input clock signal
            rst     : in STD_LOGIC; -- reset signal
            pulse   : out STD_LOGIC -- output pulse signal
        );
    end component;
   

component clock_en_500Hz is
        generic (
            n_periods  : integer := 6 -- number of input clock cycles per pulse
        );
        Port ( 
            clk     : in STD_LOGIC; -- input clock signal
            rst     : in STD_LOGIC; -- reset signal
            pulse   : out STD_LOGIC -- output pulse signal
        );
    end component;
    
    signal clock_10kHz      : STD_LOGIC; -- enable signal for PWM counter
    signal clock_20Hz       : STD_LOGIC; -- enable signal for position
    signal clock_500Hz      : STD_LOGIC; -- enable signal for 7-segm displays
    signal sig_seg1_1       : STD_LOGIC_VECTOR (6 downto 0); -- vector for the first motor percentage of rotation value on ones place
    signal sig_seg10_1      : STD_LOGIC_VECTOR (6 downto 0); -- vector for the first motor percentage of rotation value on tens place
    signal sig_seg100_1     : STD_LOGIC_VECTOR (6 downto 0); -- vector for the first motor percentage of rotation value on hundreds place
    signal sig_seg1_2       : STD_LOGIC_VECTOR (6 downto 0); -- vector for the second motor percentage of rotation value on ones place
    signal sig_seg10_2      : STD_LOGIC_VECTOR (6 downto 0); -- vector for the second motor percentage of rotation value on tens place
    signal sig_seg100_2     : STD_LOGIC_VECTOR (6 downto 0); -- vector for the second motor percentage of rotation value on hundreds place   
    signal sig_pwm_out_led : STD_LOGIC_VECTOR(1 downto 0);
 
    
begin
PWMOut_LED <= sig_pwm_out_led;
LED16_G <= '1' when sig_pwm_out_led(0) = '1' else '0';
LED16_R <= '1' when sig_pwm_out_led(1) = '1' else '0';


clock_en20Hz : clock_en_20Hz -- clock enable for rotation speed, 
        generic map (
            n_periods  => 5_000_000
        )
        port map (
            clk     => CLK100MHZ,
            rst     => BTND,
            pulse   => clock_20Hz
        );
        
clock_en100kHz : clock_en_10kHz -- clock enable for PWM counter on 10 kHz
        generic map (
            n_periods  => 10_000
        )
        port map (
            clk     => CLK100MHZ,
            rst     => BTND,
            pulse   => clock_10kHz
        );
clock_en500Hz : clock_en_500Hz -- clock enable for PWM counter on 500 Hz
        generic map (
            n_periods  => 200_000
        )
        port map (
            clk     => CLK100MHZ,
            rst     => BTND,
            pulse   => clock_500Hz
        );        
        
segm_control: seg_7c -- 7-segm display controller
        port map (
            CLK     => CLK100MHZ,
            RST     => BTND,
            EN      => clock_500Hz,
            SEG1   => sig_seg1_1,
            SEG2   => sig_seg10_1,
            SEG3   => sig_seg100_1,
            SEG4   => b"1111111",
            SEG5   => b"1111111",
            SEG6   => sig_seg1_2,
            SEG7   => sig_seg10_2,
            SEG8   => sig_seg100_2,
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
       
    LED1 : medium_1 -- -- LED1 controller
        port map (
            RST              => BTND,
            BTNC             => BTNC,
            BTNL             => BTNL,
            BTNR             => BTNR,
            CLK              => CLK100MHZ, 
            CLK_20Hz         => clock_20Hz,
            CLK_10kHz        => clock_10kHz, 
            PWM              => sig_pwm_out_led(0),
            SEG_1            => sig_seg1_1,
            SEG_10           => sig_seg10_1,
            SEG_100          => sig_seg100_1,
            SW_1              => SW_LED 
 
        );
        
     LED2 : medium_2 -- LED2 controller
        port map (
            RST              => BTND,
            BTNC             => BTNC,
            BTNL             => BTNL,
            BTNR             => BTNR,
            CLK              => CLK100MHZ, 
            CLK_20Hz         => clock_20Hz,
            CLK_10kHz        => clock_10kHz, 
            PWM              => sig_pwm_out_led(1),
            SEG_1            => sig_seg1_2,
            SEG_10           => sig_seg10_2,
            SEG_100          => sig_seg100_2,
            SW_2             => SW_LED  
        );  
end Behavioral;
