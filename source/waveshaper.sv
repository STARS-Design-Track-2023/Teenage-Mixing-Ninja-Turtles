`default_nettype none


module waveshaper(
    //inputs
    logic [15:0] fd,
    logic [15:0] count,
    logic [1:0] mode,
    logic start,
    logic clk,
    logic rst,
    //outputs
    logic [7:0] signal
);

//internal signals
logic [7:0] quotient;

//your code here

    sequential_div div(
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .dividend(count << 6),
        .divisor({6'b0, fd}),
        .fin_quo(quotient)
    );



case(mode)
    2'b00: begin
        //off
        signal = 0;
    end
    2'b01: begin
        //square
        signal = (count > fd/2);
    end
    2'b10: begin
        //triangle
        signal = (count > fd/2) ? (2 * quotient) : 128 - (2 * quotient);
    end
    2'b11: begin
        //sawtooth
        signal = quotient;
    end



endmodule


module sequential_div(
input logic clk,              // clock
    input logic rst,              // reset
    input logic start,            // start calculation
    output     logic done,             // calculation is complete (high for one tick)
    input logic [WIDTH - 1:0] dividend,    // dividend (numerator)
    input logic [WIDTH - 1:0] divisor,    // divisor (denominator)
    output     logic [WIDTH - 14:0] fin_quo,  // result value: quotient
    output     logic [WIDTH - 1:0] rem   // result: remainder
    );

    logic [WIDTH - 1:0] b1;             // copy of divisor
    logic [WIDTH - 1:0] quo, quo_next;  // intermediate quotient
    logic [WIDTH:0] acc, acc_next;    // accumulator (1 bit wider)
    logic [$clog2(WIDTH)-1:0] i;      // iteration counter
    logic busy;                       // calculation in progress

    // division algorithm iteration
    always_comb begin
        if (acc >= {1'b0, b1}) begin
            acc_next = acc - b1;
            {acc_next, quo_next} = {acc_next[WIDTH - 1:0], quo, 1'b1};
        end else begin
            {acc_next, quo_next} = {acc, quo} << 1;
        end
    end

    // calculation control
    always_ff @(posedge clk) begin
        done <= 0;
        if (start) begin
            i <= 0;
            if (divisor == 0) begin  // catch divide by zero
                busy <= 0;
                done <= 1;
            end else begin
                busy <= 1;
                b1 <= divisor;
                {acc, quo} <= {{WIDTH{1'b0}}, dividend, 1'b0};  // initialize calculation
            end
        end else if (busy) begin
            if (i == WIDTH - 1) begin  // we're done
                busy <= 0;
                done <= 1;
                fin_quo <= quo_next;
                rem <= acc_next[WIDTH:1];  // undo final shift

            end else begin  // next iteration
                i <= i + 1;
                acc <= acc_next;
                quo <= quo_next;
            end
        end
        if (rst) begin
            busy <= 0;
            done <= 0;
            fin_quo <= 0;
            rem <= 0;
        end
    end
endmodule
