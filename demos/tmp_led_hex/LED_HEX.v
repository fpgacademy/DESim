// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim
// 
// Uses SW to set HEX display patterns
//     SW are displayed on LEDR
//     KEY[0] is the synchronous reset. It sets the HEX-display selector to 0.
//     KEY[1] provides the active-low enable for the HEX-display selector
//     SW[9:7] selects a HEX display (from 0 to 5) 
module LED_HEX (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input wire CLOCK_50;
	input wire [9:0] SW;
	input wire [1:0] KEY;
    output wire [9:0] LEDR;         // DE-series LEDs   

    output reg [6:0] HEX0;          // DE-series HEX displays
    output reg [6:0] HEX1;
    output reg [6:0] HEX2;
    output reg [6:0] HEX3;
    output reg [6:0] HEX4;
    output reg [6:0] HEX5;

    assign LEDR = SW;

    reg [2:0] Addr;                 // used to select a HEX display

    always @ (posedge CLOCK_50)
        if (KEY[0] == 0)            // sync reset
            Addr <= 3'b0;
        else if (KEY[1] == 0)       // select a HEX display
            Addr <= SW[9:7];

    always @ (posedge CLOCK_50)
        case (Addr)
            3'b000:  HEX0 <= SW[6:0];
            3'b001:  HEX1 <= SW[6:0];
            3'b010:  HEX2 <= SW[6:0];
            3'b011:  HEX3 <= SW[6:0];
            3'b100:  HEX4 <= SW[6:0];
            3'b101:  HEX5 <= SW[6:0];
            default: ;
        endcase

endmodule
