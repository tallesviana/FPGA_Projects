------------------------------------------------------
-- Generates a square wave from input
------------------------------------------------------
-- 27/05/18 - tallesvv - 1st version
-- 08/06/18 - tallesvv - Add a threshold
------------------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

ENTITY square_gen IS
  PORT(
      clk, reset_n  :  IN  std_logic;
  
      audio_i       :  IN  std_logic_vector(15 downto 0);
      square_wave_o :  OUT std_logic
  );
END square_gen;

ARCHITECTURE rtl OF square_gen IS

    CONSTANT p_threshold :  integer := 400;
	CONSTANT n_threshold :  integer := -400;

    TYPE sig_state IS (sig_high, sig_low);
	SIGNAL state, next_state :  sig_state;

BEGIN

  states: PROCESS(ALL)
    BEGIN
	-- Default statement
	    next_state <= state;
		
		CASE state IS
		    -- When signal is LOW
		    WHEN sig_low =>
			    IF signed(audio_i) > p_threshold THEN
				    next_state <= sig_high;
				END IF;
				
			-- When signal is HIGH
			WHEN sig_high =>
			    IF signed(audio_i) < n_threshold THEN
				    next_state <= sig_low;
				END IF;
			
			WHEN OTHERS =>
			    next_state <= state;
				
		END CASE;
    END PROCESS;
  
  --   FLIP-FLOPS
  ff: PROCESS(ALL)
    BEGIN
        IF reset_n = '0' THEN
	        state <= sig_low;
	    ELSIF rising_edge(clk) THEN
            state <= next_state;
        END IF;			
    END PROCESS;
	

	-- OUTPUT
  outs: PROCESS(ALL)
    BEGIN
	    CASE state IS
		    WHEN sig_low  =>  square_wave_o <= '0';
			WHEN sig_high =>  square_wave_o <= '1';
			WHEN OTHERS   =>  square_wave_o <= '0';
		END CASE;
    END PROCESS;

END rtl;