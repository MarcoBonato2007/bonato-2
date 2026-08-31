The v3 adds an SoC, specifically things like an external interrupt controller, a GPIO controller, and a UART controller. Also adds mtime and mtimecmp.

TODO: note for future: you could map certain things like mtime, mtimecmp, or even controllers into the 12-bit CSR address space rather than the space of data memory.

Also: make sure that interrupt signals settle properly, i.e. align with a rising edge

## Interrupt controller

### Overview

There are two kinds of interrupts: local and global/external. 

Local refers to interrupts that can be signalled using only the mip/mie and mcause CSR's. This is either already-present interrupts like timer interrupts (mip.MTIP), software interrupts (mip.MSIP), or custom local interrupts. for example, interrupt codes >= 16 in mcause and bits 31:16 of mip/mie are reserved for platform use. One nice thing about custom local interrupts is that you can give them a wide variety of interrupt codes, so you can use the vectored mode on mtval to avoid long if/else statements on mcause in order to decide on an interrupt handler.

Now what if you had more than 16 interrupts you wanted to be able to turn off and on individually? Then you'd need global interrupts. From what I can see, global interrupts are signalled via mip.MEIP, with a fixed mcause value. The MEIP bit "is set and cleared by a platform-specific interrupt controller". Note that since mcause is fixed, vectored mode doesn't help anymore with jumping to the correct interrupt handler. 

For the moment, it's probably best to limit local interrupts to be only timer and software interrupts, which you can try to package in an interrupt/exception controller which controls stuff like mcause and mip. Now the question is how you go about using a global interrupt controller.

### PLIC

RISC-V has a specification for a PLIC (Platform Level Interrupt Controller), which seems cool to implement, except that the full thing is a bit too massive to fit on anything I'm going to actually put this project on. Below is a description of a considerably modified description of the original specification
- Supports up to 1023 interrupts (0 is reserved). May shrink in future.
- The interrupt lines will probably just be directly wired to the PLIC
- The PLIC controls the meip (machine external interrupt pending) bit of the mip CSR
- Each interrupt source has a single IP (Interrupt Pending) bit and interrupt enable (IE) bit
- If an interrupt triggers, it won't trigger again until its previous request has been completed (even if the interrupt source remains high). So on an edge-triggered source, additional edges are ignored if the previous request hasn't completed.
- Each interrupt source is assigned an unsigned integer identifier, beginning at 1 (0 means "no interrupt"). When two interrupt sources have the same priority, the one with smaller ID takes precendence.
- In software, when trapping after an external interrupt, the CPU can read the claim/complete register to retrieve the ID of the highest priority interrupt source. When this happens, the PLIC clears the IP bit for that interrupt (can detect this by just checking if the claim/complete address is being read from). A read of zero means no interrupt.
- Again in software, after an interrupt has been serviced, the core writes the interrupt's ID to the claim/complete register. If that interrupt is also enabled, the PLIC then allows that interrupt source to become pending again. Note that the PLIC does not check whether the completion ID is the same as the last claim ID for that target, so writing a wrong ID will signal completion to the wrong interrupt source. If the completion ID does not match an interrupt source that is currently enabled, the completion is silently ignored.
- There are interrupt enable, interrupt priority, interrupt pending and interrupt completion registers for each source. Interrupt completion registers are not exposed to memory.
- The PLIC masks (i.e. keeps pending) any interrupts with a priority lower than the priority threshold register. E.g. a priority threshold of 0 means any interrupt is allowed except those with priority 0: in general, priority 0 means "never interrupt". You are allowed to hardwire priority levels if you want (WARL), or hardwire certain bits to zero to limit the range of priority values.

Memory map:
- The base address is implementation-specific, the hex codes below describe offsets
- 0x0000 - 0x0FFC: Interrupt source priorities, address 0 is reserved
- 0x1000 - 0x107C: Interrupt pending bits
- 0x1080 - 0x10FC: interrupt enable bits
- 0x1100: priority threshold
- 0x1104: claim/complete
This is 4.25 KiB.

## GPIO

This is needed to allow the user to access memory-mapped I/O. Here are some ideas:
- It should just consist of a series of pins exposed as 32-bit registers
- You should be able to decide whether you want certain pins to be inputs or outputs (maybe even both?). SystemVerilog has support for tri-state logic for this.
- Perhaps combine the GPIO and interrupt controllers
- Perhaps separate the CPU from memory matters by using a bus interface like Wishbone (in general, the CPU should only see a "memory", and address decoding/other stuff is handled elsewhere)
- Need to decide how big to make the GPIO controller (is there a specification/popular example somewhere to implement?)

## UART
