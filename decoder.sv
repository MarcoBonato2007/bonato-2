
module decoder (
    input logic [31:0] instruction,
    output logic [2:0] alu_op,
    output logic alu_mod, // turns add into sub, right shift into arithmetic right shift
    output logic [4:0] rread1,
    output logic [4:0] rread2,
    output logic [4:0] rwrite,
    output logic mem_write, // 0 means read, 1 means write
    output logic alu_in_1_select, // 0 for r1, 1 for PC
    output logic alu_in_2_select, // 0 for r2, 1 for immediate value
    output logic [2:0] rf_write_select, // 00 for alu output, 01 for memory output, 10 for PC+4
    output logic shift12 // set to 1 to shift an immediate by 12 places left
);
    opcode = instruction[6:0];
    rd = instruction[11:7]
    funct3 = instruction[14:12];
    rs1 = instruction[19:15]
    rs2 = instruction[24:20]
    imm_i = instruction[31:20] // TODO: modify to make it work for different opcodes, put in block below

    always_comb begin
        if (opcode == 7'b0110011) begin
            alu_op = funct3;
            alu_mod = instruction[30];
            rread1 = rs1;
            rread2 = rs2;
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b0;
            rf_write_select = 2'b00;
            shift12 = 1'b0;
        end else if (opcode == 7'b0010011) begin
            alu_op = funct3;
            alu_mod = (funct3 == 3'b101) ? instruction[30] : 0;
            rread1 = rs1;
            rread2 = rs2; // Ignored, could set to zero
            rwrite = rd;
            mem_write = 1'b0;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            shift12 = 1'b0;
        end else if (opcode == 7'b0000011) begin
            alu_op = 3'b000; // add
            alu_mod = 1'b0;
            rread1 = rs1;
            rread2 = rs2; // Ignored, could set to zero
            rwrite = rd;
            mem_write = 1'b0; // mem read
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b01;
            shift12 = 1'b0;
        end else if (opcode == 7'b0100011) begin
            alu_op = 3'b000; // add
            alu_mod = 1'b0;
            rread1 = rs1;
            rread2 = rs2; // Ignored, could set to zero
            rwrite = 3'b000; // ignore write to register (by writing to x0)
            mem_write = 1'b1;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            shift12 = 1'b0;
        end else if (opcode == 7'b1100011) begin
            alu_op = 3'b000; // add
            alu_mod = 1'b0;
            rread1 = rs1;
            rread2 = rs2; // Ignored, could set to zero
            rwrite = 3'b000; // ignore write to register (by writing to x0)
            mem_write = 1'b1;
            alu_in_1_select = 1'b0;
            alu_in_2_select = 1'b1;
            rf_write_select = 2'b00;
            shift12 = 1'b0;
        end else if (opcode == 7'b1101111) begin
        end else if (opcode == 7'b1100111) begin
        end else if (opcode == 7'b0110111) begin
        end else if (opcode == 7'b0010111) begin
        end
        // continue...

        // TODO: Think about how to implement loading a byte vs half vs word vs unsigned byte vs unsigned half
        // TODO: need to have a circuit to construct the imm's for each instruction type properly
            // e.g. for s type vs i type they are in different places
        // TODO: need a control signal for the conditional branch
    end


endmodule
