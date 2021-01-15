// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module top (
    input wire CLOCK_50,            // On-Board 50 MHz
    input wire [3:0] KEY,           // On-board push buttons
        
    output wire [7:0] VGA_X,        // VGA column
    output wire [6:0] VGA_Y,        // VGA row
    output wire [2:0] VGA_COLOR,    // VGA pixel colour (0-7)
    output wire plot                // Pixel drawn when this is pulsed
);    


    reg [7:0] x;
    reg [6:0] y;
    reg [2:0] color;

    wire reset;

    assign reset = ~KEY[0];

    always @(posedge CLOCK_50) begin
        if(reset) begin
            x <= 0;
            y <= 0;
            color <= 0;
        end
        else begin
            if(x == 159) begin
                x <= 0;
                if(y == 119) begin
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

