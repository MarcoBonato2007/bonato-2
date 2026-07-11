# bonato-2
Exploring hardware design further, possibly in VHDL/Verilog. I want to try extending the bonato-1 to be more complicated (e.g. including a stack).

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