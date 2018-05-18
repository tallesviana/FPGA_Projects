---------------------------------------------------
--     DDS Controller via Switches[9..3
---------------------------------------------------
--
--     It controls the DDS gen via given switches_i
---------------------------------------------------
-- 18/05/18 - tallesvv - 1st version
---------------------------------------------------

LIBRARY ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.tone_gen_pkg.all;
  
------------------------------------------------------
-->>>>>>>>>>>      ENTITY DECLARATION   <<<<<<<<<<<<<<
------------------------------------------------------
ENTITY dds_sw_ctrl IS
    PORT(
	    switches_i :  IN std_logic_vector(6 downto 0);
		   
		phi_incr_o :  OUT std_logic_vector(N_CUM - 1 downto 0)
	 );
END dds_sw_ctrl;

------------------------------------------------------
-->>>>>>>>>>>>>     ARCHITECTURE   <<<<<<<<<<<<<<<<<<<
------------------------------------------------------
ARCHITECTURE comb OF dds_sw_ctrl IS

BEGIN

    phi_incr_o <= LUT_midi2dds(to_integer(unsigned(switches_i)));
	
END comb;