// Copyright (c) 2025 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none
// This module represents an accumulator controlled by a down-counter.  The data being 
// accumulated is from the SW[4:0] switches, and the accumulated Sum is shown on LEDR. 
// KEY[0] is the active-low synchronous reset/load input. When KEY[0] is low the Sum is 
// cleared and the Count is loaded, from switches SW[9:5]. When KEY[0] is high the circuit 
// accumulates each clock cycle until the Count reaches 0
module accumulate (CLOCK_50, KEY, SW, LEDR);
	input wire CLOCK_50;
	input wire [0:0] KEY;
	input wire [9:0] SW;
	output wire [9:0] LEDR;

	reg [4:0] Count;                // controls how many accumulations are done
	reg [9:0] Sum;                  // the resulting accumulation
	wire Clock, Resetn, z;
	wire [4:0] X, Y;                // X will be accumulated Y times

	assign Clock = CLOCK_50;
	assign Resetn = KEY[0];
	assign X = SW[4:0];             // accumulation this data ...
	assign Y = SW[9:5];             // this many times

	// the accumulator
	always @(posedge Clock)
		if (Resetn  == 1'b0)		// synchronous clear of the Sum
			Sum <= 0;
		else if (z == 1'b1)
			Sum <= Sum + X;

	// the counter
	always @(posedge Clock)
		if (Resetn  == 1'b0)		// synchronous load of the Count
			Count <= Y;
		else if (z == 1'b1)
			Count <= Count - 1'b1;

	assign z = | Count;
	assign LEDR = Sum;
endmodule
