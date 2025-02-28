// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

`include "resolution.sv"

module vga_demo (CLOCK_50, KEY, VGA_X, VGA_Y, VGA_COLOR, plot);

    parameter n = `ifdef VGA_640_480 10 `elsif VGA_320_240 9 `else 8 `endif ; // VGA x bitwidth
    parameter ROWS = `ifdef VGA_640_480 480 `elsif VGA_320_240 240 `else 120 `endif ;
    parameter COLS = `ifdef VGA_640_480 640 `elsif VGA_320_240 320 `else 160 `endif ;

    input logic CLOCK_50;            // On-Board 50 MHz
    input logic [3:0] KEY;           // push buttons
    output logic [n-1:0] VGA_X;      // VGA column
    output logic [n-2:0] VGA_Y;      // VGA row
    output logic [2:0] VGA_COLOR;    // VGA pixel colour (0-7)
    output logic plot;               // Pixel is drawn when this is pulsed

    logic [n-1:0] x;
    logic [n-2:0] y;
    logic [2:0] color;

    logic reset;
    assign reset = ~KEY[0];

    always @(posedge CLOCK_50) begin
        if (reset) begin
            x <= 0;
            y <= 0;
            color <= 1;
        end
        else begin
            if(x == COLS-1) begin
                x <= 0;
                if(y == ROWS-1) begin
                    y <= 0;
                    if (color < 7) begin
                        color <= color + 1'b1;
                    end 
                    else begin
                        color <= 3'd1;
                    end
                end
                else begin
                    y <= y + 1'b1;
                end
            end
            else begin
                x <= x + 1'b1;
            end  
        end
    end

    assign VGA_X = x;
    assign VGA_Y = y;
    assign VGA_COLOR = color;
    assign plot = 1'b1;

endmodule

