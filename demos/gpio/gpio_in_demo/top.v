// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ps
`default_nettype none

module top (
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
	
    inout wire [31:0] GPIO
);    

assign HEX0 = GPIO[ 6: 0];
assign HEX1 = GPIO[14: 8];
assign HEX2 = GPIO[22:16];
assign HEX3 = GPIO[30:24];

assign GPIO = 32'hZZZZZZZZ;

endmodule

