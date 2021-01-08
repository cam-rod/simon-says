vlib work
vlog testbenches/fsm/fsm_tb.sv
vsim work.fsm_tb

# Input signals, rounds, and states
log {/*}
add wave -label clk clk
add wave -label reset reset
add wave -label pulse sigs.pulse
add wave -label result sigs.result
add wave -label KEYS launch_keys
add wave -label SWITCHES player_input
add wave -label current_round current_round
add wave -label check_round sigs.check_round
add wave -label current_state dut.current
add wave -label next_state dut.next

# Output signals
add wave -label rst_seedgen sigs.rst_seedgen
add wave -label load_seed sigs.start
add wave -label load_colour sigs.load_colour
add wave -label flash_clk sigs.flash_clk
add wave -label load_speed sigs.load_speed
add wave -label speed sigs.speed
add wave -label fail_counter dut.fail_counter

run 760ns