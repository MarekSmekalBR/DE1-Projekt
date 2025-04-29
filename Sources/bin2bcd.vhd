-------------------------------------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2025 05:09:32 PM
-- Design Name: 
-- Module Name: bin2bcd - Behavioral
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
-------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity bin2bcd is
    Port ( 
        CLK                 : in STD_LOGIC;     --clock
        RST                 : in STD_LOGIC;     --reset
        BIN                 : in STD_LOGIC_VECTOR (7 downto 0);  -- input (bin)
        BCD1                : out STD_LOGIC_VECTOR (3 downto 0); -- binary output on ones
        BCD10               : out STD_LOGIC_VECTOR (3 downto 0); -- binary output on tens
        BCD100              : out STD_LOGIC_VECTOR (3 downto 0)  -- binary output on hundreds
    );
end bin2bcd;

architecture Behavioral of bin2bcd is
   type states is (start, shift, check, done); --machine status
    
    signal conversion                           : STD_LOGIC_VECTOR (19 downto 0); -- conversion
    signal conversion_next                      : STD_LOGIC_VECTOR (19 downto 0); -- next conversion
    signal bcds_out, bcds_out_next              : STD_LOGIC_VECTOR(11 downto 0); --  BCD output
    signal state                                : states; -- current state
    signal state_next                           : states; -- next state
    signal shift_counter, shift_counter_next    : natural; -- current and next number of shifts
    signal bin_current                          : STD_LOGIC_VECTOR (7 downto 0); -- binary number to convert
    
begin
    process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then -- on reset
                conversion <= (others => '0');
                bcds_out <= (others => '0');
                shift_counter <= 0;
                state <= start;
                bin_current <= BIN;
                
            else
                state <= state_next;
                conversion <= conversion_next;
                bcds_out <= bcds_out_next;
                shift_counter <= shift_counter_next;
                if not (bin_current = BIN) and (state = done) then -- get number
                    bin_current <= BIN;
                    state <= start;
                    
                end if;
            end if;
        end if;
    end process;
    
    convert: process(state, shift_counter, bin_current, conversion) -- conversion
    begin
        state_next <= state;
        if not (state = start) then
            conversion_next <= conversion; -- new conversion
        end if;
        
        shift_counter_next <= shift_counter; -- assign  value
        
        case state is
        
            when start =>
                state_next <= shift;
                conversion_next <= (b"0000_0000_0000" & bin_current); -- new conversion
                shift_counter_next <= 0; -- reset shift counter
                
            when shift =>
                conversion_next <= conversion(18 downto 0) & '0'; 
                shift_counter_next <= shift_counter + 1;
                
                if (shift_counter = 7) then -- check shifts number
                    state_next <= done;
                    
                else
                    state_next <= check;
                    
                end if;
                
            when check =>
                for i in 0 to 2 loop
                    if conversion(8+i*4+3 downto 8+i*4)>4 then -- value corrector for next shift
                        conversion_next(8+i*4+3 downto 8+i*4) <= conversion(8 + i * 4 + 3 downto 8+i*4)+3;
                    end if;
                end loop;
                
                state_next <= shift;
                
            when done =>
            
        end case;
    end process;
    
    bcds_out_next <= conversion(19 downto 8) when state = done else bcds_out; -- BCD output
       
    BCD1    <= bcds_out(3 downto 0);    -- BCD value
    BCD10   <= bcds_out(7 downto 4);    -- BCD value
    BCD100  <= bcds_out(11 downto 8);   -- BCD value
    
end Behavioral;
