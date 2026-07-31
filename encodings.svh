`ifndef ENCODINGS_SVH
`define ENCODINGS_SVH

// `define CONSTANT 1000

typedef enum logic [6:0] {
    OP_AL_REG = 7'b0110011, // AL: Arithmetic Logic
    OP_AL_IMM = 7'b0010011,
    OP_LOAD = 7'b0000011,
    OP_STORE = 7'b0100011,
    OP_BRANCH = 7'b1100011,
    OP_JAL = 7'b1101111,
    OP_JALR = 7'b1001111,
    OP_LUI = 7'b0110111,
    OP_AUIPC = 7'b0010111
} opcode_e;

// TODO: expand this, implement this into decoder.sv
    // e.g. the codes for rf_input_select, alu input selection, etc.

`endif
