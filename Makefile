# Define the assembler and emulator
ASM = nasm
EMU = qemu-system-i386

# Output file names
BOOTLOADER = bootloader.bin
KERNEL = kernel.bin
IMAGE = os-image.bin

# Assemble the bootloader
$(BOOTLOADER): bootloader.asm
	$(ASM) -f bin bootloader.asm -o $(BOOTLOADER)

# Assemble the kernel
$(KERNEL): kernel.asm
	$(ASM) -f bin kernel.asm -o $(KERNEL)

# Combine bootloader and kernel into a disk image
$(IMAGE): $(BOOTLOADER) $(KERNEL)
	cat $(BOOTLOADER) $(KERNEL) > $(IMAGE)

# Run the OS in QEMU
run: $(IMAGE)
	$(EMU) -drive format=raw,file=$(IMAGE),index=0,media=disk

# Clean up generated files
clean:
	rm -f $(BOOTLOADER) $(KERNEL) $(IMAGE)
