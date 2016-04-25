/* based from yaboot crt0.S */
/* See COPYING.yaboot */
#include "asm/ppc_asm.tmpl"

/*
 * Main entry point. We zero the BSS then jump to incept_start.
 */
.globl _start
start:
  /* "load immediate shifted" 16-31 bits into r10 */
	lis	r10,edata@h
  /* load edata 0-15 bits into r10 */
	ori	r10,r10,edata@l
  /* load high bits of end into r11 */
	lis	r11,end@h
  /* load low bits of end into r11 */
	ori	r11,r11,end@l
  /* r10 - 4bytes into r10 */
	subi	r10,r10,4
  /* r11 - 4bytes into r11 */
	subi	r11,r11,4
  /* load 0 into r0*/
	li	r0, 0
/* store word with update */
/* write 0 r10 (edata - 4) with an offset of 4 bytes  */
/* updates r10 to be 4 bytes  */
1:	stwu	r0,4(r10)
	cmp	0,r10,r11
/* loop branch if not equal to end address */
	bne	1b
/* invoke our start method */
	b	incept_start
