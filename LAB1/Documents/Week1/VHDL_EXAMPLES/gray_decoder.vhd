-------------------------------------------
-- Block code:  gray_decoder.vhd
-- History: 	30.Sep.2013 - 1st version (gelk)
--				05.Okt.2015 - added template comments (dqtm)
--              01.Mar.2018 - changed for comb inside process (dqtm)
-- Function: Decodes 3-bit vector from binary or bcd to gray code.
--           Only comb logic. Implementation with process.
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY gray_decoder IS
  PORT(
    	bcd_in    	: IN 	std_logic_vector(2 downto 0); 
    	gray_out	: OUT	std_logic_vector(2 downto 0)
		);
END gray_decoder ;

-- Architecture Declaration 
ARCHITECTURE rtl OF gray_decoder IS
-- Signals & Constants Declaration 
CONSTANT gray_0 		: std_logic_vector(2 downto 0):= "000";
CONSTANT gray_1 		: std_logic_vector(2 downto 0):= "001";
CONSTANT gray_2 		: std_logic_vector(2 downto 0):= "011";
CONSTANT gray_3 		: std_logic_vector(2 downto 0):= "010";
CONSTANT gray_4 		: std_logic_vector(2 downto 0):= "110";
CONSTANT gray_5 		: std_logic_vector(2 downto 0):= "111";
CONSTANT gray_6 		: std_logic_vector(2 downto 0):= "101";
CONSTANT gray_7 		: std_logic_vector(2 downto 0):= "100";

-- Begin Architecture
BEGIN

  -------------------------------------------
  -- Process for combinational logic  
  -------------------------------------------
  comb_proc: PROCESS (bcd_in)
  BEGIN
	CASE bcd_in IS
		WHEN "000"  =>  gray_out <= gray_0;
		WHEN "001"  =>  gray_out <= gray_1;
        WHEN "010"  =>  gray_out <= gray_2;
        WHEN "011"  =>  gray_out <= gray_3;
        WHEN "100"  =>  gray_out <= gray_4;
        WHEN "101"  =>  gray_out <= gray_5;
        WHEN "110"  =>  gray_out <= gray_6;
        WHEN OTHERS =>  gray_out <= gray_7;
	END CASE;
  END PROCESS comb_proc;
  
END rtl;

