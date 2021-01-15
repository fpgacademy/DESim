// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module top (
    input wire CLOCK_50,            // On-Board 50 MHz
    input wire [9:0] SW,            // On-board Switches
    input wire [3:0] KEY,           // On-board push buttons

    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5,

    output wire [9:0] LEDR,         // LEDs   

    inout wire  PS2_CLK,
    inout wire  PS2_DAT,
        
    output wire [7:0] VGA_X,        // VGA pixel coordinates
    output wire [6:0] VGA_Y,
    output wire [2:0] VGA_COLOR,    // VGA pixel colour (0-7)
    output wire plot,               // Pixel drawn when this is pulsed
    inout wire [31:0] GPIO
);    

    assign LEDR = SW;

    PS2_Comm comm(
        .CLOCK_50(CLOCK_50),
        .KEY(KEY[1:0]),
        .SW(SW),

        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),

        .HEX0(HEX0),
        .HEX1(HEX1)
    );

endmodule

