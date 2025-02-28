// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module top (SW, LEDR);
    input  wire [9:0] SW;         // DE-series switches
    output wire [4:0] LEDR;       // DE-series LEDs

    adder U1 (SW[9], SW[3:0], SW[7:4], LEDR[3:0], LEDR[4]);

endmodule

