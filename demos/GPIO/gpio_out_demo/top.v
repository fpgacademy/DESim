// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ps
`default_nettype none

module top (
    input wire CLOCK_50,            //On Board 50 MHz
    input wire [9:0] SW,            // On board Switches
    input wire [3:0] KEY,           // On board push buttons
    inout wire [31:0] GPIO			// On-board 40-pin header
);    


reg [31: 0] gpio_comb;
reg [31: 0] gpio_reg;

assign GPIO = gpio_comb;
//assign GPIO[31: 8] = shift_reg;
//assign GPIO[ 7: 0] = SW[7:0];

always @(*)
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

always @(posedge CLOCK_50)
begin
    if (~KEY[0])
	begin
        gpio_reg <= 32'h00000000;
	end
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

