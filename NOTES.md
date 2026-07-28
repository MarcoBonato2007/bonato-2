I want to implement the RV32I instruction set (and possibly Zicsr where the processor is always in machine mode) with the classic five-stage pipeline (fetch, decode, execute, memory, writeback).
- **Start by implementing only the basic arithmetic/logic, load/store and branching operations.**. Then consider adding in Zicsr.
- Implement FENCE/WFI as a NOP? (for now)
- Test your implementation with the official repo

# Pipeline

I did some research on the five-stage pipeline. Here are some notes (from books, wikipedia, etc.), or theories about how to implement it.

Currently a question is how much to put in the decode stage, and how much to put in the execute stage (some things seem like they could go in both).

## General notes

- From what I can see, you separate the stages using pipeline registers which kind of act like a waiting mechanism between cycles. 
- An instruction may trap/raise an exception (e.g. for an illegal CSR access): so architectural changes should not be applied until you're sure the instruction won't raise something like that
- Keep it simple: don't implement any branch prediction, apart from assuming that branches aren't taken.
- I'll have separate data and instruction memory (Harvard architecture). I could implement a Von Neumann architecture: I don't think it would be that complicated, apart from needing extra hazard detection (memory will always be being read from for a new instruction, so any memory read/write instructions cause a hazard).

## Hazards

- A hazard is a term from a problem you might get when trying to use the pipeline naively. For exampe, when the result of one instruction is needed by a subsequent one before the former has completed in the pipeline, or when you need to clear the pipeline after a branch has been taken. To resolve hazards, you usually make a dedicated hazard unit to detect hazards and handle them.
- Forwarding/bypassing is used to quickly send intermediate values in one instruction to another part of the pipeline for the next instruction, to avoid a hazard. For example, when executing add x0, x1, x2 followed by sub x3, x0, x4, the sub instruction needs to read the value of x0 after the previous add has already finished executing: this can be done by forwarding the intermediate addition result back in the pipeline so it can be used by the sub instruction.
- Stalling is used when forwarding doesn't work or for architectural hazards like two instructions trying to both read memory at the same time (e.g. trying to read instructions and data from memory simultaneously). It simply introduces a delay (like a NOP) between instructions until the instructions can execute as normal again.
- Flushing: consider branching. What instructions should your pipeline fetch next? The ones after the branch instruction or the ones following where the branch is pointing to? The simple approach is to assume it won't be taken, meaning a taken branch will require the pipeline to be flushed. More advanced processors will try to predict whether the branch will be taken or not: in general, a mispredicted branch introduces a penalty in pipelined processors.

## Fetch

