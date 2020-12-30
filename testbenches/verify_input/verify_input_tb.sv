`timescale 10ns/1ns

module verify_input_tb;
    reg [31:0][2:0] segment;
    reg [3:0] player_input;
    reg [4:0] round;
    wire result, empty;

    int i;
    reg [3:0] inputs [10:0];

    verify_input u1(.segment(segment), .player_input(player_input), .check_round(round), .result(result), .empty(empty));
    
    initial
    begin
        $readmemb("testbenches/verify_input/segment_src.txt", inputs);

        for(i=0;i<32;i=i+1)
            segment[i] = inputs[i%5][2:0];
    end

    always
        for(i = 5; i < 11; i=i+1) // Check for outputs on each round
        begin
            player_input = inputs[i];
            round = i-5;

            #1;
        end
endmodule