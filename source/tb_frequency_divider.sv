`timescale 1ns/10ps

module tb_frequency_divider ();
    
    logic CLK, N_RST, UP, DOWN;
    logic [17:0] O, O1, O2, O3, O4, O5, O6, O7, O8, O9, O10, O11;

    frequency_divider u1 (.clk(CLK), .nrst(N_RST), .o_up(UP), .o_down(DOWN), .div0(O), .div1(O1), 
        .div2(O2), .div3(O3), .div4(O4), .div5(O5), .div6(O6), .div7(O7), .div8(O8),   
        .div9(O9), .div10(O10), .div11(O11));

    task automatic clock(integer n);
        while (n != 0) begin
            CLK = 1'b1;
            #1;
            CLK = 1'b0;
            #1;
            n--;
        end
    endtask

    task automatic disp_outs(string test_name);
        $display("/////%s/////", test_name);
        $display("Out 0: %d", O);
        $display("Out 1: %d", O1);
        $display("Out 2: %d", O2);
        $display("Out 3: %d", O3);
        $display("Out 4: %d", O4);
        $display("Out 5: %d", O5);
        $display("Out 6: %d", O6);
        $display("Out 7: %d", O7);
        $display("Out 8: %d", O8);
        $display("Out 9: %d", O9);
        $display("Out 10: %d", O10);
        $display("Out 11: %d", O11);
        $display("");
    endtask

    initial begin
        $dumpfile ("dump.vcd");
        $dumpvars;
    end

    initial begin
        // Initial Reset
        N_RST = 1'b0; UP = 1'b0; DOWN = 1'b0;
        #1
        N_RST = 1'b1;
        #5

        // No shift
        UP = 1'b0; DOWN = 1'b0;
        clock(1);
        disp_outs("No Shifts - Middle Octave"); 
        #5

        // Shift up 1 - Lower High
        UP = 1'b1; DOWN = 1'b0;
        clock(1);
        UP = 1'b0;
        disp_outs("Middle to Lower High Octave");
        #5

        // Shift up 1 - Upper High
        UP = 1'b1; DOWN = 1'b0;
        clock(1);
        UP = 1'b0;
        disp_outs("Lower to Upper High Octave");
        #5

        // Shift up 1 - Upper Boundary
        UP = 1'b1; DOWN = 1'b0;
        clock(1);
        UP = 1'b0;
        disp_outs("Upper Boundary - Hold Upper High Octave");
        #5

        // Shift down 1 - Boundary to Lower High
        UP = 1'b0; DOWN = 1'b1;
        clock(1);
        DOWN = 1'b0;
        disp_outs("Upper to Lower High Octave");
        #5

        // Shift down 1 - Lower High to Middle
        UP = 1'b0; DOWN = 1'b1;
        clock(1);
        DOWN = 1'b0;
        disp_outs("Lower High to Middle Octave");
        #5

        // Both buttons pressed - No Change
        UP = 1'b1; DOWN = 1'b1;
        clock(1);
        UP = 1'b0; DOWN = 1'b0;
        disp_outs("Both Buttons - Hold Middle Octave");
        #5

        // Shift down 1 - Middle to Lower Low
        UP = 1'b0; DOWN = 1'b1;
        clock(1);
        DOWN = 1'b0;
        disp_outs("Middle to Lower Low Octave");
        #5

        // Reset Non-middle octave state
        N_RST = 1'b0; UP = 1'b0; DOWN = 1'b0;
        #1
        N_RST = 1'b1;
        disp_outs("Non-middle Octave Reset");
        #5

        // Lower Boundary
        UP = 1'b0; DOWN = 1'b1;
        clock(3);
        disp_outs("Lower Boundary - Hold Upper Low Octave");
        #5

        $finish;
    end
endmodule