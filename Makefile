CC=powerpc-elf-gcc
LD=powerpc-elf-ld
QEMU=qemu-system-ppc
CFLAGS=-Os -m32 
OBJS=entry.o incept.o
TEXTADDR  = 0x200000

CFLAGS += -DTEXTADDR=$(TEXTADDR)

LDFLAGS = -Ttext $(TEXTADDR) -Bstatic -melf32ppclinux


.PHONY: clean run

all: incept disk.img

entry.o: entry.S
	$(CC) $(CFLAGS) -I./include -isystem `$(CC) -m32 -print-file-name=include` -nostdinc -c -o $@ $<

incept.o: incept.c
	$(CC) $(CFLAGS) -I./include -isystem `$(CC) -m32 -print-file-name=include` -nostdinc -c -o $@ $<

incept: entry.o incept.o
	$(LD) $(LDFLAGS) $(OBJS) -o $@

disk.img: 
	dd bs=1M count=10 if=/dev/zero of=$@
	parted $@ mklabel msdos
# TODO makefile build disk images
#	parted $@ mkpart primary ext2 0 100%
#	sudo kpartx -av $@

run: disk.img
	$(QEMU) -nographic -hda $<

clean:
#	sudo kpartx -d disk.img
	rm -f disk.img incept
	rm -f entry.o incept.o
