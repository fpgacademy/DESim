// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (CLOCK_50, KEY, SW, LEDR);
    input  wire         CLOCK_50;   // DE-series 50 MHz clock signal
    input  wire [ 3: 0] KEY;        // DE-series pushbuttons
    input  wire [ 9: 0] SW;         // DE-series switches
    output wire [ 9: 0] LEDR;       // DE-series LEDs

    Addern U1 (SW[9], SW[3:0], SW[7:4], LEDR[3:0], LEDR[4]);

endmodule

