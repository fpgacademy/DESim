// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ps
`default_nettype none

module top (
	input wire [9:0] SW,            // On-board Switches
    inout wire [31:0] GPIO			// On-board 40-pin header
);    

assign GPIO[31:24] = (SW[1:0] == 2'h0) ? GPIO[15: 8] : 8'h00;
assign GPIO[23:16] = (SW[1:0] == 2'h0) ? GPIO[ 7: 0] : 
                     (SW[1:0] == 2'h1) ? GPIO[15: 8] | GPIO[ 7: 0] : 
                     (SW[1:0] == 2'h2) ? GPIO[15: 8] & GPIO[ 7: 0] : 
                                         GPIO[15: 8] ^ GPIO[ 7: 0];
assign GPIO[15: 0] = 16'hZZZZ;

endmodule

