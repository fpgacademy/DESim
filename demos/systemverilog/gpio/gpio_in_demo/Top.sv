// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (GPIO, HEX0, HEX1, HEX2, HEX3);
    inout  wire  [31: 0] GPIO;       // DE-series 40-pin header
    output logic [ 6: 0] HEX0;       // DE-series HEX displays
    output logic [ 6: 0] HEX1;
    output logic [ 6: 0] HEX2;
    output logic [ 6: 0] HEX3;
    

    assign HEX0 = GPIO[ 6: 0];
    assign HEX1 = GPIO[14: 8];
    assign HEX2 = GPIO[22:16];
    assign HEX3 = GPIO[30:24];

    assign GPIO = 32'hZZZZZZZZ;

endmodule

