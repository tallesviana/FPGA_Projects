LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.tone_gen_pkg.all;
  
 ENTITY dds_sw_ctrl IS
     PORT(
	       switches_i :  IN std_logic_vector(6 downto 0);
		   
		   phi_incr_o :  OUT std_logic_vector(N_CUM - 1 downto 0)
	 );
END dds_sw_ctrl;

ARCHITECTURE comb OF dds_sw_ctrl IS

BEGIN
    phi_incr_o <= std_logic_vector(LUT_midi2dds(to_integer(switches_i)));
END comb;