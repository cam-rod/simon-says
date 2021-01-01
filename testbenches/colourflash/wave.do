# Execute from top-level folder

vlib work
vlog testbenches/colourflash/colourflash_tb.sv
vsim work.colourflash_tb

log {/*}
add wave -label clk sigs.flash_clk
add wave -label reset reset
add wave -unsigned -label check_round sigs.check_round
add wave -label player_input player_input
add wave -label disp_o disp_o

run 260ns