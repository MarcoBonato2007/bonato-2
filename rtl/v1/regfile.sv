`timescale 1ns/1ps
`default_nettype none

module regfile (
    input logic clk,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd, // set to 0 for no write
    input logic [31:0] write_data,
    output logic [31:0] rs1_val,
    output logic [31:0] rs2_val
);
    logic [31:0] registers [31:0];

    // Reads with internal forwarding
    assign rs1_val = (rs1 == 5'b0) ? 32'b0 : (rs1 == rd ? write_data : registers[rs1]);
    assign rs2_val = (rs2 == 5'b0) ? 32'b0 : (rs2 == rd ? write_data : registers[rs2]);

    always_ff @(posedge clk) begin
        if (rd != 5'b0) begin
            registers[rd] <= write_data; // Write to the selected register
        end
    end
    
endmodule


