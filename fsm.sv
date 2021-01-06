/* Finite state machine
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

typedef enum {READY1, RST_SEEDGEN, READY12, START_RNG, HOLD, ADD_CLR, INC_SPEED,
      PULSE_ON, PULSE_OFF, IS_NEXT_PULSE, PLAYER_TURN, GOOD_TURN, DESELECT,
      FAIL_ON, FAIL_OFF, WIN, END} state;

module fsm (input clk, reset, fsm_sig.fsm sigs, input [1:0] launch_keys, input [3:0] player_input, output [5:0] current_round);
    state current, next;
    logic [1:0] fail_counter;

    always_comb // Next state registers
    case (current)
        READY1:         next <= launch_keys[1] : RST_SEEDGEN ? READY;               // Continue if KEY1 is pressed
        RST_SEEDGEN:    next <= READY12;
        READY12:        next <= &launch_keys : START_RNG : READY12;                 // Continue when KEY1, KEY2 are both pressed
        START_RNG:      next <= HOLD;
        HOLD:           next <= |launch_keys : HOLD : ADD_CLR;                      // Continue after both keys are released
        ADD_CLR:        next <= (current_round % 5 == 0) ? INC_SPEED : PULSE_ON;    // Increase speed every 5 rounds
        INC_SPEED:      next <= PULSE_ON;
        PULSE_ON:       next <= PULSE_OFF;
        IS_NEXT_PULSE:  if(pulse) begin // Wait until pulse is received
                            if(sigs.check_round==0) next <= PLAYER_TURN; // Advance to player turn once all segments are shown
                            else next <= PULSE_ON;
                        end
                        else next <= IS_NEXT_PULSE;
        PLAYER_TURN:    begin                                                       // Check whether to scan player input or start new round
                            if(sigs.check_round==0)
                                if(current_round[5]) next <= WIN; // Finished round 32 
                                else next <= ADD_CLR;
                            else if (|player_input) // Advance when move is played              
                                next <= GOOD_TURN;
                            else
                                next <= PLAYER_TURN;
                        end
        GOOD_TURN:      next <= result ? DESELECT : FAIL_ON;                        // Check if move is valid
        DESELECT:       next <= |player_input ? DESELECT : PLAYER_TURN;             // Advance after all options are deselected
        FAIL_ON:        next <= FAIL_OFF;
        FAIL_OFF:       next <= &fail_counter ? END : FAIL_ON;                      // Repeat until the incorrect colour is flashed thrice
        WIN:            next <= END;
        END:            next <= END;                                                // Hold state until reset signal is recieved
        default:        next <= READY1;
    endcase
endmodule