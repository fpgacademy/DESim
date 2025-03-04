`include "resolution.v" // determine VGA resolution

module top (CLOCK_50, KEY, VGA_X, VGA_Y, VGA_COLOR, plot);

    input CLOCK_50;             // DE-series 50 MHz clock signal
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [9:0] VGA_X;
    output wire [8:0] VGA_Y;
    output wire [2:0] VGA_COLOR;
    output wire plot;

    parameter n = `ifdef VGA_640_480 10 `elsif VGA_320_240 9 `else 8 `endif ; // VGA x bitwidth
    vga_demo U1 (CLOCK_50, KEY, VGA_X[n-1:0], VGA_Y[n-2:0], VGA_COLOR, plot);

endmodule

