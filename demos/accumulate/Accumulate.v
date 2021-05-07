// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// This module represents an accumulator controlled by a down-counter.  The data being 
// accumulated is from the SW[4:0] switches. KEY[0] is the active-low synchronous load
// input. When KEY[0] is low the counter is loaded from switches SW[9:5]. When KEY[0] is 
// high the circuit accumulates each clock cycle until the counter reaches 0
module Accumulate (KEY, CLOCK_50, SW, LEDR);
	input [0:0] KEY;
	input CLOCK_50;
	input [9:0] SW;
	output [9:0] LEDR;

	reg [4:0] Count;
	reg [9:0] Sum;
	wire Clock, Resetn, z;
	wire [4:0] X, Y;

	assign Clock = CLOCK_50;
	assign Resetn = KEY[0];
	assign X = SW[4:0];
	assign Y = SW[9:5];

	// the accumulator
	always @(posedge Clock)
		if (Resetn  == 1'b0)		// synchronous clear
			Sum <= 0;
		else if (z == 1'b1)
			Sum <= Sum + X;

	// the counter
	always @(posedge Clock)
		if (Resetn  == 1'b0)		// synchronous load
			Count <= Y;
		else if (z == 1'b1)
			Count <= Count - 1'b1;

	assign z = | Count;
	assign LEDR = Sum;
endmodule
