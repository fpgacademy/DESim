// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

/*
*   Keyboard interface submodule
*   see keyboard_interface.v for more details
*/

module ps2_command_in (
    // input
	clk, 
	reset, 
	start_receiving, 

    // bidirectional
	ps2_clk, 
	ps2_dat, 

    // output
	command, 
	received
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// input
input              clk;
input              reset;
input              start_receiving;

// bidirectional
inout              ps2_clk;
inout              ps2_dat;

// output
output reg [ 7: 0] command;
output             received;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

reg                process_cmd;
wire               acknowledge; // control ps2_dat to send ack bit
reg        [ 3: 0] counter;
reg        [ 2: 0] clk_div;


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
    if (process_cmd)
        clk_div[0] <= ~clk_div[2];
    else
        clk_div[0] <= 1'b1;
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        counter <= 4'b0;
        command <= 8'b0;
        process_cmd <= 1'b0;
    end

    else if(~process_cmd & start_receiving) begin
        process_cmd <= 1'b1;
    end
    
    // after (posedge ps2_clk)
    else if(process_cmd & clk_div[2] & ~clk_div[1] & ps2_clk) begin
        if(counter == 0) begin
            counter <= counter + 1'b1;
        end
        // read in command
        else if (counter < 4'b1001) begin
            command[counter-1] <= ps2_dat;
            counter <= counter + 1'b1;
        end
        // parity
        else if(counter == 4'b1001) begin
            // check for parity bit (^command) ^ 1'b1;
            counter <= counter + 1'b1;
        end
        // stop bit
        else if(counter == 4'b1010) begin
            counter <= counter + 1'b1;
        end
        else if(counter == 4'b1011) begin
            // acknowledge
            counter <= counter + 1'b1;
        end
        else if(counter == 4'b1100) begin
            process_cmd <= 1'b0;
            counter <= 0;
        end
    end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign (weak0, weak1) ps2_clk   = 1'b1;
assign (weak0, weak1) ps2_dat   = 1'b1; 
assign ps2_clk = (clk_div[2] | (~process_cmd)) ? 1'bz : 1'b0;
assign ps2_dat = (process_cmd & acknowledge) ? 1'b0 : 1'bz;

assign received    = (counter == 4'b1100) & clk_div[2] & clk_div[1]; // before (posedge ps2_clk)
assign acknowledge = (counter == 4'b1100) & (ps2_clk == 1'b0);

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

endmodule

