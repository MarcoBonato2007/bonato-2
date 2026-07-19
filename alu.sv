// use the funct3 codes, and a modifier bit for sub/arithmetic right shifts

module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [2:0] funct3,
    input logic mod, // bit 30, modifier bit for sub/arithmetic right shifts
    output logic [31:0] result
);
    always_comb begin
        case (funct3)
            3'b000: result = mod ? a - b : a + b; // ADD/SUB
            3'b001: result = a << b[4:0]; // SLL, only the last 5 bits (shift at most 31 times)
            3'b010: result = ($signed(a) < $signed(b)) ? 1 : 0; // SLT
            3'b011: result = (a < b) ? 1 : 0; // SLTU
            3'b100: result = a ^ b; // XOR
            3'b101: result = mod ? $signed(a) >>> b[4:0] : a >> b[4:0]; // SRL/SRA
            3'b110: result = a | b; // OR
            3'b111: result = a & b; // AND
            // default: result = 32'h00000000; // Default case
        endcase
    end
endmodule
