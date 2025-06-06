// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module top (CLOCK_50, KEY, SW, LEDR);
    input wire CLOCK_50;            // DE-series 50 MHz clock signal
    input wire [3:0] KEY;           // DE-series pushbuttons
    input wire [9:0] SW;            // DE-series slide switches
    output wire [9:0] LEDR;         // DE-series LEDs

    counter U1 (CLOCK_50, KEY[0], SW[0], LEDR);
endmodule

