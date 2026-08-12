`timescale 1ns/1ps
`default_nettype none

module pc (
    input logic clk,
    input logic rst, // Synchronous
    input logic we,
    input logic [31:0] nextpc,
    output logic [31:0] currentpc
);
    always_ff @(posedge clk) begin
        if (rst) begin
            currentpc <= 32'b0;
        end else if (we) begin
            // quietly handle pc alignment, may trap in future
            currentpc <= nextpc[31:0];
        end
    end
    
endmodule
