library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seg_7c is
    Port (
        CLK      : in STD_LOGIC; 
        RST      : in STD_LOGIC; 
        EN       : in STD_LOGIC; 
        SEG1    : in STD_LOGIC_VECTOR (6 downto 0); 
        SEG2    : in STD_LOGIC_VECTOR (6 downto 0);
        SEG3    : in STD_LOGIC_VECTOR (6 downto 0);
        SEG4    : in STD_LOGIC_VECTOR (6 downto 0);
        SEG5    : in STD_LOGIC_VECTOR (6 downto 0);
        SEG6    : in STD_LOGIC_VECTOR (6 downto 0);
        SEG7    : in STD_LOGIC_VECTOR (6 downto 0);
        SEG8    : in STD_LOGIC_VECTOR (6 downto 0);
        CA       : out STD_LOGIC; 
        CB       : out STD_LOGIC;
        CC       : out STD_LOGIC;
        CD       : out STD_LOGIC;
        CE       : out STD_LOGIC;
        CF       : out STD_LOGIC;
        CG       : out STD_LOGIC;
        DP       : out STD_LOGIC; 

        AN       : out STD_LOGIC_VECTOR (7 downto 0) 
    );
end seg_7c;

architecture Behavioral of seg_7c is
    signal sig_an : std_logic_vector (7 downto 0); 
    
begin
    process (CLK)
        variable last : STD_LOGIC;
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then 
                sig_an <= b"1111_1110";
            elsif EN = '1' then 
                last := sig_an(7); 
                sig_an <= sig_an(6 downto 0) & last;
            end if;
        end if;
    end process;
    
    CA <= SEG1(6) when sig_an = b"1111_1110" else 
          SEG2(6) when sig_an = b"1111_1101" else
          SEG3(6) when sig_an = b"1111_1011" else
          SEG4(6) when sig_an = b"1111_0111" else
          SEG5(6) when sig_an = b"1110_1111" else
          SEG6(6) when sig_an = b"1101_1111" else
          SEG7(6) when sig_an = b"1011_1111" else
          SEG8(6);

    CB <= SEG1(5) when sig_an = b"1111_1110" else
          SEG2(5) when sig_an = b"1111_1101" else
          SEG3(5) when sig_an = b"1111_1011" else
          SEG4(5) when sig_an = b"1111_0111" else
          SEG5(5) when sig_an = b"1110_1111" else
          SEG6(5) when sig_an = b"1101_1111" else
          SEG7(5) when sig_an = b"1011_1111" else
          SEG8(5);

    CC <= SEG1(4) when sig_an = b"1111_1110" else
          SEG2(4) when sig_an = b"1111_1101" else
          SEG3(4) when sig_an = b"1111_1011" else
          SEG4(4) when sig_an = b"1111_0111" else
          SEG5(4) when sig_an = b"1110_1111" else
          SEG6(4) when sig_an = b"1101_1111" else
          SEG7(4) when sig_an = b"1011_1111" else
          SEG8(4);

    CD <= SEG1(3) when sig_an = b"1111_1110" else
          SEG2(3) when sig_an = b"1111_1101" else
          SEG3(3) when sig_an = b"1111_1011" else
          SEG4(3) when sig_an = b"1111_0111" else
          SEG5(3) when sig_an = b"1110_1111" else
          SEG6(3) when sig_an = b"1101_1111" else
          SEG7(3) when sig_an = b"1011_1111" else
          SEG8(3);

    CE <= SEG1(2) when sig_an = b"1111_1110" else
          SEG2(2) when sig_an = b"1111_1101" else
          SEG3(2) when sig_an = b"1111_1011" else
          SEG4(2) when sig_an = b"1111_0111" else
          SEG5(2) when sig_an = b"1110_1111" else
          SEG6(2) when sig_an = b"1101_1111" else
          SEG7(2) when sig_an = b"1011_1111" else
          SEG8(2);

    CF <= SEG1(1) when sig_an = b"1111_1110" else
          SEG2(1) when sig_an = b"1111_1101" else
          SEG3(1) when sig_an = b"1111_1011" else
          SEG4(1) when sig_an = b"1111_0111" else
          SEG5(1) when sig_an = b"1110_1111" else
          SEG6(1) when sig_an = b"1101_1111" else
          SEG7(1) when sig_an = b"1011_1111" else
          SEG8(1);

    CG <= SEG1(0) when sig_an = b"1111_1110" else
          SEG2(0) when sig_an = b"1111_1101" else
          SEG3(0) when sig_an = b"1111_1011" else
          SEG4(0) when sig_an = b"1111_0111" else
          SEG5(0) when sig_an = b"1110_1111" else
          SEG6(0) when sig_an = b"1101_1111" else
          SEG7(0) when sig_an = b"1011_1111" else
          SEG8(0);
          
    DP <= '1';
    AN <= sig_an;
     
end Behavioral;