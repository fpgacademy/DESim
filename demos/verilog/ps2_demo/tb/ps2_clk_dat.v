// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

/* This module generates ps2_clk and ps2_dat waveforms in the same way as a
*  PS/2 keyboard would generate these signals. The signals are used to 
*  serialize the data byte provided on scan_code such that the ps2_clk and
*  ps2_dat waveforms are the same as those that a real keyboard would provide
*  if it were to send that scan_code across its PS/2 connector. */

module ps2_clk_dat (clk, reset, start_sending, scan_code, ps2_clk, ps2_dat, data_sent);

    input clk, reset, start_sending;
    input [7:0] scan_code;

    inout ps2_clk;
    inout ps2_dat;

    output data_sent;

    reg [2:0] clk_div;      // a shift register, used to create the correct timing
    reg [7:0] data;         // shift register that holds the scan_code
    reg data_ready;         // clk_div shift register runs when data_ready is 1
    reg clk_ready;          // ps2_clk is generated from clk_div when clk_ready is 1
    reg [3:0] counter;      // counts through START bit, data bits, PARITY, STOP
    reg ps2_buf;            // provides data bits for ps2_dat

    initial
    begin : Clock_Div
        clk_div <= 3'h7;    // set all bits of the shift register to 1
    end

    always @(posedge clk)   // specify the shift register. When data_ready is 1, it shifts 
                        // in the pattern 111, 110, 100, 000, 001, 011, 111, 110, ...
    begin
        clk_div[2:1] <= clk_div[1:0];
        if (data_ready) begin
            clk_div[0] <= ~clk_div[2];
        end
        else begin
            clk_div[0] <= 1'b1;
        end
    end

    always @(posedge clk)
    begin
        if (reset) begin        // reset all signals
            data <= 0;
            data_ready <= 1'b0;
            clk_ready <= 1'b0;
            counter <= 0;
            ps2_buf <= 1'b1;
        end

        else if (start_sending & ~data_ready) begin // nothing happens until start_sending is 1
            data_ready <= 1'b1;
            data <= scan_code;
            // $display("scan code %x\n", scan_code);
        end
   
        // sending ... shift/count every time clk_div == 01x), to properly sync data with ps2_clk
        else if (data_ready & ~clk_div[2] & clk_div[1]) begin
            if(counter == 0) begin
                ps2_buf <= 1'b0;                // START bit
                counter <= counter + 1'b1;
            end
            // data bits
            else if (counter < 4'b1001) begin
                // take the lowest bit
                ps2_buf <= data[0];             // Data bit
                // shift data
                data <= {data[0], data[7:1]};   // Shift the bits of scan_code
                counter <= counter + 1'b1;
            end
            else if(counter == 4'b1001) begin
                // parity bit
                ps2_buf <= (^data) ^ 1'b1;      // PARITY (odd) bit
                counter <= counter + 1'b1;
            end
            else if(counter == 4'b1010) begin
                // stop bit
                ps2_buf <= 1'b1;                // STOP bit
                counter <= counter + 1'b1;
            end
            else if(counter == 4'b1011) begin   // all bits are sent. Turn off signals
                // stop bit
                counter <= 0;
                data_ready <= 0;
                clk_ready <= 1'b0;
            end
        end
        if (data_ready & ~clk_div[2] & clk_div[1] & clk_div[0] &!clk_ready)
            clk_ready <= 1'b1;  // sync ps2_clk with START bit
    end

    assign (weak0, weak1) ps2_clk = 1'b1;   // bi-dir signal
    assign (weak0, weak1) ps2_dat = 1'b1;   // bi-dir signal
    assign ps2_clk = (clk_ready) ? clk_div[2] : 1'b1;           // output ps2_clk
    assign ps2_dat = (ps2_buf | (~data_ready)) ? 1'b1 : 1'b0;   // output ps2_dat

    assign data_sent = (counter == 4'b1011 & ~clk_div[2] & clk_div[1]); 

endmodule

