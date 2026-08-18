This file contains notes regarding the v1 architecture, which implements RV32I without extensions and excluding any system instructions.

# General notes

- There's no branch prediction at the moment: taken branches or jumps introduce a 2 cycle penalty.
- Instruction and data memories are separate without cache (this simplified hazards)

## Possible future changes
- Instruction memory is not clocked. Apparently in a real scenario it would need to be clocked: to do this, just let the instruction memory act as part of the if/id pipeline register to transmit the instruction to the decode stage.
- Data memory reads are not clocked (exact same situation as the instruction memory)
- Introduce an adder to the decode stage to reduce the penalty for jumps by 1 cycle, although this would complicate hazards (especially if you tried to do this for conditional branches, since comparison circuitry should be in the execute stage).
- Instead of flushing, add a `valid` control signal to each stage. Similarly, instead of setting `rd_sel` or `rs_sel` to 0 when you don't want to read/write from a register, have a register file write enable bit along with bits to indicate whether rs1 and rs2 are read / need reading.

# Pipeline

## Stages

### Fetch

- Contains the instruction memory and the pc (which is fed directly into the instruction memory)
- Currently the instruction memory is not clocked
- Also contains a multiplexer to choose between PC+4 and alu output (taken from the execute stage) for the next pc value, which is fed into the write input for the pc.
- Feeds an instruction, its pc value, and pc+4 into the if/id pipeline register

### Decode

- Contains the instruction decoder and the register file, and also has some connections to the hazard unit
- The register file reads rs1 and rs2 from the decoded instruction. The rd and write_data inputs come from the writeback stage later in the pipeline. Note that forwarding happens at the execute stage.
- The register file has internal forwarding: so when a register x is being written to with data y, any reads to x that happen simultaneously with the write will output y instead of the old value of x.
- The instruction decoder automatically constructs and sign extends immediates
- This section feeds the following signals to the id/ex pipeline register:
    * pc and pc+4
    * rs1
    * rs1_val
    * rs2
    * rs2_val
    * rd
    * imm
    * alu_in1_sel (chooses between rs1 and PC for the first ALU input)
    * alu_in2_sel (chooses between rs2 and imm for the second ALU input)
    * alu_op
    * funct3
    * is_cond (really should be renamed to is_branch, since it only affects the nextpc signal)
    * nextpc_is_branch
    * mem_mode (read or write)
    * rf_in_sel (chooses between PC+4, alu output, and memory output for register file write data)

### Execute

- Contains forwarding multiplexers for register value signals, connected to signals further in the pipeline
- Contains two multiplexers to choose the first and second inputs to the ALU using the signals described previously
- Contains the ALU and a parallel comparison unit (which compares rs1 and rs2). If is_cond is 1, and comparison fails, then nextpc_is_branch is zeroed out.
- This is the stage where branch addresses are calculated and branches/jumps are taken: branch addresses are calculated from the ALU, so there is a connection from the ALU back to the multiplexer in the fetch stage choosing the next pc value.
- This section feeds the following signals to the ex/mem pipeline register:
    * pc+4
    * alu_out
    * rs2 (needed for memory accesses)
    * funct3
    * mem_mode
    * rf_in_sel
    * rd

### Memory

- This section only contains the data memory, which is fed an address (alu output), write data (rs2), the mem_mode signal, and funct3 (to choose between loading/storing a word/half/byte).
- Things like handling sign or zero extension when loading in values are handled inside the data memory block
- This section feeds the following signals to the mem/wb pipeline register:
    * pc+4
    * alu_out
    * mem_out
    * rf_in_sel
    * rd

### Writeback

- This section contains a multiplexer to choose between pc+4, alu_out, and mem_out for the register file data write input, chosen via rf_in_sel.
- The chosen write input and the rwrite signal is then wired to the register file in the decode stage

## Hazards

### Pseudocode (old first draft)

This is an old first draft of forwarding and stalling pseudocode. Any kind of hazard detection is ignored when dealing with the zero register.

