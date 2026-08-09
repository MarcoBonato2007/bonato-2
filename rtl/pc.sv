
module pc (
    input logic clk,
    input logic rst,
    input logic we,
    input logic [31:0] nextpc,
    output logic [31:0] currentpc
);
    always_ff @(posedge clk) begin
        if (rst) begin
            currentpc <= 32'b0;
        end else if (we) begin
            currentpc <= nextpc;
        end
    end
    
endmodule
