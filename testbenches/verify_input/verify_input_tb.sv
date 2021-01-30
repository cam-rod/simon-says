/* Testbench for input verification
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

`include "../../verify_input.sv"
`include "../../fsm_interface.sv"

module verify_input_tb;
    logic [32:0][1:0] segment;
    logic [3:0] player_input;
    fsm_sig sigs();

    // Text file 
    int i;
    logic [3:0] inputs [10:0];

    verify_input u1(.segment(segment), .player_input(player_input), .sigs);
    
    initial
    begin
        $readmemb("testbenches/verify_input/segment_src.txt", inputs);

        for(i=0;i<33;i=i+1)
            segment[i] = inputs[i%5][1:0];
    end

    always
        for(i = 5; i < 11; i++) // Check for outputs on each round
        begin
            player_input = inputs[i];
            sigs.check_round = i-5;

            #1;
        end
endmodule