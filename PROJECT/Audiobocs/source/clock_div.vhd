--------------------------------
--    Fixed Clock Divider    ---
--      50MHz to 12.5MHz     ---
-- 29/03 - 1st version

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--||||||   ENTITY   ||||||--

ENTITY clock_div IS
    PORT(
        clk_fast_i :  IN std_logic;
        clk_slow_o :  OUT std_logic
    );
END clock_div;

--||||||   ARCHITECTURE  ||||||--

ARCHITECTURE rtl OF clock_div IS

    SIGNAL count, next_count  :  unsigned(1 downto 0) := 0;  -- This is signal forcing, just use it here!!!

BEGIN

    -->>  Combinational Logic

        comb_logic: PROCESS(count)
        BEGIN
            next_count <= count + 1;       
        END PROCESS

    -->>   Sequential Logic

        flip_flop: PROCESS(clk_fast_i)
        BEGIN
            IF rising_edge(clk_fast_i) THEN
                count <= next_count;
            END IF;
        END PROCESS;

    -->>  Concurrent Assignments

        clk_slow_o <= std_logic(count(1));

END rtl;