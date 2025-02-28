// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// This module represents an accumulator controlled by a down-counter. The data being 
// accumulated is from the SW[4:0] switches. KEY[0] is the active-low synchronous load
// input. When KEY[0] is low the counter is loaded from switches SW[9:5]. When KEY[0] is 
// high the circuit accumulates each clock cycle until the counter reaches 0
module accumulate (CLOCK_50, KEY, SW, LEDR);
    input logic CLOCK_50;
    input logic [0:0] KEY;
    input logic [9:0] SW;
    output logic [9:0] LEDR;

    logic [4:0] count;
    logic [9:0] sum;
    logic [4:0] x, y;
    logic Clock, Resetn, z;

    assign x = SW[4:0];
    assign y = SW[9:5];
    assign Clock = CLOCK_50;
    assign Resetn = KEY;

    // the accumulator
    always_ff @(posedge Clock)
        if (Resetn == 1'b0)
            sum <= 0;
        else if (z == 1'b1)
            sum <= sum + x;

    // the counter
    always_ff @(posedge Clock)
        if (Resetn  == 1'b0)
            count <= y;
        else if (z == 1'b1)
            count <= count - 1'b1;

    assign z = | count;
    assign LEDR = sum;

endmodule
