// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (CLOCK_50, KEY, SW, GPIO);
    input  logic         CLOCK_50;   // DE-series 50 MHz clock signal
    input  logic [ 3: 0] KEY;        // DE-series pushbuttons
    input  logic [ 9: 0] SW;         // DE-series switches
    inout  logic [31: 0] GPIO;       // DE-series 40-pin header

    logic        [31: 0] gpio_comb;
    logic        [31: 0] gpio_reg;

    assign GPIO = gpio_comb;

    always_comb
    begin
	    gpio_comb = gpio_reg;
        case (SW[9:8])
            2'b00: gpio_comb[ 7: 0] = SW[ 7: 0];
            2'b01: gpio_comb[15: 8] = SW[ 7: 0];
            2'b10: gpio_comb[23:16] = SW[ 7: 0];
            2'b11: gpio_comb[31:24] = SW[ 7: 0];
            default: ;
        endcase
    end

    always_ff @(posedge CLOCK_50)
    begin
        if (~KEY[0])
            gpio_reg <= 32'h00000000;
    	else
	    begin
            case (SW[9:8])
                2'b00: gpio_reg[ 7: 0] <= SW[ 7: 0];
                2'b01: gpio_reg[15: 8] <= SW[ 7: 0];
                2'b10: gpio_reg[23:16] <= SW[ 7: 0];
                2'b11: gpio_reg[31:24] <= SW[ 7: 0];
                default: ;
            endcase
        end
    end
    
endmodule

