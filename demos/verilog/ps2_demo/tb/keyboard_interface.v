// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

/*
*   Keyboard interface
*   NOTICE: this module only includes basic functionality of PS2 keyboard receiving command and sending data,
*           ps2 clock period is set to 4 times of CLOCK_PERIOD (clock_50)
*
*   NOT IMPLEMENTED: host aborting command, host interrupting data sending, 
                     response to some of the commands fromm host (e.g. set scan code set, set repeat rate, etc.)
*/

module keyboard_interface (
    // input
	clk, 
	reset, 
	key_action, 
	scan_code, 

    // bidirectional
	ps2_clk, 
	ps2_dat, 

    // output
	lock_controls
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

// Timing info for initiating Host-to-Device communication 
//   when using a 50MHz system clock
parameter CLOCK_CYCLES_FOR_100US   = 5000;
parameter NUMBER_OF_BITS_FOR_100US = 13;

parameter CMD_LED                  = 8'hed;
parameter CMD_ECHO                 = 8'hee;
parameter CMD_CODE_SET             = 8'hf0; 
parameter CMD_REPEAT_RATE          = 8'hf3; 
parameter CMD_ENABLE               = 8'hf4;
parameter CMD_DISABLE              = 8'hf5;
parameter CMD_RESEND               = 8'hfe;

parameter ACK_CODE                 = 8'hfa;
parameter ECHO_CODE                = 8'hee;

localparam KB_STATE_0_IDLE         = 3'h0,
           KB_STATE_1_LOAD_DATA    = 3'h1, 
           KB_STATE_2_DATA_OUT     = 3'h2,
           KB_STATE_3_CMD_IN       = 3'h3,
           KB_STATE_4_CMD_END      = 3'h4, // handle command
           KB_STATE_5_RESPONSE     = 3'h5,
           KB_STATE_6_CLK_LOW      = 3'h6;

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// input
input              clk;
input              reset;
input              key_action;
input      [ 7: 0] scan_code;

// bidirectional
inout              ps2_clk;
inout              ps2_dat;

// output
output reg [ 2: 0] lock_controls;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire               start_sending;
wire               sent_data_en;
wire               start_receiving;
wire               received_cmd_en;
wire       [ 7: 0] command_received;

// Internal Registers
reg                disable_control;

// next data to send
reg        [ 7: 0] next_to_send;
// command being processed
reg        [ 7: 0] command_to_process;

reg        [ 7: 0] keyboard_buffer [0:15];
reg        [ 4: 0] buffer_length;  


// State Machine Registers
reg		[2:0]	s_kb_transceiver;
reg		[2:0]	ns_kb_transceiver;

// Integers
integer i;

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

always @(posedge clk) begin
    if (reset == 1'b1)
        s_kb_transceiver <= KB_STATE_0_IDLE;
    else
        s_kb_transceiver <= ns_kb_transceiver;
end




always @(*)
begin
    ns_kb_transceiver = KB_STATE_0_IDLE;

    case(s_kb_transceiver)
    KB_STATE_0_IDLE:
        begin
            // host brings clk low
            if(ps2_clk == 1'b0)
                ns_kb_transceiver = KB_STATE_6_CLK_LOW;
            
            // key pressed
            else if( (buffer_length > 0) && (disable_control == 1'b0)) begin
                ns_kb_transceiver = KB_STATE_1_LOAD_DATA;
            end
            else
                ns_kb_transceiver = KB_STATE_0_IDLE;
        end

    KB_STATE_1_LOAD_DATA:
        begin
            ns_kb_transceiver = KB_STATE_2_DATA_OUT;
        end

    KB_STATE_2_DATA_OUT:
        begin
            if(sent_data_en == 1'b1)
                ns_kb_transceiver = KB_STATE_0_IDLE;
            else
                ns_kb_transceiver = KB_STATE_2_DATA_OUT;
        end

    KB_STATE_3_CMD_IN:
        begin
            if(received_cmd_en == 1'b1) 
                ns_kb_transceiver = KB_STATE_4_CMD_END;
            else
                ns_kb_transceiver = KB_STATE_3_CMD_IN; 
        end
    KB_STATE_4_CMD_END:
        begin
            if(command_to_process == 8'h0) begin
                case(command_received)
                CMD_ECHO:
                    begin
                        ns_kb_transceiver = KB_STATE_5_RESPONSE;
                    end
                CMD_LED:
                    begin
                        ns_kb_transceiver = KB_STATE_5_RESPONSE; 
                    end
                CMD_ENABLE:
                    begin
                        ns_kb_transceiver = KB_STATE_5_RESPONSE;
                    end
                CMD_DISABLE:
                    begin
                        ns_kb_transceiver = KB_STATE_5_RESPONSE;
                    end
                default:
                    begin
                        ns_kb_transceiver = KB_STATE_0_IDLE;
                    end
                endcase
            end
            // if it's the second byte of command
            else begin
                ns_kb_transceiver = KB_STATE_0_IDLE;
            end
        end
    KB_STATE_5_RESPONSE:
        begin
            if(sent_data_en == 1'b1) begin
                ns_kb_transceiver = KB_STATE_0_IDLE;
            end
            else
                ns_kb_transceiver = KB_STATE_5_RESPONSE;
        end

    KB_STATE_6_CLK_LOW:
        begin
            if(ps2_clk == 1'b0) begin
                ns_kb_transceiver = KB_STATE_6_CLK_LOW;
            end 
            // Data low, clock high: Host Request-to-Send
            else if (ps2_dat == 1'b0) begin
                ns_kb_transceiver = KB_STATE_3_CMD_IN;
            end
            // Data high, clock high
            else
                ns_kb_transceiver = KB_STATE_0_IDLE; 
        end
    endcase
end

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

initial begin
    disable_control <= 1'b0;
end
always @(posedge clk) begin
    if (reset == 1'b1)
        disable_control = 1'b0;
	else if(s_kb_transceiver == KB_STATE_4_CMD_END) begin
        if(command_to_process == 8'h0) begin
            if (command_received == CMD_ENABLE)
                disable_control = 1'b0;
            else if (command_received == CMD_DISABLE)
                disable_control = 1'b1;
		end
	end
end

initial begin
    command_to_process <= 8'h0;
end
always @(posedge clk) begin
    if (reset == 1'b1)
        command_to_process <= 8'h0;
	else if(s_kb_transceiver == KB_STATE_4_CMD_END) begin
        if ((command_to_process == 8'h0) && (command_received == CMD_LED))
            command_to_process <= command_received;

        // if it's the second byte of command
        else
            command_to_process <= 8'h0;
	end
end

initial begin
    lock_controls <= 0;
end
always @(posedge clk) begin
    if (reset == 1'b1)
        lock_controls <= 3'h0;
	else if(s_kb_transceiver == KB_STATE_4_CMD_END) begin
        if (command_to_process != 8'h0)
            lock_controls <= command_received[2:0];
	end
end

initial begin
    buffer_length <= 0;
    for (i=0; i <= 15; i=i+1) begin
        keyboard_buffer[i] <= 0;
    end
end
always @(posedge clk) begin
	if (reset == 1'b1) begin
        buffer_length <= 0;

        for (i=0; i <= 15; i=i+1) begin
            keyboard_buffer[i] <= 0;
        end
	end
	else if(s_kb_transceiver != KB_STATE_1_LOAD_DATA) begin
        if(key_action) begin
            // i.e. buffer not full
            if(buffer_length[4] == 1'b0) begin
                keyboard_buffer[buffer_length] <= scan_code; 
                buffer_length <= buffer_length + 1'b1;
            end 
        end
	end
    else begin
        buffer_length <= buffer_length - 1;

        for (i=0; i < 15; i=i+1) begin
            keyboard_buffer[i] <= keyboard_buffer[i+1];
        end
        keyboard_buffer[15] <= 8'h0;
    end
end


initial begin
    next_to_send <= 8'h0;
end
always @(posedge clk) begin
    if (reset == 1'b1)
        next_to_send <= 8'h0;
	else if(s_kb_transceiver == KB_STATE_1_LOAD_DATA)
        next_to_send = keyboard_buffer[0];
	else if(s_kb_transceiver == KB_STATE_4_CMD_END) begin
        if(command_to_process == 8'h0) begin
            case(command_received)
            CMD_ECHO:
                begin
                    next_to_send = ECHO_CODE;
                end
            CMD_LED:
                begin
                    next_to_send = ACK_CODE;
                end
            CMD_ENABLE:
                begin
                    next_to_send = ACK_CODE;
                end
            CMD_DISABLE:
                begin
                    next_to_send = ACK_CODE;
                end
            default:
                begin
                    next_to_send = 8'h0;
                end
            endcase
        end
    end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign start_receiving = (s_kb_transceiver == KB_STATE_3_CMD_IN);
assign start_sending = (s_kb_transceiver == KB_STATE_5_RESPONSE) || (s_kb_transceiver == KB_STATE_2_DATA_OUT);

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/


ps2_data_out data_out (
    // input
    .clk(clk),
    .reset(reset),
    .start_sending(start_sending),
    .scan_code(next_to_send),

    // bidirectional
    .ps2_clk(ps2_clk),
    .ps2_dat(ps2_dat),

    // output
    .data_sent(sent_data_en)
);



ps2_command_in command_in (
    // input
    .clk(clk),
    .reset(reset),
    .start_receiving(start_receiving),

    // bidirectional
    .ps2_clk(ps2_clk),
    .ps2_dat(ps2_dat),

    // output
    .command(command_received),
    .received(received_cmd_en)
);

endmodule

