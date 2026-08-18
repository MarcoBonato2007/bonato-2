`timescale 1ns/1ps
`default_nettype none
`include "encodings.svh"

module decoder (
    input logic [31:0] instr,

    output alu_op_e alu_op,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output mem_mode_e mem_mode,
    output alu_in1_sel_e alu_in1_sel,
    output alu_in2_sel_e alu_in2_sel,
    output rf_in_sel_e rf_in_sel,
    output logic is_cond, // set to 1 for branches
    output logic nextpc_is_branch,
    output logic [31:0] imm
);  
    opcode_e opcode;
    logic [4:0] rd_bits, rs1_bits, rs2_bits;

    assign opcode = opcode_e'(instr[6:0]);
    assign rd_bits = instr[11:7];
    assign rs1_bits = instr[19:15];
    assign rs2_bits = instr[24:20];

    always_comb begin
        funct3 = instr[14:12];

        unique case (opcode)
            OP_AL_REG: begin
                alu_op = alu_op_e'({instr[30], funct3});
                rs1 = rs1_bits;
                rs2 = rs2_bits;
                rd = rd_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_RS2;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b0;
                imm = 32'b0; // dummy value
            end
            OP_AL_IMM: begin
                alu_op = alu_op_e'({(funct3 == 3'b101) ? instr[30] : 1'b0, funct3});
                rs1 = rs1_bits;
                rs2 = 5'b00000;
                rd = rd_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b0;
                imm = {{20{instr[31]}}, instr[31:20]};                
            end
            OP_LOAD: begin
                alu_op = ALU_ADD;
                rs1 = rs1_bits;
                rs2 = 5'b00000;
                rd = rd_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_MEM_OUT;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b0;
                imm = {{20{instr[31]}}, instr[31:20]};                
            end
            OP_STORE: begin
                alu_op = ALU_ADD;
                rs1 = rs1_bits;
                rs2 = rs2_bits;
                rd = 5'b00000; // ignore write to register (by writing to x0)
                mem_mode = MEM_WRITE;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b0;
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end
            OP_BRANCH: begin
                alu_op = ALU_ADD;
                rs1 = rs1_bits;
                rs2 = rs2_bits;
                rd = 5'b00000;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_PC;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b1;
                nextpc_is_branch = 1'b1;
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            end
            OP_JAL: begin
                alu_op = ALU_ADD;
                rs1 = 5'b00000; 
                rs2 = 5'b00000;
                rd = rd_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_PC;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_PC_PLUS4;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b1;
                imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            end
            OP_JALR: begin
                alu_op = ALU_ADD;
                rs1 = rs1_bits;
                rs2 = 5'b00000;
                rd = rd_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_PC_PLUS4;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b1;
                imm = {{20{instr[31]}}, instr[31:20]};                
            end
            OP_LUI: begin
                alu_op = ALU_ADD;
                rs1 = 5'b00000;
                rs2 = 5'b00000;
                rd = rd_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b0;
                imm = {instr[31:12], 12'b0};                
            end
            OP_AUIPC: begin
                alu_op = ALU_ADD;
                rs1 = 5'b00000;
                rs2 = 5'b00000;
                rd = rd_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_PC;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b0;
                imm = {instr[31:12], 12'b0};                
            end
            default: begin
                // undefined, zero out
                alu_op = ALU_ADD;
                rs1 = 5'b00000;
                rs2 = 5'b00000;
                rd = 5'b00000;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_RS2;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_is_branch = 1'b0;
                imm = 32'b0;                
            end
        endcase
    end

endmodule
