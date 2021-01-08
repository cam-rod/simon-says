/* Finite state machine
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
`include "../../fsm.sv"
`include "../../fsm_interface.sv"

module fsm_tb;
    logic clk, reset, result, pulse;
    logic [1:0] launch_keys; // KEY1 and KEY2
    logic [3:0] player_input; // Switches
    logic [5:0] current_round;
    fsm_sig sigs();

    fsm dut (.*);

    initial // Set signals, start clock
    begin
        launch_keys = '0;
        player_input = '0;
        result = '0;
        pulse = '0;

        clk = '0
        forever #1 clk = ~clk;
    end

    always // Example game, shortened
    begin
        reset = '1; // Reset all signals
        #2;
        reset = ~reset;

        // Game start sequence, current state READY1
        launch_keys[0] = 1'b1;
        #4;
        launch_keys = '0; // Ensure holds state properly
        #2;
        launch_keys = '1;
        #4;
        launch_keys = '0;
        #4; // Don't request speed increase

        // Current state IS_NEXT_PULSE
        #2; // Check state holding
        pulse = '1;
        #2;
        pulse = '0;

        // Current state PULSE_ON, wait for next pulse
        #4;
        pulse = '1;
        #4;
        pulse = '0;

        // Current state IS_NEXT_PULSE, move to stete PLAYER_TURN
        pulse = '1;
        #4;
        pulse = '0;

        // Process a valid player turn
        player_input = 4'b0100;
        result = '1;
        #6; // Ensure hold in state DESELECT
        player_input = '0;
        #2;

        // Current state PLAYER_TURN, end game as win
        force dut.current_round = '1;
        release dut.current_round;
        #4; // End of basic game
    end

    always // Edge cases
    begin
        
    end
endmodule
