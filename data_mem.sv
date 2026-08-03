`include "encodings.svh"

module data_mem (
    input logic clk,
    input logic [31:0] addr,
    input mem_mode_e mem_mode,
    input logic [31:0] write_data,
    output logic [31:0] mem_out
);
    // Associative array to simulate the entire 32-bit addressing space
    logic [31:0] mem [logic [31:0]];

    always_ff @(posedge clk) begin
        if (mem_mode == MEM_WRITE) begin
            mem[addr] = write_data;
        end  
        
        mem_out <= mem.exists(addr) ? mem[addr]: 32'b0; 
    end

endmodule
