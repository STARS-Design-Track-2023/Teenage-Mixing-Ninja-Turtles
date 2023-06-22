`timescale 1ns/10ps

module tb_sequential_div;

  // Parameters
  localparam CLK_PERIOD = 100;
  localparam WIDTH = 22;

  // Signals
  logic tb_clk;                      // clk signal
  logic tb_n_rst;                    // n_rst signal

    initial begin
        $dumpfile ("dump.vcd");
        $dumpvars;
    end


  // Intialize input and output signals
  logic [WIDTH - 1:0] tb_dividend;    // dividend (numerator)
  logic [WIDTH - 1:0] tb_divisor;     // divisor (denominator)
  logic tb_start;                    // start calculation
  logic tb_done;                     // calculation is complete (high for one tick)
  logic [WIDTH - 15:0] tb_fin_quo;    // result value: quotient
  logic [WIDTH - 1:0] tb_rem;         // result: remainder
  logic [WIDTH - 1:0] tb_expected;    // expected result

  // Signal related to TB
  integer tb_test_num;
  logic tb_mismatch = 0;
  logic tb_check;
  

  // Clock generator
  always
    begin : CLK_GEN
      tb_clk = 1'b0;
      #(CLK_PERIOD / 2);
      tb_clk = 1'b1;
      #(CLK_PERIOD / 2);
    end

  // Reset task


 task reset_dut;
    begin
      tb_n_rst = 0;
      @(posedge tb_clk);
      @(posedge tb_clk);
      tb_n_rst = 1;
      @(posedge tb_clk);
      @(posedge tb_clk);
    end
  endtask

  // Calculation control task
  task start_calculation;
    begin
      tb_start = 1;
      @(posedge tb_clk);
      tb_start = 0;
    end
  endtask

  // Display results task
  task display_results;
    begin
      $display("Quotient: %h", tb_fin_quo);
      $display("Remainder: %h", tb_rem);
      $display("Failures: %d", tb_mismatch);
    end
  endtask

    task check_output;
    begin
      // Check output
      if ( tb_fin_quo == tb_expected) begin
        $display("PASSED: Test %d Expected %d Quotient %d", tb_test_num, tb_expected, tb_fin_quo);
      end else begin
        $display("FAILED: Test %d Expected %d Quotient %d", tb_test_num, tb_expected, tb_fin_quo);
        tb_mismatch = tb_mismatch + 1;
      end
    end
  endtask

  // Sequential Div module instantiation
  sequential_div #(22) div_inst (
    .clk(tb_clk),
    .nrst(tb_n_rst),
    .start(tb_start),
    .done(tb_done),
    .dividend(tb_dividend),
    .divisor(tb_divisor),
    .fin_quo(tb_fin_quo),
    .rem(tb_rem)
  );

  // Testbench process
  initial begin
    tb_test_num = 1;

    // Initialize signals
    tb_n_rst = 0;
    tb_start = 0;
    tb_dividend = 0;
    tb_divisor = 0;

    // Reset DUT
    reset_dut;

    // Set dividend and divisor values
    tb_dividend = 22'd7;
    tb_divisor = 22'd2;
    tb_expected = 22'd3;

    // Start calculation
    start_calculation;

    // Wait for calculation to complete
    @(posedge tb_clk);
    while (!tb_done)
      @(posedge tb_clk);

    // Display results
    check_output;
    //display_results;
    
    // Finish simulation



  // Test Case 2: Dividend = 0, Divisor = 5, Expected = 0
  tb_test_num = tb_test_num + 1;
  reset_dut;
  tb_dividend = 22'd0;
  tb_divisor = 22'd5;
  tb_expected = 22'd0;
  start_calculation;
  @(posedge tb_clk);
  while (!tb_done)
    @(posedge tb_clk);
  check_output;
  //display_results;

  // Test Case 3: Dividend = 10, Divisor = 3, Expected = 3
  tb_test_num = tb_test_num + 1;
  reset_dut;
  tb_dividend = 22'd10;
  tb_divisor = 22'd3;
  tb_expected = 22'd3;
  start_calculation;
  @(posedge tb_clk);
  while (!tb_done)
    @(posedge tb_clk);
  check_output;
  //display_results;

// Test Case: Division with Large Numbers
tb_test_num = tb_test_num + 1;
reset_dut;
tb_dividend = 22'd123456;  // Large dividend
tb_divisor = 22'd987654;   // Large divisor
tb_expected = 22'd0;           // Expected result (quotient) depends on the specific values used
start_calculation;
@(posedge tb_clk);
while (!tb_done)
  @(posedge tb_clk);
check_output;
//display_results;

// Test Case: Division with same Numbers
tb_test_num = tb_test_num + 1;
reset_dut;
tb_dividend = 22'd123456;  // Large dividend
tb_divisor = 22'd123456;   // Large divisor
tb_expected = 22'd1;           // Expected result (quotient) depends on the specific values used
start_calculation;
@(posedge tb_clk);
while (!tb_done)
  @(posedge tb_clk);
check_output;

  // Finish simulation
  $finish;
end
endmodule