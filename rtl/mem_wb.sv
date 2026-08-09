`include "encodings.svh"

module mem_wb (
    input logic clk,
    input logic rst,
    input logic flush,
    input logic we,

    input logic [31:0] pcplus4_mem,
    input logic [31:0] alu_out_mem,
    input logic [31:0] mem_out_mem,
    input rf_in_sel_e rf_in_sel_mem,
    input logic [4:0] rd_mem,

    output logic [31:0] pcplus4_wb,
    output logic [31:0] alu_out_wb,
    output logic [31:0] mem_out_wb,
    output rf_in_sel_e rf_in_sel_wb,
    output logic [4:0] rd_wb
);
    always_ff @(posedge clk) begin
        if (flush || rst) begin
            pcplus4_wb <= 32'b0;
            alu_out_wb <= 32'b0;
            mem_out_wb <= 32'b0;
            rf_in_sel_wb <= RF_SEL_ALU_OUT; // 2'b0
            rd_wb <= 5'b0;
        end else if (we) begin
            pcplus4_wb <= pcplus4_mem;
            alu_out_wb <= alu_out_mem;
            mem_out_wb <= mem_out_mem;
            rf_in_sel_wb <= rf_in_sel_mem;
            rd_wb <= rd_mem;
        end
    end

endmodule
