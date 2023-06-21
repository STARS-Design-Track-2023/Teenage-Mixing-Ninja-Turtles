`default_nettype none


module keypad(
    //inputs
    input logic clk,        //clock
    input logic n_rst,      // active low reset  
    input logic in,         //input signal pb[15]
    output logic modekey    //output signal modekey
    );

//internal signals
logic [1:0] delay;

always_ff @( posedge clk, posedge n_rst ) begin : blockName
    if (n_rst) 
        delay <= {delay[0], in};
    else 
        delay <= 2'b00;
end

//posedge detection
assign modekey = delay[0] & ~delay[1];


endmodule