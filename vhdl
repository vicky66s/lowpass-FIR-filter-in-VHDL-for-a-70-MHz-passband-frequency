-- 00000000000000000000000000
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LowpassFilter is
    Port (
        clk       : in  std_logic;           -- Clock input 
        reset     : in  std_logic;           -- Reset input
        data_in   : in  signed(15 downto 0); -- Input data
        data_out  : out signed(15 downto 0) -- Output data
    );
end LowpassFilter;

architecture Behavioral of LowpassFilter is
    type tap_array is array(0 to 100) of integer;  -- Number of taps 
    signal taps : tap_array := (0, ...);           -- Filter coefficients
    signal delay_line : tap_array := (others => 0); -- Delay line for input samples
    signal acc : integer := 0;                     -- Accumulator for filter output
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset filter state
                acc <= 0;
                delay_line <= (others => 0);
            else
                -- Shift delay line and insert new sample
                delay_line <= data_in & delay_line(0 to delay_line'length-2);
                
                -- Compute filter output
                acc <= 0;
                for i in 0 to delay_line'length-1 loop
                    acc <= acc + delay_line(i) * taps(i);
                end loop;

                -- Output filtered data
                data_out <= to_signed(acc, data_out'length);
            end if;
        end if;
    end process;

end Behavioral;
