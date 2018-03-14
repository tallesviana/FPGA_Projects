-------------------------------------------
-- Block code:  alarm_level_display_wo_default.vhd
-- History: 	30.Sep.2011 - example for introduction to comb logic 
--				05.Okt.2013 - also check example with default statements!! (dqtm)
-- Function: Decodes the output for a alarm level display.
--           Only comb logic. Example of logic with priority. 
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY alarm_level_display_wo_default IS
  PORT(
    	alarm_prio1    	: IN 	std_logic;
    	alarm_prio2    	: IN 	std_logic;
    	alarm_prio3    	: IN 	std_logic;
		display_red		: OUT	std_logic;
		display_orange	: OUT	std_logic;
		display_yellow	: OUT	std_logic;
		display_green	: OUT	std_logic
		);
END alarm_level_display_wo_default ;

-- Architecture Declaration 
ARCHITECTURE rtl OF alarm_level_display_wo_default IS

-- Begin Architecture
BEGIN

  -------------------------------------------
  -- Process for combinational logic  
  -------------------------------------------
  comb_alarm: PROCESS(alarm_prio1,alarm_prio2,alarm_prio3)
  BEGIN
	IF (alarm_prio1 = '1') THEN
		display_red 	<= '1';
		display_orange	<= '0';
		display_yellow	<= '0';
		display_green 	<= '0';

	ELSIF(alarm_prio2 = '1') THEN
		display_red 	<= '0';
		display_orange	<= '1';
		display_yellow	<= '0';
		display_green	<= '0';

	ELSIF(alarm_prio3 = '1') THEN
		display_red		<= '0';
		display_orange	<= '0';
		display_yellow	<= '1';
		display_green	<= '0';

	ELSE
		display_red 	<= '0';
		display_orange	<= '0';
		display_yellow	<= '0';
		display_green	<= '1';
	END IF;
  END PROCESS comb_alarm;
 
END rtl;

