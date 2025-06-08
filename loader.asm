; loader.asm - Second-Stage Bootloader for NexOS
; Switches to protected mode, sets up GDT/IDT, loads kernel

[bits 16]
[org 0x1000]

start:
    cli
    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Switch to protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Far jump to 32-bit code
    jmp 0x08:protected_mode

[bits 32]
protected_mode:
    ; Set up segment registers
    mov ax, 0x10 ; Data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000 ; Stack at 90000h

    ; Load kernel from disk (simplified)
    mov esi, 0x10000 ; Kernel load address
    mov edi, esi
    mov ecx, 0x10000 ; Kernel size (64KB)
    call load_kernel

    ; Initialize IDT
    call setup_idt

    ; Jump to kernel
    jmp 0x10000

; Load kernel (placeholder)
load_kernel:
    ; Implement disk read (similar to boot.asm)
    ret

; Setup IDT (simplified)
setup_idt:
    lidt [idt_descriptor]
    ret

; GDT
gdt_start:
    dq 0 ; Null descriptor
gdt_code:
    dw 0xFFFF ; Limit
    dw 0      ; Base
    db 0      ; Base
    db 0x9A   ; Access (present, ring 0, executable)
    db 0xCF   ; Granularity
    db 0      ; Base
gdt_data:
    dw 0xFFFF
    dw 0
    db 0
    db 0x92   ; Access (present, ring 0, data)
    db 0xCF
    db 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; IDT (simplified)
idt_descriptor:
    dw 0
    dd 0