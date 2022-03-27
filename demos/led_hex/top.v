// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`default_nettype none   // force the explicit declaration of all signal types

module top (CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

    input wire CLOCK_50;        // DE-series 50 MHz clock signal
    input wire [9:0] SW;        // DE-series switches
    input wire [3:0] KEY;       // DE-series pushbuttons
    output wire [9:0] LEDR;     // DE-series LEDs   

    output wire [6:0] HEX0;      // DE-series HEX displays
    output wire [6:0] HEX1;
    output wire [6:0] HEX2;
    output wire [6:0] HEX3;
    output wire [6:0] HEX4;
    output wire [6:0] HEX5;

    LED_HEX U1 (CLOCK_50, SW, KEY[1:0], LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

endmodule
