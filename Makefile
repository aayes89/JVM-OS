# =========================================================
# Makefile - JVM Baremetal OS (Dual Drive Mode)
# Disco 0: Bootloader | Disco 1: Kernel
# Hecho por Allan Ayes 2026
# Github: https://github.com/aayes89
# Adaptar CC y LD a tu sistema
# =========================================================

ASM := nasm
CC  := i686-linux-gnu-gcc
LD  := i686-linux-gnu-ld

# =========================================================
# FLAGS
# =========================================================

CFLAGS := \
	-m32 \
	-ffreestanding \
	-fno-pie \
	-fno-stack-protector \
	-fno-asynchronous-unwind-tables \
	-nostdlib \
	-fno-builtin \
	-Wall \
	-Wextra \
	-O0 \
	-g \
	-Iinclude

# El linker DEBE tener OUTPUT_FORMAT("binary")
# y . = 0x10000 en linker.ld
LDFLAGS := \
	-m elf_i386 \
	-T linker.ld \
	-nostdlib

# =========================================================
# DIRECTORIOS
# =========================================================

BOOT_DIR    := boot
KERNEL_DIR  := kernel
DRIVERS_DIR := drivers
LIB_DIR     := lib
FS_DIR      := fs
APPS_DIR    := apps
BUILD_DIR   := build

# =========================================================
# ARCHIVOS
# =========================================================

BOOT_SRC	:= $(BOOT_DIR)/boot.asm
BOOT_BIN	:= $(BUILD_DIR)/boot.bin
KERNEL_BIN	:= $(BUILD_DIR)/kernel.bin
IDT_ASM_SRC	:= $(KERNEL_DIR)/interrupts.asm
IDT_ASM_OBJ	:= $(BUILD_DIR)/interrupts_vectors.o


# Imágenes de disco
HDA_IMG := boot_drive.bin
HDB_IMG := kernel_drive.bin

# =========================================================
# SOURCES & OBJECTS
# =========================================================

C_SOURCES := \
	$(wildcard $(KERNEL_DIR)/*.c) \
	$(wildcard $(DRIVERS_DIR)/*.c) \
	$(wildcard $(LIB_DIR)/*.c) \
	$(wildcard $(FS_DIR)/*.c) \
	$(wildcard $(APPS_DIR)/*.c)

C_OBJECTS := \
	$(addprefix $(BUILD_DIR)/, $(notdir $(C_SOURCES:.c=.o)))

# =========================================================
# REGLAS PRINCIPALES
# =========================================================

all: $(HDA_IMG) $(HDB_IMG)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# =========================================================
# 1. Bootloader (512 bytes exactos)
# =========================================================

$(BOOT_BIN): $(BOOT_SRC) | $(BUILD_DIR)
	@echo "[ASM] Bootloader"
	$(ASM) -f bin $< -o $@

# IDT/ISRs (Objeto ELF para el Linker) - CORREGIDO
$(IDT_ASM_OBJ): $(IDT_ASM_SRC) | $(BUILD_DIR)
	@echo "[ASM] IDT/ISRs Vectors"
	$(ASM) -f elf32 $< -o $@

# =========================================================
# 2. Compilación de objetos C
# =========================================================

vpath %.c \
	$(KERNEL_DIR) \
	$(DRIVERS_DIR) \
	$(LIB_DIR) \
	$(FS_DIR) \
	$(APPS_DIR)

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	@echo "[CC ] $<"
	$(CC) $(CFLAGS) -c $< -o $@

# =========================================================
# 3. Link del kernel a binario plano
# =========================================================

$(KERNEL_BIN): $(C_OBJECTS) $(IDT_ASM_OBJ)
	@echo "[LD ] Kernel Binary"
	$(LD) $(LDFLAGS) -o $@ $^

# =========================================================
# 4. Creación de imágenes de disco
# =========================================================

$(HDA_IMG): $(BOOT_BIN)
	@echo "[IMG] Creating Boot Drive (hda)"
	dd if=$(BOOT_BIN) of=$(HDA_IMG) bs=512 conv=sync

# Creamos un disco vacío de 1.44MB y copiamos el kernel
$(HDB_IMG): $(KERNEL_BIN)
	@echo "[IMG] Creating Kernel Drive (hdb)"
	dd if=/dev/zero of=$(HDB_IMG) bs=1k count=1440
	dd if=$(KERNEL_BIN) of=$(HDB_IMG) conv=notrunc

# =========================================================
# EMULACIÓN
# =========================================================
run: all
	qemu-system-x86_64 -drive format=raw,file=$(HDA_IMG) -drive format=raw,file=$(HDB_IMG) -vga std -drive format=raw,file=data_disk.img -netdev tap,id=u1,ifname=tap0,script=no,downscript=no -device rtl8139,netdev=u1
	
headless: all
	qemu-system-x86_64 -nographic -hda $(HDA_IMG) -hdb $(HDB_IMG) -hdc data_disk.img -serial mon:stdio -net nic,model=rtl8139 -net user 
# =========================================================
# LIMPIEZA
# =========================================================

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(HDA_IMG) $(HDB_IMG)

.PHONY: all run clean
