# Execute from top-level folder

vlib work
vlog testbenches/reg8_32/reg8_32_tb.sv
vsim work.reg8_32_tb

log {/*}
add wave -label clk clk
add wave -label reset reset
add wave -label rst_seedgen sigs.rst_seedgen
add wave -hex -label seed seed

run 300ns