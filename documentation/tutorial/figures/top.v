module top (CLOCK_50, KEY, VGA_X, VGA_Y, VGA_COLOR, plot);
    input CLOCK_50;                 // DE-series 50 MHz clock signal
    input wire [3:0] KEY;           // DE-series pushbuttons

    output wire [9:0] VGA_X;        // VGA column
    output wire [8:0] VGA_Y;        // VGA row
    output wire [2:0] VGA_COLOR;    // VGA color
    output wire plot;               // VGa plot signal

    vga_demo U1 (CLOCK_50, KEY, VGA_X[8:0], VGA_Y[7:0], VGA_COLOR, plot);
endmodule

