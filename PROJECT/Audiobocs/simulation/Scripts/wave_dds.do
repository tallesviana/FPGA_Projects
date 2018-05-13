onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 25 TESTBENCH
add wave -noupdate /testbench_dds/tb_clk
add wave -noupdate /testbench_dds/tb_tone_on
add wave -noupdate /testbench_dds/tb_strobe
add wave -noupdate -radix unsigned /testbench_dds/tb_phi_incr
add wave -noupdate -format Analog-Step -height 74 -max 4094.9999999999995 /testbench_dds/DUT/dacdat_g_o
add wave -noupdate -divider -height 25 FIR
add wave -noupdate -format Analog-Step -height 74 -max 9995.0 -min -175.0 /testbench_dds/inst_fir/fdata_o
add wave -noupdate -radix unsigned /testbench_dds/DUT/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41120 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 226
configure wave -valuecolwidth 108
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
WaveRestoreZoom {0 ns} {30089216 ns}
