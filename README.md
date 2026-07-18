# bonato-2
Exploring hardware design further in SystemVerilog, trying to replicate the base RV32I RISC-V instruction set. **This will likely be a slow, long-term project.**

# ISA

This section contains observations and notes I made for myself whilst reading through the manual.

## Registers
- There are 32 registers, each 32 bits, called x0-x31. `x0` is the the zero register, and is always zero. x1-x32 are general purpose.
- There is only one additional unprivileged register, which is the program counter. There is no dedicated sp/lr/etc.
- **Convention**: use `x1` to hold the return address, with `x5` as an alternative.

## Instruction format
- All instructinos are 32 bits.
- The base ISA has `IALIGN=32`: this means that instructions must be aligned to four bytes in memory.
- The source registers are called `rs1` and `rs2`, and the destination `rd`.
- Immediates are always sign extended (except for the 5-bit immediates used in the CSR instructions)
- The sign bit of immediates is always in bit 31
- `NOP` is encoded as `ADDI x0, x0, 0`


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