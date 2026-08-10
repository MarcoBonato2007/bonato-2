`include "encodings.svh"

module decoder (
    input logic [31:0] instruction,

    output logic [3:0] alu_op,
    output logic [2:0] funct3,
    output logic [4:0] rs1_sel,
    output logic [4:0] rs2_sel,
    output logic [4:0] rd_sel,
    output mem_mode_e mem_mode,
    output alu_in1_sel_e alu_in1_sel,
    output alu_in2_sel_e alu_in2_sel,
    output rf_in_sel_e rf_in_sel,
    output logic is_cond, // set to 1 for branches
    output nextpc_sel_e nextpc_sel,
    output logic [31:0] imm
);  
    opcode_e opcode;
    logic [4:0] rd_sel_bits, rs1_sel_bits, rs2_sel_bits;

    assign opcode = opcode_e'(instruction[6:0]);
    assign rd_sel_bits = instruction[11:7];
    assign rs1_sel_bits = instruction[19:15];
    assign rs2_sel_bits = instruction[24:20];

    always_comb begin
        funct3 = instruction[14:12];

        unique case (opcode)
            OP_AL_REG: begin
                alu_op = {instruction[30], funct3};
                rs1_sel = rs1_sel_bits;
                rs2_sel = rs2_sel_bits;
                rd_sel = rd_sel_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_RS2;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_PC_PLUS4;
                imm = 32'b0; // dummy value
            end
            OP_AL_IMM: begin
                alu_op = {(funct3 == 3'b101) ? instruction[30] : 1'b0, funct3};
                rs1_sel = rs1_sel_bits;
                rs2_sel = 5'b00000;
                rd_sel = rd_sel_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_PC_PLUS4;
                imm = {{20{instruction[31]}}, instruction[31:20]};                
            end
            OP_LOAD: begin
                alu_op = 4'b0000; // add
                rs1_sel = rs1_sel_bits;
                rs2_sel = 5'b00000;
                rd_sel = rd_sel_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_MEM_OUT;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_PC_PLUS4;
                imm = {{20{instruction[31]}}, instruction[31:20]};                
            end
            OP_STORE: begin
                alu_op = 4'b0000;
                rs1_sel = rs1_sel_bits;
                rs2_sel = rs2_sel_bits;
                rd_sel = 5'b00000; // ignore write to register (by writing to x0)
                mem_mode = MEM_WRITE;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_PC_PLUS4;
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            OP_BRANCH: begin
                alu_op = 4'b0000;
                rs1_sel = rs1_sel_bits;
                rs2_sel = rs2_sel_bits;
                rd_sel = 5'b00000;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_PC;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b1;
                nextpc_sel = NEXTPC_SEL_ALU_OUT;
                imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            OP_JAL: begin
                alu_op = 4'b0000;
                rs1_sel = 5'b00000; 
                rs2_sel = 5'b00000;
                rd_sel = rd_sel_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_PC;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_PC_PLUS4;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_ALU_OUT;
                imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            OP_JALR: begin
                alu_op = 4'b0000;
                rs1_sel = rs1_sel_bits;
                rs2_sel = 5'b00000;
                rd_sel = rd_sel_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_PC_PLUS4;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_ALU_OUT;
                imm = {{20{instruction[31]}}, instruction[31:20]};                
            end
            OP_LUI: begin
                alu_op = 4'b0000;
                rs1_sel = 5'b00000;
                rs2_sel = 5'b00000;
                rd_sel = rd_sel_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_PC_PLUS4;
                imm = {instruction[31:12], 12'b0};                
            end
            OP_AUIPC: begin
                alu_op = 4'b0000;
                rs1_sel = 5'b00000;
                rs2_sel = 5'b00000;
                rd_sel = rd_sel_bits;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_PC;
                alu_in2_sel = ALU_SEL_IMM;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_PC_PLUS4;
                imm = {instruction[31:12], 12'b0};                
            end
            default: begin
                // undefined, zero out
                alu_op = 4'b0000;
                rs1_sel = 5'b00000;
                rs2_sel = 5'b00000;
                rd_sel = 5'b00000;
                mem_mode = MEM_READ;
                alu_in1_sel = ALU_SEL_RS1;
                alu_in2_sel = ALU_SEL_RS2;
                rf_in_sel = RF_SEL_ALU_OUT;
                is_cond = 1'b0;
                nextpc_sel = NEXTPC_SEL_PC_PLUS4;
                imm = 32'b0;                
            end
        endcase
    end

endmodule
