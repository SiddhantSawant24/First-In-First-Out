onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/wr_clk_i
add wave -noupdate /tb/dut/rd_clk_i
add wave -noupdate /tb/dut/clr_i
add wave -noupdate /tb/dut/wr_en_i
add wave -noupdate /tb/dut/rd_en_i
add wave -noupdate -radix decimal /tb/dut/wr_ptr
add wave -noupdate -radix decimal /tb/dut/wr_ptr_rd_clk_i
add wave -noupdate -radix hexadecimal /tb/dut/wdata_i
add wave -noupdate /tb/dut/full_o
add wave -noupdate /tb/dut/wr_toggle_f
add wave -noupdate /tb/dut/wr_toggle_f_rd_clk_i
add wave -noupdate /tb/dut/wr_error_o
add wave -noupdate -radix decimal /tb/dut/rd_ptr
add wave -noupdate -radix decimal /tb/dut/rd_ptr_wr_clk_i
add wave -noupdate -radix hexadecimal /tb/dut/rdata_o
add wave -noupdate /tb/dut/empty_o
add wave -noupdate /tb/dut/rd_toggle_f
add wave -noupdate /tb/dut/rd_toggle_f_wr_clk_i
add wave -noupdate /tb/dut/rd_error_o
add wave -noupdate /tb/dut/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 184
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {505 ps}
