/* Main module of Simon Says program
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

module simon_says(input [9:0] SW, input [3:0] KEY  output [9:0] LEDR);
	assign LEDR[5] = SW[5];
	assign reset = ~KEY[0];
endmodule

// Outputs 32-bit seed based on clock; ex 2->8 would be ABBAABBA
module reg8_32(input clk, reset, output reg [31:0] seed);
	// Increment 8 bit loop counter
	always@(posedge clk)
		if(!reset)
			seed <= 32'b0;
		else
			seed[7:0] <= (&seed[7:0]) ? 8'b0 : seed[7:0] + 8'b1;

	// Contstruct remainder of 32-bits
	always@*
		seed[23:16] <= seed[7:0];
		for (i = 0; i<8; i++) begin
			seed[8+i] <= seed[7-i];
			seed[24+i] <= seed[7-i];
		end
endmodule

// Stores up to 32 previous colours, with logic "1" msb for unassigned position
module segments_array(input [2:0] new_colour, input reset, clk, load_colour, output reg [2:0] segment [31:0]);
	always@(posedge clk)
	begin
		if(reset) // All segments are unassigned
			for(i=0;i<32;i+1)
			begin
				segment[i][2] <= 1'b1;
				segment[i][1] <= 1'b0;
				segment[i][0] <= 1'b0;
			end
		else if(load_colour)
		begin
			for(i=0;i<31;i+1)
				segment[i+1] <= segment[i];
			segment[0] <= new_colour;
		end
		else
			segment <= segment;
	end
endmodule
