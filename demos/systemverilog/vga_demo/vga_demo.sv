// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

`timescale 1ns / 1ns
`default_nettype none

`include "resolution.sv"

// Displays some rainbow colors one at a time starting from red. Color (24-bit) RGB components
// are shown on the HEX displays. After displaying all colors once, then displays a full 
// rainbow, which is read from a memory.
// To use, first press KEY[0] to reset.
module vga_demo (CLOCK_50, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, VGA_X, VGA_Y, VGA_COLOR, plot);

    parameter nX = `ifdef VGA_640_480 10 `elsif VGA_320_240 9 `else 8 `endif ; // VGA x bitwidth
    parameter nY = nX - 1;

    // Number of columns and rows in the video memory
    parameter COLS = `ifdef VGA_640_480 640 `elsif VGA_320_240 320 `else 160 `endif ;
    parameter ROWS = `ifdef VGA_640_480 480 `elsif VGA_320_240 240 `else 120 `endif ;
    // Number of address bits on the video memory
    parameter Mn =   `ifdef VGA_640_480 19  `elsif VGA_320_240 17  `else 15  `endif ;

    parameter STEP = 24'h000011 ;

    input logic CLOCK_50;            // DE-series board 50 MHz Clock
    input logic [3:0] KEY;           // push buttons
    output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;   // 7-segment displays
    output logic [nX-1:0] VGA_X;     // VGA column
    output logic [nY-1:0] VGA_Y;     // VGA row
    output logic [23:0] VGA_COLOR;   // VGA pixel colour (24-bit color)
    output logic plot;               // Pixel is drawn plot = 1

    logic Resetn;                    // active-low reset
    assign Resetn = KEY[0];
    logic [nX-1:0] x;                 // used when drawing individual colors
    logic [nY-1:0] y;                 // used when drawing individual colors
    logic [23:0] color;               // used when drawing individual colors
    logic [2:0] ramp;     // used to ramp up/down RGB components of the rainbow

    always_ff @(posedge CLOCK_50) begin
        if (Resetn == 0) begin
            x <= COLS >> 2;         // set starting x coordinate
            y <= ROWS >> 2;         // set starting y coordinate 
            ramp <= 3'h0;
            color <= 24'hFF0000;    // set starting color to red
        end

        /* Code to generate rainbow colors.
            Algorithm is to set (two colors at a time) in RBG in this manner:

            RRRRG-RGGGG-GGGGB-GBBBB-BBBBR-BRRRR     saturation level
               G   R       B   G       R   B   
              G     R     B     G     R     B
             G       R   B       G   R       B
            GBBBB-BBBBR-BRRRR-RRRRG-RGGGG-GGGGB     0 level
        */   
        else begin
            if(x == COLS-(COLS >> 2)) begin
                x <= COLS >> 2;
                if(y == ROWS-(ROWS >> 2)) begin
                    y <= ROWS >> 2;
                    if (ramp == 3'h0) begin
                        if (color != 24'hFFFF00)
                            color <= color + (STEP << 8);       // ramp up G
                        else begin
                            ramp <= ramp + 3'b1;
                            color <= color - (STEP << 16);
                        end
                    end
                    else if (ramp == 3'h1) begin
                        if (color != 24'h00FF00)
                            color <= color - (STEP << 16);      // ramp down R
                        else begin
                            ramp <= ramp + 3'b1;
                            color <= color + STEP;
                        end
                    end
                    else if (ramp == 3'h2) begin
                        if (color != 24'h00FFFF)
                            color <= color + STEP;              // ramp up B
                        else begin
                            ramp <= ramp + 3'b1;
                            color <= color - (STEP << 8);
                        end
                    end
                    else if (ramp == 3'h3) begin
                        if (color != 24'h0000FF)
                            color <= color - (STEP << 8);       // ramp down G
                        else begin
                            ramp <= ramp + 3'b1;
                            color <= color + (STEP << 16);
                        end
                    end
                    else if (ramp == 3'h4) begin
                        if (color != 24'hFF00FF)
                            color <= color + (STEP << 16);      // ramp up R
                        else begin
                            ramp <= ramp + 3'b1;
                            color <= color - STEP;
                        end
                    end
                    else if (ramp == 3'h5) begin
                        if (color != 24'hFF0000)
                            color <= color - STEP;              // ramp down B
                        else begin
                            ramp <= ramp + 3'b1;
                        end
                    end
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

    // show the RGB color components on hex displays
    hex7seg H0 (color[3:0], HEX0);
    hex7seg H1 (color[7:4], HEX1);
    hex7seg H2 (color[11:8], HEX2);
    hex7seg H3 (color[15:12], HEX3);
    hex7seg H4 (color[19:16], HEX4);
    hex7seg H5 (color[23:20], HEX5);

    logic [nX-1:0] x_add;     // used when displaying MIF from memory
    logic [nY-1:0] y_add;     // used when displaying MIF from memory
    logic [Mn-1:0] address;  // used when displaying MIF from memory
    logic [11:0] MIF_color;  // used when displaying MIF from memory

    always_ff @(posedge CLOCK_50)
        if(ramp < 3'h6) begin       // wait until all colors have been drawn once
            x_add <= 'b0;
            y_add <= 'b0;
        end
        else begin                  // generate all VGA (x,y) addresses
            if (x_add < COLS)
                x_add <= x_add + 'b1;
            else
            if (y_add < ROWS) begin
                y_add <= y_add + 'b1;
                x_add <= 'b0;
            end
        end

    // translate (x,y) to a memory address
    address_translator U1 (x_add, y_add, address);
        defparam U1.nX = nX;
        defparam U1.nY = nY;
        defparam U1.Mn = Mn;

    // instantiate the video memory
    object_mem U2 (address, CLOCK_50, MIF_color);
        defparam U2.n = 12;
        defparam U2.Mn = Mn;
        defparam U2.INIT_FILE = 
            `ifdef VGA_640_480 "rainbow_640_12.mif"
            `elsif VGA_320_240 "rainbow_320_12.mif"
            `else "rainbow_160_12.mif" `endif ;

    // display either individual colors, or the MIF rainbow of colors. The MIF has 12-bit
    // colors, so these are converted to 24-bit colors
    assign VGA_X = (ramp < 3'h6) ? x : x_add;
    assign VGA_Y = (ramp < 3'h6) ? y : y_add;
    assign VGA_COLOR = (ramp < 3'h6) ? color : 
        {{2{MIF_color[11:8]}},{2{MIF_color[7:4]}},{2{MIF_color[3:0]}}};
    assign plot = 1'b1;

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
    always_comb
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
            4'hB: display = 7'b0000011;
            4'hC: display = 7'b1000110;
            4'hD: display = 7'b0100001;
            4'hE: display = 7'b0000110;
            4'hF: display = 7'b0001110;
        endcase
endmodule

/* This module converts an (x,y) coordinate into a memory address.
 * The output of the module depends on the resolution.
 */
module address_translator(x, y, mem_address);

    parameter nX = 9, nY = 8, Mn = 17;  // default bit widths
    
	input logic [nX-1:0] x; 
	input logic [nY-1:0] y;	
	output logic [Mn-1:0] mem_address;
	
	/* The basic formula is address = y*WIDTH + x;
	 * For 320x240 resolution we can write 320 as (256 + 64). Memory address becomes
	 * (y*256) + (y*64) + x;
	 * This simplifies multiplication a simple shift and add operation.
	 * A leading 0 bit is added to each operand to ensure that they are treated as unsigned
	 * inputs. By default the use a '+' operator will generate a signed adder.
	 * Similarly, for 160x120 resolution we write 160 as 128+32.
     * For 640 we use 512 + 128
	 */
    assign mem_address = 
        `ifdef VGA_640_480 
	        ({1'b0, y, 9'd0} + {1'b0, y, 7'd0} + {1'b0, x});
        `elsif VGA_320_240 
	        ({1'b0, y, 8'd0} + {1'b0, y, 6'd0} + {1'b0, x});
        `else 
	        ({1'b0, y, 7'd0} + {1'b0, y, 5'd0} + {1'b0, x});
        `endif
    
endmodule
