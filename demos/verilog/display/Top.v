// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module top (KEY, SW, HEX0, LEDR);
    input wire [3:0] KEY;         // DE-series pushbuttons
    input wire [9:0] SW;          // DE-series switches
    output wire [6:0] HEX0;       // DE-series HEX0 display
    output wire [9:0] LEDR;       // DE-series LEDs

    display U1 (KEY[0], SW[0], HEX0, LEDR);

endmodule

