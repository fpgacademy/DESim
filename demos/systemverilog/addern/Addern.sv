// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// A multi-bit adder
module Addern (Cin, X, Y, Sum, Cout);
    parameter n = 4;

    input  logic         Cin;
    input  logic [n-1:0] X, Y;
    output logic [n-1:0] Sum;
    output logic         Cout;

    assign {Cout, Sum} = X + Y + Cin;

endmodule
