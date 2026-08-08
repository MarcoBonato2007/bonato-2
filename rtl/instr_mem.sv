
module instr_mem (
    input logic clk,
    input logic [31:0] addr,
    output logic [31:0] instr
);
    // Associative array to simulate the entire 32-bit addressing space
    logic [31:0] rom [logic [31:0]];

    initial begin
        $readmemh("program.hex", rom); 
    end

    always_ff @(posedge clk) begin
        instruction <= rom.exists(addr) ? rom[addr]: 32'b0; 
    end

endmodule
