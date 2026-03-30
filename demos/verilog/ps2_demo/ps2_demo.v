// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// This module uses ps2_clk and ps2_dat to capture scancodes received from the PS/2 keyboard. The
// last three scancodes received are always displayed on HEX6 - HEX0. Each time a scancode is 
// received, a counter called Total is incremented and displayed on LEDR. 
module ps2_demo (CLOCK_50, KEY, PS2_CLK, PS2_DAT, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input wire CLOCK_50;
    input wire [0:0] KEY;
    inout wire PS2_CLK, PS2_DAT;
    output wire [9:0] LEDR;       // DE-series LEDs
    output wire [6:0] HEX0;
    output wire [6:0] HEX1;       // DE-series HEX displays
    output wire [6:0] HEX2;
    output wire [6:0] HEX3;
    output wire [6:0] HEX4;       // DE-series HEX displays
    output wire [6:0] HEX5;       // DE-series HEX displays

    wire Resetn, negedge_ps2_clk;
    reg [32:0] Serial;              // each PS2 serial data packet has 11 bits:
                                    // STOP (1) PARITY d7 d6 d5 d4 d3 d2 d1 d0 START (0)
                                    // The most-recent three data packets received are saved
    reg [3:0] Packet;               // used to know each time that 11 bits have been received
    reg [9:0] Total;                // used to count total PS/2 keys pressed
    wire [7:0] scancode;            // used to save the current PS/2 scancode
    wire ps2_rec;                   // set to 1 for one clock cycle when a PS/2 scancode has
                                    // been received

    reg prev_ps2_clk;               // ps2_clk value in the previous CLOCK_50 clock cycle
    wire PS2_CLK_S, PS2_DAT_S;      // PS2 signals synchronized to CLOCK_50

    assign Resetn = KEY[0];

    // synchronize the PS/2 signals with CLOCK_50
    sync S3 (PS2_CLK, Resetn, CLOCK_50, PS2_CLK_S);
    sync S4 (PS2_DAT, Resetn, CLOCK_50, PS2_DAT_S);
    
    always @(posedge CLOCK_50)
        prev_ps2_clk <= PS2_CLK_S;

    // check when ps2_clk has changed from 1 to 0
    assign negedge_ps2_clk = (prev_ps2_clk & !PS2_CLK_S);

    always @(posedge CLOCK_50) begin    // specify a 33-bit shift register
        if (Resetn == 0)
            Serial <= 33'b0;
        else if (negedge_ps2_clk) begin
            Serial[31:0] <= Serial[32:1];
            Serial[32] <= PS2_DAT_S;
        end
    end

    // count ps2_clk cycles (equivalent to counting data bits received)
    always @(posedge CLOCK_50) begin
        if (!Resetn || Packet == 'd11)
            Packet <= 4'b0;
        else if (negedge_ps2_clk) begin
            Packet <= Packet + 4'b1;
        end
    end

    // PS/2 key press makes scancode/release/scancode.  Key repeat makes scancode/scancode/...
    // So we check for Serial[30:23] == Serial[8:1]
    assign ps2_rec = (Packet == 'd11) && (Serial[30:23] == Serial[8:1]);
    
    // last received PS/2 scancode is in Serial[8:1]
    regn USC (Serial[8:1], Resetn, ps2_rec, CLOCK_50, scancode);
    
    always @(posedge CLOCK_50)  // keep track of total number of PS/2 key-presses received
        if (!Resetn)
            Total <= 10'b0;
        else
            if (ps2_rec)
                Total <= Total + 10'b1;
    
    assign LEDR = Total;
    hex7seg H0 (scancode[3:0], HEX0);
    hex7seg H1 (scancode[7:4], HEX1);
    hex7seg H2 (Serial[15:12], HEX2);
    hex7seg H3 (Serial[19:16], HEX3);
    hex7seg H4 (Serial[26:23], HEX4);
    hex7seg H5 (Serial[30:27], HEX5);
endmodule

// syncronizer, implemented as two FFs in series
module sync(D, Resetn, Clock, Q);
    input wire D;
    input wire Resetn, Clock;
    output reg Q;

    reg Qi; // internal node

    always @(posedge Clock)
        if (Resetn == 0) begin
            Qi <= 1'b0;
            Q <= 1'b0;
        end
        else begin
            Qi <= D;
            Q <= Qi;
        end
endmodule

// n-bit register with enable
module regn(R, Resetn, E, Clock, Q);
    parameter n = 8;
    input wire [n-1:0] R;
    input wire Resetn, E, Clock;
    output reg [n-1:0] Q;

    always @(posedge Clock)
        if (!Resetn)
            Q <= 0;
        else if (E)
            Q <= R;
endmodule

module hex7seg (hex, display);
    input wire [3:0] hex;
    output reg [6:0] display;

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

