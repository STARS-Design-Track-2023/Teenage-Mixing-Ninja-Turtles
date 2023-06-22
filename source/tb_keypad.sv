`timescale 1ns/10ps

tb_keypad();
    localparam CLK_PERIOD = 100;
    logic tb_clk;   //clk signal
    logic tb_n_rst; //n_rst;


    //Intialize input and output signals
    //Example logic tb_inputname, tb_outputmain
        logic tb_in;    //input signal
        logic tb_out;   //output signal
        logic tb_expected;  //expected output signal
    
    //Signal related to TB
    integer tb_test_num;
    logic tb_mismatch;
    logic tb_check;

    //CLOCK_GEN
    always #(CLK_PERIOD/2) tb_clk = ~tb_clk; 


    //Reset task call for reset
    task reset_dut;
    begin
        // Activate the design's reset (does not need to be synchronize with clock)
        tb_n_rst = 1'b0;
        
        // Wait for a couple clock cycles
        @(posedge tb_clk);
        @(posedge tb_clk);
        
        // Release the reset
        @(negedge tb_clk);
        tb_n_rst = 1;




        // Wait for a while before activating the design
        @(posedge tb_clk);
        @(posedge tb_clk);
    end
    endtask 



    //Have a check output task base on the module you using 
    task check_output;
    begin
        //Check output
        if (tb_out != tb_outputmain)
        begin
            $display("Test %d failed: tb_out = %b, tb_expected = %b", tb_test_num, tb_out, tb_expected);
            tb_mismatch = 1'b1;
        end
        else
        begin
            $display("Test %d passed: tb_out = %b, tb_outputmain = %b", tb_test_num, tb_out, tb_outputmain);
            tb_mismatch = 1'b0;
        end
    end
    endtask

    

    //Extentiate DUT<Device Under Test> example below

    keypad DUT(
        .clk(tb_clk),
        .n_rst(tb_n_rst),
        .in(tb_in),
        .modekey(tb_out)
    )

    initial begin

        $dumpfile("tb_.vcd");
        $dumpvars(0, tb_);

        //Put Input signal to be inactive
        tb_test_num = 0;
        tb_in = 1'b0;
        reset_dut;

        //test 1 async reset
        tb_test_num = tb_test_num + 1;
        tb_expected = 1'b0;
        tb_in = 1'b1; 
        tb_n_rst = 1'b0; #10;   
        check_output;


        //test 2 posedge detection
        tb_test_num = tb_test_num + 1;
        reset_dut;
        tb_expected = 1'b1;
        tb_in = 1'b0; #100; //set inital signal low
        tb_in = 1'b1; #100; //trigger posedge
        check_output;

        //test 3 negedge detection
        tb_test_num = tb_test_num + 1;
        reset_dut;
        tb_expected = 1'b0;
        tb_in = 1'b1; #100; //set inital signal high
        tb_in = 1'b0; #100; //trigger negedge
        check_output;

        //test 4 check for single pulse
        tb_test_num = tb_test_num + 1;
        reset_dut;
        tb_expected = 1'b0;
        tb_in = 1'b0; #100; //set signal to 0
        tb_in = 1'b1; #400; //trigger posedge, but longer so should go back to 0
        check_output;
    
        
      
        

    end

