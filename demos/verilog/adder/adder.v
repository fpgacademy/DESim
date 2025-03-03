// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// A multi-bit adder
module adder (Cin, X, Y, S, Cout);
    input wire Cin;
    input wire [3:0] X, Y;
    output wire [3:0] S;
    output wire Cout;

    wire [4:0] sum;
    assign sum = X + Y + Cin;   // 5-bit result, with carry-out
    assign S = sum[3:0];
    assign Cout = sum[4];
endmodule
