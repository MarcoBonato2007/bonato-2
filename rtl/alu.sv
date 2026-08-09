
module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0] alu_op, // = {instr[30], funct3} or 4'b0
    output logic [31:0] result
);
    always_comb begin
        unique case (funct3)
            4'b0000: result = a + b; // ADD
            4'b1000: result = a - b; // SUB
            4'b0001: result = a << b[4:0]; // SLL
            4'b0010: result = ($signed(a) < $signed(b)) ? 1 : 0; // SLT
            4'b0011: result = (a < b) ? 1 : 0; // SLTU
            4'b0100: result = a ^ b; // XOR
            4'b0101: result = a >> b[4:0]; // SRL
            4'b1101: result = $signed(a) >>> b[4:0] // SRA
            4'b0110: result = a | b; // OR
            4'b0111: result = a & b; // AND
            default: result = 32'b0; // Default case
        endcase
    end
endmodule
