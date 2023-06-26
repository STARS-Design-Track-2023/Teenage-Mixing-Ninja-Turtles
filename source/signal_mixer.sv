`default_nettype none

module signal_mixer(
    //inputs
    input logic [7:0] sample1 ,    
    input logic [7:0] sample2 ,
    input logic [7:0] sample3 ,
    input logic [7:0] sample4 ,
    input logic [7:0] sample5 ,
    input logic [7:0] sample6 ,
    input logic [7:0] sample7 ,
    input logic [7:0] sample8 ,
    input logic [7:0] sample9 ,
    input logic [7:0] sample10 ,
    input logic [7:0] sample11 ,
    input logic [7:0] sample12 ,
                                            // 12 samples 8-bit input
    input logic [11:0] sample_enable,       //12 samples enable
    //outputs
    output logic [7:0] sample_out           //1 sample 8-bit output
    );
    
    //internal signals 
    logic [8:0] accumulator;          // 8-bit accumulator for each sample
    logic [7:0] samples [11:0];            // 12 samples 8-bit input


    //assign the samples to the internal signals
    assign samples[0] = sample_enable[0] ? sample1 : 0;
    assign samples[1] = sample_enable[1] ? sample2 : 0;
    assign samples[2] = sample_enable[2] ? sample3 : 0;
    assign samples[3] = sample_enable[3] ? sample4 : 0;
    assign samples[4] = sample_enable[4] ? sample5 : 0;
    assign samples[5] = sample_enable[5] ? sample6 : 0;
    assign samples[6] = sample_enable[6] ? sample7 : 0;
    assign samples[7] = sample_enable[7] ? sample8 : 0;
    assign samples[8] = sample_enable[8] ? sample9 : 0;
    assign samples[9] = sample_enable[9] ? sample10 : 0;
    assign samples[10] = sample_enable[10] ? sample11 : 0;
    assign samples[11] = sample_enable[11] ? sample12 : 0;
    
    //sum all the enabled samples
    assign accumulator = samples[0] + samples[1] + samples[2] + samples[3] + samples[4] + samples[5] + samples[6] + samples[7] + samples[8] + samples[9] + samples[10] + samples[11];

    // Assign the output as the sum of all the enabled samples
    always_comb begin
        if (accumulator >= 255)
            sample_out = 255;
        else
            sample_out = accumulator;
    end


endmodule
