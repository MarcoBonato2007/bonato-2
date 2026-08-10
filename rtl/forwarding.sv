`default_nettype none
`include "encodings.svh"

module forwarding (
    input logic [4:0] rs1_ex,
    input logic [4:0] rs2_ex,
    input logic [4:0] rd_mem,
    input rf_in_sel_e rf_in_sel_mem,
    input logic [4:0] rd_wb,
    input rf_in_sel_e rf_in_sel_wb,

    output forward_e forward_rs1,
    output forward_e forward_rs2
);     

    function automatic forward_e get_forward (
        input logic [4:0] rs_ex
    ); 
        get_forward = FORWARD_NONE;
        
        if (rs_ex == rd_mem && rs_ex != 5'b0) begin
            if (rf_in_sel_mem == RF_SEL_ALU_OUT) begin
                get_forward = FORWARD_ALU_OUT_MEM;
            end
        end else if (rs_ex == rd_wb && rs_ex != 5'b0) begin
            if (rf_in_sel_wb == RF_SEL_ALU_OUT) begin
                get_forward = FORWARD_ALU_OUT_WB;
            end else if (rf_in_sel_wb == RF_SEL_MEM_OUT) begin
                get_forward = FORWARD_MEM_OUT_WB;
            end
        end
    endfunction

    always_comb begin
        forward_rs1 = get_forward(rs1_ex);
        forward_rs2 = get_forward(rs2_ex);
    end
    
endmodule
