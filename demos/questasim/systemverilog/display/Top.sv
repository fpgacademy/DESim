// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (KEY, SW, HEX0, LEDR);
    input  logic  [ 3: 0] KEY;        // DE-series pushbuttons
    input  logic  [ 9: 0] SW;         // DE-series switches
    output logic  [ 6: 0] HEX0;       // DE-series HEX0 display
    output logic  [ 9: 0] LEDR;       // DE-series LEDs

    Display U1 (KEY[0], SW[0], HEX0, LEDR);

endmodule

