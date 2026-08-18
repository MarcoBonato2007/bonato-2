This file contains notes regarding the v2 architecture, which implements RV32I + Zicsr in machine mode only, building on the v1. While v1 is complete, v2 is currently a work in progress.

# Implementation notes

Note: I still need to think about how to implement traps on exceptions/interrupts.

Currently my idea is to place the CSR file at the decode stage, with two read ports and one write port (like a normal register file), and specialized hardware to deal with traps (since that requires writes to multiple specific CSR's). 

As will be mentioned below, I could easily handle the hazard management for CSR instructions via usual methods (mainly forwarding, I doubt there's a need for stalling). Furthermore, since ECALL, EBREAK and MRET all branch (causing a flush), I don't need to worry much about instructions executed after those instructions (granted the CSR file is in the decode stage and has internal forwarding). So it actually seems like I won't need to invent/change a lot of logic to be able to manage hazards for CSR's.

## Interrupts and exceptions

Exceptions (e.g. illegal instruction, misaligned fetch, etc.) always trap and are synchronous. An interrupt (e.g. timer interrupt) is asynchronous and traps when mstatus.MIE=1 and its bit is set in both mip and mie. On a trap, the following should happen:
- mepc is written with the virtual address of the instruction that was
interrupted or that encountered the exception. The lowest two bits are always zero.
- mtval is either set to zero or written with exception-specific information to assist software in handling the trap. Can be set to read-only zero if wanted. If not, it is a WARL register. See the manual for a list of rules for mtval in certain instructions (e.g. EBREAK).
- mcause is written with a code indicating the event that caused the trap. 
    * The interrupt bit is set if the trap was caused by an interrupt. 
    * The exception code field contains a code identifying the last exception or interrupt. This is a WRLR field, meaning that it accepts any write, but illegal writes cause the system to enter an undefined state. So like a WARL field but without modifying illegal write inputs to be legal.
    * Check the manual for a full list of the codes
- pc is set to mtvec.BASE
- Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0

This raises a few implementation questions.
- Ideally, an exception should be precise: this means that instructions before it finish, and instructions after it don't execute. Given the current pipeline, the latter means detecting an exception by the memory stage, which is easy. The former condition is trickier, especially when the instructions before the exception are CSR or system instructions. We would either need to be very careful when dealing with hazards (e.g. an instruction modifying mstatus.MIE followed by an ECALL), or take a lazy approach (e.g. stall an exception until instructions ahead of it complete).
- If both an exception and interrupt occur, what should be serviced first? 
- When should an exception be handled? 
    * It's likely not a good idea to do this on the cycle the exception arises, as that would reduce maximum clock speed. 
    * Doing it on the following cycle seems like a better idea. You still face the issue of having to let previous instructions finish executing. Since exceptions will be generated in the execute/memory stages, this means 3/4 cycle penalties (assuming no stalls).
    * There's also the lazy approach, which is to wait until the writeback stage, which solves the issue of previous instructions finishing their execution before the exception is handled. Here the cycle penalty is fixed at 4 cycles.

It immediately seems best to choose the last approach from the third bullet point to implement exceptions, which is to accumulate exception signals in the pipeline and then consume them once an instruction reaches the writeback stage. Yes, the cycle penalty is high, but it seems like it will be high no matter what you do, and with this approach the penalty is fixed. This approach also easily resolves the first bullet point.

Regarding the second point, suppose an interrupt is detected and we also have an exception-causing instruction in the writeback stage. Now how should you choose whether to service the exception or the interrupt?

## New instructions

- CSRRW(I): reads the old value of the csr, zero extends it, writes it to rd, then writes rs1 to the csr. If rd=x0 then the csr shouldn't be read, but still written to.
- CSRRS(I): reads the old value of the csr, zero extends it, writes it to rd, then any high bit in rs1 causes the corresponding bit in the csr to be set (if that bit is writeable). So basically you or mask with rs1.
- CSRRC(I): like CSRRS, but clears instead of sets bits at positions where rs1 is 1.
- In CSRRS/CSRRC, if rs1 is x0 then the csr is not written to. So this is the way to read a csr without any writes. Similarly, in the immediate versions, if uimm=0 then the csr is not written to.
- WFI: Can start by implementing this as a NOP. Change if implementing timers or other interrupts.
- MRET: Exits a trap. Sets pc to mepc, mstatus.MIE is set to mstatus.MPIE, then mstatus.MPIE is set to 1.
- ECALL: Set mepc to the current pc (NOT pc + 4). Write code 11 (environment call from m-mode) to mcause, and set its interrupt bit to 0. Set mtval to 0. Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0. Set pc to mtvec.BASE (can only use direct mode). 
- EBREAK: Set mepc to the current pc (NOT pc + 4). Write code 3 (environment call from m-mode) to mcause, and set its interrupt bit to 0. Set mtval to 0 (or the current pc). Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0. Set pc to mtvec.BASE (can only use direct mode). 

### CSR instructions

For the first 3 types of instructions, you need to:
- Read a certain csr
- Write its contents to rd
- Then write to the csr using rs1.
Assuming we have a separate CSR file, the first two bullet points can simply be achieved by reading the csr at a stage before writeback, and then writing to the register file as usual (from the writeback stage). The third bullet point could be achieved by extending the writeback stage to also include csr writes (this seems like the intuitive choice). However, this does mean that I'll need to implement forwarding for CSR reads aswell (although the logic should be extremely similar to the current forwarding unit), and possibly also stalls (which doesn't seem like a problem). 

A question is at what stage I should read the CSR. Decode is a natural choice, putting the CSR file parallel to the register file.

### MRET

From what I see, this requires a branch and reading from two CSR's (mepc and mstatus), which doesn't seem at all like an issue in the current datapath. Here are the main takeaways:
- Allow for two reads from the CSR file (this lines up nicely with ECALL and EBREAK)
- Branch addresses are calculated from the ALU, so you would need to be able to make the ALU take a csr read value as an input (this will also probably be required for the csr instructions from the previous section). You could do that by just extending the alu selection signals (and introducing more opcodes).

### ECALL and EBREAK

These are almost the same, except for the exception code put into the mcause CSR. In general, you need to write to mcause, mtval, mstatus and mepc, while reading from mstatus and mtvec. You also need to flush the pipeline, which is not an issue. This is again two reads, but 4 writes. 

Since this is an isolated case, I can hardcode the CSR file to be able to support specialised writes for mcause, mtval, mstatus, etc.

For instructions like ecall and ebreak, make sure that some behaviours are suppressed: e.g. minstret is not incremented, mie is unchanged, etc. (in future: find a list of suppressed behavior)

## List of CSR's (machine only)
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
    * All traps into machine mode cause pc to be set to mtvec.BASE
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
- Decide if you generate exceptions for things like misaligned accesses or misaligned jumps
