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

`ifndef _fsm_sv
`define _fsm_sv 


module fsm (input clk, reset, fsm_sig.fsm sigs, input [1:0] launch_keys, input [3:0] player_input, output [5:0] current_round);
    typedef enum {READY1, RST_SEEDGEN, READY12, START_RNG, HOLD, ADD_CLR, INC_SPEED,
        PULSE_ON, PULSE_OFF, IS_NEXT_PULSE, PREP, PLAYER_TURN, GOOD_TURN, NEXT_SEG, DESELECT,
        FAIL_ON, FAIL_ON_WAIT, FAIL_OFF, FAIL_OFF_WAIT, WIN, END} state;
    
    state current, next;
    logic [1:0] fail_counter;
    logic [5:0] current_round_ff;

    always_comb // Next state registers
    case (current)
        READY1:         next <= launch_keys[0] ? RST_SEEDGEN : READY1;                   // Continue if KEY1 is pressed
        RST_SEEDGEN:    next <= READY12;
        READY12:        next <= &launch_keys ? START_RNG : READY12;                     // Continue when KEY1, KEY2 are both pressed
        START_RNG:      next <= HOLD;
        HOLD:           next <= |launch_keys ? HOLD : ADD_CLR;                          // Continue after both keys are released
        ADD_CLR:        next <= ((current_round % 5 == 0) && (current_round != 0)) ? INC_SPEED : IS_NEXT_PULSE;   // Increase speed every 5 rounds
        INC_SPEED:      next <= IS_NEXT_PULSE;
        IS_NEXT_PULSE:  if(sigs.pulse) begin // Wait until pulse is received
                            if(sigs.check_round==6'b0) next <= PREP; // Advance to player turn once all segments are shown
                            else next <= PULSE_ON;
                        end
                        else next <= IS_NEXT_PULSE;
        PULSE_ON:       next <= sigs.pulse ? PULSE_OFF : PULSE_ON;
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
        GOOD_TURN:      next <= sigs.result ? NEXT_SEG : FAIL_ON; // Check if move is valid
        NEXT_SEG:       next <= DESELECT;
        DESELECT:       next <= |player_input ? DESELECT : PLAYER_TURN;                 // Advance after all options are deselected
        FAIL_ON:        next <= FAIL_ON_WAIT;
        FAIL_ON_WAIT:   next <= sigs.pulse ? FAIL_OFF : FAIL_ON_WAIT;
        FAIL_OFF:       next <= &fail_counter ? END : FAIL_OFF_WAIT;                    // Repeat until the incorrect colour is flashed thrice
        FAIL_OFF_WAIT:  next <= sigs.pulse ? FAIL_ON : FAIL_OFF_WAIT;
        WIN:            next <= END;
        END:            next <= END;                                                    // Hold state until reset signal is recieved
        default:        next <= READY1;
    endcase

    always_comb
    begin : fsm_outputs
        // Default states
        sigs.start <= '0;
        sigs.load_colour <= '0;
        sigs.load_speed <= '0;
        sigs.rst_seedgen <= '0;
        sigs.flash_clk <= '0;
        case(current) // Set signals and registers
            READY1: begin // Reset state
                sigs.speed <= '0;
            end
            RST_SEEDGEN: sigs.rst_seedgen <= '1;
            START_RNG: sigs.start <= '1;
            ADD_CLR: sigs.load_colour <= '1;
            INC_SPEED: begin
                sigs.speed <= sigs.speed + 1;
                sigs.load_speed <= '1;
            end
            PULSE_ON: sigs.flash_clk <= '1; // Flash each colour
            FAIL_ON: sigs.flash_clk <= '1;
            FAIL_ON_WAIT: sigs.flash_clk <= '1;
        endcase
    end

    always_ff @(posedge clk) // Round and fail counters, with blocking assignments
    case(current)
        READY1: begin
            fail_counter <= '0;
            current_round_ff = '0;
            sigs.check_round = '0;
        end
        ADD_CLR: begin
            current_round_ff = current_round_ff + 1;
            sigs.check_round = current_round_ff; 
        end
        PULSE_OFF: sigs.check_round = sigs.check_round - 1;
        PREP: sigs.check_round = current_round_ff; // Reset check to current round
        NEXT_SEG: sigs.check_round = (sigs.check_round == 6'b0) ? 6'b0 : sigs.check_round - 1; // Check next item
        FAIL_ON: begin
            if(&fail_counter==1'b0) current_round_ff = current_round_ff - 1; // Set to final round passed
            fail_counter = fail_counter + 1; // Increases for each flash
        end
    endcase
    assign current_round = current_round_ff;

    always_ff @(posedge clk) // Current state register
        current <= reset ? READY1 : next;
endmodule
`endif // _fsm_sv
