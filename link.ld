SECTIONS
{
    . = 0x00000000; /* set location counter to 0 */

    .text : {
        KEEP(*(.text._start))
        KEEP(*(.text*))
    }

    .data : { *(.data*) }
    .bss  : { *(.bss*) }
}