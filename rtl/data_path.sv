`include "encodings.svh"

module data_path (
    input logic clk,
    input logic rst
);
    // TODO: refactor. Try using struct packed and other methods.
    

    // Signals across the five pipeline stages

    logic pc_we; // from hazard unit
    logic [31:0] pc_if;
    logic [31:0] pclus4_if;
    logic [31:0] instr_if;

    // Outputs of if/id
    logic [31:0] pc_id;
    logic [31:0] pcplus4_id;
    logic [31:0] instr_id;
    // Decoder outputs
    logic [4:0] rs1_sel_id;
    logic [4:0] rs2_sel_id;
    logic [31:0] imm_id;
    alu_in1_sel_e alu_in1_sel_id;
    alu_in2_sel_e alu_in2_sel_id;
    logic [3:0] alu_op_id;
    logic [2:0] funct3_id;
    logic is_cond_id;
    nextpc_sel_e nextpc_sel_id;
    mem_mode_e mem_mode_id;
    rf_in_sel_e rf_in_sel_id;
    logic [4:0] rd_sel_id;
    // Register file outputs
    logic [31:0] rs1_id;
    logic [31:0] rs2_id;

    // Outputs of id/ex
    logic [31:0] pc_ex;
    logic [31:0] pcplus4_ex;
    logic [31:0] rs1_ex;
    logic [31:0] rs2_ex;
    logic [31:0] imm_ex;
    alu_in1_sel_e alu_in1_sel_ex;
    alu_in2_sel_e alu_in2_sel_ex;
    logic [3:0] alu_op_ex;
    logic [2:0] funct3_ex;
    logic is_cond_ex;
    nextpc_sel_e nextpc_sel_ex;
    mem_mode_e mem_mode_ex;
    rf_in_sel_e rf_in_sel_ex;
    logic [4:0] rd_sel_ex;
    // Out of alu
    logic [31:0] alu_out_ex;
    // Out of comparator
    logic comparison_result_ex;
    // Out of forwarding unit
    forward_e forward_rs1_ex;
    forward_e forward_rs2_ex;

    // Outputs of ex/mem
    logic [31:0] pcplus4_mem;
    logic [31:0] alu_out_mem;
    logic [31:0] rs2_mem;
    logic [2:0] funct3_mem;
    mem_mode_e mem_mode_mem;
    rf_in_sel_e rf_in_sel_mem;
    logic [4:0] rd_sel_mem;
    // Out of memory
    logic [31:0] mem_out_mem;

    // Outputs of mem/wb
    logic [31:0] pcplus4_wb;
    logic [31:0] alu_out_wb;
    logic [31:0] mem_out_wb;
    rf_in_sel_e rf_in_sel_wb;
    logic [4:0] rd_sel_wb;

    // Signals for pipeline registers

    logic if_id_we;
    logic if_id_flush;
    logic id_ex_we;
    logic id_ex_flush;
    logic ex_mem_we;
    logic ex_mem_flush;
    logic mem_wb_we;
    logic mem_wb_flush;



endmodule
