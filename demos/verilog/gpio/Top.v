// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module top (SW, GPIO);
    input  wire [ 9: 0] SW;         // DE-series switches
    inout  wire [31: 0] GPIO;       // DE-series 40-pin header

    gpio_demo U1 (SW, GPIO);

endmodule

