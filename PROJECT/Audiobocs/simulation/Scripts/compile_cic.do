# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/audio_filter_pkg.vhd
vcom -2008 -explicit -work work ../../source/tone_gen_pkg.vhd
vcom -2008 -explicit -work work ../../source/single_port_ram.vhd
vcom -2008 -explicit -work work ../../source/tuner_tone_by_count.vhd
vcom -2008 -explicit -work work ../../source/square_gen.vhd
vcom -2008 -explicit -work work ../../source/cic_accumulator.vhd
vcom -2008 -explicit -work work ../../source/cic_decimator.vhd
vcom -2008 -explicit -work work ../../source/cic_comb.vhd
vcom -2008 -explicit -work work ../../source/dds.vhd
vcom -2008 -explicit -work work ../../source/cic_top.vhd
vcom -2008 -explicit -work work ../../source/testbench_cic.vhd


# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_cic

do ../scripts/wave_cic.do
run 50ms;

