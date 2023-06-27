`timescale 1ns/10ps

module tb_keypad();
    localparam CLK_PERIOD = 100;
    logic tb_clk = 0;   //clk signal
    logic tb_n_rst; //n_rst;
        
    // iverilog waveform generation
    initial begin
        $dumpfile ("dump.vcd");
        $dumpvars;
    end


    //Intialize input and output signals
    //Example logic tb_inputname, tb_outputmain
        logic tb_mode_in;    //input signal
        logic [1:0] tb_octive_in;   //input signal
        logic tb_mode_out;        //output signal
        logic tb_octive_up;
        logic tb_octive_down;
        logic tb_mode_expected;  //expected output modekey output signal
        logic tb_octive_up_expected; //expected output octive up signal
        logic tb_octive_down_expected; //expected output octive down signal
    
    //Signal related to TB
    integer tb_test_num;
    integer tb_passed;

     // Clocking
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
    task check_output(out, expected);
    begin
        //Increment test number
        tb_test_num = tb_test_num + 1;
        //Check output
        if (out !== expected)
        begin
            $display("FAILED: Test %d  tb_out = %b, tb_expected = %b", tb_test_num, out, expected);
        end
        else
        begin
            $display("PASSED: Test %d  tb_out = %b, tb_expected = %b", tb_test_num, out, expected);
            tb_passed = tb_passed + 1;
        end
    end
    endtask

    //reset input signals
    task reset_input;
    begin
        tb_mode_in = 1'b0;
        tb_octive_in = 2'b00;
    end
    endtask
    

    //Extentiate DUT<Device Under Test> example below

    keypad DUT(
        .clk(tb_clk),
        .n_rst(tb_n_rst),
        .mode_in(tb_mode_in),
        .octive_in(tb_octive_in),
        .modekey(tb_mode_out),
        .octive_up(tb_octive_up),
        .octive_down(tb_octive_down)
    );

    initial begin

        //Put Input signal to be inactive
        tb_test_num = 0;
        tb_passed = 0;
        reset_input;
        reset_dut;



    //test 2 posedge detection mode

        //reset
        reset_dut;
        reset_input;

        //test
        tb_mode_in = 1'b0; #100; //set inital signal low
        tb_mode_in = 1'b1; #100; //trigger posedge
        tb_mode_expected = 1'b1;
        tb_octive_down_expected = 1'b0;
        tb_octive_up_expected = 1'b0;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //1
        check_output(tb_octive_up, tb_octive_up_expected);      //2
        check_output(tb_octive_down, tb_octive_down_expected);  //3
        

    //test 3 posedge detection octive up

        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00; #100; //set inital signal low
        tb_octive_in = 2'b10; #100; //trigger posedge
        tb_octive_up_expected = 1'b1;
        tb_mode_expected = 1'b0;
        tb_octive_down_expected = 1'b0;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //4
        check_output(tb_octive_up, tb_octive_up_expected);      //5
        check_output(tb_octive_down, tb_octive_down_expected);  //6

    //test 4 posedge detection octive down

        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00; #100; //set inital signal low
        tb_octive_in = 2'b01; #100; //trigger posedge
        tb_octive_down_expected = 1'b1;
        tb_mode_expected = 1'b0;
        tb_octive_up_expected = 1'b0;
        tb_octive_down_expected = 1'b1;

        //check
        check_output(tb_octive_down, tb_octive_down_expected);  //7
        check_output(tb_mode_out, tb_mode_expected);            //8
        check_output(tb_octive_up, tb_octive_up_expected);      //9

    //test 5 negedge detection mode

        //reset
        reset_dut;
        reset_input;

        //test
        tb_mode_in = 1'b1; #100; //set inital signal high
        tb_mode_in = 1'b0; #100; //trigger negedge
        tb_mode_expected = 1'b0;
        tb_octive_down_expected = 1'b0;
        tb_octive_up_expected = 1'b0;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //10
        check_output(tb_octive_up, tb_octive_up_expected);      //11
        check_output(tb_octive_down, tb_octive_down_expected);  //12

    //test 6 negedge detection octive up

        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b10; #100; //set inital signal high
        tb_octive_in = 2'b00; #100; //trigger negedge
        tb_octive_up_expected = 1'b0;
        tb_mode_expected = 1'b0;
        tb_octive_down_expected = 1'b0;

        //check
        check_output(tb_octive_up, tb_octive_up_expected);      //13
        check_output(tb_mode_out, tb_mode_expected);            //14
        check_output(tb_octive_down, tb_octive_down_expected);  //15

    //test 7 negedge detection octive down
        //reset
        reset_dut;
        reset_input;

        //reset
        tb_octive_in = 2'b01; #100; //set inital signal high
        tb_octive_in = 2'b00; #100; //trigger negedge
        tb_octive_down_expected = 1'b0;
        tb_mode_expected = 1'b0;
        tb_octive_up_expected = 1'b0;

        //check
        check_output(tb_octive_down, tb_octive_down_expected);  //16
        check_output(tb_mode_out, tb_mode_expected);            //17
        check_output(tb_octive_up, tb_octive_up_expected);      //18


    //test 8 check for single pulse mode
        //reset
        reset_dut;
        reset_input;

        //test
        tb_mode_in = 1'b0; #100; //set signal to 0
        tb_mode_in = 1'b1; #400; //trigger posedge, but longer so should go back to 0
        tb_mode_expected = 1'b0;
        tb_octive_down_expected = 1'b0;
        tb_octive_up_expected = 1'b0;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //19
        check_output(tb_octive_up, tb_octive_up_expected);      //20
        check_output(tb_octive_down, tb_octive_down_expected);  //21

    //test 9 check for single pulse octive up
        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00; #100; //set signal to 0
        tb_octive_in = 2'b10; #400; //trigger posedge, but longer so should go back to 0
        tb_octive_up_expected = 1'b0;
        tb_mode_expected = 1'b0;
        tb_octive_down_expected = 1'b0;

        //check
        check_output(tb_octive_up, tb_octive_up_expected);      //22
        check_output(tb_mode_out, tb_mode_expected);            //23
        check_output(tb_octive_down, tb_octive_down_expected);  //24

    //test 10 check for single pulse octive down
        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00; #100; //set signal to 0
        tb_octive_in = 2'b01; #400; //trigger posedge, but longer so should go back to 0
        tb_octive_down_expected = 1'b0;
        tb_mode_expected = 1'b0;
        tb_octive_up_expected = 1'b0;

        //check
        check_output(tb_octive_down, tb_octive_down_expected);  //25
        check_output(tb_mode_out, tb_mode_expected);            //26
        check_output(tb_octive_up, tb_octive_up_expected);      //27

    //test 1 async reset
        //reset
        reset_dut;
        reset_input;
        
        //test
        tb_mode_in = 1'b1; 
        tb_octive_in = 2'b11;
        tb_n_rst = 1'b0; #10;   
        tb_mode_expected = 1'b0;
        tb_octive_down_expected = 1'b0;
        tb_octive_up_expected = 1'b0;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //28
        check_output(tb_octive_up, tb_octive_up_expected);      //29
        check_output(tb_octive_down, tb_octive_down_expected);  //30

    //test 11 octive up and down at the same time
        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00; #100; //set signal to 0
        tb_octive_in = 2'b11; #100; //trigger posedge of both
        //expected
        tb_octive_up_expected = 1'b1;
        tb_mode_expected = 1'b0;
        tb_octive_down_expected = 1'b1;

        //check
        check_output(tb_octive_up, tb_octive_up_expected);      //31
        check_output(tb_mode_out, tb_mode_expected);            //32
        check_output(tb_octive_down, tb_octive_down_expected);  //33

    // test 12 octive up and mode at the same time
        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00; 
        tb_mode_in = 1'b0;
        #100; //set signals to 0
        tb_octive_in = 2'b10; 
        tb_mode_in = 1'b1;
        #100; //trigger posedge of both
        //expected
        tb_octive_up_expected = 1'b1;
        tb_mode_expected = 1'b1;
        tb_octive_down_expected = 1'b0;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //34
        check_output(tb_octive_up, tb_octive_up_expected);      //35
        check_output(tb_octive_down, tb_octive_down_expected);  //36
    
    //test 13 octive down and mode at the same time
        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00;
        tb_mode_in = 1'b0;
        #100; //set signals to 0
        tb_octive_in = 2'b01;
        tb_mode_in = 1'b1;
        #100; //trigger posedge of both
        //expected
        tb_octive_up_expected = 1'b0;
        tb_mode_expected = 1'b1;
        tb_octive_down_expected = 1'b1;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //37
        check_output(tb_octive_up, tb_octive_up_expected);      //38
        check_output(tb_octive_down, tb_octive_down_expected);  //39

    //test 14 all at the same time
        //reset
        reset_dut;
        reset_input;

        //test
        tb_octive_in = 2'b00;
        tb_mode_in = 1'b0;
        #100; //set signals to 0
        tb_octive_in = 2'b11;
        tb_mode_in = 1'b1;
        #100; //trigger posedge of both
        //expected
        tb_octive_up_expected = 1'b1;
        tb_mode_expected = 1'b1;
        tb_octive_down_expected = 1'b1;

        //check
        check_output(tb_mode_out, tb_mode_expected);            //40
        check_output(tb_octive_up, tb_octive_up_expected);      //41
        check_output(tb_octive_down, tb_octive_down_expected);  //42

        $display("Testbench finished: %d/%d tests passed", tb_passed, tb_test_num);
    
      $finish;
    end

endmodule