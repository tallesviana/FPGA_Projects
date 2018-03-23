-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Fri Mar 16 10:52:26 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY uart_rx_only_top IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		GPIO_1 :  IN  STD_LOGIC_VECTOR(1 DOWNTO 1);
		KEY :  IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(0 DOWNTO 0)
	);
END uart_rx_only_top;

ARCHITECTURE bdf_type OF uart_rx_only_top IS 

COMPONENT sync_n_edgedetector
	PORT(data_in : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 data_sync : OUT STD_LOGIC;
		 rise : OUT STD_LOGIC;
		 fall : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT baud_tick_generator
GENERIC (clocks_por_bit : INTEGER
			);
	PORT(reset_n : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 run_i : IN STD_LOGIC;
		 start_bit_i : IN STD_LOGIC;
		 tick_o : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT buffer_registers
	PORT(clock : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 data_rx_i : IN STD_LOGIC;
		 tick_i : IN STD_LOGIC;
		 store_i : IN STD_LOGIC;
		 data_rx_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hex2sevseg_w_control
	PORT(blank_n_i : IN STD_LOGIC;
		 lamp_test_n_i : IN STD_LOGIC;
		 ripple_blank_n_i : IN STD_LOGIC;
		 hexa_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 ripple_blank_n_o : OUT STD_LOGIC;
		 seg_o : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT uart_rx_fsm
	PORT(clock : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 data_rx_i : IN STD_LOGIC;
		 trigger_i : IN STD_LOGIC;
		 tick_i : IN STD_LOGIC;
		 isrunning_o : OUT STD_LOGIC;
		 isstart_bit_o : OUT STD_LOGIC;
		 complete_o : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	d :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	t_clock :  STD_LOGIC;
SIGNAL	t_complete :  STD_LOGIC;
SIGNAL	t_fall :  STD_LOGIC;
SIGNAL	t_gnd :  STD_LOGIC;
SIGNAL	t_isrunning :  STD_LOGIC;
SIGNAL	t_isstart :  STD_LOGIC;
SIGNAL	t_reset :  STD_LOGIC_VECTOR(0 DOWNTO 0);
SIGNAL	t_seg_hi :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	t_seg_lo :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	t_serial_data :  STD_LOGIC;
SIGNAL	t_serial_data_in :  STD_LOGIC;
SIGNAL	t_tick :  STD_LOGIC;
SIGNAL	t_vcc :  STD_LOGIC;


BEGIN 



b2v_inst : sync_n_edgedetector
PORT MAP(data_in => t_serial_data_in,
		 clock => t_clock,
		 reset_n => t_reset(0),
		 data_sync => t_serial_data,
		 fall => t_fall);


b2v_inst2 : baud_tick_generator
GENERIC MAP(clocks_por_bit => 1600
			)
PORT MAP(reset_n => t_reset(0),
		 clock => t_clock,
		 run_i => t_isrunning,
		 start_bit_i => t_isstart,
		 tick_o => t_tick);


b2v_inst3 : buffer_registers
PORT MAP(clock => t_clock,
		 reset_n => t_reset(0),
		 data_rx_i => t_serial_data,
		 tick_i => t_tick,
		 store_i => t_complete,
		 data_rx_o => d);


b2v_inst4 : hex2sevseg_w_control
PORT MAP(blank_n_i => t_vcc,
		 lamp_test_n_i => t_vcc,
		 ripple_blank_n_i => t_gnd,
		 hexa_i => d(7 DOWNTO 4),
		 seg_o => t_seg_hi);


b2v_inst6 : hex2sevseg_w_control
PORT MAP(blank_n_i => t_vcc,
		 lamp_test_n_i => t_vcc,
		 ripple_blank_n_i => t_vcc,
		 hexa_i => d(3 DOWNTO 0),
		 seg_o => t_seg_lo);




b2v_inst9 : uart_rx_fsm
PORT MAP(clock => t_clock,
		 reset_n => t_reset(0),
		 data_rx_i => t_serial_data,
		 trigger_i => t_fall,
		 tick_i => t_tick,
		 isrunning_o => t_isrunning,
		 isstart_bit_o => t_isstart,
		 complete_o => t_complete);

HEX0 <= t_seg_lo;
t_clock <= CLOCK_50;
t_reset <= KEY;
t_serial_data_in <= GPIO_1(1);
HEX1 <= t_seg_hi;
LEDR(0) <= t_complete;

t_gnd <= '0';
t_vcc <= '1';
END bdf_type;