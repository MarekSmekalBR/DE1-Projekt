----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 05:24:59 PM
-- Design Name: 
-- Module Name: segm_control - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity segm_control is
    Port (
        CLK      : in STD_LOGIC; -- main clock signal
        RST      : in STD_LOGIC; -- reset signal
        EN       : in STD_LOGIC; -- enable component signal

        SEGM1    : in STD_LOGIC_VECTOR (6 downto 0); -- Input segment values CG, CF, CE, CD, CC, CB, CA
        SEGM2    : in STD_LOGIC_VECTOR (6 downto 0);
        SEGM3    : in STD_LOGIC_VECTOR (6 downto 0);
        SEGM4    : in STD_LOGIC_VECTOR (6 downto 0);
        SEGM5    : in STD_LOGIC_VECTOR (6 downto 0);
        SEGM6    : in STD_LOGIC_VECTOR (6 downto 0);
        SEGM7    : in STD_LOGIC_VECTOR (6 downto 0);
        SEGM8    : in STD_LOGIC_VECTOR (6 downto 0);

        CA       : out STD_LOGIC; -- Cathode
        CB       : out STD_LOGIC; -- Cathode
        CC       : out STD_LOGIC; -- Cathode
        CD       : out STD_LOGIC; -- Cathode
        CE       : out STD_LOGIC; -- Cathode
        CF       : out STD_LOGIC; -- Cathode
        CG       : out STD_LOGIC; -- Cathode
        DP       : out STD_LOGIC; -- Decimal point

        AN       : out STD_LOGIC_VECTOR (7 downto 0) -- Anodes
    );
end segm_control;

architecture Behavioral of segm_control is
    signal sig_an : std_logic_vector (7 downto 0); -- internal anodes signal
begin
    process (CLK)
        variable last : STD_LOGIC;
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then -- on reset
                sig_an <= b"1111_1110"; -- seet current displaying anode to the first one
            elsif EN = '1' then -- on enabled
                last := sig_an(7); -- extract MSB, shift the rest and put the bit as LSB (rotating buffer)
                sig_an <= sig_an(6 downto 0) & last;
            end if;
        end if;
    end process;
    
    CA <= SEGM1(6) when sig_an = b"1111_1110" else -- Assign cathodes based on current anode
          SEGM2(6) when sig_an = b"1111_1101" else
          SEGM3(6) when sig_an = b"1111_1011" else
          SEGM4(6) when sig_an = b"1111_0111" else
          SEGM5(6) when sig_an = b"1110_1111" else
          SEGM6(6) when sig_an = b"1101_1111" else
          SEGM7(6) when sig_an = b"1011_1111" else
          SEGM8(6);

    CB <= SEGM1(5) when sig_an = b"1111_1110" else
          SEGM2(5) when sig_an = b"1111_1101" else
          SEGM3(5) when sig_an = b"1111_1011" else
          SEGM4(5) when sig_an = b"1111_0111" else
          SEGM5(5) when sig_an = b"1110_1111" else
          SEGM6(5) when sig_an = b"1101_1111" else
          SEGM7(5) when sig_an = b"1011_1111" else
          SEGM8(5);

    CC <= SEGM1(4) when sig_an = b"1111_1110" else
          SEGM2(4) when sig_an = b"1111_1101" else
          SEGM3(4) when sig_an = b"1111_1011" else
          SEGM4(4) when sig_an = b"1111_0111" else
          SEGM5(4) when sig_an = b"1110_1111" else
          SEGM6(4) when sig_an = b"1101_1111" else
          SEGM7(4) when sig_an = b"1011_1111" else
          SEGM8(4);

    CD <= SEGM1(3) when sig_an = b"1111_1110" else
          SEGM2(3) when sig_an = b"1111_1101" else
          SEGM3(3) when sig_an = b"1111_1011" else
          SEGM4(3) when sig_an = b"1111_0111" else
          SEGM5(3) when sig_an = b"1110_1111" else
          SEGM6(3) when sig_an = b"1101_1111" else
          SEGM7(3) when sig_an = b"1011_1111" else
          SEGM8(3);

    CE <= SEGM1(2) when sig_an = b"1111_1110" else
          SEGM2(2) when sig_an = b"1111_1101" else
          SEGM3(2) when sig_an = b"1111_1011" else
          SEGM4(2) when sig_an = b"1111_0111" else
          SEGM5(2) when sig_an = b"1110_1111" else
          SEGM6(2) when sig_an = b"1101_1111" else
          SEGM7(2) when sig_an = b"1011_1111" else
          SEGM8(2);

    CF <= SEGM1(1) when sig_an = b"1111_1110" else
          SEGM2(1) when sig_an = b"1111_1101" else
          SEGM3(1) when sig_an = b"1111_1011" else
          SEGM4(1) when sig_an = b"1111_0111" else
          SEGM5(1) when sig_an = b"1110_1111" else
          SEGM6(1) when sig_an = b"1101_1111" else
          SEGM7(1) when sig_an = b"1011_1111" else
          SEGM8(1);

    CG <= SEGM1(0) when sig_an = b"1111_1110" else
          SEGM2(0) when sig_an = b"1111_1101" else
          SEGM3(0) when sig_an = b"1111_1011" else
          SEGM4(0) when sig_an = b"1111_0111" else
          SEGM5(0) when sig_an = b"1110_1111" else
          SEGM6(0) when sig_an = b"1101_1111" else
          SEGM7(0) when sig_an = b"1011_1111" else
          SEGM8(0);
        
    DP <= '1'; -- turn off decimal point
    AN <= sig_an; -- push anode signal to anode
end Behavioral;
