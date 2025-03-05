// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// This module implements an n-bit counter. Upper bits of the counter, driven by the 
// 50 MHz clock signal, are displayed on the LEDR lights. The counter can be reset to 0
// using KEY[0] and it is enabled using SW[0]. 
module counter (CLOCK_50, KEY, SW, LEDR);
    input wire CLOCK_50;
    input wire [0:0] KEY;
    input wire [0:0] SW;
    output wire [9:0] LEDR;
    parameter n = 24;
   
    reg [n-1:0] Count;
    wire Clock, Resetn, En;

    assign Clock = CLOCK_50;
    assign Resetn = KEY[0];
    assign En = SW[0];

    // the counter
    always @(posedge Clock)
        if (Resetn  == 1'b0)        // synchronous clear
            Count <= 0;
        else if (En)
            Count <= Count + 1;

    assign LEDR = Count[n-1:n-10];
endmodule
