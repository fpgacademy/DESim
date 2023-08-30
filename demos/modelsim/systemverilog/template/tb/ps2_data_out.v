// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

/*
*   Keyboard interface submodule
*   see keyboard_interface.v for more details
*/

module ps2_data_out (
    // input
	clk, 
	reset, 
	start_sending, 
	scan_code, 

    // bidirectional
	ps2_clk, 
	ps2_dat, 

    // output
	data_sent
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// input
input         clk;
input         reset;
input         start_sending;
input [ 7: 0] scan_code;

// bidirectional
inout         ps2_clk;
inout         ps2_dat;

// output
output        data_sent;


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

reg   [ 2: 0] clk_div;
reg   [ 7: 0] data;
reg           data_ready;
reg   [ 3: 0] counter;
reg           ps2_buf;


/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

initial
begin : Clock_Div
    clk_div <= 3'h7;
end
always @(posedge clk)
begin
    clk_div[2:1] <= clk_div[1:0];
    if (data_ready)
        clk_div[0] <= ~clk_div[2];
    else
        clk_div[0] <= 1'b1;
end

always @(posedge clk)
begin
    if (reset) begin
        data <= 0;
        data_ready <= 1'b0;
        counter <= 0;
        ps2_buf <= 1'b1;
    end

    else if(start_sending & ~data_ready) begin
        data_ready <= 1'b1;
        data <= scan_code;
        // $display("scan code %x\n", scan_code);
    end
   

    // not reset
    else if (data_ready & ~clk_div[2] & clk_div[1]) begin
    
        if(counter == 0) begin
            ps2_buf <= 1'b0;
            counter <= counter + 1'b1;
        end
        // data bits
        else if (counter < 4'b1001) begin
            // take the lowest bit
            ps2_buf <= data[0];
            // shift data
            data <= {data[0], data[7:1]};
            counter <= counter + 1'b1;
        end
        else if(counter == 4'b1001) begin
            // parity bit
            ps2_buf <= (^data) ^ 1'b1;
            counter <= counter + 1'b1;
        end
        else if(counter == 4'b1010) begin
            // stop bit
            ps2_buf <= 1'b1;
            counter <= 0;
            data_ready <= 0;
        end
    end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign (weak0, weak1) ps2_clk    = 1'b1;
assign (weak0, weak1) ps2_dat   = 1'b1; 
assign ps2_clk = (clk_div[2] | (~data_ready)) ? 1'bz : 1'b0;
assign ps2_dat = (ps2_buf | (~data_ready)) ? 1'bz : 1'b0;

assign data_sent = (counter == 4'b1010 & ~clk_div[2] & clk_div[1]); 

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

endmodule

