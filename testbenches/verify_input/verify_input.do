# Execute from top-level folder

vlib work
vlog testbenches/verify_input/verify_input_tb.sv
vsim work.verify_input_tb

log {/*}
add wave player_input
add wave sigs.check_round
add wave sigs.result
add wave sigs.empty

run 80ns