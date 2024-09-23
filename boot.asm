.section .multiboot
    .long 0x1BADB002        # Multiboot magic number
    .long 0                 # Flags
    .long -(0x1BADB002 + 0) # Checksum

.section .text
.global start
.extern kernel_main

start:
    cli                     # Disable interrupts
    movl $stack_top, %esp
    call kernel_main
    hlt                     # Halt the CPU

.section .bss
stack_bottom:
    .skip 16384             # 16 KB
stack_top:
