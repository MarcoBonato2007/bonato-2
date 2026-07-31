`include "encodings.svh"

module decoder (
    input logic [31:0] instruction,

    output logic [2:0] alu_op,
    output logic [2:0] funct3,
    output logic alu_mod, // turns add into sub, right shift into arithmetic right shift
    output logic [4:0] rread1,
    output logic [4:0] rread2,
    output logic [4:0] rwrite,
    output logic mem_write, // 0 means read, 1 means write
    output logic alu_in_1_select, // 0 for r1, 1 for PC
    output logic alu_in_2_select, // 0 for r2, 1 for immediate value
    output logic [1:0] rf_write_select, // 00 for alu output, 01 for memory output, 10 for PC+4
    output logic conditional, // set to 1 for branches
    output logic nextpc_select, // 0 for PC+4, 1 for alu output
    output logic [31:0] imm
);  
    logic [6:0] opcode;
    logic [4:0] rd, rs1, rs2;

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];

    always_comb begin
        funct3 = instruction[14:12];
        if (opcode == OP_AL_REG) begin
            alu_op = funct3;
            alu_mod = instruction[30];
            rread1 = rs1;
            rread2 = rs2;
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b0;
            rf_write_select = 2'b00;
            conditional = 1'b0;
            nextpc_select = 1'b0;
            imm = 32'b0; // dummy value
        end else if (opcode == OP_AL_IMM) begin
            alu_op = funct3;
            alu_mod = (funct3 == 3'b101) ? instruction[30] : 0;
            rread1 = rs1;
            rread2 = 5'b00000;
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            conditional = 1'b0;
            nextpc_select = 1'b0;
            imm = {{20{instruction[31]}}, instruction[31:20]};
        end else if (opcode == OP_LOAD) begin
            alu_op = 3'b000; // add
            alu_mod = 1'b0;
            rread1 = rs1;
            rread2 = 5'b00000;
            rwrite = rd;
            mem_write = 1'b0; // mem read
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b01;
            conditional = 1'b0;
            nextpc_select = 1'b0;
            imm = {{20{instruction[31]}}, instruction[31:20]};
        end else if (opcode == OP_STORE) begin
            alu_op = 3'b000;
            alu_mod = 1'b0;
            rread1 = rs1;
            rread2 = rs2;
            rwrite = 5'b00000; // ignore write to register (by writing to x0)
            mem_write = 1'b1;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            conditional = 1'b0;
            nextpc_select = 1'b0;
            imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end else if (opcode == OP_BRANCH) begin
            alu_op = 3'b000;
            alu_mod = 1'b0;
            rread1 = rs1;
            rread2 = rs2;
            rwrite = 5'b00000;
            mem_write = 1'b0;
            alu_in_1_select = 1'b1;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            conditional = 1'b1;
            nextpc_select = 1'b1;
            imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        end else if (opcode == OP_JAL) begin
            alu_op = 3'b000;
            alu_mod = 1'b0;
            rread1 = 5'b00000; 
            rread2 = 5'b00000;
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b1;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b10;
            conditional = 1'b0;
            nextpc_select = 1'b1;
            imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        end else if (opcode == OP_JALR) begin
            alu_op = 3'b000;
            alu_mod = 1'b0;
            rread1 = rs1;
            rread2 = 5'b00000;
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b10;
            conditional = 1'b0;
            nextpc_select = 1'b1;
            imm = {{20{instruction[31]}}, instruction[31:20]};
        end else if (opcode == OP_LUI) begin
            alu_op = 3'b000;
            alu_mod = 1'b0;
            rread1 = 5'b00000;
            rread2 = 5'b00000;
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            conditional = 1'b0;
            nextpc_select = 1'b0;
            imm = {instruction[31:12], 12'b0};
        end else if (opcode == OP_AUIPC) begin
            alu_op = 3'b000;
            alu_mod = 1'b0;
            rread1 = 5'b00000;
            rread2 = 5'b00000;
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b1;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            conditional = 1'b0;
            nextpc_select = 1'b0;
            imm = {instruction[31:12], 12'b0};
        end else begin
            // undefined, treat as NOP
            alu_op = 3'b000;
            alu_mod = 1'b0;
            rread1 = 5'b00000;
            rread2 = 5'b00000;
            rwrite = 5'b00000;
            mem_write = 1'b0;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b0;
            rf_write_select = 2'b00;
            conditional = 1'b0;
            nextpc_select = 1'b0;
            imm = 32'b0; // dummy value
        end
    end

endmodule
