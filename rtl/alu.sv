`default_nettype none

module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input alu_op_e alu_op,
    output logic [31:0] alu_out
);
    always_comb begin
        unique case (alu_op)
            ALU_ADD: alu_out = a + b;
            ALU_SUB: alu_out = a - b;
            ALU_SLL: alu_out = a << b[4:0];
            ALU_SLT: alu_out = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            ALU_SLTU: alu_out = (a < b) ? 32'b1 : 32'b0;
            ALU_XOR: alu_out = a ^ b;
            ALU_SRL: alu_out = a >> b[4:0];
            ALU_SRA: alu_out = $signed(a) >>> b[4:0];
            ALU_OR: alu_out = a | b;
            ALU_AND: alu_out = a & b;
            default: alu_out = 32'b0;
        endcase
    end
endmodule