- Should mainly contain the PC and instruction memory. It should feed the fetched intruction (and also probably its PC value) forward to the decode stage via a pipeline register.
- On a branch (suppose there's a branch further in the pipeline, either in the execute or writeback stage), apart from the rest of the pipeline being flushed, the PC should set its value to the new one

## Decode

- This should just be responsible for generating the control signals for the following stages of the pipeline. Here are some ideas for the control signals I'll need:
    * A 3-bit ALU control signal (taken from funct3 for arithmetic/logic operations, 0 otherwise (assuming all other operations only use the ALU for addition)), along with a modifier bit (to change add into sub and right shift into arithmetic right shift)
    * Two register read signals and a register write signal & write enable signal
    * A memory read/write signal. 
    * Something to choose between a register selection and the PC (for the first ALU input)
    * Something to choose between a register selection and an immediate value (for the second ALU input)
    * A signal to decide whether the PC is replaced with PC+4 or the ALU output (actually, this can be generated in the execute stage)
    * A signal to decide whether the register file write input is PC+4 / alu output / memory output
    * A signal to decide whether to shift an immediate value left by 12 (hardcoded shifter circuit)
    * The data memory read input can always be ALU output, and its write input can always be the second register selection (although perhaps modified when writing a byte/half). Note this means the second register selection should be available even if it's not the second alu input.
- From what I can see online, this stage also includes steps like sign extending immediates, choosing alu inputs, reading the register file, etc. (i.e. getting everything ready before the execute step). Maybe some things can go in the execute step though.
- You could combine the sign extension circuitry with the shift left by 12 component (which together makes the component that completely prepares immediates for the execute stage)
- This is also a good stage to send data to the hazard/control unit to decide whether to go ahead with this instruction as usual or if there's a need to flush/stall

## Execute

- This stage should definitely contain the ALU, and perhaps also the hardcoded shift by 12 component (as previously mentioned you could also put this into the decode stage)
- Consider branching: you'd want to perform a comparison, and also calculate a sum with the PC. The ALU already has its control codes filled by other operations, so you'll probably want to have a separate comparison circuit.
- You'll probably want to generate a control signal here (the one that decides whether the PC increments or is replaced by the ALU output)
- This is probably where you'd want to detect a taken branch and flush the pipeline if so. However, it might be a good idea to move the comparison circuit to the decode step, and detect taken branches there, reducing the amount of the pipeline that is flushed on a taken branch.
- You could move the muxes for choosing alu inputs into this section, so that you can do forwarding more easily. Or you could keep them in the decode stage.

## Memory access

- This should just contain the data memory, and get fed some signals like read address/write input/write address/write enable/etc.
- Actually, chances are that the read and write address inputs are actually the same (i.e. the memory can't read and write at the same time)

## Writeback

- I think this section can just contain the multiplexer used to choose what to write back into the register file, the output of which can then be fed back into the pipeline stage with the register file.
- Note: apparently some hardware impementations of register don't work when being read from and written to at the same time, so it might be a good idea to have hazard detection for this (this can probably be solved easily by forwarding).

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
- `ECALL`, `EBREAK`, `CSRRW(I)`, `CSRRS(I)`, `CSRRC(I)`, `MRET`, `WFI`: `1110011` (system opcode)

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

## CSR's and registers (machine only)

### CSR's
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
    * The MODE field is hardcoded to 0 and ignores writes (no support for vectored mode for now)
- medeleg, mideleg: do not exist
- mie/mip: mie contains interrupt enable bits, and mip contains info on pending interrupts. An interrupt i traps if mstatus.MIE=1 and bit i is set in both mip and mie. Spans various types of interrupts (external, timer, software, etc.).
    * The MSIP, SEIP, STIP, SSIP, LCOFIP bits of mip should be read-only zero
    * The MSIE, SEIE, STIE, SSIE, LCOFIE bits of mie should be read-only zero.
- mcycle(h): counts the number of clock cycles executed. Has 64 bits (hence the higher bit version)
- minstret(h): counts the number of instructions retired/executed. Has 64 bits (hence the higher bit version)
- mhpmcounter3-31 / mhpmevent3-mhpmevent31: should be read-only zero. These are just counters for custom (platform-dependent) events, and can be zero if not implemented.
- mcounteren: should not exist
- mcountinhibit: controls whether mcycle/minstret/mhpmcountern increment. The CY/IR bits are 1/0 when mcycle/minstret do/do not count. HPMn bits control whether mhpmcountern csr's count, which they don't: these fields should be hardwired to zero, ignoring writes.
- mscratch: use is entirely up to the platform. Typically, it is used to hold a pointer to a machine-mode hart-local context space and swapped with a user register upon entry to an M-mode trap handler.
- mepc: When a trap is taken into M-mode, mepc is written with the virtual address of the instruction that was
interrupted or that encountered the exception. The lowest two bits are always zero.
- mcause: When a trap is taken into M-mode, mcause is written with a code indicating the event that caused the trap. 
    * The interrupt bit is set if the trap was caused by an interrupt. 
    * The exception code field contains a code identifying the last exception or interrupt. This is a WRLR field, meaning that it accepts any write, but illegal writes cause the system to enter an undefined state. So like a WARL field but without modifying illegal write inputs to be legal.
    * Check the manual for a full list of the codes
- mtval: When a trap is taken into M-mode, mtval is either set to zero or written with exception-specific information to assist software in handling the trap. Can be set to read-only zero if wanted. If not, it is a WARL register. See the manual for a list of rules for mtval in certain instructions (e.g. EBREAK).
- mconfigptr: should be read-only zero (not implemented)
- menvcfg(h): does not exist
- mseccfg(h): does not exist

Attempting to access any other CSR should raise an illegal instruction exception.

## Extra info

- Upon reset, the mstatus fields MIE and MPRV are reset to 0. If little endian memory accesses are supported, the mstatus/mstatush field MBE is reset to 0. The pc is set to an implementation-defined reset vector. The mcause register is set to a value indicating the cause of the reset (can set to 0 if the implementation doesn't distinguish between reset conditions). 
- Split the address space into main memory/IO. Allow byte/halfword/word accesses everywhere. Should I allow misaligned accesses? Disallow instruction fetch from IO regions.

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

