`default_nettype none


module signal_mixr(
    //inputs
    input logic [7:0] samples_in [11:0],    //12 samples 8bit each
    input logic [11:0] sample_enable,       //12 samples enable
    //outputs
    output logic [7:0] sample_out           //1 sample 8bit output
    );
    
    //internal signals
    integer i;
    logic [11:0] accumulator;
    
    //sum all the samples
    for (i = 0; i < 12; i=i+1) begin
        if (sample_enable[i]) begin
            accumulator = accumulator + samples_in[i];
        end
    end
    
    //saturation arithmetic
    if (accumulator > 255) begin //overflow
        accumulator = 255;
    end else if (accumulator < 0) begin //underflow
        accumulator = 0;
    end 
    
    sample_out = accumulator[7:0];


endmodule
