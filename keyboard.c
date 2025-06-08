/* keyboard.c - PS/2 Keyboard Driver
 * Handles interrupt-based keyboard input
 */

#include "drivers.h"
#include "interrupts.h"

#define KEYBOARD_PORT 0x60
#define KEYBOARD_IRQ 1

static char key_buffer[256];
static int buffer_pos = 0;

void keyboard_handler(void) {
    unsigned char scancode = inb(KEYBOARD_PORT);
    char key = scancode_to_ascii(scancode);
    if (key && buffer_pos < 256) {
        key_buffer[buffer_pos++] = key;
    }
    pic_eoi(KEYBOARD_IRQ);
}

void keyboard_init(void) {
    // Register IRQ handler
    irq_install_handler(KEYBOARD_IRQ, keyboard_handler);
    // Enable keyboard interrupts
    outb(0x21, inb(0x21) & ~(1 << KEYBOARD_IRQ));
}

char keyboard_getchar(void) {
    if (buffer_pos == 0) return 0;
    char c = key_buffer[0];
    for (int i = 0; i < buffer_pos - 1; i++) {
        key_buffer[i] = key_buffer[i + 1];
    }
    buffer_pos--;
    return c;
}

// Simplified scancode to ASCII (extend for full keymap)
char scancode_to_ascii(unsigned char scancode) {
    static char keymap[] = {
        0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0, 0,
        'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', 0,
        'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', 0, 0, '\\',
        'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
    };
    if (scancode < sizeof(keymap)) return keymap[scancode];
    return 0;
}