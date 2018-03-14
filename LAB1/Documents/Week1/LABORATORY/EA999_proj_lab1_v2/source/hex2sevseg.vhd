-------------------------------------------
-- Block code:  <filename>.vhd
-- History: 	24.Sep.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: Hexa to seven-seg converter
--            plain functionality 
--            implemented with comb logic outside process
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY hex2sevseg IS
  PORT(
    	hexa_i    	: IN   std_logic_vector(3 downto 0);  
    	seg_o			: OUT  std_logic_vector(6 downto 0)); -- Sequence is "gfedcba" (MSB is seg_g)
END hex2sevseg ;


-- Architecture Declaration 
ARCHITECTURE rtl OF hex2sevseg IS

	-- Signals & Constants Declaration 
	CONSTANT display_0 		: std_logic_vector(6 downto 0):= "0111111";
	CONSTANT display_1 		: std_logic_vector(6 downto 0):= "0000110"; 
	CONSTANT display_2 		: std_logic_vector(6 downto 0):= "1011011";
	CONSTANT display_3 		: std_logic_vector(6 downto 0):= "1001111";
	CONSTANT display_4 		: std_logic_vector(6 downto 0):= "1100110";
	CONSTANT display_5 		: std_logic_vector(6 downto 0):= "1101101";
	CONSTANT display_6 		: std_logic_vector(6 downto 0):= "1111101";
	CONSTANT display_7 		: std_logic_vector(6 downto 0):= "0000111";
	CONSTANT display_8 		: std_logic_vector(6 downto 0):= "1111111";
	CONSTANT display_9 		: std_logic_vector(6 downto 0):= "1101111";
	CONSTANT display_A 		: std_logic_vector(6 downto 0):= "1110111";
	CONSTANT display_B 		: std_logic_vector(6 downto 0):= "1111100";
	CONSTANT display_C 		: std_logic_vector(6 downto 0):= "0111001";
	CONSTANT display_D 		: std_logic_vector(6 downto 0):= "1011110";
	CONSTANT display_E 		: std_logic_vector(6 downto 0):= "1111001";
	CONSTANT display_F 		: std_logic_vector(6 downto 0):= "1110001"; 
	CONSTANT display_blank 	: std_logic_vector(6 downto 0):= (others =>'0');

	
-- Begin Architecture
BEGIN

  -------------------------------------------
  -- Concurrent Assignments  
  -------------------------------------------
  -- Implementation option: concurrent comb logic with with/select/when
  WITH hexa_i  SELECT
    seg_o <= 	NOT(display_0) WHEN x"0",
					NOT(display_1) WHEN x"1",
					NOT(display_2) WHEN x"2",
					NOT(display_3) WHEN x"3",
					NOT(display_4) WHEN x"4",
					NOT(display_5) WHEN x"5",
					NOT(display_6) WHEN x"6",
					NOT(display_7) WHEN x"7",
					NOT(display_8) WHEN x"8",
					NOT(display_9) WHEN x"9",
					NOT(display_A) WHEN x"A",
					NOT(display_B) WHEN x"B",
					NOT(display_C) WHEN x"C",
					NOT(display_D) WHEN x"D",
					NOT(display_E) WHEN x"E",
					NOT(display_F) WHEN x"F",
					NOT(display_blank) WHEN OTHERS; 
	
	 
END rtl;

