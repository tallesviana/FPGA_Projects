-------------------------------------------
-- Block code:  testbench_uart_rx_only_top.vhd
-- History: 	13.Mar.2018 - 1st version (dqtm)
--				22.Mar.2018 - 2nd version - Adapted to my uart - Talles Viana
--                 <date> - <changes>  (<author>)
-- Function: Testbench for uart_rx_only_top in EA999 - Lab2
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY testbench_uart_rx_only_top IS
  
END testbench_uart_rx_only_top ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_uart_rx_only_top IS

	-- Components Declaration
COMPONENT uart_rx_only_top
	PORT
	(
		CLOCK_50 :  IN   STD_LOGIC;
		GPIO_1_1 :  IN   STD_LOGIC;
		KEY_N_0 :   IN   STD_LOGIC;
		HEX0_N :    OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1_N :    OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR_0 :    OUT  STD_LOGIC
	);
END COMPONENT;	
	
	
	-- Signals & Constants Declaration 
	-- Inputs
	SIGNAL tb_clock 	: std_logic;
	SIGNAL tb_reset_n 	: std_logic;
	SIGNAL tb_serdata	: std_logic;
	-- Outputs
	SIGNAL tb_ledr		: std_logic;
	SIGNAL tb_hex_0		: std_logic_vector(6 downto 0);
	SIGNAL tb_hex_1		: std_logic_vector(6 downto 0);
	
	CONSTANT clk_50M_halfp 	: time := 10 ns;  		-- Half-Period of Clock 50MHz
	CONSTANT baud_31k250_per : time := 32 us;		-- One-Period of Baud Rate 31.25KHz
	
	SIGNAL tb_hex_data	: std_logic_vector(7 downto 0); -- to check DUT-internal signal
	SIGNAL tb_tick      : std_logic;					-- check baud tick generate
	SIGNAL tb_complete  : std_logic;					-- check completion
	SIGNAL tb_isrunning : std_logic;					-- check if fsm is running

	SIGNAL tb_test_vector : std_logic_vector(9 downto 0); -- (stop-bit)+(data-byte)+(start-bit) to shift in serial_in
	
BEGIN
  -- Instantiations
  DUT: uart_rx_only_top
  PORT MAP (
	CLOCK_50	=>	tb_clock ,
    GPIO_1_1    =>	tb_serdata ,	
	KEY_N_0	    =>	tb_reset_n ,
    HEX0_N	    =>	tb_hex_0 ,
    HEX1_N	    =>	tb_hex_1 ,
	LEDR_0	    =>	tb_ledr 
		);
		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clock <= '1';
		wait for clk_50M_halfp;	
		tb_clock <= '0';
		wait for clk_50M_halfp;
	END PROCESS generate_clock;
	
		
	-------------------------------------------
	-- VHDL-2008 Syntax allowing to bind 
	--           internal signals to a debug signal in the testbench
	-------------------------------------------
	tb_hex_data <= <<signal DUT.d : std_logic_vector(7 downto 0)>>;		-- Output Data
	tb_tick <= <<signal DUT.t_tick : std_logic>>;						--Tick signal
	tb_complete <= <<signal DUT.t_complete : std_logic>>;				-- Complete signal
	tb_isrunning <= <<signal DUT.t_isrunning : std_logic>>;				-- isrunning signal
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- STEP 0
		report "Initialise: define constants and pulse reset on/off";
		tb_serdata <= '1';
		tb_test_vector <= B"1_1010_1111_0"; -- (stop-bit)+(data-byte)+(start-bit) = 0xAF
		----------------
		tb_reset_n <= '0';
		wait for 20 * clk_50M_halfp; 
		tb_reset_n <= '1';
		wait for 100 us;  -- introduce pause to check HW-bug after reset release
		
		-- STEP 1
		report "Send (start-bit)+(data-byte)+(stop-bit) with baud rate 31250 (async from clk50M)";
		wait for 200 * clk_50M_halfp;
		
		-- shift-direction is LSB first
		-- START-BIT 
		-- BIT-0 (LSB-first of lower nibbl
		-- BIT-1
		-- ...
		-- BIT-7
		-- STOP-BIT
		-- SERDATA BACK TO INACTIVE
		for I in 0 to 9 loop
			tb_serdata <= tb_test_vector(I);
			wait for baud_31k250_per;
		end loop;
		
		-- STEP 2
		report "Wait few clock_50M periods and check parallel output";
		wait for 20 * clk_50M_halfp;
		assert (tb_hex_data = "11100101") report "!!!!!! Received Data is WRONG !!!!!!" severity note;
		--assert (tb_reg0_lo = x"2") report "Reg_0 Lower Nibble Wrong" severity note;
		wait for 20 * clk_50M_halfp;
		
		-- stop simulation
		assert false report "All tests passed!" severity failure;
		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

