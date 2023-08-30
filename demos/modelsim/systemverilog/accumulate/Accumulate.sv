// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// This module represents an accumulator controlled by a down-counter.  The data being 
// accumulated is from the SW[4:0] switches. KEY[0] is the active-low synchronous load
// input. When KEY[0] is low the counter is loaded from switches SW[9:5]. When KEY[0] is 
// high the circuit accumulates each clock cycle until the counter reaches 0
module Accumulate (CLOCK, RESETn, SW, LEDR);
    input   logic         CLOCK;
    input   logic         RESETn;
    input   logic [ 9: 0] SW;
    output  logic [ 9: 0] LEDR;


    logic         [ 4: 0] count;
    logic         [ 9: 0] sum;
    logic        [ 4: 0] x, y;
    logic                z;

    assign x = SW[4:0];
    assign y = SW[9:5];


    // the accumulator
    always_ff @(posedge CLOCK)
        if (RESETn  == 1'b0)        // synchronous clear
            sum <= 0;
        else if (z == 1'b1)
            sum <= sum + x;

    // the counter
    always_ff @(posedge CLOCK)
        if (RESETn  == 1'b0)        // synchronous load
            count <= y;
        else if (z == 1'b1)
            count <= count - 1'b1;


    assign z    = | count;
    assign LEDR = sum;

endmodule
