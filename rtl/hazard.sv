`include "encodings.svh"

module hazard (
    // For load-use detection
    input logic [4:0] rs1_sel_id,
    input logic [4:0] rs2_sel_id,
    // _cond means "after the conditional check has been applied" (in the execute stage)
    input logic [4:0] rwrite_ex_cond,
    input rf_in_sel_e rf_in_sel_ex_cond,

    // Branch detection (flushing)
    input nextpc_sel_e nextpc_sel_ex_cond,

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
        if (nextpc_sel_ex_cond == NEXTPC_SEL_ALU_OUT) begin
            if_id_flush = 1'b1;
            id_ex_flush = 1'b1;
        end
        // Stall on a load-use hazard
        else if (
            rf_in_sel_ex_cond == RF_SEL_MEM_OUT
            && rwrite_ex_cond != 5'b0
            && (rs1_sel_id == rwrite_ex_cond || rs2_sel_id == rwrite_ex_cond)
        ) begin
            pc_we = 1'b0;
            if_id_we = 1'b0;
            id_ex_flush = 1'b1;
        end

    end
endmodule
