
module comparator (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [2:0] funct3,
    output logic result
);
    always_comb begin
        case (funct3)
            3'b000: result = (a == b);
            3'b001: result = (a != b);
            3'b100: result = ($signed(a) < $signed(b));
            3'b101: result = ($signed(a) >= $signed(b));
            3'b110: result = (a < b);
            3'b111: result = (a >= b);
            default: result = 1'b0;
        endcase
    end
endmodule
