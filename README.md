# bonato-2
Exploring hardware design further in SystemVerilog, trying to replicate the base RV32I RISC-V instruction set. **This will likely be a slow, long-term project.**

# ISA

This section contains observations and notes I made for myself whilst reading through the manual.

## Registers
- There are 32 registers, each 32 bits, called x0-x31. `x0` is the the zero register, and is always zero. x1-x32 are general purpose.
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
- `NOP` is encoded as `ADDI x0, x0, 0`
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
- `ECALL`, `BREAK`: `1110011`

### funct3
- Branch/load/store instructions: `funct3` helps to uniquely identify the type of instruction (e.g. differentiating `BLT` and `BGE`)
- Arithmetic instructions: `funct3` is the same for the same types of operations: e.g. `funct3` is `111` for `AND` and `ANDI`. Note that `ADD` and `SUB` are considered the same type too.

### funct7
- For the base ISA, only bit 30 can be non-zero. Bit 30 is 1 for arithmetic right shifts or subtraction, and 0 otherwise.

# Commands

## Running

`$env:PATH = "C:\msys64\ucrt64\bin;C:\msys64\usr\bin;" + $env:PATH`
`verilator_bin --binary -Wall hello.sv -LDFLAGS "-mconsole"`
`.\obj_dir\Vhello.exe`

## Generating a schematic: yosys

`
yosys -p "
read_verilog -sv and_gate.sv;
hierarchy -top and_gate;
proc;
opt;
show -format svg -prefix and_gate
"
`   

## Generating a schematic: netlistsvg

`
yosys -p "
read_verilog -sv and_gate.sv;
hierarchy -top and_gate;
proc;
opt;
write_json and_gate.json
"
`

`netlistsvg and_gate.json -o and_gate.svg`