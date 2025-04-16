library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_luminosity is
end tb_luminosity;

architecture behavior of tb_luminosity is
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal change_en : std_logic := '0';
    signal en       : std_logic := '1'; 
    signal low      : std_logic := '0';
    signal high     : std_logic := '0';
    signal lum      : std_logic_vector(7 downto 0);

    component luminosity
        Port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            change_en : in  std_logic;
            en       : in  std_logic;
            low      : in  std_logic;
            high     : in  std_logic;
            lum      : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    uut: luminosity
        Port map (
            clk => clk,
            rst => rst,
            change_en => change_en,
            en => en,
            low => low,
            high => high,
            lum => lum
        );
    clk_process : process
    begin
        clk <= not clk after 10 ns;  --peroda
        wait for 10 ns;
    end process;

    stim_proc: process
    begin
        -- Test 1: Reset čítače
        rst <= '1'; -- Aktivace resetu
        wait for 20 ns;
        rst <= '0'; -- Deaktivace resetu
        wait for 20 ns;

        --pricitani (high hold)
        change_en <= '1';   
        high <= '1';        
        low <= '0';         
        wait for 100 ns;    
        
        --konec pricitani
        high <= '0';        
        wait for 50 ns;     
        
        --odcitani (hold low)
        low <= '1';         
        high <= '0';        
        wait for 100 ns;   
        --obe vyple 
        low <= '0';         
        high <= '0';       
        wait for 100 ns;   
        --test obou zmacknutych zaroven 
        low <= '1';         
        high <= '1';        
        wait for 100 ns;  
        --deaktivace zmen
        change_en <= '0';   
        wait for 100 ns;   
        
        wait;
    end process;

end behavior;
