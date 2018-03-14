---------------------------
-- BAUD TICK GENERATOR
-- Talles Viana
-- To get right amount of clocks, do: 50 MHz/ UART_BAUD_RATE
-- In our case, 50MHZ / 31250 bits/s = 1600
--------------------------

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity declaration
ENTITY baud_tick_generator IS
    GENERIC(
        clocks_por_bit    : positive := 1600    -- Amount of clocks between bits
    );
    PORT(
        reset_n, clock    : IN std_logic;
        run_i, start_bit_i: IN std_logic;
        tick_o            : OUT std_logic
    );
END baud_tick_generator;

-- Architecture
ARCHITECTURE rtl OF baud_tick_generator IS
    SIGNAL tick, next_tick : std_logic;
    SIGNAL clks_por_bit, next_clks_por_bit    : integer range 0 to clocks_por_bit-1 := 0

BEGIN
    ---------------------------------
    -- INPUT COMB LOGIC
    ---------------------------------

    comb_logic: PROCESS(run_i, start_bit_i, tick, clks_por_bit)
    BEGIN
    -- default
        next_tick = '0'; 

        IF run_i = '1'THEN      -- If we are getting data
            IF start_bit_i = '1' THEN
                IF clks_por_bit < (clocks_por_bit-1)/2 THEN     -- T/2 para start bit
                    next_clks_por_bit <= clks_por_bit + 1;      -- Can I put this statement at default?
                ELSE
                    next_tick <= '1';
                    next_clks_por_bit <= 0;
                END IF;
            ELSE
                IF clks_por_bit < (clocks_por_bit-1) THEN       -- T para other bits
                    next_clks_por_bit <= clks_por_bit + 1;
                ELSE
                    next_tick <= '1';
                    next_clks_por_bit <= 0; 
                END IF;
            END IF;
        END IF;

    ---------------------------
    -- Flip-Flop
    --------------------------
    flip_flops: PROCESS(clock, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            tick <= '0';
            clks_por_bit <= 0;
        ELSIF rising_edge(clock) THEN
           tick <= next_tick;
           clks_por_bit <= next_clks_por_bit;
        END IF;
    END PROCESS;

    -------------------------
    -- OUTPUT COMB LOGIC
    -------------------------
    tick_o <= tick;
END rtl;


