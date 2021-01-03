/* Module flashes colours and displays user input
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

// Flashes colours, based on display, and also shows currently selected option
module colourflash(fsm_sig.led sigs, input reset, input [3:0] player_input, input [32:0][1:0] segment, output logic [3:0] disp_o);
	logic [3:0] disp_ff; // Used for procedural logic
    always_ff @(posedge sigs.flash_clk) // Toggle light
        case (segment[sigs.check_round])
            2'b00: disp_ff <= 4'b0001;
            2'b01: disp_ff <= 4'b0010;
            2'b10: disp_ff <= 4'b0100;
            2'b11: disp_ff <= 4'b1000;
            default: disp_ff <= '0;
        endcase
	
	always_comb // Display player input, not clearing any flashed info
		if(reset)
			disp_o <= '0;
		else
			disp_o <= player_input | disp_ff;
endmodule