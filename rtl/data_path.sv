`default_nettype none
`include "encodings.svh"

// TODO: refactor.
    // use a packed struct for each pipeline register
    // Instead of having .sv files for each pipeline reg, just use the packed structs, assigning 0 on flush/rst
    // Maybe use _d for for next state and _q for current state or smth like that
    // You probably don't need we and flush for every pipeline reg, remove what you don't need, hardcode the rest

module data_path (
    input logic clk,
    input logic rst
);    
    // Fetch stage

    logic pc_we;
    logic [31:0] pc_if;
    logic [31:0] pcplus4_if;
    logic [31:0] instr_if;

    // Decode stage

    logic [31:0] pc_id;
    logic [31:0] pcplus4_id;
    logic [31:0] instr_id;

    logic [4:0] rs1_sel_id;
    logic [4:0] rs2_sel_id;
    logic [31:0] imm_id;
    alu_in1_sel_e alu_in1_sel_id;
    alu_in2_sel_e alu_in2_sel_id;
    alu_op_e alu_op_id;
    logic [2:0] funct3_id;
    logic is_cond_id;
    nextpc_sel_e nextpc_sel_id;
    mem_mode_e mem_mode_id;
    rf_in_sel_e rf_in_sel_id;
    logic [4:0] rd_sel_id;

    logic [31:0] rs1_id;
    logic [31:0] rs2_id;

    // Execute stage

    logic [31:0] pc_ex;
    logic [31:0] pcplus4_ex;
    logic [31:0] rs1_ex;
    logic [31:0] rs2_ex;
    logic [31:0] imm_ex;
    alu_in1_sel_e alu_in1_sel_ex;
    alu_in2_sel_e alu_in2_sel_ex;
    alu_op_e alu_op_ex;
    logic [2:0] funct3_ex;
    logic is_cond_ex;
    nextpc_sel_e nextpc_sel_ex;
    mem_mode_e mem_mode_ex;
    rf_in_sel_e rf_in_sel_ex;
    logic [4:0] rd_sel_ex;

    logic [31:0] alu_out_ex;

    logic comparison_result_ex;

    forward_e forward_rs1_ex;
    forward_e forward_rs2_ex;

    // Memory stage

    logic [31:0] pcplus4_mem;
    logic [31:0] alu_out_mem;
    logic [31:0] rs2_mem;
    logic [2:0] funct3_mem;
    mem_mode_e mem_mode_mem;
    rf_in_sel_e rf_in_sel_mem;
    logic [4:0] rd_sel_mem;

    logic [31:0] mem_out_mem;

    // Writeback stage

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
