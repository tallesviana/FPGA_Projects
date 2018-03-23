-------------------------------------------
-- Block code:  <filename>.vhd
-- History: 	24.Sep.2013 - 1st version (gelk)
--                 <date> - <changes>  (<author>)
-- Function: 2-1Mux, plain functionality, example for IF-THEN/ELSE
--            implemented with comb logic inside process
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY mux2to1 IS
  PORT(
    	a,b    	: IN 	std_logic_vector(7 downto 0); 
		sel		: IN	std_logic;
    	x		: OUT	std_logic_vector(7 downto 0)
		);
END mux2to1 ;


-- Architecture Declaration 
ARCHITECTURE rtl OF mux2to1 IS

-- Begin Architecture
BEGIN

  -------------------------------------------
  -- Process for combinational logic 
  -------------------------------------------
  muxer: PROCESS(ALL)
    BEGIN
		IF (sel = '1') THEN 
			x <= a;
		ELSE 
			x <= b;
		END IF;
  END PROCESS;
	
	 
END rtl;

