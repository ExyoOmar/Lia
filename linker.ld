/* linker.ld - Linker Script for NexOS Kernel
 * Defines memory layout
 */

OUTPUT_FORMAT("elf32-i386")
ENTRY(kmain)

SECTIONS {
    . = 0x10000; /* Kernel load address */
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss) }
}