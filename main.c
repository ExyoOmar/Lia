/* main.c - NexOS Kernel Entry Point
 * Initializes memory, interrupts, drivers, and starts shell
 */

#include "kernel.h"
#include "interrupts.h"
#include "memory.h"
#include "heap.h"
#include "shell.h"
#include "drivers.h"

void kmain(void) {
    // Initialize VGA text mode
    vga_init();

    // Print boot message
    vga_puts("NexOS Kernel v1.0\n");

    // Initialize memory management
    memory_init();
    heap_init();

    // Setup interrupts
    interrupts_init();

    // Initialize drivers
    keyboard_init();
    mouse_init();
    ide_init();
    pit_init();
    rtc_init();
    pci_init();

    // Initialize filesystem
    fs_init();

    // Initialize multitasking
    multitasking_init();

    // Start GUI (if enabled)
    gui_init();

    // Launch shell
    shell_run();

    // Halt if shell exits
    while (1) {
        asm("hlt");
    }
}