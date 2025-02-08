// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

// Reset with SW[0]. Clock counter and memory with KEY[0]
// Each clock cycle reads a character from memory and shows it on the HEX displays
module Display (CLOCK, RESETn, HEX0, LEDR);
    input  wire         CLOCK;
    input  wire         RESETn;
    output reg  [ 6: 0] HEX0;
    output wire [ 9: 0] LEDR;

    parameter A = 8'd65, b = 8'd98, C = 8'd67, d = 8'd100, E = 8'd69, F = 8'd70, 
        g = 8'd103, h = 8'd104;

	wire        [ 2: 0] count;
    wire        [ 7: 0] char;

    count3 U1 (CLOCK, RESETn, count);
    inst_mem U2 ({2'b0, count}, CLOCK, char);
    assign LEDR = {2'b0, char};
    
    always @(*)
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

module count3 (CLOCK, RESETn, Q);
    input  wire         CLOCK;
    input  wire         RESETn;
    output reg  [ 2: 0] Q;

    always @ (posedge CLOCK)
        if (RESETn == 0)
            Q <= 3'b000;
        else
            Q <= Q + 1'b1;
endmodule
