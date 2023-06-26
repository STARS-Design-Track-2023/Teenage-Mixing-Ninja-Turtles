
module oscillator (
    input logic clk,                    // clock input
    input logic n_rst,                  // reset input active low
    //input [15:0] freq_div_table [0:11], // frequency division table
    input logic [17:0] freq_C,
    input logic [17:0] freq_Cs,
    input logic [17:0] freq_D,
    input logic [17:0] freq_Ds,
    input logic [17:0] freq_E,
    input logic [17:0] freq_F,
    input logic [17:0] freq_Fs,
    input logic [17:0] freq_G,
    input logic [17:0] freq_Gs,
    input logic [17:0] freq_A,
    input logic [17:0] freq_As,
    input logic [17:0] freq_B,
    //output [15:0] counts [0:11]         // output counts
    output logic [17:0] count_out_C,
    output logic [17:0] count_out_Cs,
    output logic [17:0] count_out_D,
    output logic [17:0] count_out_Ds,
    output logic [17:0] count_out_E,
    output logic [17:0] count_out_F,
    output logic [17:0] count_out_Fs,
    output logic [17:0] count_out_G,
    output logic [17:0] count_out_Gs,
    output logic [17:0] count_out_A,
    output logic [17:0] count_out_As,
    output logic [17:0] count_out_B
    );

    //instances of clkdiv
    clkdiv #(
        .BITLEN(18)
    ) clkdiv_C (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_C),
        .cnt_out(count_out_C)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_Cs (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_Cs),

        .cnt_out(count_out_Cs)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_D (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_D),
        .cnt_out(count_out_D)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_Ds (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_Ds),
        .cnt_out(count_out_Ds)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_E (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_E),
        
        .cnt_out(count_out_E)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_F (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_F),
        
        .cnt_out(count_out_F)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_Fs (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_Fs),
        
        .cnt_out(count_out_Fs)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_G (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_G),
        
        .cnt_out(count_out_G)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_Gs (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_Gs),
        
        .cnt_out(count_out_Gs)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_A (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_A),
        
        .cnt_out(count_out_A)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_As (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_As),
        
        .cnt_out(count_out_As)
    );

    clkdiv #(
        .BITLEN(18)
    ) clkdiv_B (
        .clk(clk),
        .n_rst(n_rst),
        .lim(freq_B),
        
        .cnt_out(count_out_B)
    );
    


endmodule

////////Supporting modules////////

// module clkdiv#(
//     parameter BITLEN = 8
//     ) (
//     input logic clk,                    // clock
//     input logic n_rst,                    // active high reset 
//     input logic [BITLEN-1:0] lim,       // limit for counter
//     output logic hzX,                   // output clock
//     output logic [BITLEN-1:0] cnt_out   // counter
//     );

//     logic [BITLEN-1:0] cnt;
//     logic [BITLEN-1:0] next_cnt;
//     logic next_hzX;

//     //flip flop
//     always_ff @ (posedge clk, negedge n_rst) begin
//         if (!n_rst) begin
//             cnt <= 0;
//             hzX <= 0;
//         end
//         else
//             cnt <= next_cnt;
//             hzX <= next_hzX;
//     end

//     //combinational logic
//     always_comb begin
//         if (cnt == lim) begin
//             next_cnt = 0;
//             next_hzX = 1;
//         end
//         else begin
//             next_cnt = cnt + 1;
//             next_hzX = 0;
//         end
//     end

            

// endmodule