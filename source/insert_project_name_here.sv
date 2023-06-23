`default_nettype none

module insert_project_name_here (
    // HW
    input logic clk, nrst,
    
    // Wrapper
    input logic cs, // Chip Select (Active Low)
    inout logic [33:0] gpio // Breakout Board Pins
);

    logic outsignal; // Output Signal
    logic n_rst;    // Reset Signal
    //select logic
    assign n_rst = cs ? nrst : 1'b0; // Assign the reset signal to the breakout board pin

    // Instantiate the top level module
    top top_inst (
        .hwclk(clk),
        .reset(n_rst),
        .pb(gpio[20:0]),
        .sigout(outsignal),
    );



endmodule