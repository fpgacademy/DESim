// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module top (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, PS2_CLK, PS2_DAT);
    input wire CLOCK_50;        // DE-series 50 MHz clock signal
    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [6:0] HEX0;     // DE-series HEX displays
    output wire [6:0] HEX1;
    output wire [6:0] HEX2;
    output wire [6:0] HEX3;
    output wire [6:0] HEX4;
    output wire [6:0] HEX5;

    output wire [9:0] LEDR;     // DE-series LEDs 

    inout  wire PS2_CLK;        // DE-series PS/2 Clock
    inout  wire PS2_DAT;        // DE-series PS/2 Data

    ps2_demo U1 (CLOCK_50, KEY[0], PS2_CLK, PS2_DAT, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

endmodule

