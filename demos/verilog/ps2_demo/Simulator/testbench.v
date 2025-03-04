`timescale 1ns / 1ns
`default_nettype none

module testbench ( );

	parameter CLOCK_PERIOD = 20;

    reg CLOCK_50 = 0;
	reg [9:0] SW;
    reg [3:0] KEY;
    wire [0:6] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	wire [9:0] LEDR;

    reg key_action = 0;
    reg [7:0] scan_code = 0;
    wire [2:0] ps2_lock_control;
    wire ps2_clk;
    wire ps2_dat;

	initial begin
        CLOCK_50 <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) CLOCK_50 <= ~CLOCK_50;
	end

	initial begin
		KEY <= 4'hF; key_action <= 1'b0; scan_code <= 8'h00;
		#20 KEY[0] <= 1'b0; // reset
		#20 KEY[0] <= 1'b1; // done reset
		#20 key_action <= 1'b1; scan_code = 8'h1b;      // PS/2 keyboard s key
        #20 key_action <= 1'b0;
		#80 key_action <= 1'b1; scan_code = 8'hF0;      // PS/2 keyboard release
        #20 key_action <= 1'b0;
		#80 key_action <= 1'b1; scan_code = 8'h1b;      // PS/2 keyboard s key
		#20 key_action <= 1'b0;
	end // initial

	PS2_keyboard U1 (CLOCK_50, KEY[0], key_action, scan_code, ps2_clk, ps2_dat);

endmodule
