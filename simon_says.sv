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

// Initial version uses SW and LEDR [3:0]

interface fsm_sig;
	logic start, load_colour, load_speed, rst_seedgen, player_turn, flash_colour; // FSM commands
	logic [4:0] check_round;
	logic [2:0] speed;
	logic result, empty, pulse; // FSM inputs

	modport fsm (input result, empty, pulse, output start, load_colour, load_speed, rst_seedgen, player_turn,
				 flash_colour, check_round, speed);
	modport reg8 (input rst_seedgen);
	modport rand (input start);
	modport segments (input load_colour)
	modport flasher (input load_speed, speed, output pulse);
	modport led (input check_round, flash_colour);
	modport check (input check_round, output result, empty);
endinterface

module simon_says(input [9:0] SW, input [3:0] KEY, input CLOCK_50, output [9:0] LEDR);
	assign reset = ~KEY[0];
	logic [31:0] seed;
	logic [31:0][2:0] segment;
	logic [5:0] current_round;
	logic [1:0] new_colour;

	fsm_sig sigs();

	// Setup each round
	reg8_32 seedgen(.clk(CLOCK_50), .reset, .sigs, .seed);
	rng rand(.clk(CLOCK_50), .reset, .sigs, seed_i(seed), number_o(new_colour));
	segments_array set(.new_colour({1'b0, new_colour}), .reset, .clk(CLOCK_50), .sigs, .segment);

	// Operational modules: timer controlled by parameter (max speed 125ms/colour, 16Hz signals), module to flash colours for user
	variable_timer flasher(.clk(CLOCK_50), .reset, .sigs);
	// Colour flasher goes HERE

	// Gameplay modules
	verify_input check(.segment, .player_input(SW[3:0]), .sigs);
endmodule

// Outputs 32-bit seed based on clock; ex 2->8 would be ABBAABBA
module reg8_32(input clk, reset, fsm_sig.reg8 sigs, output reg [31:0] seed);
	// Increment 8 bit loop counter
	always@(posedge clk)
		if(reset | sigs.rst_seedgen)
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
module segments_array(input [2:0] new_colour, input reset, clk, fsm_sig.segments sigs, output reg [31:0][2:0] segment);
	always@(posedge clk)
	begin
		if(reset) // All segments are unassigned
			for(i=0;i<32;i+1)
			begin
				segment[i][2] <= 1'b1;
				segment[i][1] <= 1'b0;
				segment[i][0] <= 1'b0;
			end
		else if(sigs.load_colour)
		begin
			for(i=0;i<31;i+1)
				segment[i+1] <= segment[i];
			segment[0] <= new_colour;
		end
		else
			segment <= segment;
	end
endmodule

module variable_timer(input clk, reset, fsm_sig.flasher sigs);
	reg [25:0] counter;
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			counter <= 26'd49_999_999;
			sigs.speed <= 3'b00;
		end
		else if(sigs.load_speed | sigs.pulse)
			case (sigs.speed)
				3'b000: counter <= 26'd49_999_999 // 1Hz
				3'b001: counter <= 26'd24_999_999 // 2Hz
				3'b010: counter <= 26'd12_499_999 // 4Hz
				3'b011: counter <= 26'd6_249_999 // 8Hz
				3'b100: counter <= 26'd3_124_999 // 16Hz
				default: counter <= 26'd1;
			endcase
		else
			counter <= counter - 26'b1
	end

	assign sigs.pulse = (counter == 26'b0);
endmodule