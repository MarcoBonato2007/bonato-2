// Standard rv32I can address at most 4 GiB of memory (byte-addressed)
// I'll use memory with 256 words for now

module ram (
    input logic clk,
    input logic [7:0] address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] ram_out,
);
    logic [31:0] memory [255:0];

    always_ff @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= write_data;
        end else begin
            ram_out <= memory[address];
        end
    end
    
endmodule
