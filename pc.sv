// nextpc should be either currentpc+4, or alu output (may change later)
// May need a write enable signal in future (for a multi-cycle architecture)

module pc (
    input logic clk,
    input logic rst_n,
    input logic [31:0] nextpc,
    output logic [31:0] currentpc,
);
    logic [31:0] pc;
    assign currentpc = pc;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 32'b0;
        end else begin
            pc <= nextpc;
        end
    end
    
endmodule

