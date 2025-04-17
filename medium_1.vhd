----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 04:55:15 PM
-- Design Name: 
-- Module Name: medium_1 - Behavioral
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

entity medium_1 is
port (
        BTNC            : in STD_LOGIC; -- reset servo position to the middle
        BTNL            : in STD_LOGIC; -- turn servo left
        BTNR            : in STD_LOGIC; -- turn servo right
        CLK_10kHz       : in STD_LOGIC; -- enable signal with low frequency for reading 
        CLK_20Hz        : in STD_LOGIC; -- enable signal with high frequency for pwm counter (300*PWM frequency)
        CLK             : in STD_LOGIC; -- main clock
        RST             : in STD_LOGIC; -- reset
        SW_1            : in STD_LOGIC;
        PWM             : out STD_LOGIC; -- PWM output
        SEG_1           : out STD_LOGIC_VECTOR (6 downto 0); -- rotation percentage number in ones place for 7-segm display
        SEG_10          : out STD_LOGIC_VECTOR (6 downto 0); -- rotation percentage number in tens place for 7-segm display
        SEG_100         : out STD_LOGIC_VECTOR (6 downto 0) -- rotation percentage number in hundreds place for 7-segm display
    );
end medium_1;

architecture Behavioral of medium_1 is
    component luminosity is
        port (
            rst     : in STD_LOGIC; -- reset signal
            low    : in STD_LOGIC; -- position decrement
            high   : in STD_LOGIC; -- position increment
            clk     : in STD_LOGIC; -- main clock signal
            en      : in STD_LOGIC; -- enable reading signal
            change_en : in STD_LOGIC; -- component enable signal
            lum     : out STD_LOGIC_VECTOR (7 downto 0) -- output position vector
            );
       end component;
       
   component PWM_gen is
        generic (
            C_END   : integer := 300 -- End of the counter
        );
        Port ( 
        clk     : in STD_LOGIC; -- main clock
        rst     : in STD_LOGIC; -- reset
        en      : in STD_LOGIC; -- component enable signal
        lum     : in STD_LOGIC_VECTOR(7 downto 0); -- position parameter defining HL position
        pwm_out : out STD_LOGIC -- PWM output signal
        );
    end component;
    
    component bin2bcd is
        Port ( 
            CLK                 : in STD_LOGIC; -- clock signals
            RST                 : in STD_LOGIC; --  reset signals
            BIN                 : in STD_LOGIC_VECTOR (7 downto 0); -- binary input
            BCD_1, BCD_10, BCD_100 : out STD_LOGIC_VECTOR (3 downto 0) -- binary number output on ones, tens and hundreds places
        );
    end component;
    
    component seg_bcd_j is
        Port (
           
        bin    : in  STD_LOGIC_VECTOR(3 downto 0);
        clear  : in  STD_LOGIC;
        seg    : out STD_LOGIC_VECTOR(6 downto 0)  -- a-g segments
    );
    end component;
    
   component seg_bcd_d is
        Port (
           
        bin    : in  STD_LOGIC_VECTOR(3 downto 0);
        clear  : in  STD_LOGIC;
        seg    : out STD_LOGIC_VECTOR(6 downto 0)  -- a-g segments
    );
    end component;
    
   component seg_bcd_s is
        Port (
           
        bin    : in  STD_LOGIC_VECTOR(3 downto 0);
        clear  : in  STD_LOGIC;
        seg    : out STD_LOGIC_VECTOR(6 downto 0)  -- a-g segments
    );
    end component;
    
    signal sig_pos                 : STD_LOGIC_VECTOR (7 downto 0); -- position signal
    signal BCD_1, BCD_10, BCD_100  : STD_LOGIC_VECTOR (3 downto 0); -- BCD signals
    
begin

lum: luminosity-- component that controls the position of PWM
        port map (
            clk         => CLK,
            rst         => BTNC,
            change_en   => SW_1,
            en          => CLK_20Hz,
            low         => BTNL,
            high        => BTNR,
            lum         => sig_pos
        );
        
signal_pwm : PWM_gen -- generates PWM
        port map (
            clk     => CLK,
            rst     => RST,
            en      => CLK_10kHz,
            lum     => sig_pos,
            pwm_out => PWM
        );

bin_to_bcd: bin2bcd -- converts binary value to BCD
        port map (
            BIN     => sig_pos,
            CLK     => CLK,
            RST     => RST,
            BCD_1    => BCD_1,
            BCD_10   => BCD_10,
            BCD_100  => BCD_100
        );

        
    bcd1: seg_bcd_j -- converts BCD ones value to segment values
        port map (
            clear   => RST,
            bin     => BCD_1,
            seg     => SEG_1
        );
        
    bcd10: seg_bcd_d -- converts BCD ones value to segment values
        port map (
            clear   => RST,
            bin     => BCD_10,
            seg     => SEG_10
        );
    bcd100: seg_bcd_s -- converts BCD ones value to segment values
        port map (
            clear   => RST,
            bin     => BCD_100,
            seg     => SEG_100
        );
end Behavioral;



