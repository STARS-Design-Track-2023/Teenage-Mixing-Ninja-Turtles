`timescale 1ns/10ps

module tb_frequency_divider ();
    
    logic CLK, N_RST, OCTAVE;
    logic [15:0] O, O1, O2, O3, O4, O5, O6, O7, O8, O9, O10, O11;

    frequency_divider u1 (.clk(CLK), .nrst(N_RST), .octave(OCTAVE), .div0(O), .div1(O1), 
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

    task automatic disp_outs();
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
        N_RST = 1'b0; OCTAVE = 1'b0;
        #1
        N_RST = 1'b1;
        // lowest octave (mode 0)
        clock(1);
        $display("/////Initial Reset | Lowest Octave/////");
        disp_outs();

        #5 
        // medium octave (mode 1)
        OCTAVE = 1'b1;
        clock(1);
        OCTAVE = 1'b0;
        $display("/////State Change | Medium Octave/////");
        disp_outs();

        #5 
        // high octave (mode 2)
        OCTAVE = 1'b1;
        clock(1);
        OCTAVE = 1'b0;
        $display("/////State Change | High Octave/////");
        disp_outs();

        #5
        // back to low octave (mode 0)
        OCTAVE = 1'b1;
        clock(1);
        OCTAVE = 1'b0;
        $display("/////State Change | Wrap to Lowest/////");
        disp_outs();
        
        #5
        $finish;
    end
endmodule