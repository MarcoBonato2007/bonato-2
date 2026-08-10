`default_nettype none

module if_id (
    input logic clk,
    input logic rst,
    input logic flush,
    input logic we,

    input logic [31:0] pc_if,
    input logic [31:0] pcplus4_if,
    input logic [31:0] instr_if,

    output logic [31:0] pc_id,
    output logic [31:0] pcplus4_id,
    output logic [31:0] instr_id
);
    always_ff @(posedge clk) begin
        if (flush || rst) begin
            pc_id <= 32'b0;
            pcplus4_id <= 32'b0;
            instr_id <= 32'b0;
        end else if (we) begin
            pc_id <= pc_if;
            pcplus4_id <= pcplus4_if;
            instr_id <= instr_if;
        end
    end
    
endmodule
