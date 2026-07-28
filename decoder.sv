
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
        end
        // continue...
    end


endmodule
