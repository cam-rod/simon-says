/* Testbench for segment loader module
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

`timescale 10ns/1ns

`include "../../segments_array.sv"
`include "../../fsm_interface.sv"

module segments_array_tb;
    logic reset, clk;
    logic [1:0] new_colour;
    logic [32:0][1:0] segment;
    fsm_sig sigs();

    logic [1:0] inputs [10:0];
    int i, j;

    segments_array dut(.*);

    initial // Start clock, load signals
    begin
        $readmemb("testbenches/segments_array/inputs.txt", inputs);
        for(i = 0; i<33;i++);
            segment[i] = inputs[i%4];
        
        new_colour = '0;
        sigs.load_colour = '0;
        
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    always
    begin
        reset = 1'b1;
        #2;
        reset = ~reset;
        
        sigs.load_colour = 1'b1;
        for(j = 5; j<8;j++) // Load 3 signals
        begin
            new_colour = inputs[j];
            #2;
        end

        new_colour = inputs[8];
        sigs.load_colour = 1'b0;
        #2; // Verify colour is not load_speed

        sigs.load_colour = 1'b1;
        for(int j = 8; j<10;j++) // Load next 2 signals
        begin
            new_colour = inputs[j];
            #2;
        end

        reset = ~reset; // Clear all segments
        #2;
        reset = ~reset;

        new_colour = inputs[10];
        #2; // Load last segment
    end
endmodule