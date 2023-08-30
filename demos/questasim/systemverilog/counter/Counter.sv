// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// This module implements an n-bit counter. Upper bits of the counter, driven by the 
// 50 MHz clock signal, are displayed on the LEDR lights. The counter can be reset to 0
// using KEY[0]. 
module Counter (CLOCK, RESETn, LEDR);
    input  logic         CLOCK;
    input  logic         RESETn;
    output logic [ 9: 0] LEDR;

	parameter n = 24;
   
    logic         [n-1:0] count;

    // the counter
    always_ff @(posedge CLOCK)
        if (RESETn  == 1'b0)        // synchronous clear
            count <= 0;
        else
            count <= count + 1;

    assign LEDR = count[n-1:n-10];
endmodule
