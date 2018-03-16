# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/testbench_uart_rx_only_top.vhd
vcom -2008 -explicit -work work ../../source/uart_rx_only_top.vhd
vcom -2008 -explicit -work work ../../source/baud_tick_generator.vhd
vcom -2008 -explicit -work work ../../source/buffer_registers.vhd
vcom -2008 -explicit -work work ../../source/hex2sevseg_w_control.vhd
vcom -2008 -explicit -work work ../../source/sync_n_edgeDetector.vhd
vcom -2008 -explicit -work work ../../source/uart_rx_fsm.vhd




# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_uart_rx_only_top

do ../scripts/wave.do
run 30.0 us 

