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

typedef enum {READY, KEY1, RST_SEED, KEY12, START_RNG, HOLD, ADD_CLR, INC_SPEED,
      PULSE_ON, PULSE_OFF, IS_NEXT_PULSE, PLAYER_TURN, GOOD_TURN, DESELECT,
      FAIL_ON, FAIL_OFF, WIN, END} state;

module fsm (input clk, reset, input [5:0] current_round, fsm_sig.fsm sigs);
    
endmodule