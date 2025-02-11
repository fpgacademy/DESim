// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module top (CLOCK_50, KEY, SW, HEX0, HEX1, LEDR, 
        PS2_CLK, PS2_DAT);
    input  wire         CLOCK_50;   // DE-series 50 MHz clock signal
    input  wire [ 3: 0] KEY;        // DE-series pushbuttons
    input  wire [ 9: 0] SW;         // DE-series switches
    output wire [ 6: 0] HEX0;       // DE-series HEX displays
    output wire [ 6: 0] HEX1;
    output wire [ 9: 0] LEDR;       // DE-series LEDs

    inout  wire         PS2_CLK;    // PS/2 Clock
    inout  wire         PS2_DAT;    // PS/2 Data

    assign LEDR = SW;

    PS2_Comm comm(CLOCK_50, KEY[1:0], SW, PS2_CLK, PS2_DAT, HEX0, HEX1);

endmodule

