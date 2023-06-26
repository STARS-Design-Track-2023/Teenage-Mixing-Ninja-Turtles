`default_nettype none


module keypad(
    //inputs
    input logic clk,                   //clock
    input logic n_rst,                 // active low reset  
    input logic mode_in,               //input signal pb[15]
    input logic [1:0] octive_in,       //input signal pb[14], pb[13]
    output logic modekey,              //output signal modekey
    output logic octive_up,            //output logic octive_up
    output logic octive_down           //output logic octive_down
    );

//internal signals
logic [1:0] delay_in;
logic [1:0] delay_octive_up_in;
logic [1:0] delay_octive_down_in;

always_ff @( posedge clk, negedge n_rst ) begin : mode_edge_detection
    if (n_rst) 
        delay_in <= {delay_in[0], mode_in};
    else 
        delay_in <= 2'b00;
end

always_ff @( posedge clk, negedge n_rst ) begin : octive_up_edge_detection
    if (n_rst) 
        delay_octive_up_in <= {delay_octive_up_in[0], octive_in[1]};
    else 
        delay_octive_up_in <= 2'b00;
end

always_ff @( posedge clk, negedge n_rst ) begin : octive_down_edge_detection
    if (n_rst) 
        delay_octive_down_in <= {delay_octive_down_in[0], octive_in[0]};
    else 
        delay_octive_down_in <= 2'b00;
end

//posedge detection
assign modekey = delay_in[0] & ~delay_in[1];
assign octive_up = delay_octive_up_in[0] & ~delay_octive_up_in[1];
assign octive_down = delay_octive_down_in[0] & ~delay_octive_down_in[1];

endmodule