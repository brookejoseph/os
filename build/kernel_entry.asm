[bits 32]
[extern main]

global _start

_start:
    ; Set up stack
    mov esp, stack_top

    ; Call C function
    call main

    ; Halt the CPU
    cli
    hlt

section .bss
stack_bottom:
    resb 64*1024  ; 64 KiB
stack_top:

