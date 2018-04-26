-------------------------------------------------------------------------------
-- Project     : Audio_Synth
-- Description : i2s_fsm_decoder
--
--       It is the FSM which controls the s2p and p2s blocks
--               
--               
--
-------------------------------------------------------------------------------
--
-- Change History
-- Date     |Name      |Modification
------------|----------|-------------------------------------------------------
-- 17/04/18 | Talles   | File created 
-------------------------------------------------------------------------------

LIBRARY ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

ENTITY i2s_fsm_decoder IS 
    GENERIC(data_size : natural := 16);  -- I2S Data Size 16, 32, 64..
    PORT(
        reset_n     :  IN std_logic;
        clk         :  IN std_logic;
        init_n      :  IN std_logic;

        SHIRFT_L_o  :  OUT std_logic;
        SHIRFT_R_o  :  OUT std_logic;
        bclk_o      :  OUT std_logic;
        ws_o        :  OUT std_logic;
        strobe_o    :  OUT std_logic
    );
END i2s_fsm_decoder;

ARCHITECTURE rtl OF i2s_fsm_decoder IS 
    
    TYPE t_fsm_state is (load, shift_l, hold_l, shift_r, hold_r);

    SIGNAL state, next_state  :  t_fsm_state; 
    SIGNAL bclk, next_blck    :  std_logic;
    SIGNAL count, next_count  :  unsigned(6 downto 0) := to_unsigned(0,7); 

BEGIN

    --========  STATE MACHINE =========---
    fsm_i2s: PROCESS (state, count, init_n)
    BEGIN
        -- Default Statements
        next_state <= state;
        SHIRFT_L_o <= '0';
        SHIRFT_R_o <= '0';
        strobe_o <= '0';  

        CASE state IS

            WHEN load =>                 -- LOAD STATE
                strobe_o <= '1';
                IF count = 1 THEN
                    next_state <= shift_l;
                END IF;

            WHEN shift_l =>              -- SHIFT LEFT STATE
                IF (count > 0) and (count <= data_size) THEN
                    SHIRFT_L_o <= '1';
                ELSE
                    next_state <= hold_l;
                END IF;
              
            WHEN hold_l =>               -- HOLD LEFT SHIFT
                IF not((count > data_size) and (count <= 64)) THEN
                    next_state <= shift_r;
                END IF;

            WHEN shift_r =>              -- SHIFT RIGHT STATE
                IF (count > 64) and (count <= data_size + 64) THEN
                    SHIRFT_R_o <= '1';
                ELSE
                    next_state <= hold_r;
                END IF;

            WHEN hold_r =>               -- HOLD RIGHT SHIFT
                IF not(count > data_size + 64) THEN
                    next_state <= load;
                END IF;

            WHEN OTHERS =>
                next_state <= load;

        END CASE;
    END PROCESS;

                                   --            _   _   _   _   _
    --=====   BCLK GEN  =====--       CLK_12   _| |_| |_| |_| |_| |_
                                   --            ___     ___     ___
                                   -- BCLK     _|   |___|   |___|
        next_blck <= bclk xor '1';   -- Overflowing
    

    --=====   BIT COUNTER  ======--   -- Counts up to 127
    counter: PROCESS (count, init_n)
    BEGIN
        IF init_n = '0' THEN
            next_count <= to_unsigned(0,7);
        ELSIF bclk = '1'THEN                -- BLCK as enable
            next_count <= count + 1;
        ELSE
            next_count <= count;
        END IF;
    END PROCESS;

    --=======   WS GEN  =======--
    ws_gen: PROCESS(count)
    BEGIN
        IF count < 64 THEN
            ws_o <= '0';
        ELSE
            ws_o <= '1';
        END IF;
    END PROCESS;


    --======  FLIP FLOPS ======-
    ffs: PROCESS(reset_n, clk)
    BEGIN
        IF reset_n = '0' THEN
            state <= load;
            count <= to_unsigned(0, 7);
            bclk  <= '0';
        ELSIF rising_edge(clk) THEN
            state <= next_state;
            count <= next_count;
            bclk <= next_blck;
        END IF;
    END PROCESS;

    --======= CONCURREMENT ASSIGMENTS ====--
    bclk_o <= bclk;
END rtl;