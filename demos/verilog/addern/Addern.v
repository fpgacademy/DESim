// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// A multi-bit adder
module addern (Cin, X, Y, Sum, Cout);
    parameter n = 4;

    input  wire         Cin;
    input  wire [n-1:0] X, Y;
    output wire [n-1:0] Sum;
    output wire         Cout;

    assign {Cout, Sum} = X + Y + Cin;

endmodule
