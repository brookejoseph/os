CXX = i686-elf-g++
AS = i686-elf-as
LD = i686-elf-ld

CXXFLAGS = -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti
ASFLAGS = --32
LDFLAGS = -T linker.ld -nostdlib

all: myos.iso

boot.o: boot.asm
	$(AS) $(ASFLAGS) boot.asm -o boot.o

kernel.o: kernel.cpp
	$(CXX) -c kernel.cpp -o kernel.o $(CXXFLAGS)

myos.bin: boot.o kernel.o
	$(LD) -o myos.bin $(LDFLAGS) boot.o kernel.o

myos.iso: myos.bin
	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/myos.bin
	echo 'menuentry "MyOS" { multiboot /boot/myos.bin }' > isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir

run: myos.iso
	qemu-system-i386 -cdrom myos.iso

clean:
	rm -f *.o myos.bin myos.iso
	rm -rf isodir
