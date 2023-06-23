`default_nettype none

module top 
(
  // I/O ports
  input  logic hwclk, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

//inter signal
logic modekey;              //modekey signal  to be used for mode change
logic clk;                  // dummy clock used to set 12M to 10M
logic [15:0] Count [11:0];  //counters for wave shaper from oscillator
logic [7:0] samples [11:0]; //samples from wave shaper to signal mixer
logic [11:0] sample_enable; //sample enable for signal mixer
logic [7:0] final_sample;   //final sample from signal mixer
logic start;                //start signal from wave shaper
logic pwm, pwm_out;         //pwm output

//keypad for modekey
keypad modein(
  .clk(clk),
  .n_rst(reset),
  .in(pb[15]),
  .modekey(modekey)
);

//freq divider table
logic [15:0] freq_div_table [11:0]= {
  16'd38223, //C
  16'd36077, //C#
  16'd34052, //D
  16'd32141, //D#
  16'd30337, //E
  16'd28635, //F
  16'd27027, //F#
  16'd25511, //G
  16'd24079, //G#
  16'd22727, //A
  16'd21452, //A#
  16'd20248  //B
};


//sample rate clk div
sample_rate_clkdiv sample_rate_clkdiv(
  .clk(clk),
  .n_rst(reset),
  .sample_now(start)
);

//oscillators
oscillator osc(
  .clk(clk),
  .n_rst(reset),
  .freq_div_table(freq_div_table),
  .counts(Count)
);

//waveshapers


//signal mixer
signal_mixer mixer(
    .sample1(samples[0]),
    .sample2(samples[1]),
    .sample3(samples[2]),
    .sample4(samples[3]),
    .sample5(samples[4]),
    .sample6(samples[5]),
    .sample7(samples[6]),
    .sample8(samples[7]),
    .sample9(samples[8]),
    .sample10(samples[9]),
    .sample11(samples[10]),
    .sample12(samples[11]),
    .sample_enable(sample_enable),
    .sample_out(final_sample)
);

//pwm
pwm PWM(
  .clk(clk),
  .n_rst(reset),
  .start(start),
  .final_in(final_sample),
  .pwm_out(pwm)
);

//output logic
always_ff @(posedge clk)
  pwm_out <= pwm;


endmodule

/////////////////////////////////////////
///////     Extra Modules Here  /////////
/////////////////////////////////////////


////////////////Keypad Module/////////////

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

/////  Sample Rate Divider Module  ///////
module sample_rate_clkdiv(
    //inputs
    input logic clk,                   // clock
    input logic n_rst,                 // active high reset
    //outputs
    output logic sample_now            // sample now
    );

    //internal signals
    clkdiv #(
        .BITLEN(8)
    ) clkdiv_inst (
        .clk(clk),
        .n_rst(n_rst),
        .lim(255),
        .hzX(sample_now),
        .cnt_out()
    ); 

endmodule


/////////// Oscillator Module ////////////
module oscillator (
    input logic clk,                    // clock input
    input logic n_rst,                  // reset input active low
    input [15:0] freq_div_table [0:11], // frequency division table
    output [15:0] counts [0:11]         // output counts
    );

    generate
        genvar i;
        for (i = 0; i < 12; i++) begin
            clkdiv #(.BITLEN(16)) clkdiv_inst (
                .clk(clk),
                .n_rst(n_rst),
                .lim(freq_div_table[i]),
                .hzX(),
                .cnt_out(counts[i])
            );
        end
    endgenerate


endmodule

/////////// Wave Shaper Module ///////////


/////////// Signal Mixer Module //////////
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
    assign sample_out = accumulator[7:0];

endmodule

/////////// PWM Module ///////////////////

module pwm(
    //inputs
    input logic clk,            //clock
    input logic n_rst,          //active low reset
    input logic start,          //start signal from wave shaper
    input logic [7:0] final_in, //final input from signal mixer
    //outputs
    output logic pwm_out         //pwm output
    );

    //internal signals
    logic [7:0] final_sample_in;     //sample input from signal mixer
    logic [7:0] counter;            //counter for pwm
    logic [7:0] next_counter;       //next counter for pwm
    logic next_pwm_out;             //next pwm output

    //Flip flop for pwm
    always_ff @(posedge clk, posedge n_rst) begin
        if (n_rst) begin
            if (start) begin
                final_sample_in <= final_in;
                counter <= next_counter;
                pwm_out <= next_pwm_out;
            end
            else begin
                final_sample_in <= 8'b0;
                counter <= 8'b0;
                pwm_out <= 1'b0;
            end
        end
    end

    //comb logic for pwm
    always_comb begin
        //next counter
        if(counter == 255)
            next_counter = 8'b0;
        else
            next_counter = counter + 1;

        //next pwm output
        if( counter <= final_sample_in)
            next_pwm_out = 1'b1;
        else
            next_pwm_out = 1'b0;
    end

endmodule

//////////// Clock Div Module ////////////
module clkdiv#(
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
