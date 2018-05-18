--------------------------------------------------------------------
-- Project     : Audio_Synth
--
-- File Name   : single_port_ram.vhd
-- Description : Implement single-port ram for audio filter tap-line
--				 separated block for special syntax inferring embedded M4K mem blocks
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 29.03.17 |    dqtm  | file created
-- 26.03.18 |    dqtm  | adapted for FIR tap-line
--------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.audio_filter_pkg.all;
  
ENTITY single_port_ram IS 	
	GENERIC(
		ADDR_NBR:		integer := N_LUT;   -- constants from audio_filter_pkg
		ADDR_WIDTH: 	integer := N_addr_LUT;
		DATA_WIDTH:		integer := N_RESOL_TAP    
		);
	PORT( clk	 	 	: IN    std_logic;						
		we				: IN	std_logic;		-- 1:write enabled / read every clk-cycle
		addr			: IN	std_logic_vector(ADDR_WIDTH-1 downto 0);	
		data_i			: IN 	std_logic_vector(DATA_WIDTH-1 downto 0);	
		data_o			: OUT	std_logic_vector(DATA_WIDTH-1 downto 0) -- available 1-clk after addr set
    	);
END single_port_ram;

ARCHITECTURE beh_ram OF single_port_ram IS
-- Signals & Constants Declaration
-------------------------------------------
TYPE mem_2d_type IS ARRAY (0 to (ADDR_NBR-1)) of std_logic_vector(DATA_WIDTH-1 downto 0);
SIGNAL ram 		: mem_2d_type := (OTHERS => (OTHERS => '0')); --forcing just for simulation, remove afterwards
SIGNAL addr_reg : std_logic_vector(ADDR_WIDTH-1 downto 0);
	
-- Begin Architecture
-------------------------------------------
BEGIN
	
----------------------------------------------------- ------------------
-- REGISTER PROCESS
-----------------------------------------------------------------------
	RAM_block : PROCESS(clk)
	BEGIN	
		IF rising_edge(clk) THEN
			IF (we='1') THEN
				ram(to_integer(unsigned(addr))) <= data_i;
			END IF;
			addr_reg <= addr;		-- read address is internally registered
		END IF;
	END PROCESS RAM_block;		
	
-----------------------------------------------------------------------
-- CONCURRENT ASSIGNMENTS
-----------------------------------------------------------------------
	data_o <= ram(to_integer(unsigned(addr_reg)));
	
end beh_ram;

