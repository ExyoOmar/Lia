/* window.c - NexOS Window Manager
 * Manages GUI windows and mouse interaction
 */

#include "gui.h"
#include "drivers.h"

typedef struct {
    int x, y, width, height;
    char title[32];
} Window;

static Window windows[10];
static int window_count = 0;

void window_create(int x, int y, int width, int height, const char *title) {
    if (window_count >= 10) return;
    Window *w = &windows[window_count++];
    w->x = x;
    w->y = y;
    w->width = width;
    w->height = height;
    strncpy(w->title, title, 31);
    window_draw(w);
}

void window_draw(Window *w) {
    // Placeholder: draw window using VGA driver
    vga_puts("Drawing window: ");
    vga_puts(w->title);
    vga_putc('\n');
}

void gui_init(void) {
    // Initialize GUI
    window_create(100, 100, 200, 150, "Terminal");
}