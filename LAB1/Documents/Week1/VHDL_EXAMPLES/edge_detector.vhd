-------------------------------------------
-- Block code:  edge_detector.vhd
-- History: 	14.Oct.2013 - 1st version (dqtm)
--              01.Mar.2018 - rename in English (dqtm)
-- Function: synchronous edge detector for a serial data input.
--           Outputs are rise and fall pulses lasting 1 clock period. 
--
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY edge_detector IS
  PORT( data_in 	: IN    std_logic;
		clock		: IN    std_logic;
		reset_n		: IN    std_logic;
    	rise    	: OUT   std_logic;
		fall     	: OUT   std_logic
    	);
END edge_detector;


-- Architecture Declaration 
ARCHITECTURE rtl OF edge_detector IS

	-- Signals & Constants Declaration 
	SIGNAL Q_after1FF: std_logic;
	SIGNAL Q_after2FF: std_logic;
	
-- Begin Architecture
BEGIN 
    -------------------------------------------
    -- Process for combinational logic
    ------------------------------------------- 
	 -- not needed in this file, using concurrent logic
	 
	 -------------------------------------------
    -- Process for registers (flip-flops)
    -------------------------------------------
	flip_flops : PROCESS(clock, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			Q_after1FF <= '0';
			Q_after2FF <= '0';
		ELSIF rising_edge(clock) THEN
			Q_after1FF <= data_in;
			Q_after2FF <= Q_after1FF;
		END IF;
	END PROCESS flip_flops;	
	 

	 -------------------------------------------
    -- Concurrent Assignments  
    -------------------------------------------
	rise <= Q_after1FF AND NOT(Q_after2FF);
	fall <= Q_after2FF AND NOT(Q_after1FF);
	
	
END rtl;	
