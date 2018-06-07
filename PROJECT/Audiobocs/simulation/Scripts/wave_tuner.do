onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 20 Testbench
add wave -noupdate /testbench_tuner/tb_reset_n
add wave -noupdate /testbench_tuner/tb_clk
add wave -noupdate -divider -height 20 DDS
add wave -noupdate -color Red -format Analog-Step -height 74 -max 4095.0 -min -4096.0 /testbench_tuner/inst_dds/dacdat_g_o
add wave -noupdate /testbench_tuner/inst_dds/phi_incr_i
add wave -noupdate /testbench_tuner/inst_dds/strobe_i
add wave -noupdate -divider -height 20 {Square WAVE}
add wave -noupdate /testbench_tuner/inst_sq/square_wave_o
add wave -noupdate -divider -height 20 {TUNER COUNT}
add wave -noupdate /testbench_tuner/DUT/flag_count_on
add wave -noupdate /testbench_tuner/DUT/note_o
add wave -noupdate -radix decimal /testbench_tuner/DUT/delta_o
add wave -noupdate /testbench_tuner/DUT/chosen_note
add wave -noupdate -radix decimal /testbench_tuner/DUT/count_mean
add wave -noupdate -radix decimal /testbench_tuner/DUT/count_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3405600 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 130
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
WaveRestoreZoom {0 ns} {52500 us}
