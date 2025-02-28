// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

/*
 * This module provides the basic functionality of a PS/2 keyboard.
 *   Inputs:
 *       Clock, Resetn
 *       key_action: this signal is set to 1 whenever scan_code is valid
 *       scan_code: the KEY corresponding to key_action
 *   Outputs:
         ps2_clk, ps2_dat: waveforms output corresponding to the scancode (d7, ..., d0):
             START (0), d0, d1, d2, d3, d4, d5, d6, d7, PARITY (odd), STOP (1)
 *       Note: ps2_clk frequency is 6 times slower than Clock
*/

module PS2_keyboard (Clock, Resetn, key_action, scan_code, ps2_clk, ps2_dat);
    localparam KB_0_IDLE         = 3'h0,
               KB_1_LOAD_DATA    = 3'h1, 
               KB_2_DATA_OUT     = 3'h2;
    
    input Clock, Resetn, key_action;
    input [7:0] scan_code;
    
    inout ps2_clk;
    inout ps2_dat;
    
    wire start_sending;                 // set to 1 at start of a scan_code
    wire sent_data_en;                  // set to 1 at end of a scan_code
    
    reg [7:0] next_to_send;             // next scan_code to send
    reg [7:0] keyboard_FIFO [0:15];     // FIFO memory to hold scan_code bytes
    reg [4:0] FIFO_depth;               // number of scan_code bytes to send
    
    
    reg [2:0] y_Q;                      // FSM present state
    reg [2:0] Y_D;                      // FSM next state
    
    // Integers
    integer i;
    
    // FSM flip-flops
    always @(posedge Clock) begin
        if (Resetn == 1'b0)
            y_Q <= KB_0_IDLE;
        else
            y_Q <= Y_D;
    end
    
    // FSM state table
    always @(*)
    begin
        Y_D = KB_0_IDLE;    // default
    
        case(y_Q)
            KB_0_IDLE: begin
                if (FIFO_depth > 0)                 // scan_code(s) received
                    Y_D = KB_1_LOAD_DATA;
                else
                    Y_D = KB_0_IDLE;
            end
    
            KB_1_LOAD_DATA: begin
                Y_D = KB_2_DATA_OUT;
            end
    
            KB_2_DATA_OUT: begin
                if (sent_data_en == 1'b1)
                    Y_D = KB_0_IDLE;
                else
                    Y_D = KB_2_DATA_OUT;
            end
    
        endcase
    end
    
    // Sequential Logic
    
    always @(posedge Clock) begin                   // reset
    	if (Resetn == 1'b0) begin
            FIFO_depth <= 0;
    
            for (i=0; i <= 15; i=i+1)
                keyboard_FIFO[i] <= 0;
    	end
    	else if (y_Q != KB_1_LOAD_DATA) begin       // can insert into FIFO
            if (key_action) begin                   // scan_code available?
                if (FIFO_depth[4] == 1'b0) begin    // if FIFO not full
                    keyboard_FIFO[FIFO_depth] <= scan_code; 
                    FIFO_depth <= FIFO_depth + 1'b1;
                end 
            end
    	end
        else begin                                          // top of FIFO removed
            FIFO_depth <= FIFO_depth - 1;
    
            for (i=0; i < 15; i=i+1) begin
                keyboard_FIFO[i] <= keyboard_FIFO[i+1];     // shift FIFO
            end
            keyboard_FIFO[15] <= 8'h0;
        end
    end
    
    always @(posedge Clock) begin
        if (Resetn == 1'b0)
            next_to_send <= 8'h0;
    	else if (y_Q == KB_1_LOAD_DATA)
            next_to_send = keyboard_FIFO[0];
    end
    
    assign start_sending = (y_Q == KB_2_DATA_OUT);
    
    ps2_clk_dat data_out (.clk(Clock), .reset(~Resetn), .start_sending(start_sending),
        .scan_code(next_to_send), .ps2_clk(ps2_clk), .ps2_dat(ps2_dat), 
        .data_sent(sent_data_en));

endmodule
