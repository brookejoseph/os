# Define the assembler, C compiler, linker, and emulator
ASM = nasm
CC = i686-elf-gcc
LD = i686-elf-ld
EMU = qemu-system-i386

# Compiler and linker flags
CFLAGS = -ffreestanding -m32 -g -c
LDFLAGS = -melf_i386 -Ttext 0x1000 --oformat binary

# Output file names
BOOTLOADER = bootloader.bin
KERNEL_ASM = kernel_entry.o
KERNEL_C = kernel.o
KERNEL = kernel.bin
IMAGE = os-image.bin

# Default target
all: $(IMAGE)

# Assemble the bootloader
$(BOOTLOADER): bootloader.asm
	$(ASM) -f bin $< -o $@

# Assemble the kernel's assembly entry point
$(KERNEL_ASM): kernel_entry.asm
	$(ASM) -f elf $< -o $@

# Compile the kernel's C part
$(KERNEL_C): kernel.c
	$(CC) $(CFLAGS) $< -o $@

# Link the kernel
$(KERNEL): $(KERNEL_ASM) $(KERNEL_C)
	$(LD) $(LDFLAGS) $^ -o $@

# Combine bootloader and kernel into a disk image
$(IMAGE): $(BOOTLOADER) $(KERNEL)
	cat $(BOOTLOADER) $(KERNEL) > $(IMAGE)

# Run the OS in QEMU
run: $(IMAGE)
	$(EMU) -drive format=raw,file=$(IMAGE),index=0,media=disk

# Clean up generated files
clean:
	rm -f $(BOOTLOADER) $(KERNEL_ASM) $(KERNEL_C) $(KERNEL) $(IMAGE)

.PHONY: all run clean