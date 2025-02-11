`include "resolution.v" // determine VGA resolution

module top (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, VGA_X, VGA_Y, VGA_COLOR, plot);

    input CLOCK_50;             // DE-series 50 MHz clock signal
    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [6:0] HEX0;     // DE-series HEX displays
    output wire [6:0] HEX1;
    output wire [6:0] HEX2;
    output wire [6:0] HEX3;
    output wire [6:0] HEX4;
    output wire [6:0] HEX5;

    output wire [9:0] LEDR;     // DE-series LEDs   
    output wire [9:0] VGA_X;
    output wire [8:0] VGA_Y;
    output wire [2:0] VGA_COLOR;
    output wire plot;

    parameter n = `ifdef VGA_640_480 10 `elsif VGA_320_240 9 `else 8 `endif ; // VGA x bitwidth
    vga_demo U1 (CLOCK_50, KEY, VGA_X[n-1:0], VGA_Y[n-2:0], VGA_COLOR, plot);

endmodule

