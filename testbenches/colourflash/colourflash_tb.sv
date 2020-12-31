/* Testbench for display module
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

`timescale 10ns/1ns

`include "../../colourflash.sv"
`include "../../fsm_interface.sv"

module colourflash_tb;
    logic reset;
    logic [3:0] player_input, disp;
    logic [31:0][2:0] segment;
    fsm_sig sigs();

    // Text file parsers
    int i;
    logic [10:0][3:0] inputs;    

    colourflash dut(.*);

    always // Clock
    begin
        sigs.flash_clk = 1'b0;
        #1;
        sigs.flash_clk = 1'b1;
        #1;
    end

    initial // Load segments and reset all inputs
    begin
        $readmemb("testbenches/colourflash/inputs.txt", inputs);
        for(i=0;i<32;i=i+1)
            segment[i] = inputs[i%5][2:0]; 
        sigs.check_round = '0;

        reset = 1'b1;
        #1.5;
        reset = 1'b0;
    end
    // Reset, flash for a set of given rounds, then pair with player inputs
endmodule
