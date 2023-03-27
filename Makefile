ASM = nasm
CPP = i386-elf-gcc
LD	= i386-elf-ld

KERNEL_LOCATION = 0x7e00

SRC_DIR = src
BUILD_DIR = build

.PHONY: bootloader kernel image all clean always

# nOS Image
image: $(BUILD_DIR)/nos.img

$(BUILD_DIR)/nos.img: bootloader kernel
	cat $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/kernel.bin > $(BUILD_DIR)/nos.img
	truncate -s 1440K $(BUILD_DIR)/nos.img

# Bootloader
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

# Kernel
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/kernel_start.asm -f elf -o $(BUILD_DIR)/kernel_start.o
	$(CPP) -ffreestanding -m32 -g -c $(SRC_DIR)/kernel/kernel.cpp -o $(BUILD_DIR)/kernel.o
	$(LD) -o $(BUILD_DIR)/kernel.bin -Ttext $(KERNEL_LOCATION) --entry main $(BUILD_DIR)/kernel_start.o $(BUILD_DIR)/kernel.o --oformat binary

# Always
always:
	mkdir -p $(BUILD_DIR)

# Clean
clean:
	rm -rf $(BUILD_DIR)/*