---------------------------------------------------------
--  Serial to Parallel Converter (16 bits)
---------------------------------------------------------
--
--   Shiftregiters to get serial data and output the parallel
--   TOWARDS MSB
-- tallesvv 20/04/18 - First version
---------------------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

ENTITY s2p_block IS
    PORT(
        clk, reset_n : IN std_logic;
        ENABLE_i       : IN std_logic;   -- BLCK signal
        SHIFT_i      : IN std_logic;
        SER_i        : IN std_logic;

        PAR_o        : OUT std_logic_vector(15 downto 0)
    );
END s2p_block;  

ARCHITECTURE rtl OF s2p_block IS

    SIGNAL shiftreg, next_shiftreg  :  std_logic_vector(15 downto 0);

BEGIN   

    --========  COMB INPUT LOGIC   ========-   check whether enable and/or shift is HIGH
    comb_shift: PROCESS (shiftreg, ENABLE_i, SHIFT_i, SER_i)
    BEGIN
        
        next_shiftreg <= shiftreg;

        IF SHIFT_i = '1' and ENABLE_i = '1'THEN
            next_shiftreg <= shiftreg(14 downto 0) & SER_i;  -- Towards MSB
        END IF;

    END PROCESS;

    --======= FLIP FLOPS ========-
    ffs: PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            shiftreg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            shiftreg <= next_shiftreg;
        END IF;
    END PROCESS;

END rtl;