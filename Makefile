CC=powerpc-elf-gcc
LD=powerpc-elf-ld
QEMU=qemu-system-ppc
GDB=powerpc-elf-gdb
CFLAGS=-Os -m32 
OBJS=entry.o incept.o
TEXTADDR  = 0x200000

CFLAGS += -DTEXTADDR=$(TEXTADDR) -g

LDFLAGS = -Ttext $(TEXTADDR) -Bstatic -melf32ppclinux


.PHONY: clean run

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


run: disk.img
	$(QEMU) -nographic -hda $< 

debug: disk.img
	$(QEMU) -nographic -hda $<  -S

clean:
	sudo kpartx -d disk.img || :
	rm -f disk.img incept
	rm -f entry.o incept.o

gdb: incept
	$(GDB) -q incept
