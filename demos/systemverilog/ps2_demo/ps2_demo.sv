// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// This module uses ps2_clk and ps2_dat to capture the last three bytes of data received 
// from the PS/2 keyboard. It displays this data on the HEX displays, and also displays the
// last byte of data received, along with its PARITY bit, on LEDR.
module ps2_demo (CLOCK_50, KEY, PS2_CLK, PS2_DAT, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input logic CLOCK_50;
    input logic [0:0] KEY;
    inout wire PS2_CLK, PS2_DAT;
    output logic [9:0] LEDR;       // DE-series LEDs
    output logic [6:0] HEX0;
    output logic [6:0] HEX1;       // DE-series HEX displays
    output logic [6:0] HEX2;
    output logic [6:0] HEX3;
    output logic [6:0] HEX4;       // DE-series HEX displays
    output logic [6:0] HEX5;       // DE-series HEX displays

    logic Resetn, negedge_ps2_clk;
    logic [32:0] Serial;           // each PS/2 data packet has 11 bits:
                                   // STOP (1) PARITY d7 d6 d5 d4 d3 d2 d1 d0 START (0)
    logic prev_ps2_clk;            // PS2_CLK value in the previous clock cycle

    assign Resetn = KEY[0];

    always_ff @(posedge CLOCK_50)
        prev_ps2_clk <= PS2_CLK;

    // check when PS2_CLK has changed from 1 to 0
    assign negedge_ps2_clk = (prev_ps2_clk & !PS2_CLK);

    always_ff @(posedge CLOCK_50) begin    // specify a 33-bit shift register
        if (Resetn == 0)
            Serial <= 33'b0;
        else if (negedge_ps2_clk) begin
            Serial[31:0] <= Serial[32:1];
            Serial[32] <= PS2_DAT;
        end
    end

    assign LEDR = Serial[32:23];        // STOP, PARITY, Data for the last byte received
    hex7seg H0 (Serial[4:1], HEX0);
    hex7seg H1 (Serial[8:5], HEX1);
    hex7seg H2 (Serial[15:12], HEX2);
    hex7seg H3 (Serial[19:16], HEX3);
    hex7seg H4 (Serial[26:23], HEX4);
    hex7seg H5 (Serial[30:27], HEX5);
endmodule

module hex7seg (hex, display);
    input logic [3:0] hex;
    output logic [6:0] display;

    /*
     *       0  
     *      ---  
     *     |   |
     *    5|   |1
     *     | 6 |
     *      ---  
     *     |   |
     *    4|   |2
     *     |   |
     *      ---  
     *       3  
     */
    always @ (hex)
        case (hex)
            4'h0: display = 7'b1000000;
            4'h1: display = 7'b1111001;
            4'h2: display = 7'b0100100;
            4'h3: display = 7'b0110000;
            4'h4: display = 7'b0011001;
            4'h5: display = 7'b0010010;
            4'h6: display = 7'b0000010;
            4'h7: display = 7'b1111000;
            4'h8: display = 7'b0000000;
            4'h9: display = 7'b0011000;
            4'hA: display = 7'b0001000;
            4'hb: display = 7'b0000011;
            4'hC: display = 7'b1000110;
            4'hd: display = 7'b0100001;
            4'hE: display = 7'b0000110;
            4'hF: display = 7'b0001110;
        endcase
endmodule
