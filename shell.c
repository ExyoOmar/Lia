/* shell.c - NexOS Kernel Shell
 * Provides CLI for system interaction
 */

#include "kernel.h"
#include "drivers.h"
#include "fs.h"

void shell_run(void) {
    char cmd[256];
    int pos = 0;

    vga_puts("NexOS Shell\n> ");
    while (1) {
        char c = keyboard_getchar();
        if (!c) continue;

        if (c == '\n') {
            cmd[pos] = 0;
            shell_exec(cmd);
            pos = 0;
            vga_puts("\n> ");
        } else if (c == '\b' && pos > 0) {
            pos--;
            vga_putc('\b');
            vga_putc(' ');
            vga_putc('\b');
        } else if (pos < 255) {
            cmd[pos++] = c;
            vga_putc(c);
        }
    }
}

void shell_exec(const char *cmd) {
    if (strcmp(cmd, "ls") == 0) {
        fs_list_dir();
    } else if (strcmp(cmd, "clear") == 0) {
        vga_init();
    } else if (cmd[0]) {
        vga_puts("Unknown command: ");
        vga_puts(cmd);
        vga_putc('\n');
    }
}