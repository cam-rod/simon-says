// Confirms whether the segment selected is accurate, or informs if current segment is empty
module verify_input(input [2:0] segment [31:0], input [3:0] player_input, input [4:0] check_round, output result, empty);
	reg [2:0] play;

	always@* // Encoding play
		case (player_input)
			4'b1000: play <= 3'b011;
			4'b0100: play <= 3'b010;
			4'b0010: play <= 3'b001;
			4'b0001: play <= 3'b000;
			default: play <= 3'b100;
		endcase

	assign empty = segment[check_round][2];
	assign result = segment[check_round] == play;
endmodule
