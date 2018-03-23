LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY full_adder_w_maxvalue IS
	GENERIC(max_value 	: positive := 15);
	PORT(
		clock, reset_n	: in std_logic;
		
		hexdata_o	: out std_logic_vector(7 downto 0)
	);
END full_adder_w_maxvalue;

ARCHITECTURE rtl OF full_adder_w_maxvalue IS

	SIGNAL count, next_count	: unsigned(7 downto 0):= to_unsigned(0, 8);
	
BEGIN

	count_logic: PROCESS(count)
	BEGIN
		IF count = max_value THEN
			next_count <= 0;
		ELSE
			next_count <= count + 1;
		END IF;
	END PROCESS;

	
	flip_flop: PROCESS(clock)
	BEGIN
		IF reset_n = '0' THEN
			count <= to_unsigned(0,8);
		ELSIF rising_edge(clock) THEN
			count <= next_count;
		END IF;
	END PROCESS;
	
	hexdata_o <= std_logic(count);


END rtl;
	