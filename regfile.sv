
module regfile (
    input logic clk,
    input logic [4:0] reg1_select,
    input logic [4:0] reg2_select,
    input logic [4:0] write_select,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] reg1_out,
    output logic [31:0] reg2_out
);
    logic [31:0] registers [31:0];

    assign reg1_out = (reg1_select == 5'b0) ? 32'b0 : registers[reg1_select];
    assign reg2_out = (reg2_select == 5'b0) ? 32'b0 : registers[reg2_select];

    always_ff @(posedge clk) begin
        if (write_enable && write_select != 5'b0) begin
            registers[write_select] <= write_data; // Write to the selected register
        end
    end
    
endmodule


