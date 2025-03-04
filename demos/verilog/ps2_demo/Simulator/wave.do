onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLOCK_50 -radix binary /testbench/CLOCK_50
add wave -noupdate -label KEY -radix binary -expand /testbench/KEY
add wave -noupdate -label ps2_clk -radix binary /testbench/ps2_clk
add wave -noupdate -label ps2_dat -radix binary /testbench/ps2_dat
add wave -noupdate -divider PS2_keyboard
add wave -noupdate -label CLOCK_50 -radix binary /testbench/U1/Clock
add wave -noupdate -label Reset -radix binary /testbench/U1/Resetn
add wave -noupdate -label key_action -radix binary /testbench/U1/key_action
add wave -noupdate -label scan_code -radix hexadecimal /testbench/U1/scan_code
add wave -noupdate -label FIFO_depth -radix hexadecimal /testbench/U1/FIFO_depth
add wave -noupdate -label FSM -radix hexadecimal /testbench/U1/y_Q
add wave -noupdate -label data_ready -radix hexadecimal /testbench/U1/data_out/data_ready
add wave -noupdate -label clk_ready -radix hexadecimal /testbench/U1/data_out/clk_ready
add wave -noupdate -label start_sending -radix hexadecimal /testbench/U1/data_out/start_sending
add wave -noupdate -label data -radix hexadecimal /testbench/U1/data_out/data
add wave -noupdate -label ps2_buf -radix hexadecimal /testbench/U1/data_out/ps2_buf
add wave -noupdate -label counter -radix hexadecimal /testbench/U1/data_out/counter
add wave -noupdate -label clk_div -radix hexadecimal /testbench/U1/data_out/clk_div
add wave -noupdate -label data_sent -radix hexadecimal /testbench/U1/data_out/data_sent
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 80
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {500 ns}
