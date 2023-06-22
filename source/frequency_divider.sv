`default_nettype none

/*
    The module outputs the necessary counts for all 12 notes based on the
    given octave (low, medium, high). A higher octave is achieved by dividing
    each of the counts by 2
*/

module frequency_divider (
    // HW
    input logic clk, nrst,
    input logic octave,
    output logic [15:0] div0, div1, div2, div3, div4, div5, div6, div7, div8, div9, div10, div11
);
    // All counts are derived from the known periods of a full scale
    // (exluding the 13th note) and multiplied by the clock frequency of 10MHz
    logic [15:0] low_c, low_cs, low_d, low_ds, low_e, low_f, low_fs, low_g, low_gs, low_a, low_as, low_b;
    assign low_c = 16'd38223; // count for lowest C
    assign low_cs = 16'd36077; // count for lowest C#
    assign low_d = 16'd34052; // count for lowest D
    assign low_ds = 16'd32141; // count for lowest D#
    assign low_e = 16'd30337; // count for lowest E
    assign low_f = 16'd28635; // count for lowest F
    assign low_fs = 16'd27027; // count for F#
    assign low_g = 16'd25511; // count for G
    assign low_gs = 16'd24079; // count for G#
    assign low_a = 16'd22727; // count for A
    assign low_as = 16'd21452; // count for A#
    assign low_b = 16'd20248; // count for B  

    logic [2:0] state;
    logic [2:0] next_state;

    always_ff @ (posedge octave or negedge nrst) begin
        if (!nrst) begin
            state <= 3'b001;
        end
        else begin
            state <= next_state
        end
    end

    always_comb begin
        // set next state
        case (state)
            3'b001: begin // lowest octave
                next_state = 3'b010;
            end
            3'b010: begin // middle octave
                next_state = 3'b100;
            end
            3'b100: begin // highest octave
                next_state = 3'b001; 
            end
            default: next_state = 3'b001 
        endcase

        // set outputs from the current states and the lowest octave
        div0 = low_c / state;
        div1 = low_cs / state;
        div2 = low_d / state;
        div3 = low_ds / state;
        div4 = low_e / state;
        div5 = low_f / state;
        div6 = low_fs / state;
        div7 = low_g / state;
        div8 = low_gs / state;
        div9 = low_a / state;
        div10 = low_as / state;
        div11 = low_b / state;
    end

endmodule