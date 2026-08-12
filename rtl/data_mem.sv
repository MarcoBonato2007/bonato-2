`timescale 1ns/1ps
`default_nettype none
`include "encodings.svh"

module data_mem (
    input logic clk,
    input logic [31:0] addr,
    input mem_mode_e mem_mode,
    input logic [2:0] funct3,
    input logic [31:0] write_data,
    output logic [31:0] mem_out
);
    // Associative array to simulate the entire 32-bit addressing space
    logic [7:0] mem [logic [31:0]];

    logic sign_ext = !funct3[2];
    size_e size = size_e'(funct3[1:0]);

    always_ff @(posedge clk) begin
        /* verilator lint_off BLKSEQ */
        if (mem_mode == MEM_WRITE) begin
            unique case (size)
                SIZE_BYTE: begin
                    mem[addr] = write_data[7:0];
                end
                SIZE_HALF: begin
                    mem[addr] = write_data[7:0];
                    mem[addr+1] = write_data[15:8];
                end
                SIZE_WORD: begin
                    mem[addr] = write_data[7:0];
                    mem[addr+1] = write_data[15:8];
                    mem[addr+2] = write_data[23:16];
                    mem[addr+3] = write_data[31:24];
                end
                default: begin end
            endcase
        end else begin
            logic [31:0] temp;
            unique case (size)
                SIZE_BYTE: begin
                    temp[7:0] = mem.exists(addr) ? mem[addr] : 8'b0;
                    temp[31:8] = sign_ext ? {{24{temp[7]}}} : 24'b0;
                end
                SIZE_HALF: begin
                    temp[7:0] = mem.exists(addr) ? mem[addr] : 8'b0;
                    temp[15:8] = mem.exists(addr+1) ? mem[addr+1] : 8'b0;
                    temp[31:16] = sign_ext ? {{16{temp[15]}}} : 16'b0;
                end
                SIZE_WORD: begin
                    temp[7:0] = mem.exists(addr) ? mem[addr] : 8'b0;
                    temp[15:8] = mem.exists(addr+1) ? mem[addr+1] : 8'b0;
                    temp[23:16] = mem.exists(addr+2) ? mem[addr+2] : 8'b0;
                    temp[31:24] = mem.exists(addr+3) ? mem[addr+3] : 8'b0;
                end
                default: begin 
                    temp = 32'b0;
                end
            endcase
            mem_out <= temp;
        end
        /* verilator lint_on BLKSEQ */
    end

endmodule
