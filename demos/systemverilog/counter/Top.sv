// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module top (CLOCK_50, KEY, LEDR);
    input logic CLOCK_50;       // DE-series 50 MHz clock signal
    input logic [3:0] KEY;      // DE-series pushbuttons
    output logic [9:0] LEDR;    // DE-series LEDs

    counter U1 (CLOCK_50, KEY[0], LEDR);

endmodule

