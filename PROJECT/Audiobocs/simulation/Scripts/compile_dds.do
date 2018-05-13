# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/audio_filter_pkg.vhd
vcom -2008 -explicit -work work ../../source/tone_gen_pkg.vhd
vcom -2008 -explicit -work work ../../source/single_port_ram.vhd
vcom -2008 -explicit -work work ../../source/testbench_dds.vhd
vcom -2008 -explicit -work work ../../source/fir_core.vhd
vcom -2008 -explicit -work work ../../source/dds.vhd

# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_dds

do ../scripts/wave_dds.do
run 17ms

