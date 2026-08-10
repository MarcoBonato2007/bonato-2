
module regfile (
    input logic clk,
    input logic [4:0] rs1_sel,
    input logic [4:0] rs2_sel,
    input logic [4:0] rd_sel, // set to 0 for no write
    input logic [31:0] write_data,
    output logic [31:0] rs1,
    output logic [31:0] rs2
);
    logic [31:0] registers [31:0];

    // Reads with internal forwarding
    assign rs1 = (rs1_sel == 5'b0) ? 32'b0 : (rs1_sel == rd_sel ? write_data : registers[rs1_sel]);
    assign rs2 = (rs2_sel == 5'b0) ? 32'b0 : (rs2_sel == rd_sel ? write_data : registers[rs2_sel]);

    always_ff @(posedge clk) begin
        if (rd_sel != 5'b0) begin
            registers[rd_sel] <= write_data; // Write to the selected register
        end
    end
    
endmodule


