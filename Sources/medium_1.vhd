----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 04:05:15 PM
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity medium_1 is
port (
        EN              : in STD_LOGIC; -- enable LED control 
        BTNC            : in STD_LOGIC; -- reset position to the middle
        BTNL            : in STD_LOGIC; -- turn intensity down
        BTNR            : in STD_LOGIC; -- turn intensity up
        CLK_POS         : in STD_LOGIC; -- enable signal
        CLK_PWM_COUNTER : in STD_LOGIC; -- enable signal for pwm counter (100*PWM frequency)
        CLK             : in STD_LOGIC; -- main clock
        RST             : in STD_LOGIC; -- reset
        PWM             : out STD_LOGIC; -- PWM output
        SEG1            : out STD_LOGIC_VECTOR (6 downto 0);    -- luminosity percentage number in ones place for 7-segm display
        SEG10           : out STD_LOGIC_VECTOR (6 downto 0);    -- luminosity percentage number in tens place for 7-segm display
        SEG100          : out STD_LOGIC_VECTOR (6 downto 0)     -- luminosity percentage number in hundreds place for 7-segm display
    );
end medium_1;

architecture Behavioral of medium_1 is
    component luminosity is
        port (
            rst     : in STD_LOGIC; -- reset 
            down    : in STD_LOGIC; -- position decrement
            up      : in STD_LOGIC; -- position increment
            clk     : in STD_LOGIC; -- main clock 
            en      : in STD_LOGIC; -- enable reading 
            comp_en : in STD_LOGIC; -- component enable 
            lum     : out STD_LOGIC_VECTOR (7 downto 0) -- output position 
        );
       end component;
       
   component PWM_LED is
        generic (
            C_END   : integer := 100 -- End of the counter
        );
        Port ( 
            clk     : in STD_LOGIC; -- main clock
            rst     : in STD_LOGIC; -- reset
            en      : in STD_LOGIC; -- component enable 
            POS     : in STD_LOGIC_VECTOR(7 downto 0); -- position parameter
            pwm_out : out STD_LOGIC -- PWM output 
        );
    end component;
    
    component bin2bcd is
        Port ( 
            CLK, RST            : in STD_LOGIC; -- clock and reset 
            BIN                 : in STD_LOGIC_VECTOR (7 downto 0); -- binary input
            BCD1, BCD10, BCD100 : out STD_LOGIC_VECTOR (3 downto 0) -- binary output on ones, tens, hundreds
        );
    end component;
    
    component bin2seg is
        Port (
            clear   : in STD_LOGIC; -- turns off the display
            bin     : in STD_LOGIC_VECTOR (3 downto 0); -- binary input 
            seg     : out STD_LOGIC_VECTOR (6 downto 0) -- segments value
        );
    end component;
    
    signal sig_lum              : STD_LOGIC_VECTOR (7 downto 0); -- position signal
    signal bcd1, bcd10, bcd100  : STD_LOGIC_VECTOR (3 downto 0); -- BCD signals
    
begin

lum: luminosity -- controls the position of PWM
        port map (
            clk     => CLK,
            rst     => BTNC,
            en      => CLK_POS,
            comp_en => EN,
            down    => BTNL,
            up       => BTNR,
            lum     => sig_lum
        );
        
        
signal_pwm : PWM_LED -- generates PWM
        port map (
            clk     => CLK,
            rst     => RST,
            en      => CLK_PWM_COUNTER,
            POS     => sig_lum,
            pwm_out => PWM
        );

bin_to_bcd: bin2bcd -- binary to BCD
        port map (
            BIN     => sig_lum,
            CLK     => CLK,
            RST     => RST,
            bcd1    => bcd1,
            bcd10   => bcd10,
            bcd100  => bcd100
        );

    seg_bcd1: bin2seg -- BCD ones to segment 
        port map (
            clear   => RST,
            bin     => bcd1,
            seg     => SEG1
        );
    seg_bcd10: bin2seg -- BCD tens to segment 
        port map (
            clear   => RST,
            bin     => bcd10,
            seg     => SEG10
        );
    seg_bcd100: bin2seg -- BCD hundreds to segment 
        port map (
            clear   => RST,
            bin     => bcd100,
            seg     => SEG100
        );      
end Behavioral;


