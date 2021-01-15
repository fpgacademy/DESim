// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

module top	(
        input wire CLOCK_50,           // On Board 50 MHz
        output wire [9:0] LEDR         // LEDs   
); 

wire [5:0] blank;

ctr16 i_ctr16 (
    .clock(CLOCK_50),
    .q({LEDR[9:0],blank})
);

endmodule
