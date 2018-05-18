-------------------------------------------
-- Block code:  testbench_fir_design.vhd
-- History: 	27.Mar.2018 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: Testbench for FIR design in EA-999 project - for Milestone-2
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
-- Entity Declaration 
ENTITY testbench_fir_design IS
  
END testbench_fir_design ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_fir_design IS

	-- Component Declaration
COMPONENT fir_core 
        PORT(
            clk         : in    std_logic;
            reset_n     : in    std_logic;
			strobe_i	: in    std_logic; 					   -- indicates beginning of audio frame
			adata_i		: in	std_logic_vector(15 downto 0); --   audio  data input
			fdata_o		: out	std_logic_vector(15 downto 0) -- filtered data output
        );
END COMPONENT;
		
	-- Signals & Constants Declaration 
	-- Inputs
	SIGNAL tb_clk 		: std_logic;
	SIGNAL tb_reset_n 	: std_logic;
	SIGNAL tb_strobe_i	: std_logic;
	SIGNAL tb_adata_i	: std_logic_vector(15 downto 0);

	-- Outputs
	SIGNAL tb_fdata_o	: std_logic_vector(15 downto 0);
	
	-- Constants
	CONSTANT CLK_50M_HALFP 	: time := 10 ns;  		-- Half-Period of Clock 50MHz
	CONSTANT STR_48K_PER 	: time := 20.8 us;  	-- Period of Audio Frame strobe 48kHz
	CONSTANT DAT_200_HALFP 	: time := 2_500 us;  	-- Half-Period of Data with freq 200Hz
	
	-- Auxiliary Signals for internal probes
	--SIGNAL tb_reg0_up	: std_logic_vector(3 downto 0); -- to check DUT-internal signal
	--SIGNAL tb_reg0_lo	: std_logic_vector(3 downto 0);	
	
BEGIN
  -- Instantiations
  DUT: fir_core
  PORT MAP (
	clk         => tb_clk,         
	reset_n     => tb_reset_n ,    
	strobe_i	=> tb_strobe_i,
	adata_i		=> tb_adata_i,		
	fdata_o	    => tb_fdata_o
		);
		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clk <= '1';
		wait for CLK_50M_HALFP;	
		tb_clk <= '0';
		wait for CLK_50M_HALFP;
	END PROCESS generate_clock;
	
  -- Strobe Generation Process	
	generate_strobe: PROCESS
	BEGIN
		tb_strobe_i <= '0';
		wait for (STR_48K_PER - 2*CLK_50M_HALFP);	
		tb_strobe_i <= '1';
		wait for 2*CLK_50M_HALFP;
	END PROCESS generate_strobe;

  -- Audio-Data Generation Process: start with impulse, then square-w-200Hz	
	generate_adata: PROCESS
	BEGIN

		tb_adata_i <= (OTHERS => '0');
		wait for 1.5*STR_48K_PER;
		wait until rising_edge(tb_strobe_i);
		tb_adata_i(14) <= '1';
		wait until falling_edge(tb_strobe_i);
		tb_adata_i(14) <= '0';
		wait for 3*DAT_200_HALFP;	

		tb_adata_i <= std_logic_vector(to_signed((2**8)-1,16)); -- positive half-period
		wait for DAT_200_HALFP;	
		tb_adata_i <= (OTHERS => '0'); -- back to zero
		wait for 2*DAT_200_HALFP;	
			
		tb_adata_i <= std_logic_vector(to_signed((2**8)-1,16)); -- positive half-per
		wait for DAT_200_HALFP;	
		tb_adata_i <= std_logic_vector(to_signed(-(2**8),16)); -- negative half-per
		wait for DAT_200_HALFP;
		tb_adata_i <= (OTHERS => '0'); -- back to zero

		wait for 3*DAT_200_HALFP;	
		
	END PROCESS generate_adata;

	
	-------------------------------------------
	-- VHDL-2008 Syntax allowing to bind 
	--           internal signals to a debug signal in the testbench
	-------------------------------------------
	-- tb_reg0_up <= <<signal DUT.reg0_up_hexa : std_logic_vector(3 downto 0) >>;
	-- tb_reg0_lo <= <<signal DUT.reg0_lo_hexa : std_logic_vector(3 downto 0) >>;
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- STEP 0
		report "Initialise: pulse reset on/off";
		tb_reset_n <= '0';
		----------------
		wait for 12 * clk_50M_halfp; 
		tb_reset_n <= '1';
		wait for 1 us;  -- pause before starting 1st I2C TX
		
		-- STEP 1
		report "Observe filtering iterations (currently visually)";
		-- values of strobe and adata defined above

		wait for 10 * DAT_200_HALFP;

		
		-- stop simulation
		assert false report "All tests passed!" severity failure;
		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

