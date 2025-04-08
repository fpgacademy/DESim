// Copyright (c) 2022 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`include "resolution.sv" // determine VGA resolution
 
// Protect against undefined nets
`default_nettype none

module template (CLOCK_50, KEY, SW, GPIO, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR,
                 PS2_CLK, PS2_DAT, VGA_X, VGA_Y, VGA_COLOR, plot);

    parameter n = `ifdef VGA_640_480 10 `elsif VGA_320_240 9 `else 8 `endif ; // VGA x bitwidth
    
    input  logic         CLOCK_50;   // DE-series 50 MHz clock signal
    input  logic [ 3: 0] KEY;        // DE-series pushbuttons
    input  logic [ 9: 0] SW;         // DE-series switches
    inout  wire [31: 0] GPIO;        // DE-series 40-pin header
    output logic [ 6: 0] HEX0;       // DE-series HEX displays
    output logic [ 6: 0] HEX1;
    output logic [ 6: 0] HEX2;
    output logic [ 6: 0] HEX3;
    output logic [ 6: 0] HEX4;
    output logic [ 6: 0] HEX5;
    output logic [ 9: 0] LEDR;       // DE-series LEDs

    inout  wire          PS2_CLK;    // PS/2 Clock
    inout  wire          PS2_DAT;    // PS/2 Data

    output logic [ n-1: 0] VGA_X;    // "VGA" column
    output logic [ n-2: 0] VGA_Y;    // "VGA" row
    output logic [ 23: 0] VGA_COLOR; // "VGA pixel"
    output logic         plot;       // "Pixel" is drawn when this is pulsed

    logic [7:0] address;
    logic [3:0] x, y;
    assign GPIO      = 32'hZZZZZZZZ;

    assign HEX0      = 7'h40;
    assign HEX1      = 7'h47;
    assign HEX2      = 7'h47;
    assign HEX3      = 7'h06;
    assign HEX4      = 7'h09;
    assign HEX5      = 7'h7F;

    assign LEDR      = 10'h155;

    assign PS2_CLK   = 1'bZ;
    assign PS2_DAT   = 1'bZ;

    assign plot      = 1'b1;

    // Read an object from a memory, and display on the VGA output
    always @(posedge CLOCK_50)
        if (KEY[0] == 0)
            address <= 8'b0;
        else
            address <= address + 1'b1;

    object_mem U1 (address, CLOCK_50, VGA_COLOR);

    // Extract (x,y) from the memory address, and delay one clock cycle to wait for the data.
    // We can use {YC,XC} because the x dimension of the object memory is a power of 2
    always @(posedge CLOCK_50)
        if (KEY[0] == 0) begin
            x <= 4'b0;
            y <= 4'b0;
        end
        else begin
            x <= address[3:0];
            y <= address[7:4];
        end
    
    parameter XOFFSET = `ifdef VGA_640_480 312 `elsif VGA_320_240 152 `else 72 `endif;
    parameter YOFFSET = `ifdef VGA_640_480 232 `elsif VGA_320_240 112 `else 52 `endif;
    // center the object on the screen
    assign VGA_X = x + XOFFSET;
    assign VGA_Y = y + YOFFSET;

endmodule

