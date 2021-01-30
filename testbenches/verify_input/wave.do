# Execute from top-level folder

vlib work
vlog testbenches/verify_input/verify_input_tb.sv
vsim work.verify_input_tb

log {/*}
add wave -label player_input player_input
add wave -label check_round sigs.check_round
add wave -label result sigs.result

run 80ns