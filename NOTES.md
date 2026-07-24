I want to implement the RV32I instruction set + Zicsr, where the processor is always in machine mode, and is single cycle (I will maybe change it to be two cycles, fetch/decode and execute).

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

## CSR's (machine only)
There's a 12 bit encoding space for CSR's. The top two bits indicate whether the register is read/write (00, 01 or 10) or read-only (11).  

- misa: identifies the ISA used. 
    * MXL field = 1 (read-only, top two bits)
    * Extension field has a 1 in position 8 ("I") and nowhere else. 
    * Because of this implementation, misa is essentially read-only, but silently ignores writes (without raising an exception).
- mvendorid: set to 0 (non-commercial implementation), read-only
- marchid: set to 0, read-only
- mimpid: essentially a version control number, can set to 1.0.0 initially, read-only. The format/layout can be decided freely.
- mhartid: set to 0 (there's only one core/thread)
- mstatus(h): Encodes the hart's current operating state. mstatush is the upper 32 bits. 
    * SIE/SPIE/MPRV/MXR/SUM/SBE/UBE/TVM/TW/TSR/FS/VS/XS/SD fields should be read-only 0.
    * The MIE field is interrupt enable (1) / disable (0). 
    * The MPIE field holds the value of MIE prior to a trap
    * MPP holds the previous privilege mode (hardcoded to M, ignore writes). Other xPP fields are read-only 0. 
    * SXL/UXL fields don't exist
    * MBE field should be hardcoded to 0 (little endian) and ignore writes
    * SPELP/MPELP fields should be hardcoded to 0 and ignore writes
- mtvec: holds trap vector configuration. 
    * The BASE field must be 4-byte aligned (note that the CSR doesn't contain the last two bits of BASE, those are zero filled when using BASE as an address)
    * The MODE field is hardcoded to 0 and ignores writes
    

Attempting to access any other CSR should raise an illegal instruction exception.


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

