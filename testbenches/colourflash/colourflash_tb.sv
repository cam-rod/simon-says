/* Testbench for display module
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

`timescale 10ns/1ns

`include "../../colourflash.sv"
`include "../../fsm_interface.sv"

module colourflash_tb;
    logic reset;
    logic [3:0] player_input, disp_o;
    logic [32:0][1:0] segment;
    fsm_sig sigs();

    // Text file parsers
    int i, j;
    logic [3:0] inputs [10:0];    

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
        for(i=0;i<33;i=i+1)
            segment[i] = inputs[i%5][1:0]; 
        sigs.check_round = '0;
        player_input = '0;

        reset = 1'b1;
        #1.5;
        reset = 1'b0;
    end
    // Flash for a set of given rounds, then pair with player inputs
    always // Independent inputs
    begin
        #2;
        for (i = 0; i<15; i++) // 5 cycles independently, 5 cycles with other inputs
        begin
            sigs.check_round <=sigs.check_round + 1'b1;
            #2;
        end
    end

    always // User inputs
    begin
        #14; // Change partway through cycles
        for(j = 0; j < 5; j++)
        begin
            player_input = inputs[6+j];
            #2;
        end
    end
endmodule
