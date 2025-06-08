# Makefile - Build System for NexOS
# Compiles and links bootloader, kernel, and userland

NASM = nasm
GCC = i686-w64-mingw32-gcc
LD = i686-w64-mingw32-ld
QEMU = qemu-system-i386
OBJCOPY = i686-w64-mingw32-objcopy
MKISOFS = mkisofs

CFLAGS = -ffreestanding -m32 -Wall -Iinclude
LDFLAGS = -T linker.ld -nostdlib

BOOT_SRC = boot/boot.asm boot/loader.asm
KERNEL_SRC = kernel/main.c kernel/interrupts.c kernel/memory.c kernel/heap.c kernel/shell.c kernel/panic.c kernel/syscall.c kernel/multitasking.c
DRIVER_SRC = drivers/keyboard.c drivers/mouse.c drivers/vga.c drivers/ide.c drivers/pit.c drivers/rtc.c drivers/pci.c
FS_SRC = fs/fat.c fs/fileman.c
GUI_SRC = gui/window.c gui/desktop.c gui/apps.c gui/font.c
LIBC_SRC = libc/stdio.c libc/stdlib.c libc/string.c
USER_SRC = user/shell.c user/calc.c user/notepad.c

BOOT_OBJ = $(BOOT_SRC:.asm=.o)
KERNEL_OBJ = $(KERNEL_SRC:.c=.o)
DRIVER_OBJ = $(DRIVER_SRC:.c=.o)
FS_OBJ = $(FS_SRC:.c=.o)
GUI_OBJ = $(GUI_SRC:.c=.o)
LIBC_OBJ = $(LIBC_SRC:.c=.o)
USER_OBJ = $(USER_SRC:.c=.o)

all: nexos.iso

# Assemble boot sector as flat binary
boot/boot.bin: boot/boot.asm
	$(NASM) -f bin $< -o $@

# Assemble loader as ELF object
boot/loader.o: boot/loader.asm
	$(NASM) -f elf32 $< -o $@

# Assemble other .asm files (if any)
%.o: %.asm
	$(NASM) -f elf32 $< -o $@

# Compile C files
%.o: %.c
	$(GCC) $(CFLAGS) -c $< -o $@

# Link kernel
kernel.bin: $(KERNEL_OBJ) $(DRIVER_OBJ) $(FS_OBJ) $(GUI_OBJ) $(LIBC_OBJ) boot/loader.o
	$(LD) $(LDFLAGS) -o $@ $^

# Create bootable disk image
nexos.img: boot/boot.bin kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=boot/boot.bin of=$@ bs=512 conv=notrunc
	dd if=kernel.bin of=$@ bs=512 seek=11 conv=notrunc

# Create ISO
nexos.iso: nexos.img
	$(MKISOFS) -o $@ -b $< .

clean:
	rm -f *.o *.bin *.img *.iso boot/*.o boot/*.bin kernel/*.o drivers/*.o fs/*.o gui/*.o libc/*.o user/*.o

qemu: nexos.iso
	$(QEMU) -cdrom $< -m 128M -serial stdio

.PHONY: all clean qemu