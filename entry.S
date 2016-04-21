/* based from yaboot crt0.S */
/* See COPYING.yaboot */
#include "asm/ppc_asm.tmpl"

/*
 * Main entry point. We zero the BSS then jump to yaboot_start.
 */
.globl _start
start:
	lis	r10,edata@h
	ori	r10,r10,edata@l
	lis	r11,end@h
	ori	r11,r11,end@l
	subi	r10,r10,4
	subi	r11,r11,4
	li	r0, 0
1:	stwu	r0,4(r10)
	cmp	0,r10,r11
	bne	1b
	b	incept_start
