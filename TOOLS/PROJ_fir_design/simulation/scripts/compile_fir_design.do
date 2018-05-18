# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/audio_filter_pkg.vhd
vcom -2008 -explicit -work work ../../source/single_port_ram.vhd
vcom -2008 -explicit -work work ../../source/fir_core.vhd
vcom -2008 -explicit -work work ../../source/testbench_fir_design.vhd

# run the simulation
vsim -t 1ns -lib work -novopt work.testbench_fir_design
do ../scripts/wave_fir_design.do
run 30 ms 

