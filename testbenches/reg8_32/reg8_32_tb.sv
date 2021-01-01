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

`timescale 10ns/1ns

`include "fsm_interface.sv"
`include "../../reg8_32.sv"

module reg8_32_tb;
    logic clk, reset;
    fsm_sig sigs();
    logic [31:0] seed;

    reg8_32 dut (.*);
    initial
    begin
        reset = '1;
        clk = '0;
        sigs.rst_seedgen = '0;
        #1.5;
        reset = '0;
    end

    always // Clock cycles
        forever
        begin
            #1;
            clk = ~clk;
        end

    always // Reset seed
    begin
        #22; 
        sigs.rst_seedgen = '1;
        #1.5;
        sigs.rst_seedgen = '0;
    end

    always // Test seed rollover
    begin
        #26;
        dut.seed_basis = '1;
    end

endmodule