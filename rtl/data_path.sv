`timescale 1ns/1ps
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
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [31:0] rs1_val;
        logic [31:0] rs2_val;
        logic [4:0] rd;
        logic [31:0] imm;
        logic [2:0] funct3;
        alu_in1_sel_e alu_in1_sel;
        alu_in2_sel_e alu_in2_sel;
        alu_op_e alu_op;
        logic is_cond;
        logic nextpc_is_branch;
        mem_mode_e mem_mode;
        rf_in_sel_e rf_in_sel;
    } id_ex_t;
    id_ex_t id_ex_d, id_ex_q;
    logic id_ex_flush;

    typedef struct packed {
        logic [31:0] pcplus4;
        logic [31:0] alu_out;
        logic [31:0] rs2_val;
        logic [4:0] rd;
        logic [2:0] funct3;
        mem_mode_e mem_mode;
        rf_in_sel_e rf_in_sel;
    } ex_mem_t;
    ex_mem_t ex_mem_d, ex_mem_q;

    typedef struct packed {
        logic [31:0] pcplus4;
        logic [31:0] alu_out;
        logic [31:0] mem_out;
        logic [4:0] rd;
        rf_in_sel_e rf_in_sel;
    } mem_wb_t;
    mem_wb_t mem_wb_d, mem_wb_q;

    // Declare signals which pass directly between pipeline registers
    assign id_ex_d.pc = if_id_q.pc;
    assign id_ex_d.pcplus4 = if_id_q.pcplus4;
    assign ex_mem_d.pcplus4 = id_ex_q.pcplus4;
    assign ex_mem_d.mem_mode = id_ex_q.mem_mode;
    assign ex_mem_d.funct3 = id_ex_q.funct3;
    assign ex_mem_d.rs2_val = rs2_val_forwarded_ex;
    assign ex_mem_d.rf_in_sel = id_ex_q.rf_in_sel;
    assign ex_mem_d.rd = id_ex_q.rd;
    assign mem_wb_d.pcplus4 = ex_mem_q.pcplus4;
    assign mem_wb_d.alu_out = ex_mem_q.alu_out;
    assign mem_wb_d.rf_in_sel = ex_mem_q.rf_in_sel;
    assign mem_wb_d.rd = ex_mem_q.rd;

    // Intermediate signals require calculation, or are between two modules only
    // Other signals are wired with pipeline registers

    // Fetch stage intermediate signals
    logic pc_we;
    logic [31:0] nextpc_if;

    // Execute stage intermediate signals
    forward_e forward_rs1_ex;
    forward_e forward_rs2_ex;
    logic [31:0] rs1_val_forwarded_ex;
    logic [31:0] rs2_val_forwarded_ex;
    logic [31:0] alu_in1_ex;
    logic [31:0] alu_in2_ex;

    logic comparison_result_ex;
    logic nextpc_is_branch_ex_cond;

    // Writeback stage intermediate signals
    logic [31:0] rf_write_data_wb;

    // Wiring modules
    pc pc_i (
        .clk (clk),
        .rst (rst),
        .we (pc_we),
        .nextpc (nextpc_if),
        .currentpc (if_id_d.pc)
    );

    instr_mem instr_mem_i (
        .addr (if_id_d.pc),
        .instr (if_id_d.instr)
    );

    decoder decoder_i (
        .instr (if_id_q.instr),
        .alu_op (id_ex_d.alu_op),
        .funct3 (id_ex_d.funct3),
        .rs1 (id_ex_d.rs1),
        .rs2 (id_ex_d.rs2),
        .rd (id_ex_d.rd),
        .mem_mode (id_ex_d.mem_mode),
        .alu_in1_sel (id_ex_d.alu_in1_sel),
        .alu_in2_sel (id_ex_d.alu_in2_sel),
        .rf_in_sel (id_ex_d.rf_in_sel),
        .is_cond (id_ex_d.is_cond),
        .nextpc_is_branch (id_ex_d.nextpc_is_branch),
        .imm (id_ex_d.imm)
    );

    regfile regfile_i (
        .clk (clk),
        .rs1 (id_ex_d.rs1),
        .rs2 (id_ex_d.rs2),
        .rd (mem_wb_q.rd),
        .write_data (rf_write_data_wb),
        .rs1_val (id_ex_d.rs1_val),
        .rs2_val (id_ex_d.rs2_val)
    );

    alu alu_i (
        .a (alu_in1_ex),
        .b (alu_in2_ex),
        .alu_op (id_ex_q.alu_op),
        .alu_out (ex_mem_d.alu_out)
    );

    comparator comparator_i (
        .a (rs1_val_forwarded_ex),
        .b (rs1_val_forwarded_ex),
        .funct3 (id_ex_q.funct3),
        .result (comparison_result_ex)
    );

    data_mem data_mem_i (
        .clk (clk),
        .addr (ex_mem_q.alu_out),
        .mem_mode (ex_mem_q.mem_mode),
        .funct3 (ex_mem_q.funct3),
        .write_data (ex_mem_q.rs2_val),
        .mem_out (mem_wb_d.mem_out)
    );

    forwarding forward_i (
        .rs1_ex (id_ex_q.rs1),
        .rs2_ex (id_ex_q.rs2),
        .rd_mem (ex_mem_q.rd),
        .rf_in_sel_mem (ex_mem_q.rf_in_sel),
        .rd_wb (mem_wb_q.rd),
        .rf_in_sel_wb (mem_wb_q.rf_in_sel),
        .forward_rs1 (forward_rs1_ex),
        .forward_rs2 (forward_rs2_ex)
    );

    hazard hazard_i (
        .rs1_id (id_ex_d.rs1),
        .rs2_id (id_ex_d.rs2),
        .rd_ex (id_ex_q.rd),
        .rf_in_sel_ex (id_ex_q.rf_in_sel),
        .nextpc_is_branch_ex_cond (nextpc_is_branch_ex_cond),
        .if_id_we (if_id_we),
        .if_id_flush (if_id_flush),
        .id_ex_flush (id_ex_flush),
        .pc_we (pc_we)
    );

    // Calculate intermediate signals
    always_comb begin
        // forwarding
        unique case (forward_rs1_ex) 
            FORWARD_NONE: rs1_val_forwarded_ex = id_ex_q.rs1_val;
            FORWARD_ALU_OUT_MEM: rs1_val_forwarded_ex = ex_mem_q.alu_out;
            FORWARD_ALU_OUT_WB: rs1_val_forwarded_ex = mem_wb_q.alu_out;
            FORWARD_MEM_OUT_WB: rs1_val_forwarded_ex = mem_wb_q.mem_out;
        endcase
        unique case (forward_rs2_ex) 
            FORWARD_NONE: rs2_val_forwarded_ex = id_ex_q.rs2_val;
            FORWARD_ALU_OUT_MEM: rs2_val_forwarded_ex = ex_mem_q.alu_out;
            FORWARD_ALU_OUT_WB: rs2_val_forwarded_ex = mem_wb_q.alu_out;
            FORWARD_MEM_OUT_WB: rs2_val_forwarded_ex = mem_wb_q.mem_out;
        endcase

        // alu inputs
        unique case (id_ex_q.alu_in1_sel)   
            ALU_SEL_RS1: alu_in1_ex = rs1_val_forwarded_ex;
            ALU_SEL_PC: alu_in1_ex = id_ex_q.pc;
        endcase
        unique case (id_ex_q.alu_in2_sel)   
            ALU_SEL_RS2: alu_in2_ex = rs2_val_forwarded_ex;
            ALU_SEL_IMM: alu_in2_ex = id_ex_q.imm;
        endcase

        if_id_d.pcplus4 = if_id_d.pc + 4;
        nextpc_is_branch_ex_cond = (id_ex_q.nextpc_is_branch && (!id_ex_q.is_cond || (id_ex_q.is_cond && comparison_result_ex)));
        nextpc_if = {{nextpc_is_branch_ex_cond ? ex_mem_d.alu_out : if_id_d.pcplus4}[31:2], 2'b0};
        
        // register file write
        unique case (mem_wb_q.rf_in_sel)
            RF_SEL_ALU_OUT: rf_write_data_wb = mem_wb_q.alu_out;
            RF_SEL_MEM_OUT: rf_write_data_wb = mem_wb_q.mem_out;
            RF_SEL_PC_PLUS4: rf_write_data_wb = mem_wb_q.pcplus4;
            default: rf_write_data_wb = mem_wb_q.alu_out;
        endcase
    end

    // Pipeline management (incl. stalling, flushing)
    always_ff @(posedge clk) begin
        if (rst || if_id_flush) begin
            if_id_q <= '0;
        end else if (if_id_we) begin
            if_id_q <= if_id_d;
        end

        if (rst || id_ex_flush) begin
            id_ex_q <= '0;
        end else begin
            id_ex_q <= id_ex_d;
        end

        if (rst) begin
            ex_mem_q <= '0;
        end else begin
            ex_mem_q <= ex_mem_d;
        end

        if (rst) begin
            mem_wb_q <= '0;
        end else begin
            mem_wb_q <= mem_wb_d;
        end
    end

endmodule
