# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/testbench_i2s_master.vhd
vcom -2008 -explicit -work work ../../source/i2s_master.vhd
vcom -2008 -explicit -work work ../../source/i2s_fsm_decoder.vhd
vcom -2008 -explicit -work work ../../source/s2p_block.vhd
vcom -2008 -explicit -work work ../../source/p2s_block.vhd

# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_i2s_master

do ../scripts/wave_i2s.do
run 35us

