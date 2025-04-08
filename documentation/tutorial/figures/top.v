module top (CLOCK_50, KEY, VGA_X, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, VGA_Y, VGA_COLOR, plot);

    input CLOCK_50;             // DE-series 50 MHz clock signal
    input wire [3:0] KEY;       // DE-series pushbuttons

    output wire [6:0] HEX0;     // DE-series HEX displays
    output wire [6:0] HEX1;
    output wire [6:0] HEX2;
    output wire [6:0] HEX3;
    output wire [6:0] HEX4;
    output wire [6:0] HEX5;

    output wire [9:0] VGA_X;    // DESim VGA signals
    output wire [8:0] VGA_Y;
    output wire [23:0] VGA_COLOR;
    output wire plot;

    vga_demo U1 (CLOCK_50, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, VGA_X[7:0], VGA_Y[6:0], VGA_COLOR, plot);

endmodule
