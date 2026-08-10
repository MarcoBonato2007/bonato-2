`include "encodings.svh"

module id_ex (
    input logic clk,
    input logic rst,
    input logic flush,
    input logic we,

    input logic [31:0] pc_id,
    input logic [31:0] pcplus4_id,
    input logic [4:0] rs1_sel_id,
    input logic [4:0] rs2_sel_id,
    input logic [31:0] rs1_id,
    input logic [31:0] rs2_id,
    input logic [31:0] imm_id,
    input alu_in1_sel_e alu_in1_sel_id,
    input alu_in2_sel_e alu_in2_sel_id,
    input logic [3:0] alu_op_id,
    input logic [2:0] funct3_id,
    input logic is_cond_id,
    input nextpc_sel_e nextpc_sel_id,
    input mem_mode_e mem_mode_id,
    input rf_in_sel_e rf_in_sel_id,
    input logic [4:0] rd_sel_id,

    output logic [31:0] pc_ex,
    output logic [31:0] pcplus4_ex,
    output logic [4:0] rs1_sel_ex,
    output logic [4:0] rs2_sel_ex,
    output logic [31:0] rs1_ex,
    output logic [31:0] rs2_ex,
    output logic [31:0] imm_ex,
    output alu_in1_sel_e alu_in1_sel_ex,
    output alu_in2_sel_e alu_in2_sel_ex,
    output logic [3:0] alu_op_ex,
    output logic [2:0] funct3_ex,
    output logic is_cond_ex,
    output nextpc_sel_e nextpc_sel_ex,
    output mem_mode_e mem_mode_ex,
    output rf_in_sel_e rf_in_sel_ex,
    output logic [4:0] rd_sel_ex
);
    always_ff @(posedge clk) begin
        if (flush || rst) begin
            pc_ex <= 32'b0;
            pcplus4_ex <= 32'b0;
            rs1_sel_ex <= 5'b0;
            rs2_sel_ex <= 5'b0;
            rs1_ex <= 32'b0;
            rs2_ex <= 32'b0;
            imm_ex <= 32'b0;
            alu_in1_sel_ex <= ALU_SEL_RS1; // 1'b0
            alu_in2_sel_ex <= ALU_SEL_RS2; // 1'b0
            alu_op_ex <= 4'b0;
            funct3_ex <= 3'b0;
            is_cond_ex <= 1'b0;
            nextpc_sel_ex <= NEXTPC_SEL_ALU_OUT; // 1'b0
            mem_mode_ex <= MEM_READ; // 1'b0
            rf_in_sel_ex <= RF_SEL_ALU_OUT; // 2'b0
            rd_sel_ex <= 5'b0;
        end else if (we) begin
            pc_ex <= pc_id;
            pcplus4_ex <= pcplus4_id;
            rs1_sel_ex <= rs1_sel_id;
            rs2_sel_ex <= rs2_sel_id;
            rs1_ex <= rs1_id;
            rs2_ex <= rs2_id;
            imm_ex <= imm_id;
            alu_in1_sel_ex <= alu_in1_sel_id;
            alu_in2_sel_ex <= alu_in2_sel_id;
            alu_op_ex <= alu_op_id;
            funct3_ex <= funct3_id;
            is_cond_ex <= is_cond_id;
            nextpc_sel_ex <= nextpc_sel_id;
            mem_mode_ex <= mem_mode_id;
            rf_in_sel_ex <= rf_in_sel_id;
            rd_sel_ex <= rd_id;
        end
    end
    
endmodule
