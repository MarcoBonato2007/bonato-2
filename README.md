# bonato-2
Exploring hardware design further in SystemVerilog, trying to replicate the base RV32I RISC-V instruction set. Currently I'm working on implementing only the base instructions, and then later adding support for Zicsr and ecall/ebreak.

## The architecture

It's a five-stage pipeline: fetch, decode, execute, memory access, and writeback. Originally, I wasn't sure what stages I should use, but this seemed like the standard across all the research I did and similar projects I looked at. Below is the diagram of the v1 architecture (you can find the logisim file in `/diagrams`), which supports the base instruction set excluding ecall and ebreak. I'm currently working on testing it.

![v1 architecture](diagrams/v1.png)
