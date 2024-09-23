extern "C" void kernel_main() {
    const char* msg = "Hello from my minimal OS!";
    unsigned char* vidmem = (unsigned char*) 0xb8000;
    
    for (int i = 0; msg[i] != '\0'; ++i) {
        vidmem[i*2] = msg[i];
        vidmem[i*2+1] = 0x07; // Light gray on black
    }
}
