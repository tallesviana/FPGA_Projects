-------------------------------------------
--    Syncronization Block   
--    Sync buttons with sys_clock    
--    29/03 - 1st Version tallesvv
--

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--||||||   ENTITY   ||||||--

ENTITY sync_block IS
    PORT(
        async_i:  IN std_logic;
        clk:      IN std_logic;

        syncd_o:   OUT std_logic
    );
END sync_block;

--||||||   ARCHITECTURE  ||||||--

ARCHITECTURE rtl OF sync_block IS

    SIGNAL shiftreg, next_shiftreg:  std_logic_vector(2 downto 0);

BEGIN

    -->> Combination Logic

    next_shiftreg <= async_i & shiftreg(2 downto 1);   

    -->> Sequential Logic

    flip_flop: PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            shiftreg <= next_shiftreg;
        END IF;
    END PROCESS;

    -->> Concurrent Assignments

    syncd_o <= shiftreg(1);
      
END rtl;