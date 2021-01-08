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

`include "fsm_interface.sv"

typedef enum {READY1, RST_SEEDGEN, READY12, START_RNG, HOLD, ADD_CLR, INC_SPEED,
      PULSE_ON, PULSE_OFF, IS_NEXT_PULSE, PREP, PLAYER_TURN, GOOD_TURN, DESELECT,
      FAIL_ON, FAIL_OFF, WIN, END} state;

module fsm (input clk, reset, fsm_sig.fsm sigs, input [1:0] launch_keys, input [3:0] player_input, output [5:0] current_round);
    state current, next;
    logic [1:0] fail_counter;

    always_comb // Next state registers
    case (current)
        READY1:         next <= launch_keys[0] : RST_SEEDGEN ? READY;                   // Continue if KEY1 is pressed
        RST_SEEDGEN:    next <= READY12;
        READY12:        next <= &launch_keys : START_RNG : READY12;                     // Continue when KEY1, KEY2 are both pressed
        START_RNG:      next <= HOLD;
        HOLD:           next <= |launch_keys : HOLD : ADD_CLR;                          // Continue after both keys are released
        ADD_CLR:        next <= (current_round % 5 == 0) ? INC_SPEED : IS_NEXT_PULSE;   // Increase speed every 5 rounds
        INC_SPEED:      next <= IS_NEXT_PULSE;
        IS_NEXT_PULSE:  if(pulse) begin // Wait until pulse is received
                            if(sigs.check_round==6'b0) next <= PREP; // Advance to player turn once all segments are shown
                            else next <= PULSE_ON;
                        end
                        else next <= IS_NEXT_PULSE;
        PULSE_ON:       next <= pulse ? PULSE_OFF : PULSE_ON;
        PULSE_OFF:      next <= IS_NEXT_PULSE;
        PREP:           next <= PLAYER_TURN;
        PLAYER_TURN:    begin                                                           // Check whether to scan player input or start new round
                            if(sigs.check_round==6'b0)
                                if(current_round[5]) next <= WIN; // Finished round 32 
                                else next <= ADD_CLR;
                            else if (|player_input) // Advance when move is played              
                                next <= GOOD_TURN;
                            else
                                next <= PLAYER_TURN;
                        end
        GOOD_TURN:      next <= result ? DESELECT : FAIL_ON;                            // Check if move is valid
        DESELECT:       next <= |player_input ? DESELECT : PLAYER_TURN;                 // Advance after all options are deselected
        FAIL_ON:        next <= FAIL_OFF;
        FAIL_OFF:       next <= &fail_counter ? END : FAIL_ON;                          // Repeat until the incorrect colour is flashed thrice
        WIN:            next <= END;
        END:            next <= END;                                                    // Hold state until reset signal is recieved
        default:        next <= READY1;
    endcase

    always_comb
    begin : fsm_outputs
        // Default states
        start <= '0;
        load_colour <= '0;
        load_speed <= '0;
        rst_seedgen <= '0;
        flash_clk <= '0;
        case(current) // Set signals and registers
            READY1: begin // Reset state
                current_round = '0;
                check_round = '0;
                fail_counter = '0;
                speed = '0;
            end
            RST_SEEDGEN: rst_seedgen <= '1;
            START_RNG: start <= '1;
            ADD_CLR: begin // Add colour and increase round
                current_round = current_round + 1;
                check_round <= current_round;
                load_colour <= '1;
            end
            INC_SPEED: begin
                speed <= speed + 1;
                load_speed <= '1;
            end
            PULSE_ON: flash_clk <= '1; // Flash each colour
            PULSE_OFF: check_round <= check_round - 1;
            PREP: check_round <= current_round; // Reset check to current round
            DESELECT: check_round <= check_round - 1; // Check next item
            FAIL_ON: begin
                if(&fail_counter==1'b0) current_round <= current_round - 1; // Set to final round passed
                fail_counter <= fail_counter + 1; // Increases for each flash
                flash_clk <= '1;
            end
        endcase
    end

    always_ff @(posedge clk) // Current state register
        current <= reset ? READY1 : next;
endmodule