`timescale 1ns/10ps

module tb_base ();

  // 10MHz Clock Rate
  localparam CLK_PERIOD        = 100;
  
  // 10MHz D-FF Timing Constraints
  localparam PROPAGATION_DELAY = 1.1; // Allow for 1.1ns for FF propogation delay

  // TB-Specific Localparams
  localparam  VALUE = 8'b0;

  // Inactive Inputs and Reset Output Values
  localparam  INACTIVE_D_VALUE = 1'b0;
  localparam  RESET_OUTPUT_VALUE = 2'b0;

  // Declare Test Case Signals
  integer tb_test_case_num;
  string  tb_test_case_name;
  int     tb_bit_num;
  logic   tb_mismatch;
  logic   tb_check;

  // Declare DUT Connection Signals
  logic   tb_clk;
  logic   tb_nrst;
  logic   tb_D;
  logic [1:0]tb_mode;
  logic tb_modekey;

  // Declare the Test Bench Signals for Expected Results
  logic [1:0]tb_expected_output;

  // Clock generation block
  always begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end

  task start_dut;
  begin
    // Init Test Case Meta Variables
    tb_test_case_num         = 0;
    tb_test_case_name        = "Test Bench Initializaton";
    tb_mismatch              = 1'b0;
    tb_check                 = 1'b0;
  end
  endtask

  // Task for standard DUT reset procedure
  task reset_dut;
  begin
    // Activate the reset
    tb_nrst = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_nrst = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Set input signals to zero before starting with new testcases
  task deactivate_signals;
  begin
    tb_D = INACTIVE_D_VALUE;
  end
  endtask

  // Set input signals to zero before starting with new testcases
  task start_testcase;
    input string test_case_name;
  begin
    // Space test case out from previous test case
    #(CLK_PERIOD * 3);

    // Set name and number
    tb_test_case_num  = tb_test_case_num + 1;
    tb_test_case_name = test_case_name;

    // Reset and deactivate DUT
    deactivate_signals();
    reset_dut();
  end
  endtask

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input int tb_input;
    input string check_tag;
  begin
    tb_mismatch = 1'b0;
    tb_check    = 1'b1;
    if(tb_expected_output == tb_input) begin // Check passed
      $display("Correct output %s during %s test case.", check_tag, tb_test_case_name);
    end
    else begin // Check failed
      tb_mismatch = 1'b1;
      $error("Incorrect output %s during %s test case. \nExpected %h, got %h.", check_tag, tb_test_case_name, tb_expected_output, tb_input);
    end

    // Wait some small amount of time so check pulse timing is visible on waves
    #(0.1);
    tb_check =1'b0;
  end
  endtask

  // DUT Portmap
  fsm DUT 
  (
    .clk(tb_clk), 
    .n_rst(tb_nrst), 
    .mode(tb_mode),
    .modekey(tb_modekey)
    );

  // Signal Dump
  initial begin
    $dumpfile ("dump.vcd");
    $dumpvars;
  end
  
  // Test Cases
  initial begin
    // Initialize all of the test inputs and test environment
    deactivate_signals();
    start_dut();
    
    // Wait some time before starting first test case
    #(0.1);

    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_case_num  = tb_test_case_num + 1;
    tb_test_case_name = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    deactivate_signals();
    tb_nrst = 1'b0; // Manually enable chip reset

    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    tb_expected_output = RESET_OUTPUT_VALUE;
    check_output(tb_mode,"after reset applied");

    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output(tb_mode, "after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(negedge tb_clk);
    tb_nrst = 1'b1;   // Deactivate the chip reset

    // Check that internal state was correctly keep after reset release
    #(PROPAGATION_DELAY);
    check_output(tb_mode,  "after reset was released");

    // ************************************************************************
    // Test Case 2: Loop Test
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Test Case 2: Loop Test");

    tb_test_case_num  = tb_test_case_num + 1;
    tb_test_case_name = "Loop Test";
    #(0.1);
    // Check 1
    tb_expected_output = 2'b0;
    check_output(tb_mode, "00");
    // Check 2
    tb_modekey = 1;
    #(CLK_PERIOD);
    tb_expected_output = 2'b01;
    check_output(tb_mode,"01");
    
    

    // Check 3
    #(CLK_PERIOD);
    tb_expected_output = 2'b10;
    check_output(tb_mode,"10");
    
    

    // Check 4
    #(CLK_PERIOD);
    tb_expected_output = 2'b11;
    check_output(tb_mode,"11");
    

    // Check 5
    #(CLK_PERIOD);
    tb_expected_output = 2'b00;
    check_output(tb_mode,"00");
    
    // Check 6
    #(CLK_PERIOD);
    tb_expected_output = 2'b01;
    check_output(tb_mode,"01");
    
    #(CLK_PERIOD);

    // ************************************************************************
    // Test Case 3: Mid-Loop Reset Test
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Test Case 3: Mid-Loop Reset Test");
    tb_nrst = 1'b0;
    #(CLK_PERIOD);
    tb_nrst = 1'b1;
    tb_test_case_num  = tb_test_case_num + 1;
    tb_test_case_name = "Mid-Loop Reset Tests";
    // Check 1
    tb_expected_output = 2'b0;
    
    check_output(tb_mode, "00");
    // Check 2
    tb_modekey = 1;
    #(CLK_PERIOD);
    tb_expected_output = 2'b01;
    check_output(tb_mode,"01");

    // Check 3
    #(CLK_PERIOD);
    tb_expected_output = 2'b10;
    check_output(tb_mode,"10");

    //reset
    tb_nrst = 1'b0;
    #(CLK_PERIOD);
    tb_expected_output = 2'b00;
    check_output(tb_mode,"ZERO");

    // ************************************************************************
    // Test Case 4: Unpressed Test
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Test Case 3: Unpressed Test");
    tb_nrst = 1'b0;
    #(CLK_PERIOD);
    tb_nrst = 1'b1;
    tb_test_case_num  = tb_test_case_num + 1;
    tb_test_case_name = "Mid-Loop Reset Tests";
    // Check 1
    tb_expected_output = 2'b01;
    tb_modekey = 1;
    #(CLK_PERIOD);
    check_output(tb_mode, "wait for it...");

    // Check 2
    tb_expected_output = 2'b10;
    #(CLK_PERIOD);
    check_output(tb_mode, "wait for it...");
    tb_modekey = 0;

// Check 2
    tb_expected_output = 2'b10;
    #(CLK_PERIOD);
    check_output(tb_mode, "FROZEN!");
    tb_modekey = 0;

    $display("Simulation complete");
    $stop;
  end

endmodule