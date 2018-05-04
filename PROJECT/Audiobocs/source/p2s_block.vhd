------------------------------------------------------------
-- Parallel to Serial block
------------------------------------------------------------
-- Towards MSB
------------------------------------------------------------
-- tallesvv 20/04/18 - 1st Version
------------------------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

ENTITY p2s_block IS
    PORT(
        clk, reset_n  : IN std_logic;
        ENABLE_i      : IN std_logic;
        LOAD_i        : IN std_logic;
        SHIFT_i       : IN std_logic;
        PAR_i         : IN std_logic_vector(15 downto 0);

        SER_o         : OUT std_logic
    );
END p2s_block;

ARCHITECTURE rtl OF p2s_block IS

    SIGNAL shiftreg, next_shiftreg  :  std_logic_vector(15 downto 0);

BEGIN

    --====== COMB INPUT LOGIC ======-
    comb_shiftreg: PROCESS (shiftreg, ENABLE_i, LOAD_i, SHIFT_i, PAR_i)
    BEGIN
        next_shiftreg <= shiftreg;
        IF LOAD_i = '1' THEN
            next_shiftreg <= PAR_i;
        ELSIF ENABLE_i = '1'and SHIFT_i = '1'THEN
            next_shiftreg <= shiftreg(14 downto 0) & '0';  -- Towards MSB
        END IF;
    END PROCESS;



    --===== FLIP FLOPS =======--
    ffs: PROCESS(clk, reset_n)
    BEGIN
        IF reset_n = '0'THEN
            shiftreg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            shiftreg <= next_shiftreg;
        END IF;
    END PROCESS;

    --===== CONCURRENT ASSIGNMENTS =====-
    SER_o <=shiftreg(15);  -- Sends towards MSB
    
END rtl;