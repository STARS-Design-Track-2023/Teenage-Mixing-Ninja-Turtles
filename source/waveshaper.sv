`default_nettype none

module waveshaper(
  //inputs
  input logic [15:0] fd,
  input logic [15:0] count,
  input logic [1:0] mode,
  input logic start,
  input logic clk,
  input logic nrst,
  //outputs
  output logic [7:0] signal,
  output logic done
);

  //internal signals
  logic [7:0] quotient;

  //your code here

  sequential_div #(22) div(
    .clk(clk),
    .nrst(nrst), // Updated signal name from "nrst" to "rst"
    .start(start),
    .done(done),
    .dividend({count, 6'b0}),
    .divisor({6'b0, fd}),
    .fin_quo(quotient)
  );

  always_comb begin
    if (!nrst) begin // Asynchronous negative-edge reset
      signal = 0;
    end else begin
      case (mode)
        2'b00: begin
          //off
          signal = 0;
        end
        2'b01: begin
          //square
          signal = {8{(count > fd/2)}};
        end
        2'b10: begin
          //triangle
          signal = (count > fd/2) ? (2 * quotient) : 128 - (2 * quotient);
        end
        2'b11: begin
          //sawtooth
          signal = quotient;
        end
      endcase
    end
  end

endmodule


module sequential_div #(parameter WIDTH = 22)(
  input logic clk,              // clock
  input logic nrst,              // reset
  input logic start,            // start calculation
  output logic done,            // calculation is complete (high for one tick)
  input logic [WIDTH - 1:0] dividend,    // dividend (numerator)
  input logic [WIDTH - 1:0] divisor,     // divisor (denominator)
  output logic [WIDTH - 15:0] fin_quo,  // result value: quotient
  output logic [WIDTH - 1:0] rem        // result: remainder
);

  logic [WIDTH - 1:0] b1;             // copy of divisor
  logic [WIDTH - 1:0] quo, quo_next;  // intermediate quotient
  logic [WIDTH:0] acc, acc_next;      // accumulator (1 bit wider)
  logic [$clog2(WIDTH)-1:0] i;        // iteration counter
  logic busy;                        // calculation in progress

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
always_ff @(posedge clk or negedge nrst) begin
  if (!nrst) begin
    done <= 0;
    busy <= 0;
    i <= 0;
    acc <= 0;
    quo <= 0;
    b1 <= 0;
    fin_quo <= 0;
    rem <= 0;
  end else begin
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
        fin_quo <= quo_next[7:0];
        rem <= acc_next[WIDTH:1];  // undo final shift
      end else begin  // next iteration
        i <= i + 1;
        acc <= acc_next;
        quo <= quo_next;
      end
    end
  end
end
endmodule