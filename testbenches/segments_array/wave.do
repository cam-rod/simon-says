vlib work
vlog testbenches/segments_array/segments_array_tb.sv
vsim work.segments_array_tb

log {/*}
add wave -label clk clk
add wave -label reset reset
add wave -label load_colour sigs.load_colour
add wave -label segs {segment[7:0]}
add wave -label segs_main {segments_array_tb/dut/segs_main[5:0]}
add wave -label seg_new segments_array_tb/dut/seg_new

run 190ns