```sv
forward_1 = 2'b00 // 2'b00 means no forwarding
forward_2 = 2'b00
if (rs1_ex == rwrite_mem && rs1_ex != 5'b00000) begin
    if (rf_in_sel_mem == 2'b00) begin
        forward_1 = 2'b01 // forward alu out from memory stage
    end
end else if (rs1_ex == rwrite_wb && rs1_ex != 5'b00000) begin
    if (rf_in_sel_wb == 2'b00) begin
        forward_1 = 2'b10 // forward alu out from writeback stage
    end else if (rf_in_sel_wb == 2'b01) begin
        forward_1 = 2'b11 // forward mem out from writeback stage
    end
end

// Copy the same code for rs2
```

One question is how to implement. There are two options:
- Generate the forwarding signals when the instruction being forwarded to is in the execute stage. This may reduce the maximum clock speed slightly since, in the execute stage, you would need to wait for the `forward_1` and `forward_2` signals to settle.
- Detect any forwarding during the decode stage, a nd then stage a write to registers holding the `forward_1` and `forward_2` signals. Then, on the next cycle, those signals will immediately be available. However, I would have to wait for the rs1 and rs2 signals to be decoded.

Although the second option seemed better at first (even though it wasn't the standard), it would require waiting for several signals to settle in the execute stage, whereas the first option can always immediately use signals. So I'll opt for the first option.

### Types of hazards

- Branching/jumping: since there is no branch prediction, taken branches/jumps will require two stages of the pipeline to be flushed (i.e. zeroed out), introducing a 2 cycle penalty. 
- Read after write: this is the main hazard, caused when an instruction writes to a register rd and the next attempts to read from rd. This is solved using forwarding, stalling, and internal forwarding. Here are some examples.
    * `add x1, x2, x3` followed by `sub x4, x1, x5`. This case is solved by forwarding the alu output from the start of the memory stage to the start of the execute stage. If there was an instruction inbetween, you could forward the alu output from the start of the writeback stage instead. If there were two instructions in-between, then the hazard is solved by internal forwarding in the register file.
    * The above example is the most common, but there's another important case: a load to a register followed by a read to it, for example, `lw x1, [x2, imm]` followed by `sub x4, x1, x5`. If there were one or two independent instructions in-between, then this hazard is solved in the same way as before (by forwarding memory out or internal forwarding respectively). However, if there is no instruction in-between, you would insert a bubble between the two instructions (stalling), and then use forwarding as in the one-in-between case. 
    * Note: instead of stalling, you could forward from the end of the memory stage to the start of the execute stage, but then you would have to wait for all the signals in the execute stage to settle again, reducing the maximum clock speed considerably. Therefore stalling is the better option.
- Note: read after write is only an issue with registers, since memory access can only happen in one place. Furthermore, registers can be written to by 3 things: alu out, memory out, and pc+4. Registers are only written by pc+4 on a jump, and since there's a 2 cycle penalty, the reading instruction is at most in the decode stage when the writing instruction is in the writeback stage, so only internal forwarding is needed. Therefore we don't need to worry about forwarding pc+4 to the multiplexers at the start of the execute satge.

### Forwarding

I will forward to multiplexers at the start of the execute stage (for the rs1 and rs2 signals) from the following places ahead in the pipeline:
- alu output (from the start of the memory stage)
- alu output (from the start of the writeback stage)
- memory output (from the start of the writeback stage)
You can check the `forwarding.sv` file for the logic (it turned out to be suprisingly simple).

### Stalling

From what I can see, the only case where this is required is on a load-use hazard: i.e. when you load a value from memory into a register, and then proceed to read from it. 
While you could forward the memory out signal from the end of the memory stage to the start of the execute stage, this would really reduce the maximum clock speed. So instead you stall the pipeline by 1 cycle. 
This happens when the reading instruction reaches the decode stage. You do this by disabling the write enable for the if/id register, and setting the flush signal the id/ex register.

### Flushing

This is required for taken branches and all jumps. Branch addresses and conditions are calculated in the execute stage. When a branch/jump is detected, you set the flush signals for both the if/id and id/ex pipeline registers, introducing a 2-cycle penalty.

### Layering

Is it possible to create more complicated situations where you try to stack hazards on top of each other?
- Load-use followed by a conditional branch: e.g. loading a value into rs1, and then using rs1 to perform a conditional branch. This is solved by stalling: i.e. insert a bubble so that when the load instruction is in the writeback stage, the branch instruction is in the execute stage, and you can forward the loaded value back. This can be handled in the exact same way as a normal load-use, but with the added implication that our comparison circuitry remains in the execute stage.
- ... (any more?)

# Notes from the manuals

## Registers
- There are 32 registers, each 32 bits, called x0-x31. `x0` is the the zero register, and is always zero. x1-x31 are general purpose.
- There is only one additional unprivileged register, which is the program counter. There is no dedicated sp/lr/etc.
- A 'saved register' is one that should remain unchanged after a subroutine has finished executing

### Convention
- `x1`: return address (ra)
- `x2`: stack pointer (sp)
- `x3`: global pointer (gp)
- `x4`: thread pointer (tp)
- `x5-x7`: temporary registers (t0-t2, like r0-r3 on arm)
- `x8`: saved/frame pointer (s0)
- `x9`: saved register (s1)
- `x10-x11`: fn args/return values (a0-a1)
- `x12-x17`: fn args (a2-a7)
- `x18-x27`: saved registers (s2-s11)
- `x28-x31`: temporaries (t3-t6) 

## Instruction format
- All instructions are 32 bits.
- The base ISA has `IALIGN=32`: this means that instructions must be aligned to four bytes in memory.
- The source registers are called `rs1` and `rs2`, and the destination `rd`.
- Immediates are always sign extended (except for the 5-bit immediates used in the CSR instructions)
- The sign bit of immediates is always in bit 31
- `NOP` is encoded as `ADDI x0, x0, 0` by default
- The funct3 and funct7 fields act like secondary opcodes to identify an instruction

## Encoding notes
### opcode
- `LUI`: `0110111` (load upper immediate)
- `AUIPC`: `0010111` (shifts a 20-bit immediate 12 spots left, adds to pc, stores in register)
- `JAL`: `1101111`
- `JALR`: `1100111`
- `B<cond>`: `1100011`
- Load instructions: `0000011`
- Store instructions: `0100011`
- Immediate arithmetic (e.g. `ANDI`): `0010011`
- Register arithmetic (e.g. `AND`): `0110011`
- `FENCE`, `PAUSE`: `0001111`
- `ECALL`, `EBREAK`, `CSRRW(I)`, `CSRRS(I)`, `CSRRC(I)`, `MRET`, `WFI`: `1110011` (system opcode)

### funct3
- Branch/load/store instructions: `funct3` helps to uniquely identify the type of instruction (e.g. differentiating `BLT` and `BGE`)
- Arithmetic instructions: `funct3` is the same for the same types of operations: e.g. `funct3` is `111` for `AND` and `ANDI`. Note that `ADD` and `SUB` are considered the same type too.

### funct7
- For the base ISA (looking at the base arithmetic/logic/branching instructions), only bit 30 can be non-zero. Bit 30 is 1 for arithmetic right shifts or subtraction, and 0 otherwise.

# Commands

## Running verilator

`verilator_bin --binary -Wall hello.sv`. Add `--trace` if dumping to a waveform file.

## Generating a schematic: yosys

`
yosys -p "
read_verilog -sv file.sv;
hierarchy -top module;
proc;
opt;
show -format svg -prefix module
"
`   

## Generating a schematic: netlistsvg

`
yosys -p "
read_verilog -sv file.sv;
hierarchy -top module;
proc;
opt;
write_json module.json
"
`

`netlistsvg module.json -o module.svg`

## Yosys command for datapath

First comment out the instruction and data memories

`
yosys -p "                                                      
read_verilog -sv -I. data_path.sv alu.sv pc.sv hazard.sv decoder.sv forwarding.sv regfile.sv comparator.sv;
read_verilog -lib -sv data_mem.sv instr_mem.sv;
hierarchy -top data_path;
proc;                    
write_json data_path.json
"
`

`netlistsvg data_path.json -o data_path.svg`

## Assembly to elf

You'll likely want `link.ld` to specify that instructions start at address 0.

`riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T link.ld -o program.elf program.s`

`riscv64-unknown-elf-objdump -d program.elf`

## elf to hex
`riscv64-unknown-elf-objcopy -O verilog --verilog-data-width=4 test_program.elf test_program.hex`

