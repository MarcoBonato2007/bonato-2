This file contains notes regarding the v2 architecture, which implements RV32I + Zicsr in machine mode only, building on the v1. While v1 is complete, v2 is currently a work in progress.

# Implementation notes

The v2 implements Zicsr and machine mode. Certain things like memory mapping and interrupt/GPIO controllers is left for later (v3?).

Note: since this implementation is in-order, treat a FENCE instruction as a NOP.
Note: change certain things to be clocked (like instr/data mem reads)

## Interrupt and exception behavior (+ MRET, ECALL, EBREAK)

### Overview

Exceptions (e.g. illegal instruction, misaligned fetch, etc.) always trap and are synchronous. An interrupt x (e.g. timer interrupt) is asynchronous and traps when mstatus.MIE=1 and bit x is set in both mip and mie. On a trap, the following should happen:
- mepc is written with the virtual address of the instruction that was interrupted or that encountered the exception. The lowest two bits are always zero.
- mtval is either set to zero or written with exception-specific information to assist software in handling the trap
- mcause is written with a code indicating the event that caused the trap. 
    * The interrupt bit is set if the trap was caused by an interrupt. 
    * The exception code field contains a code identifying the last exception or interrupt. This is a WRLR field, meaning that it accepts any write, but illegal writes cause the system to enter an undefined state. So like a WARL field but without modifying illegal write inputs to be legal.
    * Check the manual for a full list of the codes
- pc is set to mtvec.BASE or BASE+4*cause, depending on if vectored mode is enabled or not
- Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0

This raises a few implementation questions.
- Ideally, an exception should be precise: this means that instructions before it finish, and instructions after it don't execute. The former condition is tricky, especially when the instructions before the exception are CSR or system instructions. We would either need to be very careful when dealing with hazards (e.g. an instruction modifying mstatus.MIE followed by an ECALL), or take a lazy approach (e.g. stall an exception until instructions ahead of it complete).
- If both an exception and interrupt occur, what should be serviced first? This seems platform dependent, in this implementation I'll opt for letting exceptions go first.
- When should an exception be handled? 
    * It's likely not a good idea to do this on the cycle the exception arises, as that would reduce maximum clock speed. 
    * Doing it on the following cycle seems like a better idea. You still face the issue of having to let previous instructions finish executing. Since exceptions will be generated in the execute/memory stages, this means 3/4 cycle penalties (assuming no stalls).
    * There's also the lazy approach, which is to wait until the writeback stage, which solves the issue of previous instructions finishing their execution before the exception is handled. Here the cycle penalty is fixed at 4 cycles.

It immediately seems best to choose the last approach from the third bullet point to implement exceptions, which is to accumulate exception signals in the pipeline and then consume them once an instruction reaches the writeback stage. Yes, the cycle penalty is high, but it seems like it will be high no matter what you do, and with this approach the penalty is fixed. This approach also easily resolves the first bullet point.

However, when a faulting instruction moves to the writeback stage, the instruction after it will go into the memory stage and possibly modify data. To fix this you can send a signal from the writeback stage back to the memory stage to prevent any write.

### List of exceptions

Note that there's an exception priority which needs to be observed.
- Misaligned jump / memory write / memory read
- Illegal instruction (e.g. accessing non-existent CSR's, writing to read-only CSR's, etc.)
- ECALL/EBREAK
- Trying to access memory which is out of bounds / location doesn't exist (this isn't actually an issue when enforcing alignment)
- I'll also raise an exception for an unrecognised opcode

### Overall implementation notes
- Accumulate exceptions from the decode/execute/memory stages until an instruction reaches the writeback stage, and an exception is consumed there
- Expand the memory mode signal to have a memory off signal, to prevent misaligned address exceptions for instructions that don't even use memory
- Expand the next pc selection signal to include an mtvec.BASE or mtvec.BASE+4*cause input and an mepc input
- When an exception or trapping interrupt is detected (remember to check mstatus.MIE, mip and mie first), have a unit that decides the priority, (see table 17 from the manual), and then:
    - Set a trap=1 signal on the CSR file (to indicate a trap on the next rising edge)
    - Have the pc in the writeback stage be an input to the CSR file, so when trap=1, mepc can be set to that pc value
    - Have the ALU out of the writeback stage also be an input to the CSR file, so that you can set mtval (along with the pc)
    - Have an input signal to the CSR file for the cause of the exception/interrupt 
    - Using mtvec.MODE, send either mtvec.BASE or mtvec.BASE+4*cause as the next pc value, and modify the nextpc selection signal.
    - Set mstatus.MPIE to mstatus.MIE, and then set mstatus.MIE to 0. 
    - Send flush signals to every pipeline register
