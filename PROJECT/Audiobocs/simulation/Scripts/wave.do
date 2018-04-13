onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 25 -label {CLOCK 12,5} /testbench_audio_synth_top/DUT/t_clock_12_5
add wave -noupdate -height 25 -label {Button INIT
} /testbench_audio_synth_top/DUT/t_init_syncd
add wave -noupdate -height 25 -expand -group {Codec Ctrl
} -color Orange -height 25 -label {State
} /testbench_audio_synth_top/DUT/codec/state
add wave -noupdate -height 25 -expand -group {Codec Ctrl
} -height 25 -label {Write Data
} /testbench_audio_synth_top/tb_write
add wave -noupdate -height 25 -expand -group {Codec Ctrl
} -height 25 -label {Data
} -radix hexadecimal /testbench_audio_synth_top/tb_data2write
add wave -noupdate -height 25 -expand -group {I2C Master} -color Orange -height 25 -label {State
} /testbench_audio_synth_top/DUT/master/fsm_state
add wave -noupdate -height 25 -expand -group {I2C Master} -color yellow -height 25 -label {SDA
} /testbench_audio_synth_top/DUT/master/sda
add wave -noupdate -height 25 -expand -group {I2C Master} -height 25 -label {SCL
} /testbench_audio_synth_top/DUT/master/scl
add wave -noupdate -height 25 -expand -group {I2C Master} -height 25 -label {WRITE DONE?} -radix symbolic /testbench_audio_synth_top/tb_write_done
add wave -noupdate -divider -height 25 {I2C Slave}
add wave -noupdate -color yellow -label {SDA
} /testbench_audio_synth_top/inst_codec/sda_io
add wave -noupdate -label {SCL
} /testbench_audio_synth_top/inst_codec/scl_io
add wave -noupdate -divider -height 25 Testbench
add wave -noupdate -label {tb_SDA
} /testbench_audio_synth_top/tb_i2c_sdat
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1400 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 199
configure wave -valuecolwidth 158
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
WaveRestoreZoom {0 ns} {23204 ns}
