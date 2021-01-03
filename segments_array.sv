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

 // Stores up to 32 previous colours, with logic "1" msb for unassigned position
module segments_array(input [1:0] new_colour, input reset, clk, fsm_sig.segments sigs, output reg [32:0][1:0] segment);	
	always_ff @(posedge clk)
	begin
		if(reset) // All segments are unassigned
			for(int i=0;i<33;i++)
				segment[i] <='b00;
		else if(sigs.load_colour)
		begin
			segment <= segment << 2;
			segment[1] <= new_colour; // First slot is placeholder to avoid overflow issues
		end
		else
			segment <= segment;
	end
endmodule