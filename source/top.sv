`default_nettype none

module top 
(
  // I/O ports
  input  logic hwclk, reset,
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
logic clk;                  // dummy clock used to set 12M to 10M
logic modekey;              //modekey signal  to be used for mode change
logic octave_up, octave_down; //octave up and down signals
logic [11:0] done;          //done signals from wave shaper
logic [1:0] mode;           //mode signal
logic [15:0] freq_div_table [0:11]; //frequency division table
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
    .mode_in(pb[15]),
    .octive_in({pb[14], pb[13]}),
    .modekey(modekey),
    .octive_up(octave_up),
    .octive_down(octave_down)
);

//freq divider table
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
  //freq div table
  .freq_C(freq_div_table[0]),
    .freq_Cs(freq_div_table[1]),
    .freq_D(freq_div_table[2]),
    .freq_Ds(freq_div_table[3]),
    .freq_E(freq_div_table[4]),
    .freq_F(freq_div_table[5]),
    .freq_Fs(freq_div_table[6]),
    .freq_G(freq_div_table[7]),
    .freq_Gs(freq_div_table[8]),
    .freq_A(freq_div_table[9]),
    .freq_As(freq_div_table[10]),
    .freq_B(freq_div_table[11]),
    //counters
  .count_out_C(Count[0]),
    .count_out_Cs(Count[1]),
    .count_out_D(Count[2]),
    .count_out_Ds(Count[3]),
    .count_out_E(Count[4]),
    .count_out_F(Count[5]),
    .count_out_Fs(Count[6]),
    .count_out_G(Count[7]),
    .count_out_Gs(Count[8]),
    .count_out_A(Count[9]),
    .count_out_As(Count[10]),
    .count_out_B(Count[11])
);


//FSM
fsm FSM(
    .clk(clk),
    .n_rst(reset),
    .modekey(modekey),
    .mode(mode)
);

//waveshapers
generate
    genvar i;
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


endmodule
