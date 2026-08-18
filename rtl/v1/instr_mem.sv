`timescale 1ns/1ps
`default_nettype none

module instr_mem (
    input logic [31:0] addr,
    output logic [31:0] instr
);
    // Associative array to simulate the entire 32-bit addressing space
    // program is loaded in externally by a testbench
    logic [31:0] rom [logic [31:0]];

    // rom has 0, 1, 2, ... addresses but instructions have 0, 4, 8, ... addresses, so >> 2
    assign instr = rom.exists(addr >> 2) ? rom[addr >> 2] : 32'b0;


    // If you want to have clocked memory, then remove instr from pipeline reg
    // The clocking of the memory acts as a pipeline register by itself

    // always_ff @(posedge clk) begin
    //     instr <= rom.exists(addr) ? rom[addr]: 32'b0; 
    // end

endmodule
