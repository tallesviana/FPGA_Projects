LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY test_keys IS
	PORT(
		CLOCK_50	:	IN STD_LOGIC;
		KEY			:	IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		LEDR		:	OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDG		:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END test_keys;

ARCHITECTURE rtl OF test_keys IS

	SIGNAL led, next_led	:	STD_LOGIC_VECTOR(17 DOWNTO 0);
	
BEGIN

	comb:	PROCESS(led, KEY)
	BEGIN
		CASE not(KEY) IS
			WHEN "0000" => next_led <= led;
			WHEN "0001" => next_led <= "000000000000000001";
			WHEN "0010" => next_led <= "000000000000000010";
			WHEN "0011" => next_led <= "000000000000000100";
			WHEN "0100" => next_led <= "000000000000001000";
			WHEN "0101" => next_led <= "000000000000010000";
			WHEN "0110" => next_led <= "000000000000100000";
			WHEN "0111" => next_led <= "000000000001000000";
			WHEN "1000" => next_led <= "000000000010000000";
			WHEN "1001" => next_led <= "000000000100000000";
			WHEN "1010" => next_led <= "000000001000000000";
			WHEN "1011" => next_led <= "000000010000000000";
			WHEN "1100" => next_led <= "000000100000000000";
			WHEN "1101" => next_led <= "000001000000000000";
			WHEN "1110" => next_led <= "000010000000000000";
			WHEN "1111" => next_led <= "000100000000000000";
			WHEN OTHERS => next_led <= "000000000000000000";
		END CASE;
	END PROCESS;

	flip_flop: PROCESS(CLOCK_50)
	BEGIN
		IF rising_edge(CLOCK_50) THEN
			led <= next_led;
		END IF;
	END PROCESS;
	
	LEDG <= led(7 DOWNTO 0);
	LEDR <= led(17 DOWNTO 8);
END rtl;