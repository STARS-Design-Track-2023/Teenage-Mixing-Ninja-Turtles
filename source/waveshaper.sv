`default_nettype none


module waveshaper(
    //inputs
    logic [15:0] fd1, fd2, fd3, fd4, fd5, fd6, fd7, fd8, fd9, fd10, fd11, fd12;
    logic [15:0] count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12;
    logic [1:0] mode;
    logic start;
    logic clk;
    logic rst;
    //outputs
    logic [7:0] signal [11:0];
);

//internal signals
logic [7:0] quotient [11:0];

//your code here
for (int i=0; i<11; i++) begin
    sequential_div div(
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .dividend(count[i] << 6),
        .divisor({6'b0, fd[i]}),
        .fin_quo(quotient[i]),
        
    );
end


case(mode)
    2'b00: begin
        //off
        signal = 0;
    end
    2'b01: begin
        //square
        signal = (count > fd/2)
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
input wire logic clk,              // clock
    input wire logic rst,              // reset
    input wire logic start,            // start calculation
    output     logic done,             // calculation is complete (high for one tick)
    input wire logic [WIDTH - 1:0] dividend,    // dividend (numerator)
    input wire logic [WIDTH - 1:0] divisor,    // divisor (denominator)
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
