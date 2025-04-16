library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Ä?Ã­taÄ?
entity luminosity is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        change_en  : in  std_logic;
        en       : in  std_logic;
        low     : in  std_logic;
        high    : in  std_logic;
        lum      : out std_logic_vector(7 downto 0)
    );
end luminosity;

architecture Behavioral of luminosity is
    
    signal sig_count : std_logic_vector(7 downto 0);
    signal plus_i, minus_i : std_logic_vector(7 downto 0);
    signal plus, minus : std_logic;
    signal next_count : std_logic_vector(7 downto 0);

begin
    --podminky pro scitani/odcitani
    plus <= '1' when unsigned(sig_count) < 100 else '0';
    minus <= '1' when unsigned(sig_count) > 0 else '0';
    --pricitani/odcitani
    plus_i  <= std_logic_vector(unsigned(sig_count) + 10);
    minus_i <= std_logic_vector(unsigned(sig_count) - 10);

    process(clk)
    begin
        if rising_edge(clk) then  --reakce na nabeznou hranu citace
            if rst = '1' then
                sig_count <= (others => '0');  --reset
            elsif change_en = '1' then  --povoleni zmeny
                if en = '1' then  --povoleni­ citace
                    if high = '1' and low = '1'  then
                        sig_count <= sig_count; --obe tlacitka zaroven
                    elsif high = '1' and plus = '1' then
                        sig_count <= plus_i;  --pricitani v case
                    elsif low = '1' and minus = '1' then
                        sig_count <= minus_i; --odecitani v case
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- vystupni promenna
    lum <= sig_count;

end Behavioral;