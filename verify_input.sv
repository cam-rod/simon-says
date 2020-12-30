/* Module to verify inputs
 * Copyright (C) 2020 Cameron Rodriguez
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

`include "fsm_interface.sv"

// Confirms whether the segment selected is accurate, or informs if current segment is empty
module verify_input(input [31:0][2:0] segment, input [3:0] player_input, fsm_sig.check sigs);
	logic [2:0] play;

	always@* // Encoding play
		case (player_input)
			4'b1000: play <= 3'b011;
			4'b0100: play <= 3'b010;
			4'b0010: play <= 3'b001;
			4'b0001: play <= 3'b000;
			default: play <= 3'b100;
		endcase

	assign sigs.empty = segment[sigs.check_round][2];
	assign sigs.result = segment[sigs.check_round] == play;
endmodule
