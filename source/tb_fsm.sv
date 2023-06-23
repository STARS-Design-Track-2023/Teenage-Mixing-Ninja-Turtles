`timescale 1ns/10ps

tb_yourmodulename();
    localparam CLK_PERIOD = 100;
    logic tb_clk; //clk signal
    logic tb_n_rst; //n_rst;

    //Intialize input and output signals
    //Example logic tb_inputname, tb_outputmain
    
    //Signal related to TB
    integer tb_test_num;
    logic tb_mismatch;
    logic tb_check;

    //CLOCK_GEN
    always
    begin : CLK_GEN
        tb_clk = 1'b0;
        #(CLK_PERIOD / 2);
        tb_clk = 1'b1;
        #(CLK_PERIOD / 2);
    end  


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

    

    //Extentiate DUT<Device Under Test> example below
/*
    digit_decoder DUT (
        .clk(tb_clk),
        .n_rst(tb_n_rst),
        .keycode(tb_keycode),
        .keystrobe(tb_keystrobe),
        .isdig(tb_isdig),
        .digit(tb_digit)
    );
*/


    initial begin
        //Put Input signal to be inactive

        ///////////////////////////////
        /*
            if you are using stuff with long clock_cycle use

                repeat(NUM_OF_CYCLE) begin
                    @(posedge tb_clk);
                end

        */

        /*
            Example simple flow of tb_step
            
            tb_test_num = tb_test_num + 1;
            reset_dut;

            @(negedge tb_clk);
            change inputs values to the ones you want to test on negedge;

            wait however clk_cycle your output need
            call check_output task 


        */






    end

