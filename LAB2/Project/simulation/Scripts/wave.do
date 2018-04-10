onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 25 INPUT
add wave -noupdate -color Yellow -height 25 -label {Serial Data} /testbench_uart_rx_only_top/tb_serdata
add wave -noupdate -divider -height 25 {GENERATED SIGNALS}
add wave -noupdate -color Coral -height 25 -label {Tick Gen} /testbench_uart_rx_only_top/tb_tick
add wave -noupdate -divider -height 25 {STATE SIGNALS}
add wave -noupdate -color {Medium Violet Red} -height 25 -label {UART FSM State} /testbench_uart_rx_only_top/DUT/b2v_inst9/state
add wave -noupdate -height 25 -label {Rx Is running ?} /testbench_uart_rx_only_top/tb_isrunning
add wave -noupdate -height 25 -label {Rx Complete ?} /testbench_uart_rx_only_top/tb_complete
add wave -noupdate -height 25 -label {Bit Counter} -radix hexadecimal /testbench_uart_rx_only_top/DUT/b2v_inst9/count
add wave -noupdate -divider -height 25 OUTPUT
add wave -noupdate -color Maroon -height 25 -label {Data - Display} -radix hexadecimal -subitemconfig {/testbench_uart_rx_only_top/tb_hex_data(7) {-color Maroon} /testbench_uart_rx_only_top/tb_hex_data(6) {-color Maroon} /testbench_uart_rx_only_top/tb_hex_data(5) {-color Maroon} /testbench_uart_rx_only_top/tb_hex_data(4) {-color Maroon} /testbench_uart_rx_only_top/tb_hex_data(3) {-color Maroon} /testbench_uart_rx_only_top/tb_hex_data(2) {-color Maroon} /testbench_uart_rx_only_top/tb_hex_data(1) {-color Maroon} /testbench_uart_rx_only_top/tb_hex_data(0) {-color Maroon}} /testbench_uart_rx_only_top/tb_hex_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 330
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {437455 ns}
