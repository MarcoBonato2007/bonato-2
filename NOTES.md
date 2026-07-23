# Notes from the manuals

## Implementation ideas / notes to myself
- Keep the shifter inside the ALU, but have a hardcoded shift by 12 circuit
- And then add the zero register to that
- Have the write data to the register file be multiplexed between PC+4, alu output and memory output
- Have the write data to the pc be multiplexed between alu output and PC+4
- Implement FENCE as a NOP (for now... may change on a multi-cycle or multi-core cpu)
- Need to make sure that all machine instructions are supported (the ones that should be)
- Test your implementation with the official repo

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
- `ECALL`, `BREAK`, `CSRRW(I)`, `CSRRS(I)`, `CSRRC(I)`, `MRET`, `WFI`: `1110011` (system opcode)

### funct3
- Branch/load/store instructions: `funct3` helps to uniquely identify the type of instruction (e.g. differentiating `BLT` and `BGE`)
- Arithmetic instructions: `funct3` is the same for the same types of operations: e.g. `funct3` is `111` for `AND` and `ANDI`. Note that `ADD` and `SUB` are considered the same type too.

### funct7
- For the base ISA (looking at the base arithmetic/logic/branching instructions), only bit 30 can be non-zero. Bit 30 is 1 for arithmetic right shifts or subtraction, and 0 otherwise.

# Notes from privileged manual

I want to implement the RV32I instruction set + Zicsr, where the processor is always in machine mode, and is single cycle (I will maybe change it to be two cycles, fetch/decode and execute).

## Extra instructions (Zicsr, machine level ISA, ecall, ebreak)

I want to implement the Zicsr extension, with the CPU always running in machine mode. That introduces the following instructions (along with the standard ECALL and EBREAK):
- CSRRW(I): reads the old value of the csr, zero extends it, writes it to rd, then writes rs1 to the csr. If rd=x0 then the csr shouldn't be read, but still written to.
- CSRRS(I): reads the old value of the csr, zero extends it, writes it to rd, then any high bit in rs1 causes the corresponding bit in the csr to be set (if that bit is writeable). So basically you or mask with rs1.
- CSRRC(I): like CSRRS, but clears instead of sets bits at positions where rs1 is 1.
- In CSRRS/CSRRC, if rs1 is x0 then the csr is not written to. So this is the way to read a csr without any writes. Similarly, in the immediate versions, if uimm=0 then the csr is not written to.
- WFI: Can start by implementing this as a NOP. Change if implementing timers or other interrupts.
- MRET: Exits a trap. Sets pc to mepc, mstatus.MIE is set to mstatus.MPIE, then mstatus.MPIE is set to 1.
- ECALL: Set mepc to the current pc (NOT pc + 4). Write code 11 (environment call from m-mode) to mcause, and set its interrupt bit to 0. Set mtval to 0. Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0. Set pc to mtvec.BASE (can only use direct mode). 
- EBREAK: Set mepc to the current pc (NOT pc + 4). Write code 3 (environment call from m-mode) to mcause, and set its interrupt bit to 0. Set mtval to 0 (or the current pc). Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0. Set pc to mtvec.BASE (can only use direct mode). 

For instructions like ecall and ebreak, make sure that some behaviours are suppressed: e.g. minstret is not incremented, mie is unchanged, etc. (in future: find a list of suppressed behavior)

## Machine CSR's
TODO: make a list of the CSR's, how they're laid out, what they do, etc.
- ...
- Attempting to access any other CSR should raise an exception (which one?)


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

