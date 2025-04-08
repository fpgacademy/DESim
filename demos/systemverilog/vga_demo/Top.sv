`include "resolution.sv" // determine VGA resolution

module top (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, VGA_X, VGA_Y, VGA_COLOR, plot);

    input CLOCK_50;             // DE-series 50 MHz clock signal
    input logic [9:0] SW;        // DE-series switches
    input logic [3:0] KEY;       // DE-series pushbuttons

    output logic [6:0] HEX0;     // DE-series HEX displays
    output logic [6:0] HEX1;
    output logic [6:0] HEX2;
    output logic [6:0] HEX3;
    output logic [6:0] HEX4;
    output logic [6:0] HEX5;

    output logic [9:0] LEDR;     // DE-series LEDs   
    output logic [9:0] VGA_X;
    output logic [8:0] VGA_Y;
    output logic [23:0] VGA_COLOR;
    output logic plot;

    parameter n = `ifdef VGA_640_480 10 `elsif VGA_320_240 9 `else 8 `endif ; // VGA x bitwidth
    vga_demo U1 (CLOCK_50, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, VGA_X[n-1:0], VGA_Y[n-2:0], VGA_COLOR, plot);


endmodule

