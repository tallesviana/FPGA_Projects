library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-- ENTITY DECLARATION --
entity cic_accumulator is
    port(
        clk, reset_n: in std_logic;
        strobe_in   : in std_logic;

        signal_in   : in std_logic_vector(15 downto 0);
        signal_out  : out std_logic_vector(15 downto 0)
    );
end cic_accumulator;

-- ARCHITECTURE OF ACCUMULATOR  --
architecture rtl of cic_accumulator is

    signal sum, next_sum : signed(15 downto 0);

begin

-- SUMMING UP
    summin: process(all)
    begin
        next_sum <= sum;
        if strobe_in = '1' then
            next_sum <= sum + signed(signal_in);
        end if;
    end process summin;

-- FLIP FLOP PROCESS
    flip_flop: process(all)
    begin
        if reset_n = '0' then
            sum <= (others => '0');
        elsif rising_edge(clk) then
            sum <= next_sum;
        end if;
    end process flip_flop;

-- CONCURRENT ASSIGNMENTS --
    signal_out <= std_logic_vector(sum);
end rtl;