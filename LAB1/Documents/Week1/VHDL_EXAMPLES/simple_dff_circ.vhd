-------------------------------------------
-- Block code:  simple_dff_circ.vhd
-- History: 	04.Feb.2014 - 1st version (dqtm)
-- Function: 	simple 1-DFF circuit for VHDL introduction
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;


-- Entity Declaration 
ENTITY simple_dff_circ IS
	PORT ( 	
		clock 	: in std_logic; 
		reset_n : in std_logic; 
		data_i	: in std_logic;
		hold_i	: in std_logic;
		buff_o	: out std_logic
		);
END simple_dff_circ;


-- Architecture Declaration 
ARCHITECTURE rtl OF simple_dff_circ IS

	-- Signals & Constants Declaration
	SIGNAL buff, next_buff	: std_logic ;

-- Begin Architecture
BEGIN
    -------------------------------------------
    -- Process for combinatorial logic
    -------------------------------------------
	comb_logic: PROCESS(ALL)
	BEGIN 	
	-- hold or update
		IF hold_i='1' THEN
			next_buff <= buff;
		ELSE
			next_buff <= data_i;
		END IF;
	END PROCESS comb_logic;   
  
    
    ------------------------------------------- 
    -- Process for registers (flip-flops)
    -------------------------------------------
	flip_flops : PROCESS(clock, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			buff <= '0';
		ELSIF RISING_EDGE(clock) THEN
			buff <= next_buff ;
		END IF;
	END PROCESS flip_flops;	
    
    -------------------------------------------
    -- Concurrent Assignements  
    -- e.g. Assign outputs from intermediate signals
    -------------------------------------------
	buff_o <= buff;
		
 -- End Architecture 	
END rtl; 
