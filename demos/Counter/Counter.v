// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// This module implements an n-bit counter. Upper bits of the counter, driven by the 
// 50 MHz clock signal, are displayed on the LEDR lights. The counter can be reset to 0
// using KEY[0]. 
module Counter (KEY, CLOCK_50, LEDR);
	input [0:0] KEY;
	input CLOCK_50;
	output [9:0] LEDR;
   parameter n = 24;
   
	reg [n-1:0] Count;
	wire Clock, Resetn;

	assign Clock = CLOCK_50;
	assign Resetn = KEY[0];

	// the counter
	always @(posedge Clock)
		if (Resetn  == 1'b0)		// synchronous clear
			Count <= 0;
		else
			Count <= Count + 1;

	assign LEDR = Count[n-1:n-10];
endmodule
