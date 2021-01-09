/* Interface for FSM signals
 * Copyright (C) 2020, 2021 Cameron Rodriguez
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>. */


`ifndef _fsm_interface_sv
`define _fsm_interface_sv

interface fsm_sig;
	logic start, load_colour, load_speed, rst_seedgen, flash_clk; // FSM commands
	logic [5:0] check_round;
	logic [2:0] speed;
	logic result, pulse; // FSM inputs

	modport fsm (input result, pulse, output start, load_colour, load_speed, rst_seedgen,
				 flash_clk, check_round, speed);
	modport reg8 (input rst_seedgen);
	modport rng_in (input start);
	modport segments (input load_colour);
	modport flash_timer (input load_speed, speed, output pulse);
	modport led (input check_round, flash_clk);
	modport check (input check_round, output result);
endinterface
`endif // _fsm_interface_sv
