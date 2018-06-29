library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-- ENTITY DECLARATION --
entity cic_decimator is
    generic ( rate : unsigned(9 downto 0) := to_unsigned(100, 10));
    port(
        clk, reset_n: in std_logic;
        strobe_in   : in std_logic;
        strobe_dec_o    : out std_logic;
        signal_in   : in std_logic_vector(15 downto 0);
        signal_out  : out std_logic_vector(15 downto 0)
    );
end cic_decimator;

-- ARCHITECTURE --
ARCHITECTURE rtl of cic_decimator is

    signal count, next_count            : unsigned(9 downto 0);
    signal output_sig, next_output_sig  : std_logic_vector(15 downto 0);

begin

-- RATE CHANGER --
    decimate: process(all)
    begin
        next_output_sig <= output_sig;
        strobe_dec_o    <= '0';

        if count = rate then
            next_output_sig <= signal_in;
            strobe_dec_o    <= '1';
        end if;
    end process decimate;

-- COUNTER --
    counting: process(all)
    begin
        next_count <= count;
        if strobe_in = '1' then
            next_count <= count + 1;
        end if;
        if count = rate then
            next_count <= (others => '0');
        end if;
    end process counting;

-- FLIP FLOPS --
    flip_flop: process(all)
    begin
        if reset_n = '0' then
            count <= to_unsigned(0, 10);
            output_sig <= (others => '0');
        elsif rising_edge(clk) then
            count <= next_count;
            output_sig <= next_output_sig;
        end if;       
    end process flip_flop;

-- CONCURRENT ASSIGNMENTS --
signal_out <= output_sig;
end rtl;