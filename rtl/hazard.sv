`default_nettype none
`include "encodings.svh"

module hazard (
    // For load-use detection
    input logic [4:0] rs1_id,
    input logic [4:0] rs2_id,
    input logic [4:0] rd_ex,
    input rf_in_sel_e rf_in_sel_ex,

    // Branch detection (flushing)
    input logic nextpc_is_branch_ex_cond,

    output logic if_id_we,
    output logic if_id_flush,
    output logic id_ex_flush,
    output logic pc_we
);      
    always_comb begin
        if_id_we = 1'b1;
        if_id_flush = 1'b0;
        id_ex_flush = 1'b0;
        pc_we = 1'b1;
        
        // Flush on taken branches
        if (nextpc_is_branch_ex_cond) begin
            if_id_flush = 1'b1;
            id_ex_flush = 1'b1;
        end
        // Stall on a load-use hazard
        else if (
            rf_in_sel_ex == RF_SEL_MEM_OUT
            && rd_ex != 5'b0
            && (rs1_id == rd_ex || rs2_id == rd_ex)
        ) begin
            pc_we = 1'b0;
            if_id_we = 1'b0;
            id_ex_flush = 1'b1;
        end

    end
endmodule