- Note: an ECALL/EBREAK instruction can just be regarded as a particular type of exception and dealt with as such
- You will need something special for an MRET instruction, for example:
    - Set a return=1 signal on the CSR File (to indicate a trap exit on the next rising edge)
    - Set the next pc select signal to be mepc (implying mepc is an output of the csr file)
    - Set mstatus.MIE to mstatus.MPIE, then set mstatus.MPIE to 1
    - Send flush signals to every pipeline register
- When taking a trap, minstret should not increment, and a faulting instruction should not modify any state
- On a trap or a return, be aware that something may still update at the memory stage. To avoid this, i'll add signals such as "enabled", "trap" or "return" to components in the memory stage to suppress any state change.

## Local interrupts

For the v2, external interrupts will be hardwired to zero, so we'll only worry about local interrupts. There are only two kinds: timer interrupts and software interrupts. An annoyance is that mtime and mtimecmp (the registers used for timer interrupts) are defined to be memory-mapped: the v2 is only a CPU design and not an SoC, so I'd like to avoid defining a memory-map where possible. So I'll just not include these, and disable / hardwire to zero any timer interrupt or related things.

## CSR instructions

### Overview

Here are the three CSR instructions to implement:
- CSRRW(I): reads the old value of the csr, zero extends it, writes it to rd, then writes rs1 to the csr. If rd=x0 then the csr shouldn't be read, but still written to.
- CSRRS(I): reads the old value of the csr, zero extends it, writes it to rd, then any high bit in rs1 causes the corresponding bit in the csr to be set (if that bit is writeable). So basically you or mask with rs1.
- CSRRC(I): like CSRRS, but clears instead of sets bits at positions where rs1 is 1.
- In CSRRS/CSRRC, if rs1 is x0 or uimm=0 then the csr is read from but is not written to, so for example this should not raise an exception for read only registers.

To implement these instructions, you need to:
- Read a certain csr
- Write its contents to rd
- Then write to the csr using rs1 or uimm (5-bit zero extended immediate value)
Assuming we have a separate CSR file, the first two bullet points can simply be achieved by reading the csr at a stage before writeback, and then writing to the register file as usual (from the writeback stage). The third bullet point could be achieved by extending the writeback stage to also include csr writes (this seems like the intuitive choice). However, this does mean I need to look out for new hazards when it comes to CSR's.

