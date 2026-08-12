.global _start

.section .text._start

_start:
    li t0, 0x12345678

.section .text

loop:
    j loop
