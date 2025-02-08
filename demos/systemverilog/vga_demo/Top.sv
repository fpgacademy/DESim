// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (CLOCK_50, KEY, VGA_X, VGA_Y, VGA_COLOR, plot);
    input  logic         CLOCK_50;   // DE-series 50 MHz clock signal
    input  logic [ 3: 0] KEY;        // DE-series pushbuttons

    output logic  [ 7: 0] VGA_X;      // "VGA" column
    output logic  [ 6: 0] VGA_Y;      // "VGA" row
    output logic  [ 2: 0] VGA_COLOR;  // "VGA pixel" colour (0-7)
    output logic          plot;       // "Pixel" is drawn when this is pulsed

    logic         [ 7: 0] x;
    logic         [ 6: 0] y;
    logic         [ 2: 0] color;

    logic                 reset;

    assign reset = ~KEY[0];

    always_ff @(posedge CLOCK_50) begin
        if (reset) begin
            x <= 0;
            y <= 0;
            color <= 3'd1;
        end
        else begin
            if(x == 159) begin
                x <= 0;
                if (y == 119) begin
                    y <= 0;
                    color <= color + 3'd1;
                end
                else begin
                    y <= y + 1'b1;
                end
            end
            else begin
                x <= x + 1'b1;
            end  
        end
    end

    assign VGA_X     = x;
    assign VGA_Y     = y;
    assign VGA_COLOR = color;
    assign plot      = 1'b1;

endmodule

