vlib work
vlog testbenches/segments_array/segments_array_tb.sv
vsim work.segments_array_tb

log {/*}
add wave -label clk clk
add wave -label reset reset
add wave -label load_colour sigs.load_colour
add wave -label segs {segment[7:0]}

run 190ns