A question is at what stage I should put the CSR file (i.e. at what stage to read the CSR's). My current idea is to put it in the memory stage, and always enforce a one-cycle stall after every csr instruction. This way, I think I can keep my clock speed higher, whilst only changing forwarding logic slightly, and only needing one port on the CSR file.

### Overall implementation notes
- Add a CSR file in the memory stage, with a single address port.
- Always add a one-cycle stall after each CSR instruction. This could probably easily be changed to only happen when needed (i.e. when the next instruction is trying to read from rd)
- When using the CSR file, feed in rs1, and have it work using read-before-write: i.e. on the next rising clock edge, it will output the old value of the CSR, and then update the CSR value to its new value internally. You could also move the CSR write to the writeback stage, but that would mean needing another address port which seems annoying.
- Adapt register forwarding 
    * Option 1: add a multiplexer to the end of the memory stage to choose between csr out and memory read, then you can reuse MEM_OUT signals, but this may decrease maximum clock speed
    * Option 2: keep memory out and csr out separate and feed both into mem/wb, expand the register file select signals, and expand the forwarding muxes in the execute stage.

## WFI

From what I can see online, this is implemented via clock gating (i.e. disconnecting the clock signal from the CPU). Perhaps I can do this by disconnecting the clock from most of the CPU except for particular areas like an interrupt unit.

TODO: research implementation details

## CSR behaviour

This section considers implementing certain CSR's like mcycle or mtime.
- mcycle is really easy (just increment every clock cycle)
- minstret is too, except it must not increment on faulting/trapping instructions or flushed pipeline stages: therefore it would be best to add an "is_valid" signal to the pipeline registers

# List of CSR's (machine only)
There's a 12 bit encoding space for CSR's. The top two bits indicate whether the register is read/write (00, 01 or 10) or read-only (11).  

- misa 0x301: identifies the ISA used. 
    * MXL field = 1 (read-only, top two bits)
    * Extension field has a 1 in position 8 ("I") and nowhere else. 
    * Because of this implementation, misa is essentially read-only, but silently ignores writes (without raising an exception).
- mvendorid 0xF11: set to 0 (non-commercial implementation), read-only
- marchid 0xF12: set to 0, read-only
- mimpid 0xF13: essentially a version control number, can set to 1.0.0 initially, read-only. The format/layout can be decided freely.
- mhartid 0xF14: set to 0 (there's only one core/thread)
- mstatus 0x300, mstatush 0x310: Encodes the hart's current operating state. mstatush is the upper 32 bits. 
    * SIE/SPIE/MPRV/MXR/SUM/SBE/UBE/TVM/TW/TSR/FS/VS/XS/SD fields should be read-only 0.
    * The MIE field is interrupt enable (1) / disable (0). 
    * The MPIE field holds the value of MIE prior to a trap
    * MPP holds the previous privilege mode (hardcoded to M, ignore writes). Other xPP fields are read-only 0. 
    * SXL/UXL fields don't exist
    * MBE field should be hardcoded to 0 (little endian) and ignore writes
    * SPELP/MPELP fields should be hardcoded to 0 and ignore writes
- mtvec 0x305: holds trap vector configuration. 
    * All traps into machine mode cause pc to be set to mtvec.BASE
    * The BASE field must be 4-byte aligned (note that the CSR doesn't contain the last two bits of BASE, those are zero filled when using BASE as an address)
    * The MODE field is hardcoded to 0 and ignores writes (no support for vectored mode for now)
- mie 0x304, mip 0x344: mie contains interrupt enable bits, and mip contains pending interrupts. An interrupt i traps if mstatus.MIE=1 and bit i is set in both mip and mie. This spans various types of interrupts (external, timer, software, etc.).
    * The MSIP bit is a software interrupt
    * The MEIP bit is an external interrupt (controlled using an interrupt controller)
    * The MTIP bit is a timer interrupt
    * The SEIP, STIP, SSIP, LCOFIP bits of mip should be read-only zero
    * The SEIE, STIE, SSIE, LCOFIE bits of mie should be read-only zero.
- mcycle 0xB00, mcycleh 0xB80: counts the number of clock cycles executed. Has 64 bits (hence the higher bit version)
- minstret 0xB02, minstreth 0xB82: counts the number of instructions retired/executed. Has 64 bits (hence the higher bit version)
- mhpmcounter3(h)-31(h) (0xB03-0xB1F, 0xB83-0xB9F), mhpmevent3(h)-mhpmevent31(h) (0x323-0x33F, 0x723-0x73F): should be read-only zero. These are just counters for the occurrences of custom events, and can be zero if not implemented.
- mcountinhibit 0x320: controls whether mcycle/minstret increment. The CY/IR bits are 1/0 when mcycle/minstret do/do not count. HPMn bits should be hardwired to zero, ignoring writes.
- mscratch 0x340: use is entirely up to the platform. Typically, it is used to hold a pointer to a machine-mode hart-local context space and swapped with a user register upon entry to an M-mode trap handler.
- mepc 0x341: When a trap is taken into M-mode, mepc is written with the virtual address of the instruction that was interrupted or that encountered the exception. The lowest two bits are always zero.
- mcause 0x342: When a trap is taken into M-mode, mcause is written with a code indicating the event that caused the trap. 
    * The interrupt bit is set if the trap was caused by an interrupt. 
    * The exception code field contains a code identifying the last exception or interrupt. This is a WRLR field, meaning that it accepts any write, but illegal writes cause the system to enter an undefined state. So like a WARL field but without modifying illegal write inputs to be legal.
    * Check the manual for a full list of the codes
- mtval 0x343: When a trap is taken into M-mode, mtval is either set to zero or written with exception-specific information to assist software in handling the trap. Can be set to read-only zero if wanted. If not, it is a WARL register. See the manual for a list of rules for mtval in certain instructions (e.g. EBREAK).
    * On a breakpoint or address-misaligned exception, mtval will contain the faulting address (i.e. the alu out or pc signal in the writeback stage)
    * On an illegal instruction exception, it will contain the faulting instruction bits (this implies I'll need to propagate the instruction through to the execute stage)
- mconfigptr 0xF15: should be read-only zero (not implemented)
- time(h)/cycle(h)/instret(h): these are read-only shadows of their respective m versions. When mtime changes, it is guaranteed to be reflected in time and timeh but not immediately.
    * cycle 0xC00, cycleh 0xC80
    * time 0xC01, timeh 0xC81
    * instret 0xC02, instreth 0xC82 

Attempting to access non-existent CSR's should raise an illegal instruction exception.

# Extra info

- Upon reset, the mstatus fields MIE and MPRV are reset to 0. If little endian memory accesses are supported, the mstatus/mstatush field MBE is reset to 0. The pc is set to an implementation-defined reset vector. The mcause register is set to a value indicating the cause of the reset (can set to 0 if the implementation doesn't distinguish between reset conditions). 