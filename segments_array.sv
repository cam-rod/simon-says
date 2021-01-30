/* Testbench for input verification
 * Copyright (C) 2021 Cameron Rodriguez
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

`ifndef _segments_array_sv
`define _segments_array_sv

// Stores up to 32 previous colours, with logic "1" msb for unassigned position
module segments_array(input [1:0] new_colour, input reset, clk, fsm_sig.segments sigs, output [32:0][1:0] segment);	
	logic [30:0][1:0] segs_main;
	logic [1:0] seg_new;

	always_ff @(posedge clk)
	begin
		if(reset) // All segments are unassigned
		begin
			segs_main = '0;
			seg_new = '0;
		end
		else if(sigs.load_colour)
		begin
			segs_main <= (segs_main << 2) | seg_new;
			seg_new <= new_colour;
		end
		else
		begin
			segs_main <= segs_main;
			seg_new <= seg_new;
		end
	end

	assign segment = {segs_main, seg_new, 2'b00}; // First slot is placeholder to avoid overflow issues
endmodule
`endif // _segments_array_sv
