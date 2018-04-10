# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/testbench_audio_synth_top.vhd
vcom -2008 -explicit -work work ../../source/audio_synth_top.vhd
vcom -2008 -explicit -work work ../../source/clock_div.vhd
vcom -2008 -explicit -work work ../../source/reg_table_pkg.vhd
vcom -2008 -explicit -work work ../../source/codec_ctrl.vhd
vcom -2008 -explicit -work work ../../source/i2c_master.vhd
vcom -2008 -explicit -work work ../../source/i2c_slave_bfm.vhd
vcom -2008 -explicit -work work ../../source/sync_block.vhd

# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_audio_synth_top

do ../scripts/wave.do
run -all

