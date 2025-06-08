/* shell.c - Userland Shell
 * Runs in user mode, interacts via syscalls
 */

#include "syscall.h"
#include "stdio.h"

int main(void) {
    printf("Userland Shell\n> ");
    while (1) {
        char cmd[256];
        gets(cmd);
        if (strcmp(cmd, "exit") == 0) break;
        printf("Executing: %s\n", cmd);
    }
    return 0;
}