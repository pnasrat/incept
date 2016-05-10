CC=powerpc-elf-gcc
LD=powerpc-elf-ld
QEMU=qemu-system-ppc
GDB=powerpc-elf-gdb
OBJDUMP=powerpc-elf-objdump
CFLAGS=-g3 -m32
OBJS=entry.o incept.o
STRIP=powerpc-elf-strip
TEXTADDR  = 0x200000

CFLAGS += -DTEXTADDR=$(TEXTADDR) -g -fno-signed-char

LDFLAGS = -Ttext $(TEXTADDR) -Bstatic -melf32ppclinux


.PHONY: clean run debug dump gdb

all: incept disk.img

entry.o: entry.S
	$(CC) $(CFLAGS) -I./include -isystem `$(CC) -m32 -print-file-name=include` -nostdinc -c -o $@ $<

incept.o: incept.c
	$(CC) $(CFLAGS) -I./include -isystem `$(CC) -m32 -print-file-name=include` -nostdinc -c -o $@ $<

incept: entry.o incept.o
	$(LD) $(LDFLAGS) $(OBJS) -o $@

disk.img: incept
	dd bs=1M count=10 if=/dev/zero of=$@
	parted --script $@ mklabel msdos
	parted --script --align none $@ -- mkpart primary ext2 0 100%
	bash format.bash

of:
	$(QEMU) -nographic

run: disk.img
	$(QEMU) -nographic -hda $< 

debug: disk.img
	$(QEMU) -nographic -hda $<  -S -s

clean:
	sudo kpartx -d disk.img || :
	rm -f disk.img incept
	rm -f entry.o incept.o

gdb: incept
	$(GDB) -q incept

dump: incept
	$(OBJDUMP) -d $<
