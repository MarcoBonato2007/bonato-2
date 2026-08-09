`include "encodings.svh"

module ex_mem (
    input logic clk,
    input logic rst,
    input logic flush,
    input logic we,

    input logic [31:0] pcplus4_ex,
    input logic [31:0] alu_out_ex,
    input logic [31:0] rs2_ex,
    input logic [2:0] funct3_ex,
    input mem_mode_e mem_mode_ex,
    input rf_in_sel_e rf_in_sel_ex,
    input logic [4:0] rd_ex,

    output logic [31:0] pcplus4_mem,
    output logic [31:0] alu_out_mem,
    output logic [31:0] rs2_mem,
    output logic [2:0] funct3_mem,
    output mem_mode_e mem_mode_mem,
    output rf_in_sel_e rf_in_sel_mem,
    output logic [4:0] rd_mem
);
    always_ff @(posedge clk) begin
        if (flush || rst) begin
            pcplus4_mem <= 32'b0;
            alu_out_mem <= 32'b0;
            rs2_mem <= 32'b0;
            funct3_mem <= 3'b0;
            mem_mode_mem <= MEM_READ; // 1'b0
            rf_in_sel_mem <= RF_SEL_ALU_OUT; // 2'b0
            rd_mem <= 5'b0;
        end else if (we) begin
            pcplus4_mem <= pcplus4_ex;
            alu_out_mem <= alu_out_ex;
            rs2_mem <= rs2_ex;
            funct3_mem <= funct3_ex;
            mem_mode_mem <= mem_mode_ex;
            rf_in_sel_mem <= rf_in_sel_ex;
            rd_mem <= rd_ex;
        end
    end
    
endmodule


