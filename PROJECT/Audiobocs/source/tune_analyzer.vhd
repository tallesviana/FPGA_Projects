LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
ENTITY tune_analyzer IS
  PORT(
      clk, reset_n :  IN std_logic;
	  
	  fdata_e2_i  :  IN std_logic_vector(15 downto 0);
      fdata_a2_i  :  IN std_logic_vector(15 downto 0);
      fdata_d3_i  :  IN std_logic_vector(15 downto 0);
      fdata_g3_i  :  IN std_logic_vector(15 downto 0);
      fdata_b3_i  :  IN std_logic_vector(15 downto 0);
      fdata_e4_i  :  IN std_logic_vector(15 downto 0)
   
  );
END tune_analyzer;


ARCHITECTURE rtl OF tune_analyzer IS

    SIGNAL audio2tune  :  std_logic_vector(15 downto 0); -- Signal to choose the best signal to tune 

BEGIN



END rtl;