// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// Reset with SW[0]. Clock counter and memory with KEY[0]
// Each clock cycle reads a character from memory and shows it on the HEX displays
module display (CLOCK_50, KEY, HEX0, LEDR);
    input logic CLOCK_50;
    input logic [0:0] KEY;
    output logic [6:0] HEX0;
    output logic [9:0] LEDR;

    parameter A = 8'd65, b = 8'd98, C = 8'd67, d = 8'd100, E = 8'd69, F = 8'd70, 
        g = 8'd103, h = 8'd104;

    logic [2:0] count;
    logic [7:0] char;
    logic Clock, Resetn;
    assign Clock = CLOCK_50;
    assign Resetn = KEY;

    count3 U1 (Clock, Resetn, count);
    inst_mem U2 ({2'b0, count}, Clock, char);
    assign LEDR = {2'b0, char};
    
    always_comb
        case (char)
            A: HEX0 = 7'b0001000;
            b: HEX0 = 7'b0000011;
            C: HEX0 = 7'b1000110;
            d: HEX0 = 7'b0100001;
            E: HEX0 = 7'b0000110;
            F: HEX0 = 7'b0001110;
            g: HEX0 = 7'b0010000;
            h: HEX0 = 7'b0001011;
            default HEX0 = 7'b1111111;
        endcase
endmodule

module count3 (Clock, Resetn, Q);
    input logic Clock;
    input logic Resetn;
    output logic [2:0] Q;

    always_ff @(posedge Clock)
        if (Resetn == 0)
            Q <= 3'b000;
        else
            Q <= Q + 1'b1;
endmodule
