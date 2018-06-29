library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-- ENTITY DECLARATION --
entity cic_comb is
    port(
        clk, reset_n: in std_logic;
        strobe_dec_i   : in std_logic;

        signal_in   : in std_logic_vector(15 downto 0);
        signal_out  : out std_logic_vector(15 downto 0)
    );
end cic_comb;

-- ARCHITECTURE --
ARCHITECTURE rtl of cic_comb is

    signal output_sig, next_output_sig  : signed(15 downto 0);
    signal delayed, next_delayed        : signed(15 downto 0);

begin

-- DELAY INPUT --
    delay: process(all)
    begin
        next_delayed <= delayed;

        if strobe_dec_i = '1' then      -- Save last input to delay
            next_delayed <= signed(signal_in);
        end if;
    end process delay;

-- DIFF PROCESS --
    diff: process(all)
    begin
        next_output_sig <= output_sig;

        if strobe_dec_i = '1' then
            next_output_sig <= signed(signal_in) - delayed;
        end if;

    end process diff;

-- FLIP FLOPS --
    flip_flop: process(all)
    begin
        if reset_n = '0' then
            delayed <= (others => '0');
            output_sig <= (others => '0');
        elsif rising_edge(clk) then
            delayed <= next_delayed;
            output_sig <= next_output_sig;
        end if;

    end process flip_flop;

-- CONCURRENT ASSIGMENTS --
signal_out <= std_logic_vector(output_sig);

end rtl;