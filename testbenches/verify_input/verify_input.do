vlib work
vlog verify_input.sv
vlog testbenches/verify_input/verify_input_tb.sv
vsim work.verify_input_tb

log {/*}
add wave player_input
add wave round
add wave result
add wave empty

run 80ns