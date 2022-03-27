// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

// This testbench is designed to hide the details of using the VPI code

module tb();

reg CLOCK_50 = 0;       // On-board 50 MHz
reg [9:0] SW = 0;       // On-board Switches
reg [3:0] KEY = 0;      // On-board push buttons
wire [(8*6) -1:0] HEX;  // HEX displays
wire [9:0] LEDR;        // LEDs

reg key_action = 0;
reg [7:0] scan_code = 0;
wire [2:0] ps2_lock_control;

wire [7:0] VGA_X;       // VGA pixel coordinates
wire [6:0] VGA_Y;
wire [2:0] VGA_COLOR;   // VGA pixel colour (0-7)
wire plot;              // Pixel drawn when this is pulsed
wire [31:0] GPIO;		// On-board 40-pin header

initial $sim_fpga(CLOCK_50, SW, KEY, LEDR, HEX, key_action, scan_code, 
                  ps2_lock_control, VGA_X, VGA_Y, VGA_COLOR, plot, GPIO);

wire [6:0] HEX0;
wire [6:0] HEX1;
wire [6:0] HEX2;
wire [6:0] HEX3;
wire [6:0] HEX4;
wire [6:0] HEX5;

// Define the 50 MHz clock signal
always #10 CLOCK_50 <= ~CLOCK_50;

// Assign the individual HEX displays to the sim_fpga HEX port
assign HEX[47:40] = {1'b0, HEX0};
assign HEX[39:32] = {1'b0, HEX1};
assign HEX[31:24] = {1'b0, HEX2};
assign HEX[23:16] = {1'b0, HEX3};
assign HEX[15: 8] = {1'b0, HEX4};
assign HEX[ 7: 0] = {1'b0, HEX5};

top DUT (
    .CLOCK_50(CLOCK_50),
    .SW(SW),
    .KEY(KEY),
    .GPIO(GPIO)
);

endmodule
