; boot.asm - MBR Boot Sector for NexOS
; Loads second-stage bootloader, sets up protected mode, and displays splash screen

[bits 16] ; Real mode
[org 0x7C00] ; Boot sector loaded at 0x7C00

; Constants
BOOT_SECTOR_SIZE equ 512
LOADER_SECTOR equ 1
LOADER_ADDRESS equ 0x1000

start:
    cli ; Disable interrupts
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00 ; Set stack below boot sector

    ; Display boot splash
    mov si, boot_msg
    call print_string

    ; Load second-stage bootloader from disk
    mov ah, 0x02 ; BIOS read sector
    mov al, 10   ; Number of sectors to read
    mov ch, 0    ; Cylinder 0
    mov cl, 2    ; Sector 2 (after MBR)
    mov dh, 0    ; Head 0
    mov bx, LOADER_ADDRESS ; Destination
    int 0x13     ; BIOS disk interrupt
    jc disk_error ; Handle error

    ; Jump to second-stage bootloader
    jmp LOADER_ADDRESS

; Print string (SI points to string)
print_string:
    mov ah, 0x0E ; BIOS teletype
.print_loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .print_loop
.done:
    ret

disk_error:
    mov si, error_msg
    call print_string
    hlt

; Data
boot_msg db "NexOS Booting...", 0x0D, 0x0A, 0
error_msg db "Disk Error!", 0x0D, 0x0A, 0

; Boot sector signature
times 510-($-$$) db 0
dw 0xAA55