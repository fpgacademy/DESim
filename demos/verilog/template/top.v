// Copyright (c) 2022 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`include "resolution.v" // determine VGA resolution
 
// Protect against undefined nets
`default_nettype none

module top (CLOCK_50, KEY, SW, GPIO, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR,
            PS2_CLK, PS2_DAT, VGA_X, VGA_Y, VGA_COLOR, plot);


    input  wire         CLOCK_50;   // DE-series 50 MHz clock signal
    input  wire [ 3: 0] KEY;        // DE-series pushbuttons
    input  wire [ 9: 0] SW;         // DE-series switches
    inout  wire [31: 0] GPIO;       // DE-series 40-pin header
    output wire [ 6: 0] HEX0;       // DE-series HEX displays
    output wire [ 6: 0] HEX1;
    output wire [ 6: 0] HEX2;
    output wire [ 6: 0] HEX3;
    output wire [ 6: 0] HEX4;
    output wire [ 6: 0] HEX5;
    output wire [ 9: 0] LEDR;       // DE-series LEDs

    inout  wire         PS2_CLK;    // PS/2 Clock
    inout  wire         PS2_DAT;    // PS/2 Data

    output wire [ 9: 0] VGA_X;      // "VGA" column
    output wire [ 8: 0] VGA_Y;      // "VGA" row
    output wire [ 23: 0] VGA_COLOR; // "VGA pixel" colour (0-7)
    output wire         plot;       // "Pixel" is drawn when this is pulsed

    parameter n = `ifdef VGA_640_480 10 `elsif VGA_320_240 9 `else 8 `endif ; // VGA x bitwidth
    template U1 (CLOCK_50, KEY, SW, GPIO, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR,
                 PS2_CLK, PS2_DAT, VGA_X[n-1:0], VGA_Y[n-2:0], VGA_COLOR, plot);
    
endmodule

