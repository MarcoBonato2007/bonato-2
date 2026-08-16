# rvmodel_macros.h
# RVMODEL macro definitions for OpenHW CV32E20 core
# SPDX-License-Identifier: Apache-2.0

#ifndef _RVMODEL_MACROS_H
#define _RVMODEL_MACROS_H

#define RVMODEL_DATA_SECTION

##### STARTUP #####

# Perform boot operations. Can be empty or left undefined unless needed for
# DUT-specific behavior such as turning on a memory controller or
# initializing custom state.
//#define RVMODEL_BOOT

// Custom RVMODEL_BOOT_TO_MMODE overrides default RVTEST_BOOT_TO_MMODE
// if defined.  For most DUTs, the default should work and this macro
// should not be defined.  If no M-mode or CSRs are implemented, define this
// macro as blank to bypass the boot process.  If a nonconforming
// M-mode is implemented, define this macro to set up the necessary
// state in a fashion similar to RVTEST_BOOT_TO_MMODE.
#define RVMODEL_BOOT_TO_MMODE

# Address to use for load/store fault tests that should cause an access fault on the DUT.
//#define RVMODEL_ACCESS_FAULT_ADDRESS 0x00000000

##### TERMINATION #####

// 0x20000000 stores whether a test passed/failed
// a value of 0 means passed, 1 means failed

# Terminate test with a pass indication.
# When the test is run in simulation, this should end the simulation.
#define RVMODEL_HALT_PASS  \
  li t0, 0               ;\
  li t1, 0x20000000       ;\
  write_halt_pass:        ;\
    sw t0, 0(t1)          ;\
  self_loop_pass:         ;\
    j self_loop_pass      ;\

# Terminate test with a fail indication.
# When the test is run in simulation, this should end the simulation.
#define RVMODEL_HALT_FAIL \
  li t0, 1                ;\
  li t1, 0x20000000       ;\
  write_halt_fail:        ;\
    sw t0, 0(t1)          ;\
  self_loop_fail:         ;\
    j self_loop_fail      ;\

##### IO #####

# Initialization steps needed prior to writing to the console
# _R1, _R2, and _R3 can be used as temporary registers if needed.
# Do not modify any other registers (or make sure to restore them).
# Can be empty or left undefined if no initialization is needed.
//#define RVMODEL_IO_INIT(_R1, _R2, _R3)

# Prints a null-terminated string using a DUT specific mechanism.
# A pointer to the string is passed in _STR_PTR.
# _R1, _R2, and _R3 can be used as temporary registers if needed.
# Do not modify any other registers (or make sure to restore them).
#define RVMODEL_IO_WRITE_STR(_R1, _R2, _R3, _STR_PTR)

##### MTVEC Alignment #####

##### Interrupt Latency #####

#define RVMODEL_INTERRUPT_LATENCY

##### Machine Timer #####
#define RVMODEL_MAX_CYCLES_PER_TIMER_TICK 1

#define RVMODEL_TIMER_INT_SOON_DELAY
##### Machine Interrupts #####

// Drive cv32e20 core irq pins via the cv32e20-dv mm_ram Sail-protocol
// simple_interrupt_generator at 0x15000020 (DUT testbench peripheral).
// Per sail-riscv doc/SimpleInterruptGenerator.md v1.0:
//   base+0: version register (read-only)
//   base+4: platform register (write set/clear)
//     bit 31 = 1 (set) / 0 (clear); bit 3 = MSI, bit 11 = MEI

#define RVMODEL_SET_MEXT_INT(_R1, _R2)                                  

#define RVMODEL_CLR_MEXT_INT(_R1, _R2)                                  

#define RVMODEL_SET_MSW_INT(_R1, _R2)                                   

#define RVMODEL_CLR_MSW_INT(_R1, _R2)                                   

##### Supervisor Interrupts #####

#define RVMODEL_SET_SEXT_INT(_R1, _R2)

#define RVMODEL_CLR_SEXT_INT(_R1, _R2)

#define RVMODEL_SET_SSW_INT(_R1, _R2)

#define RVMODEL_CLR_SSW_INT(_R1, _R2)

#endif // _RVMODEL_MACROS_H
