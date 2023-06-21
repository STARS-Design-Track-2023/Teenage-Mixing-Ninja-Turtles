`default_nettype none

module signal_mixr(
    //inputs
    input logic [7:0] samples_in [11:0],    //12 samples 8-bit each
    input logic [11:0] sample_enable,       //12 samples enable
    //outputs
    output logic [7:0] sample_out           //1 sample 8-bit output
    );
    
    //internal signals
    logic [8:0] accumulator;
    

    //sum all the samples
    always_comb begin
        accumulator = 0;
        for (int i = 0; i < 12; i++) begin
            if (sample_enable[i]) begin
                accumulator += samples_in[i];
            end
        end
    end
    
    // Assign the output as the sum of all the enabled samples
    assign sample_out = accumulator[7:0];

endmodule
