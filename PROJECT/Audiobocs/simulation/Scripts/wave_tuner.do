onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 20 Testbench
add wave -noupdate /testbench_tuner/tb_reset_n
add wave -noupdate /testbench_tuner/tb_clk
add wave -noupdate -divider -height 20 DDS
add wave -noupdate -color Red -format Analog-Step -height 74 -max 4095.0 -min -4096.0 -subitemconfig {/testbench_tuner/inst_dds/dacdat_g_o(15) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(14) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(13) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(12) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(11) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(10) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(9) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(8) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(7) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(6) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(5) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(4) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(3) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(2) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(1) {-color Red} /testbench_tuner/inst_dds/dacdat_g_o(0) {-color Red}} /testbench_tuner/inst_dds/dacdat_g_o
add wave -noupdate /testbench_tuner/inst_dds/phi_incr_i
add wave -noupdate /testbench_tuner/inst_dds/strobe_i
add wave -noupdate -divider -height 20 {Square WAVE}
add wave -noupdate /testbench_tuner/inst_sq/square_wave_o
add wave -noupdate -divider -height 20 {TUNER COUNT}
add wave -noupdate /testbench_tuner/DUT/note_o
add wave -noupdate -radix decimal /testbench_tuner/DUT/delta_o
add wave -noupdate /testbench_tuner/DUT/chosen_note
add wave -noupdate -radix decimal /testbench_tuner/DUT/count_mean
add wave -noupdate -radix decimal /testbench_tuner/DUT/count_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1919520 ns} 0}
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
WaveRestoreZoom {0 ns} {17850 us}
