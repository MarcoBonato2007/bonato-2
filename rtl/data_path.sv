`default_nettype none
`include "encodings.svh"

module data_path (
    input logic clk,
    input logic rst
);    
    // Pipeline registers (packed structs)
    // _d is the next state, _q is the current state

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] pcplus4;
        logic [31:0] instr;
    } if_id_t;
    if_id_t if_id_d, if_id_q;
    logic if_id_we;
    logic if_id_flush;

    typedef struct packed {
        logic [31:0] pc;
        logic [31:0] pcplus4;
        logic [31:0] rs1;
        logic [31:0] rs2;
        logic [31:0] imm;
        logic [4:0] rs1_sel;
        logic [4:0] rs2_sel;
        logic [4:0] rd_sel;
        logic [2:0] funct3;
        alu_in1_sel_e alu_in1_sel;
        alu_in2_sel_e alu_in2_sel;
        alu_op_e      alu_op;
        logic         is_cond;
        nextpc_sel_e  nextpc_sel;
        mem_mode_e    mem_mode;
        rf_in_sel_e   rf_in_sel;
    } id_ex_t;
    id_ex_t id_ex_d, id_ex_q;
    logic id_ex_flush;

    typedef struct packed {
        logic [31:0] pcplus4;
        logic [31:0] alu_out;
        logic [31:0] rs2;
        logic [4:0] rd_sel;
        logic [2:0] funct3;
        mem_mode_e mem_mode;
        rf_in_sel_e rf_in_sel;
    } ex_mem_t;
    ex_mem_t ex_mem_d, ex_mem_q;

    typedef struct packed {
        logic [31:0] pcplus4;
        logic [31:0] alu_out;
        logic [31:0] mem_out;
        logic [4:0] rd_sel;
        rf_in_sel_e rf_in_sel;
    } mem_wb_t;
    mem_wb_t mem_wb_d, mem_wb_q;

    // Fetch stage intermediate signals

    logic pc_we;
    logic [31:0] pc_if;
    logic [31:0] pcplus4_if;
    logic [31:0] instr_if;

    // Decode stage intermediate signals

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

    // Execute stage intermediate signals

    forward_e forward_rs1_ex;
    forward_e forward_rs2_ex;
    logic [31:0] alu_in1_ex;
    logic [31:0] alu_in2_ex;
    logic [31:0] alu_out_ex;
    logic comparison_result_ex;

    // Memory stage intermediate signals

    logic [31:0] mem_out_mem;





endmodule
