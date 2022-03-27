// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (CLOCK_50, KEY, SW, GPIO, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR,
        PS2_CLK, PS2_DAT, 
        VGA_X, VGA_Y, VGA_COLOR, plot);
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

    inout  wire         PS2_CLK;
    inout  wire         PS2_DAT;

    output wire [ 7: 0] VGA_X;      // "VGA" column
    output wire [ 6: 0] VGA_Y;      // "VGA" row
    output wire [ 2: 0] VGA_COLOR;  // "VGA pixel" colour (0-7)
    output wire         plot;       // "Pixel" is drawn when this is pulsed


    assign GPIO      = 32'hZZZZZZZZ;

    assign HEX0      = 7'h40;
    assign HEX1      = 7'h47;
    assign HEX2      = 7'h47;
    assign HEX3      = 7'h06;
    assign HEX4      = 7'h09;
    assign HEX5      = 7'h7F;

    assign LEDR      = 10'h155;

    assign VGA_X     = {4'h0, SW[3:0]};
    assign VGA_Y     = {3'h0, SW[7:4]};
    assign VGA_COLOR = KEY[3:1];
    assign plot      = KEY[0];

endmodule

