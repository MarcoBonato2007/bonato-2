
module csr_file (
    input logic clk,
    input logic enabled,

    input logic [11:0] addr,
    input logic [31:0] rs1_val,

    input logic trap, // set to 1 when trapping. Disables reading/writing.
    input logic pc_wb, // used for mepc and for mtval
    input logic [31:0] alu_out_wb, // used for mtval
    input logic [31:0] cause,

    input logic ret, // set to 1 for an MRET instruction

    input logic wb_valid, // set to 1 if the writeback stage has a non-excepting, non-flushed instruction

    output logic [31:0] new_csr_val,
    output logic illegal, // =1 if accessing unknown CSR, writing to a read-only CS, etc.

    // mtvec_mode chooses between base and base_vectored for a nextpc selection signal
    output logic mtvec_mode,
    output logic [31:0] mtvec_base, 
    output logic [31:0] mtvec_base_vectored,

    output logic [31:0] mepc // part of next pc selection signals
);  
    


    always_ff @(posedge clk) begin
        // when wb_valid=1, minstret increments (even if trap=1)
        // This should happen before a read (cuz of the case of an instruction followed by a read to minstret)
        // traps are not an issue since the instruction in writeback will still complete if wb_valid=1


        // mret takes priority over interrupts
        if (ret) begin
            // Set mstatus.MIE to mstatus.MPIE, then set mstatus.MPIE to 1
        end else if (trap) begin
            // Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0
        end else if (enabled) begin
            // give an illegal exception if accessing an unknown csr or writing to a read-only CSR
            // check conditions with rs1=x0 or imm=x0 (actually, check how you're inputting imm)

            // 1. output the old CSR value
            // 2. then update the CSR to its new value (write after read)
            // 3. output the new value too 

        end
    end

endmodule

