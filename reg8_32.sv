/* Seed generation module
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

// Outputs 32-bit seed based on clock; ex 2->8 would be ABBAABBA
module reg8_32(input clk, reset, fsm_sig.reg8 sigs, output logic [31:0] seed);
	logic [7:0] seed_basis;
    // Increment 8 bit loop counter
	always_ff @(posedge clk)
		if(reset | sigs.rst_seedgen)
			seed_basis <= '0;
		else
			seed_basis[7:0] <= (&seed_basis[7:0]) ? 8'b0 : seed_basis[7:0] + 8'b1;

	// Contstruct remainder of 32-bits
	assign seed = {{<<{seed_basis[7:0]}},{>>{seed_basis[7:0]}},{<<{seed_basis[7:0]}},{>>{seed_basis[7:0]}}};
endmodule