/* Module flashes colours and displays user input
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

// Flashes colours, based on display, and also shows currently selected option
module colourflash(fsm_sig.led sigs, input reset, input [3:0] player_input, input [31:0][2:0] segment, output [3:0] disp);
	always_ff @(posedge sigs.flash_clk) // Toggle light
        case (segment[sigs.check_round])
            3'b000: disp[0] <= 1'b1;
            3'b001: disp[1] <= 1'b1;
            3'b010: disp[2] <= 1'b1;
            3'b011: disp[3] <= 1'b1;
            default: disp <= disp;
        endcase
	
	always_comb // Display player input, not clearing any flashed info
		if(reset)
			disp <= '0;
		else
			disp <= player_input | disp;
endmodule