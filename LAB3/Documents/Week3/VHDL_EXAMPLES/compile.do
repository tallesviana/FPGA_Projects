# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/testbench_simple_dff_circ.vhd
vcom -2008 -explicit -work work ../../source/simple_dff_circ.vhd


# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_simple_dff_circ

do ../scripts/wave.do
run 30.0 us 

