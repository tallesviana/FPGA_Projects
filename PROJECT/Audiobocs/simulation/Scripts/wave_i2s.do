onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 22 TESTBENCH
add wave -noupdate -height 22 /testbench_i2s_master/tb_clk_12M
add wave -noupdate -height 22 /testbench_i2s_master/tb_reset_n
add wave -noupdate -height 22 /testbench_i2s_master/tb_init_n
add wave -noupdate -height 22 /testbench_i2s_master/tb_adc_s_i
add wave -noupdate -divider <NULL>
add wave -noupdate -divider -height 22 {I2S DECODER}
add wave -noupdate -height 22 /testbench_i2s_master/DUT/i2s_decoder/next_state
add wave -noupdate -color yellow -height 22 /testbench_i2s_master/DUT/i2s_decoder/bclk_o
add wave -noupdate -height 22 /testbench_i2s_master/DUT/i2s_decoder/ws_o
add wave -noupdate -height 22 /testbench_i2s_master/DUT/i2s_decoder/strobe_o
add wave -noupdate -color coral -height 22 /testbench_i2s_master/DUT/i2s_decoder/SHIRFT_L_o
add wave -noupdate -color {Cornflower Blue} -height 22 /testbench_i2s_master/DUT/i2s_decoder/SHIRFT_R_o
add wave -noupdate -height 22 -radix unsigned /testbench_i2s_master/DUT/i2s_decoder/count
add wave -noupdate -divider -height 22 {S2P LEFT}
add wave -noupdate -color Salmon -height 22 -itemcolor salmon /testbench_i2s_master/DUT/s2p_left/PAR_o
add wave -noupdate -divider -height 22 {S2P RIGHT}
add wave -noupdate -color {Cornflower Blue} -height 22 -itemcolor {Cornflower Blue} /testbench_i2s_master/DUT/s2p_right/PAR_o
add wave -noupdate -divider -height 30 OUT
add wave -noupdate /testbench_i2s_master/DUT/DACDAT_s_o
add wave -noupdate -divider -height 25 {P2S LEFT}
add wave -noupdate /testbench_i2s_master/DUT/p2s_left/PAR_i
add wave -noupdate /testbench_i2s_master/DUT/p2s_left/SER_o
add wave -noupdate /testbench_i2s_master/DUT/p2s_left/shiftreg
add wave -noupdate -divider -height 25 {P2S RIGHT}
add wave -noupdate /testbench_i2s_master/DUT/p2s_right/PAR_i
add wave -noupdate /testbench_i2s_master/DUT/p2s_right/SER_o
add wave -noupdate /testbench_i2s_master/DUT/p2s_right/shiftreg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13680 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 138
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
WaveRestoreZoom {0 ns} {6153 ns}
