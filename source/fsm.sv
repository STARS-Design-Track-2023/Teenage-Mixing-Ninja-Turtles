module fsm(
    //inputs
    input logic clk,   
                n_rst,
                modekey,//2-bit "off" "square" "triangle" "sawtooth" 
        
    //outputs
    output logic [1:0] mode           //1 sample 8bit output
    );
    //internal signals
    logic [1:0]next_mode;
    always_ff @( posedge modekey, posedge n_rst ) begin : blockName
        if (n_rst) 
        mode <= 0;
    else 
        mode <= next_mode;
    end
    always_comb begin : blockNamed
      case (mode)
        2'b00: next_mode = 2'b01;
        2'b01: next_mode = 2'b10;
        2'b10: next_mode = 2'b11;
        default: next_mode = 2'b00;
      endcase   
    end
endmodule