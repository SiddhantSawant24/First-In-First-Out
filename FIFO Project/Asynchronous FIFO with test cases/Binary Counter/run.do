vlib work
vlog tb.v
vsim tb +testcase=write_read
#add wave -position insertpoint sim:/tb/dut/*
do wave.do
run -all

