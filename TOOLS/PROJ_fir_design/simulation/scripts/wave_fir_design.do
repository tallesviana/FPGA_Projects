onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold -height 27 /testbench_fir_design/tb_clk
add wave -noupdate -color Gold -height 27 /testbench_fir_design/tb_reset_n
add wave -noupdate -color Gold -height 27 /testbench_fir_design/tb_strobe_i
add wave -noupdate -color Gold -format Analog-Step -height 74 -max 16384.0 -radix decimal /testbench_fir_design/tb_adata_i
add wave -noupdate -color Gold -format Analog-Step -height 74 -max 824.99999999999989 -min -66.0 -radix sfixed /testbench_fir_design/tb_fdata_o
add wave -noupdate -height 27 /testbench_fir_design/DUT/fir_state
add wave -noupdate -height 27 -radix unsigned /testbench_fir_design/DUT/tap_counter
add wave -noupdate -height 27 /testbench_fir_design/DUT/tap_we
add wave -noupdate -height 27 -radix unsigned /testbench_fir_design/DUT/addr_offset
add wave -noupdate -height 27 -radix unsigned /testbench_fir_design/DUT/tap_addr
add wave -noupdate -format Analog-Step -height 74 -max 55951400.0 -min -4768140.0 -radix sfixed /testbench_fir_design/DUT/tap_mac_2store
add wave -noupdate -format Analog-Step -height 74 -max 55951400.0 -min -4768140.0 -radix sfixed /testbench_fir_design/DUT/tap_data_o
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(250)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(251)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(252)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(253)
add wave -noupdate -color Magenta -radix sfixed /testbench_fir_design/DUT/tap_line/ram(254)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(0)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(1)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(2)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(3)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(4)
add wave -noupdate -radix sfixed /testbench_fir_design/DUT/tap_line/ram(5)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15027840 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 198
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
WaveRestoreZoom {0 ns} {31500 us}
