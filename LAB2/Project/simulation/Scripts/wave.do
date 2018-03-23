onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /testbench_uart_rx_only_top/tb_hex_data
add wave -noupdate /testbench_uart_rx_only_top/tb_tick
add wave -noupdate /testbench_uart_rx_only_top/tb_serdata
add wave -noupdate /testbench_uart_rx_only_top/tb_complete
add wave -noupdate /testbench_uart_rx_only_top/tb_isrunning
add wave -noupdate /testbench_uart_rx_only_top/DUT/b2v_inst9/state
add wave -noupdate /testbench_uart_rx_only_top/DUT/b2v_inst9/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 248
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
WaveRestoreZoom {0 ns} {1211068 ns}
