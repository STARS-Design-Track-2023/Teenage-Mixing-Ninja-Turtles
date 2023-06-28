`default_nettype none

module TMNT (
    // HW
    input logic clk, nrst,
    
    // Wrapper
    input logic cs, // Chip Select (Active Low)
    inout logic [33:0] gpio // Breakout Board Pins
);

    logic n_rst;    // Reset Signal
    //select logic
    assign n_rst = cs ? (gpio[0] ? !nrst : nrst) : 1'b0; // Assign the reset signal to the breakout board pin

    // Instantiate the top level module
    top_asic top_asic (
        .clk(clk),
        .reset(n_rst),
        .pb(gpio[15:1]),
        .sigout(gpio[16]),
        .mode_out(gpio[18:17])
    );



endmodule