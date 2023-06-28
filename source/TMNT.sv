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
    assign n_rst = cs ? nrst : 1'b0; // Assign the reset signal to the breakout board pin

    // Instantiate the top level module
    top_asic top_asic (
        .hwclk(clk),
        .r_eset(n_rst),
        .pb(gpio[15:1]),
        .sigout(gpio[17]),
    );



endmodule