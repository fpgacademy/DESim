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
    input logic CLOCK_50;
    input logic [1:0] KEY;
    input logic [9:0] SW;
    output logic [6:0] HEX0;
    output logic [6:0] HEX1;
    output logic [6:0] HEX2;
    output logic [6:0] HEX3;
    output logic [6:0] HEX4;
    output logic [6:0] HEX5;
    output logic [9:0] LEDR;

    logic [2:0] addr;               // used to select a HEX display

	assign LEDR = SW;

    always_ff @ (posedge CLOCK_50)
        if (KEY[0] == 0)            // sync reset
            addr <= 3'b0;
        else if (KEY[1] == 0)       // select a HEX display
            addr <= SW[9:7];

    always_comb
        case (addr)
            3'b000:  HEX0 <= SW[6:0];
            3'b001:  HEX1 <= SW[6:0];
            3'b010:  HEX2 <= SW[6:0];
            3'b011:  HEX3 <= SW[6:0];
            3'b100:  HEX4 <= SW[6:0];
            3'b101:  HEX5 <= SW[6:0];
            default: ;
        endcase

endmodule
