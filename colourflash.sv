// Flashes colours, based on display, and also shows currently selected option
module colourflash(fsm_sig.led sigs, input reset, input [3:0] player_input, input [31:0][2:0] segment, output [3:0] disp);
	always_ff @(posedge sigs.flash_clk) // Toggle light
        case (segment[sigs.check_round])
            3'b000: disp[0] <= 1'b1;
            3'b001: disp[1] <= 1'b1;
            3'b010: disp[2] <= 1'b1;
            3'b011: disp[3] <= 1'b1;
            default: disp <= disp;
        endcase
	
	always_comb // Display player input, not clearing any flashed info
		if(reset)
			disp <= '0;
		else
			disp <= player_input | disp;
endmodule