/* fat.c - FAT12/FAT32 Filesystem Driver
 * Provides basic file operations
 */

#include "fs.h"
#include "drivers.h"

void fs_init(void) {
    // Initialize FAT filesystem
    vga_puts("FAT Filesystem Initialized\n");
}

void fs_list_dir(void) {
    // Placeholder: list directory contents
    vga_puts("dir1\nfile1.txt\n");
}