`timescale 1ns/10ps

tb_signal_mixer();
    localparam CLK_PERIOD = 100;
    logic tb_clk;
    logic tb_reset;


    // initalize input and output signals
    logic [7:0] tb_sample1;
    logic [7:0] tb_sample2;
    logic [7:0] tb_sample3;
    logic [7:0] tb_sample4;
    logic [7:0] tb_sample5;
    logic [7:0] tb_sample6;
    logic [7:0] tb_sample7;
    logic [7:0] tb_sample8;
    logic [7:0] tb_sample9;
    logic [7:0] tb_sample10;
    logic [7:0] tb_sample11;
    logic [7:0] tb_sample12;
    logic [11:0] tb_sample_enable;

    logic [7:0] tb_sample_out;
    logic [7:0] tb_expected_out;

    // TB signal
    integer tb_test_num;
    logic tb_mismatch;
    logic tb_check;

    //clock gen
    always #(CLK_PERIOD/2) tb_clk = ~tb_clk;


    // reset task
        task reset_dut;
            begin
                //rest dut
                tb_reset = 0;

                //wait 2 clock cycles
                @(posedge tb_clk);
                @(posedge tb_clk);

                //release reset
                tb_reset = 1;

                //rest signals
                tb_sample1 = 0;
                tb_sample2 = 0;
                tb_sample3 = 0;
                tb_sample4 = 0;
                tb_sample5 = 0;
                tb_sample6 = 0;
                tb_sample7 = 0;
                tb_sample8 = 0;
                tb_sample9 = 0;
                tb_sample10 = 0;
                tb_sample11 = 0;
                tb_sample12 = 0;
                
                //wait 2 clock cycles
                @(posedge tb_clk);
                @(posedge tb_clk);

            end
        endtask

    // check outputs
    task check_output;
        begin
            //check output
            if (tb_sample_out != tb_expected_out) begin
                $display("FAILED: test %d,  sample_out = %d, expected_out = %d", tb_test_num, tb_sample_out, tb_expected_out);
                tb_mismatch = tb_mismatch + 1;
            end
            else
                $display("PASSED: test %d,  sample_out = %d, expected_out = %d", tb_test_num, tb_sample_out, tb_expected_out);
        end
    endtask

    //instance DUT

    signal_mixer dut (
        .clk(tb_clk),
        .reset(tb_reset),
        .sample1(tb_sample1),
        .sample2(tb_sample2),
        .sample3(tb_sample3),
        .sample4(tb_sample4),
        .sample5(tb_sample5),
        .sample6(tb_sample6),
        .sample7(tb_sample7),
        .sample8(tb_sample8),
        .sample9(tb_sample9),
        .sample10(tb_sample10),
        .sample11(tb_sample11),
        .sample12(tb_sample12),
        .sample_enable(tb_sample_enable),
        .sample_out(tb_sample_out)
    );

    `include ".v"
    `default_nettype none
    
    initial begin
        $dumpfile("tb_.vcd");
        $dumpvars(0, tb_);
    end
    
    initial begin
        #1 rst_n<=1'bx;clk<=1'bx;
        #(CLK_PERIOD*3) rst_n<=1;
        #(CLK_PERIOD*3) rst_n<=0;clk<=0;
        repeat(5) @(posedge clk);
        rst_n<=1;
        @(posedge clk);
        repeat(2) @(posedge clk);
        $finish(2);
    end
    
    initial begin
        //inital values
        tb_test_num = 0;
        tb_mismatch = 0;
        tb_check = 0;
        tb_sample_enable = 0;
        tb_expected_out = 0;
        reset_dut;

        // test 1 sample 1 pass through
        tb_test_num = tb_test_num + 1;
        tb_sample1 = 25;
        tb_sample_enable = 8'b11111111;
        tb_expected_out = 25;
        @(posedge tb_clk);
        check_output;

        // test 2 sample 2 pass through only 1 enable
        reset_dut;
        tb_test_num = tb_test_num + 1;
        tb_sample2 = 25;
        tb_sample_enable = 8'b00000001;
        tb_expected_out = 25;
        @(posedge tb_clk);
        check_output;

        // test 3 all on no enable
        reset_dut;
        tb_test_num = tb_test_num + 1;
        tb_sample1 = 25;
        tb_sample2 = 25;
        tb_sample3 = 25;
        tb_sample4 = 25;
        tb_sample5 = 25;
        tb_sample6 = 25;
        tb_sample7 = 25;
        tb_sample8 = 25;
        tb_sample9 = 25;
        tb_sample10 = 25;
        tb_sample11 = 25;
        tb_sample12 = 25;
        tb_sample_enable = 8'b00000000;
        tb_expected_out = 0;
        @(posedge tb_clk);
        check_output;

        // test 4 sample 1 and 2 sum
        reset_dut;
        tb_test_num = tb_test_num + 1;
        tb_sample1 = 25;
        tb_sample2 = 25;
        tb_sample_enable = 8'b00000011;
        tb_expected_out = 50;
        @(posedge tb_clk);
        check_output;

        // test 5 sample 1 and 2 and 3 sum
        reset_dut;
        tb_test_num = tb_test_num + 1;
        tb_sample1 = 25;
        tb_sample2 = 25;
        tb_sample3 = 25;
        tb_sample_enable = 8'b00000111;
        tb_expected_out = 75;
        @(posedge tb_clk);
        check_output;

        //test overflow
        reset_dut;
        tb_test_num = tb_test_num + 1;
        tb_sample1 = 200;
        tb_sample2 = 200;
        tb_sample_enable = 8'b00000011;
        tb_expected_out = 255;
        @(posedge tb_clk);
        check_output;

        
