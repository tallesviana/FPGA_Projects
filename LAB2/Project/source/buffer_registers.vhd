---------------------------------
-- SHIFT REGISTER W/ BUFFER
-- Talles Viana
---------------------------------
-- Shitfs data from data_rx_i on every Tick rising edge
-- And then, stores, if store_i is HIGH
---------------------------------

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY buffer_registers IS
    PORT(
        clock, reset_n      : IN std_logic;
        data_rx_i         : IN std_logic;
        tick_i            : IN std_logic;
        store_i           : IN std_logic;
        data_rx_o         : OUT std_logic_vector(7 downto 0)
    );
END buffer_registers;

ARCHITECTURE rtl OF buffer_registers IS
    SIGNAL reg, next_reg  : std_logic_vector(9 downto 0); -- 1 Start + 1 Stop + 8 Data
    SIGNAL buf, next_buf  : std_logic_vector(7 downto 0); -- 8 Data

BEGIN
    --------------------------------
    -- SHIFT-REGISTERS
    --------------------------------
    comb_logic: PROCESS(tick_i, reg, store_i)
    BEGIN
        IF store_i = '0' THEN
            IF tick_i = '1' THEN
                next_reg <= data_rx_i & reg(9 downto 1);   -- Towards LSB
			ELSE
				next_reg <= reg;
            END IF;
        ELSE
                next_reg <= (OTHERS => '1');  -- Set all bits to 1
        END IF;
    END PROCESS;

    -------------------------------
    -- SAVE BUFFER
    ------------------------------
    save_logic: PROCESS(store_i, buf, reg)  -- Probably we will need to integrate with the block above
    BEGIN   
        IF store_i = '1' THEN
            next_buf <= reg(8 downto 1); -- Get only the 8 DATA BITS
        ELSE
            next_buf <= buf;
        END IF;
    END PROCESS;

    --------------------
    -- FF
    --------------------
    flip_flops: PROCESS(clock, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            buf <= (OTHERS => '0');     -- Show blank in the seven seg
            reg <= (OTHERS => '1');
        ELSIF rising_edge(clock) THEN
            buf <= next_buf;
            reg <= next_reg;
        END IF;
    END PROCESS;

    -------------------
    -- CONCURRENT ASSIGNMENTS
    -------------------

    data_rx_o <= buf;
END rtl;

