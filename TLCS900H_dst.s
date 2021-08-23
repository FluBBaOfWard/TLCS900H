#ifdef __arm__

#include "TLCS900H.i"
#include "TLCS900H_mac.h"

	.global dstExXRR
	.global dstExXRRd
	.global dstEx8
	.global dstEx16
	.global dstEx24
	.global dstExR32
	.global dstExDec
	.global dstExInc


	.syntax unified
	.arm

;@----------------------------------------------------------------------------
#ifdef GBA
	.section .ewram, "ax"		;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
;@----------------------------------------------------------------------------
dstExXRR:
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]	;@ XRR
	ldrb r0,[t9pc],#1
	adr r1,dstOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
dstExXRRd:
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]	;@ XRR
	ldrsb r0,[t9pc],#1
	add t9Mem,t9Mem,r0
	t9eatcycles 2
	ldrb r0,[t9pc],#1
	adr r1,dstOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
dstEx8:
	ldrb t9Mem,[t9pc],#1
	t9eatcycles 2
	ldrb r0,[t9pc],#1
	adr r1,dstOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
dstEx24:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#8
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#16
	t9eatcycles 3
	ldrb r0,[t9pc],#1
	adr r1,dstOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
dstExR32:
	adr lr,dst_asm
	b ExR32
;@----------------------------------------------------------------------------
dstExDec:
	adr lr,dst_asm
	b ExDec
;@----------------------------------------------------------------------------
dstExInc:
	adr lr,dst_asm
	b ExInc
;@----------------------------------------------------------------------------
dstEx16:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#8
	t9eatcycles 2
