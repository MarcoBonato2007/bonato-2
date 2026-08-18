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
    OP_JALR = 7'b1100111,
    OP_LUI = 7'b0110111,
    OP_AUIPC = 7'b0010111
} opcode_e;

// = {modifier bit, funct3}
typedef enum logic [3:0] {
    ALU_ADD  = 4'b0000,
    ALU_SUB  = 4'b1000,
    ALU_SLL  = 4'b0001,
    ALU_SLT  = 4'b0010,
    ALU_SLTU = 4'b0011,
    ALU_XOR  = 4'b0100,
    ALU_SRL  = 4'b0101,
    ALU_SRA  = 4'b1101,
    ALU_OR   = 4'b0110,
    ALU_AND  = 4'b0111
} alu_op_e;

typedef enum logic {
    MEM_READ = 1'b0,
    MEM_WRITE = 1'b1
} mem_mode_e;

typedef enum logic {
    ALU_SEL_RS1 = 1'b0,
    ALU_SEL_PC = 1'b1
} alu_in1_sel_e;

typedef enum logic {
    ALU_SEL_RS2 = 1'b0,
    ALU_SEL_IMM = 1'b1
} alu_in2_sel_e;

typedef enum logic [1:0] {
    RF_SEL_ALU_OUT = 2'b00,
    RF_SEL_MEM_OUT = 2'b01,
    RF_SEL_PC_PLUS4 = 2'b10
} rf_in_sel_e;

typedef enum logic [1:0] {
    FORWARD_NONE = 2'b00,
    FORWARD_ALU_OUT_MEM = 2'b01,
    FORWARD_ALU_OUT_WB = 2'b10,
    FORWARD_MEM_OUT_WB = 2'b11
} forward_e;

typedef enum logic [1:0] {
    SIZE_BYTE = 2'b00,
    SIZE_HALF = 2'b01,
    SIZE_WORD = 2'b10
} size_e;

`endif
