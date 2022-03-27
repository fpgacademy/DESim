// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
    input  wire         CLOCK_50;   // DE-series 50 MHz clock signal
    input  wire [ 3: 0] KEY;        // DE-series pushbuttons
    input  wire [ 9: 0] SW;         // DE-series switches
    output wire [ 6: 0] HEX0;       // DE-series HEX displays
    output wire [ 6: 0] HEX1;
    output wire [ 6: 0] HEX2;
    output wire [ 6: 0] HEX3;
    output wire [ 6: 0] HEX4;
    output wire [ 6: 0] HEX5;
    output wire [ 9: 0] LEDR;       // DE-series LEDs

    LED_HEX U1 (CLOCK_50, KEY[1:0], SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

endmodule
