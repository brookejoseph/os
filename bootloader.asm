[org 0x7C00]

    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:0x1000

[bits 32]
hang:
    hlt
    jmp hang

times 510 - ($ - $$) db 0
dw 0xAA55
