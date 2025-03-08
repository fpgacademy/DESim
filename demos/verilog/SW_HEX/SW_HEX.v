// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// Uses SW to set HEX display patterns
//     SW are displayed on LEDR
//     KEY[0] is the synchronous reset. It sets the HEX-display selector to 0.
//     KEY[1] provides the active-low enable for the HEX-display selector
//     SW[9:7] selects a HEX display (from 0 to 5) 
module SW_HEX (CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

    input wire CLOCK_50;        // DE-series 50 MHz clock signal
    input wire [9:0] SW;        // DE-series switches
    input wire [1:0] KEY;       // DE-series pushbuttons

    output reg [6:0] HEX0;      // DE-series HEX displays
    output reg [6:0] HEX1;
    output reg [6:0] HEX2;
    output reg [6:0] HEX3;
    output reg [6:0] HEX4;
    output reg [6:0] HEX5;

    output wire [9:0] LEDR;     // DE-series LEDs   

    assign LEDR = SW;

    reg [2:0] Addr;             // used to select a HEX display

    always @ (posedge CLOCK_50 or negedge KEY[0])
        if (KEY[0] == 0)
            Addr <= 3'b0;
        else if (KEY[1] == 0)
            Addr <= SW[9:7];

    always @ *
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
