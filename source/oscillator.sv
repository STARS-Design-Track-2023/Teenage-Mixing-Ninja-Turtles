
module oscillator (
    input logic clk,                    // clock input
    input logic n_rst,                  // reset input active low
    input [15:0] freq_div_table [0:11], // frequency division table
    output [15:0] counts [0:11]         // output counts
    );

    generate
        genvar i;
        for (i = 0; i < 12; i++) begin
            clkDiv #(.BITLEN(16)) clkDiv_inst (
                .clk(clk),
                .n_rst(n_rst),
                .lim(freq_div_table[i]),
                .hzX(),
                .cnt_out(counts[i])
            );
        end
    endgenerate


endmodule

////////Supporting modules////////

module clkDiv#(
    parameter BITLEN = 8
    ) (
    input logic clk,                    // clock
    input logic n_rst,                    // active high reset 
    input logic [BITLEN-1:0] lim,       // limit for counter
    output logic hzX,                   // output clock
    output logic [BITLEN-1:0] cnt_out   // counter
    );

    logic [BITLEN-1:0] cnt;
    logic [BITLEN-1:0] next_cnt;
    logic next_hzX;

    //flip flop
    always_ff @ (posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            cnt <= 0;
            hzX <= 0;
        end
        else
            cnt <= next_cnt;
            hzX <= next_hzX;
    end

    //combinational logic
    always_comb begin
        if (cnt == lim) begin
            next_cnt = 0;
            next_hzX = 1;
        end
        else begin
            next_cnt = cnt + 1;
            next_hzX = 0;
        end
    end

            

endmodule