// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// A multi-bit adder
module adder (Cin, X, Y, S, Cout);
    input logic Cin;
    input logic [3:0] X, Y;
    output logic [3:0] S;
    output logic Cout;

    logic [4:0] sum;
    assign sum = X + Y + Cin;   // 5-bit result, with carry-out
    assign S = sum[3:0];
    assign Cout = sum[4];
endmodule
