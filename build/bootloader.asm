[bits 16]
[org 0x7c00]

start:
    ; Set up stack
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0xFFFF

    ; Save boot drive number
    mov [boot_drive], dl

    ; Load kernel from disk
    mov bx, 0x1000  ; Load address
    mov dh, 2       ; Number of sectors to read
    mov dl, [boot_drive]
    call disk_load

    ; Disable interrupts
    cli

    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Switch to protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far jump to 32-bit code
    jmp 0x08:0x1000  ; Jump to the kernel entry point

; Disk load function
disk_load:
    pusha
    push dx

    mov ah, 0x02  ; BIOS read sector function
    mov al, dh    ; Read DH sectors
    mov ch, 0x00  ; Select cylinder 0
    mov dh, 0x00  ; Select head 0
    mov cl, 0x02  ; Start reading from second sector (i.e., after boot sector)

    int 0x13      ; BIOS interrupt

    jc disk_error ; Jump if error (i.e. carry flag set)

    pop dx
    cmp dh, al    ; If AL (sectors read) != DH (sectors expected)
    jne disk_error
    popa
    ret

disk_error:
    mov si, DISK_ERROR_MSG
    call print_string
    jmp $

; Print string function
print_string:
    pusha
    mov ah, 0x0E  ; BIOS teletype output
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    popa
    ret

; GDT
gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; Variables
boot_drive: db 0
DISK_ERROR_MSG: db "Disk read error!", 0

times 510-($-$$) db 0
dw 0xAA55