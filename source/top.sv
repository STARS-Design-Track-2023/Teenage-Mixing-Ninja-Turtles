`default_nettype none

module top 
(
  // I/O ports
  input  logic hwclk, r_eset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,
  output logic sigout,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

//inter signal
logic reset;                //reset signal
logic clk;                  // dummy clock used to set 12M to 10M
logic modekey;              //modekey signal  to be used for mode change
logic octave_up, octave_down; //octave up and down signals
logic [11:0] done;          //done signals from wave shaper
logic [1:0] mode;           //mode signal
logic [17:0] freq_div_table [11:0]; //frequency division table
logic [17:0] Count [11:0];  //counters for wave shaper from oscillator
logic [7:0] samples [11:0]; //samples from wave shaper to signal mixer
logic [11:0] sample_enable; //sample enable for signal mixer
logic [7:0] final_sample;   //final sample from signal mixer
logic start;                //start signal from wave shaper
logic pwm, pwm_out;         //pwm output

assign clk = hwclk;         // dummy clock used to set 12M to 10M
assign reset = ~r_eset;     // reset is active low
assign sample_enable = pb[11:0]; //sample enable from keypad

//keypad for modekey //good
keypad modein(
    .clk(clk),
    .n_rst(reset),
    .mode_in(pb[15]),
    .octive_in({pb[14], pb[13]}),
    .modekey(modekey),
    .octive_up(octave_up),
    .octive_down(octave_down)
);

//freq divider table //good
frequency_divider freq_div(
    .clk(clk),
    .nrst(reset),
    .o_up(octave_up),
    .o_down(octave_down),
    .div0(freq_div_table[0]),
    .div1(freq_div_table[1]),
    .div2(freq_div_table[2]),
    .div3(freq_div_table[3]),
    .div4(freq_div_table[4]),
    .div5(freq_div_table[5]),
    .div6(freq_div_table[6]),
    .div7(freq_div_table[7]),
    .div8(freq_div_table[8]),
    .div9(freq_div_table[9]),
    .div10(freq_div_table[10]),
    .div11(freq_div_table[11])
);


//sample rate clk div // good
sample_rate_clkdiv smpl_rt_clkdiv(
  .clk(clk),
  .n_rst(reset),
  .sample_now(start)
);

//oscillators
generate
  genvar i;
    for (i=0; i<12; i= i +1)begin
        oscillator osc(
            .clk(clk),
            .n_rst(reset),
            .freq_in(freq_div_table[i]),
            .count_out(Count[i])
        );
    end
endgenerate

//FSM
fsm FSM(
    .clk(clk),
    .n_rst(reset),
    .modekey(modekey),
    .mode(mode)
);

//waveshapers
generate
        for (i = 0; i < 12; i = i + 1) begin
            waveshaper wave_shpr(
                .clk(clk),
                .nrst(reset),
                .fd(freq_div_table[i]),
                .count(Count[i]),
                .mode(mode),
                .start(start),
                .signal(samples[i]),
                .done(done[i])
            );
        end
endgenerate


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
  .start(|done),
  .final_in(final_sample),
  .pwm_out(pwm)
);

//output logic
always_ff @(posedge clk)
  pwm_out <= pwm;

assign {left,right} = Count[0][15:0];
assign red = start; // red led



endmodule
