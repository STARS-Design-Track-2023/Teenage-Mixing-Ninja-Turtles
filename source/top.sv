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
logic [15:0] Count [11:0];  //counters for wave shaper
logic [7:0] samples [11:0]; //samples from wave shaper
logic [11:0] sample_enable; //sample enable from wave shaper
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

//oscillators

//waveshapers

//signal mixer
signal_mixr mixer(
  .samples_in(samples),
  .sample_enable(sample_enable),
  .sample_out(final_sample)
);

//pwm
pwm pwm(
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


/////////// Oscillator Module ////////////


/////////// Wave Shaper Module ///////////


/////////// Signal Mixer Module //////////
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
        if(count == 255)
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