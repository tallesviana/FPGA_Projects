----------------------------
-- FINITE STATE MACHINE - UART RX
-- Talles Viana
----------------------------

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY uart_rx_fsm IS
    PORT(
        clock, reset_n: in std_logic;
        data_rx_i   : in std_logic;
        trigger_i   : in std_logic;
        tick_i : in std_logic;
        isrunning_o : out std_logic;
        isstart_bit_o   : out std_logic;
        complete_o  : out std_logic
    );
END uart_rx_fsm;

ARCHITECTURE rtl OF uart_rx_fsm IS
    -- Signals and Types
    TYPE fsm_state IS (idle, start_bit, data_bits, stop_bit, check_save);
    SIGNAL state, next_state    : fsm_state;
    SIGNAL count, next_count    : unsigned(3 downto 0);

BEGIN
    -------------------------------------------
    -- Process for combinational logic
    -------------------------------------------
    comb_logic: PROCESS (state, count, trigger_i, data_rx_i, tick_i)
    BEGIN
    -- default
    next_state <= state;
    next_count <= count;

    -- state transitions
    CASE state IS
        -- IDLE
        WHEN idle =>
            IF trigger_i = '1' THEN
                next_state  <= start_bit;
            END IF;

        -- CHECK START BIT
        WHEN start_bit =>
            IF tick_i = '1' THEN
               IF data_rx_i = '0' THEN
                   next_state <= data_bits;
                   next_count <= to_unsigned(7, 4);
                ELSE
                    next_state <= idle;
                END IF;
            END IF;
        
        -- RECEIVING 8 BITS OF DATA
        WHEN data_bits =>
            IF tick_i = '1' THEN
                IF count = 0 THEN
                    next_state <= stop_bit;
                ELSE
                    next_count <= count - 1;
                END IF;
            END IF;

        -- CHECK STOP BIT
        WHEN stop_bit =>
            IF tick_i = '1' THEN
                IF data_rx_i = '1' THEN
                    next_state <= check_save;
                ELSE
                    next_state <= idle;
                END IF;
            END IF;

        -- OTHER VALUES
        WHEN OTHERS =>
            next_state <= idle;
            next_count <= to_unsigned(0,4);
        END CASE;
    END PROCESS comb_logic;

    ------------------------------------------- 
    -- Process for registers (flip-flops)
    -------------------------------------------
	flip_flops : PROCESS(clock, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			state <= idle;
			count <= to_unsigned(0,4);
		ELSIF RISING_EDGE(clock) THEN
			state <= next_state;
			count <= next_count;
		END IF;
	END PROCESS flip_flops;	

    --------------------------------------------------
    -- PROCESS FOR COMB-OUTPUT LOGIC
    --------------------------------------------------
    fsm_output : PROCESS (state)
    BEGIN
  
  	    CASE state IS
  		    WHEN  idle =>           -- Can I put the zeros as a default statement?
                isrunning_o   <= '0';
                isstart_bit_o <= '0';
                complete_o    <= '0';
  		    WHEN start_bit =>
                isrunning_o   <= '1';
                isstart_bit_o <= '1';
                complete_o    <= '0';
            WHEN data_bits | stop_bit =>
                isrunning_o   <= '1';
                isstart_bit_o <= '0';
                complete_o    <= '0';
            WHEN check_save =>
                isrunning_o   <= '0';
                isstart_bit_o <= '0';
                complete_o    <= '1';
            WHEN OTHERS =>
                isrunning_o   <= '0';
                isstart_bit_o <= '0';
                complete_o    <= '0';           
  	    END CASE;
    END PROCESS fsm_output;
END rtl;

                
