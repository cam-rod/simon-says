/* Module to verify inputs
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

`include "fsm_interface.sv"

`ifndef _verify_input_sv
`define _verify_input_sv

// Confirms whether the segment selected is accurate, or informs if current segment is empty
module verify_input(input [32:0][1:0] segment, input [3:0] player_input, fsm_sig.check sigs);
	logic [1:0] play;
	logic invalid;

	always@* // Encoding play
	begin
		invalid <= 1'b0;
		case (player_input)
			4'b1000: play <= 'b11;
			4'b0100: play <= 'b10;
			4'b0010: play <= 'b01;
			4'b0001: play <= 'b00;
			default: begin
				play <= 'b00;
				invalid <= 1'b1;
			end
		endcase
	end
	assign sigs.result = invalid ? 1'b0 : (segment[sigs.check_round] == play);
endmodule
`endif // _verify_input_sv
