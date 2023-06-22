`timescale 1ns/10ps

module tb_frequency_divider ();
    
    logic N_RST, OCTAVE;
    logic [15:0] O, O1, O2, O3, O4, O5, O6, O7, O8, O9, O10, O11;

    frequency_divider u1 (.nrst(N_RST), .octave(OCTAVE), .div0(O), div1(O1), 
        div2(O2), div3(O3), div4(O4), div5(O5), div6(O6), div7(O7), div8(O8),   
        div9(O9), div10(O10), div11(O11));

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
    endtask

    initial begin
        testname = "Initial Test w/ Reset"
        N_RST = 1'b0; OCTAVE = 1'b0;
        #1
        N_RST = 1'b1;
        disp_outs();
    end
endmodule