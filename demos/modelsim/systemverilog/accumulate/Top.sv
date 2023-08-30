// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (CLOCK_50, KEY, SW, LEDR);
    input  logic         CLOCK_50;   // DE-series 50 MHz clock signal
    input  logic [ 3: 0] KEY;        // DE-series pushbuttons
    input  logic [ 9: 0] SW;         // DE-series switches
    output logic [ 9: 0] LEDR;       // DE-series LEDs

    Accumulate U1 (CLOCK_50, KEY[0], SW, LEDR);

endmodule