;@----------------------------------------------------------------------------
dst_asm:
	ldrb r0,[t9pc],#1
	ldr pc,[pc,r0,lsl#2]
	mov r11,r11
dstOpCodes:
;@ 0x00
	.long dstLDBi,	ed,			dstLDWi,	ed,			dstPOPB,	ed,			dstPOPW,	ed
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
;@ 0x10
	.long ed,		ed,			ed,			ed,			dstLDBm16,	ed,			dstLDWm16,	ed
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
;@ 0x20
	.long dstLDAW,	dstLDAW,	dstLDAW,	dstLDAW,	dstLDAW,	dstLDAW,	dstLDAW,	dstLDAW
	.long dstANDCFA,dstORCFA,	dstXORCFA,	dstLDCFA,	dstSTCFA,	ed,			ed,			ed
;@ 0x30
	.long dstLDAL,	dstLDAL,	dstLDAL,	dstLDAL,	dstLDAL,	dstLDAL,	dstLDAL,	dstLDAL
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
;@ 0x40
	.long dstLDBR,	dstLDBR,	dstLDBR,	dstLDBR,	dstLDBR,	dstLDBR,	dstLDBR,	dstLDBR
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
;@ 0x50
	.long dstLDWR,	dstLDWR,	dstLDWR,	dstLDWR,	dstLDWR,	dstLDWR,	dstLDWR,	dstLDWR
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
;@ 0x60
	.long dstLDLR,	dstLDLR,	dstLDLR,	dstLDLR,	dstLDLR,	dstLDLR,	dstLDLR,	dstLDLR
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
;@ 0x70
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
	.long ed,		ed,			ed,			ed,			ed,			ed,			ed,			ed
;@ 0x80
	.long dstANDCF,	dstANDCF,	dstANDCF,	dstANDCF,	dstANDCF,	dstANDCF,	dstANDCF,	dstANDCF
	.long dstORCF,	dstORCF,	dstORCF,	dstORCF,	dstORCF,	dstORCF,	dstORCF,	dstORCF
;@ 0x90
	.long dstXORCF,	dstXORCF,	dstXORCF,	dstXORCF,	dstXORCF,	dstXORCF,	dstXORCF,	dstXORCF
	.long dstLDCF,	dstLDCF,	dstLDCF,	dstLDCF,	dstLDCF,	dstLDCF,	dstLDCF,	dstLDCF
;@ 0xA0
	.long dstSTCF,	dstSTCF,	dstSTCF,	dstSTCF,	dstSTCF,	dstSTCF,	dstSTCF,	dstSTCF
	.long dstTSET,	dstTSET,	dstTSET,	dstTSET,	dstTSET,	dstTSET,	dstTSET,	dstTSET
;@ 0xB0
	.long dstRES,	dstRES,		dstRES,		dstRES,		dstRES,		dstRES,		dstRES,		dstRES
	.long dstSET,	dstSET,		dstSET,		dstSET,		dstSET,		dstSET,		dstSET,		dstSET
;@ 0xC0
	.long dstCHG,	dstCHG,		dstCHG,		dstCHG,		dstCHG,		dstCHG,		dstCHG,		dstCHG
	.long dstBIT,	dstBIT,		dstBIT,		dstBIT,		dstBIT,		dstBIT,		dstBIT,		dstBIT
;@ 0xD0
	.long dstNever,	dstJP,		dstJP,		dstJP,		dstJP,		dstJP,		dstJP,		dstJP
	.long dstJUMP,	dstJP,		dstJP,		dstJP,		dstJP,		dstJP,		dstJP,		dstJP
;@ 0xE0
	.long dstNever,	dstCALL,	dstCALL,	dstCALL,	dstCALL,	dstCALL,	dstCALL,	dstCALL
	.long dstCL,	dstCALL,	dstCALL,	dstCALL,	dstCALL,	dstCALL,	dstCALL,	dstCALL
;@ 0xF0
	.long dstNever,	dstRET,		dstRET,		dstRET,		dstRET,		dstRET,		dstRET,		dstRET
	.long dstRT,	dstRET,		dstRET,		dstRET,		dstRET,		dstRET,		dstRET,		dstRET

ed:
	mov r11,r11
	mov r0,#0xED
	t9fetch 0
;@----------------------------------------------------------------------------

;@----------------------------------------------------------------------------
dstLDBi:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	bl t9StoreB_mem
	t9fetch 5
;@----------------------------------------------------------------------------
dstLDWi:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	bl t9StoreW_mem
	t9fetch 6
;@----------------------------------------------------------------------------
dstPOPB:
;@----------------------------------------------------------------------------
	bl pop8
	bl t9StoreB_mem
	t9fetch 6
;@----------------------------------------------------------------------------
dstPOPW:
;@----------------------------------------------------------------------------
	bl pop16
	bl t9StoreW_mem
	t9fetch 6
;@----------------------------------------------------------------------------
dstLDBm16:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	bl t9LoadB
	bl t9StoreB_mem
	t9fetch 8
;@----------------------------------------------------------------------------
dstLDWm16:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	bl t9LoadW
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
dstLDAW:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#0x07
	mov t9Reg,t9Reg,lsl#2
	strh t9Mem,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
dstLDAL:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#0x07
	str t9Mem,[t9gprBank,t9Reg,lsl#2]
	t9fetch 4
;@----------------------------------------------------------------------------
dstANDCFA:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	tst r1,#0x08
	and r1,r1,#0x0F
	mov r2,#1
	tsteq r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstORCFA:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstXORCFA:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstLDCFA:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	tst r1,#0x08
	and r1,r1,#0x0F
	mov r2,#1
	biceq t9f,t9f,#PSR_C
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstSTCFA:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl r1
	orrne r0,r0,r2,lsl r1
	bl t9StoreB_mem
	t9fetch 8
;@----------------------------------------------------------------------------
dstLDBR:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#0x07
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
dstLDWR:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#0x07
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
dstLDLR:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#0x07
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl t9StoreL_mem
	t9fetch 6
;@----------------------------------------------------------------------------
dstANDCF:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r1,#1
	tst r0,r1,lsl t9Reg
	biceq t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstORCF:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r1,#1
	tst r0,r1,lsl t9Reg
	orrne t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstXORCF:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r1,#1
	tst r0,r1,lsl t9Reg
	eorne t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstLDCF:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r1,#1
	tst r0,r1,lsl t9Reg
	biceq t9f,t9f,#PSR_C
	orrne t9f,t9f,#PSR_C
	t9fetch 8
;@----------------------------------------------------------------------------
dstSTCF:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r2,#1
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl t9Reg
	orrne r0,r0,r2,lsl t9Reg
	bl t9StoreB_mem
	t9fetch 8
;@----------------------------------------------------------------------------
dstTSET:					;@ Test and Set
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r2,#1
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	tst r0,r2,lsl t9Reg
	orreq t9f,t9f,#PSR_Z
	orr r0,r0,r2,lsl t9Reg
	bl t9StoreB_mem
	t9fetch 10
;@----------------------------------------------------------------------------
dstRES:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r2,#1
	bic r0,r0,r2,lsl t9Reg
	bl t9StoreB_mem
	t9fetch 8
;@----------------------------------------------------------------------------
dstSET:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r2,#1
	orr r0,r0,r2,lsl t9Reg
	bl t9StoreB_mem
	t9fetch 8
;@----------------------------------------------------------------------------
dstCHG:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	mov r2,#1
	eor r0,r0,r2,lsl t9Reg
	bl t9StoreB_mem
	t9fetch 8
;@----------------------------------------------------------------------------
dstBIT:
;@----------------------------------------------------------------------------
	and t9Reg,r0,#7
	bl t9LoadB_mem
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	mov r2,#1
	tst r0,r2,lsl t9Reg
	orreq t9f,t9f,#PSR_Z
	t9fetch 8
;@----------------------------------------------------------------------------
dstJP:
;@----------------------------------------------------------------------------
	bl conditionCode
	cmp r0,#0
	beq dstNever
;@----------------------------------------------------------------------------
dstJUMP:
;@----------------------------------------------------------------------------
	bic t9pc,t9Mem,#0xFF000000
	bl reencode_pc
	t9fetch 9
;@----------------------------------------------------------------------------
dstCALL:
;@----------------------------------------------------------------------------
	bl conditionCode
	cmp r0,#0
	beq dstNever
;@----------------------------------------------------------------------------
dstCL:
;@----------------------------------------------------------------------------
	ldr r0,[t9optbl,#tlcs_LastBank]
	sub r0,t9pc,r0
	bl push32
	bic t9pc,t9Mem,#0xFF000000
	bl reencode_pc
	t9fetch 12
;@----------------------------------------------------------------------------
dstRET:
;@----------------------------------------------------------------------------
	bl conditionCode
	cmp r0,#0
	beq dstNever
;@----------------------------------------------------------------------------
dstRT:
;@----------------------------------------------------------------------------
	bl pop32
	bl encode_r0_pc
	t9fetch 12
;@----------------------------------------------------------------------------
dstNever:
;@----------------------------------------------------------------------------
	t9fetch 6

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
