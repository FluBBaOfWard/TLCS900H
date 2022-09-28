//
//  TLCS900H_src.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2022 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "TLCS900H_mac.h"

	.global srcExXRR
	.global srcExXRRd
	.global srcEx8
	.global srcEx16
	.global srcEx24
	.global srcExR32
	.global srcExDec
	.global srcExInc
	.global unknown_RR_Target

	.syntax unified
	.arm

#ifdef NDS
	.section .itcm						;@ For the NDS ARM9
#elif GBA
	.section .iwram, "ax", %progbits	;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
	.align 2
;@----------------------------------------------------------------------------
;@ 49 size checks.
;@----------------------------------------------------------------------------
srcExXRR:
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]	;@ XRR
	ldrb r0,[t9pc],#1
	and t9Reg,r0,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
srcExXRRd:
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]	;@ XRR
	ldrsb r0,[t9pc],#1
	add t9Mem,t9Mem,r0
	t9eatcycles 2
	ldrb r0,[t9pc],#1
	and t9Reg,r0,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
srcEx8:
	ldrb t9Mem,[t9pc],#1
	t9eatcycles 2
	ldrb r0,[t9pc],#1
	and t9Reg,r0,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
srcEx24:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#8
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#16
	t9eatcycles 3
	ldrb r0,[t9pc],#1
	and t9Reg,r0,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
srcExR32:
	adr lr,src_asm
	b ExR32
;@----------------------------------------------------------------------------
srcExDec:
	adr lr,src_asm
	b ExDec
;@----------------------------------------------------------------------------
srcExInc:
	adr lr,src_asm
	b ExInc
;@----------------------------------------------------------------------------
srcEx16:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#8
	t9eatcycles 2
;@----------------------------------------------------------------------------
src_asm:
	ldrb r0,[t9pc],#1
	and t9Reg,r0,#0x07
	ldr pc,[pc,r0,lsl#2]
	mov r11,r11
srcOpCodes:
;@ 0x00
	.long es,		es,			es,			es,			srcPUSH,	es,			srcRLD,		srcRRD
	.long es,		es,			es,			es,			es,			es,			es,			es
;@ 0x10
	.long srcLDI,	srcLDIR,	srcLDD,		srcLDDR,	srcCPI,		srcCPIR,	srcCPD,		srcCPDR
	.long es,		srcLD16m,	es,			es,			es,			es,			es,			es
;@ 0x20
	.long srcLD,	srcLD,		srcLD,		srcLD,		srcLD,		srcLD,		srcLD,		srcLD
	.long es,		es,			es,			es,			es,			es,			es,			es
;@ 0x30
	.long srcEX,	srcEX,		srcEX,		srcEX,		srcEX,		srcEX,		srcEX,		srcEX
	.long srcADDi,	srcADCi,	srcSUBi,	srcSBCi,	srcANDi,	srcXORi,	srcORi,		srcCPi
;@ 0x40
	.long srcMUL,	srcMUL,		srcMUL,		srcMUL,		srcMUL,		srcMUL,		srcMUL,		srcMUL
	.long srcMULS,	srcMULS,	srcMULS,	srcMULS,	srcMULS,	srcMULS,	srcMULS,	srcMULS
;@ 0x50
	.long srcDIV,	srcDIV,		srcDIV,		srcDIV,		srcDIV,		srcDIV,		srcDIV,		srcDIV
	.long srcDIVS,	srcDIVS,	srcDIVS,	srcDIVS,	srcDIVS,	srcDIVS,	srcDIVS,	srcDIVS
;@ 0x60
	.long srcINC,	srcINC,		srcINC,		srcINC,		srcINC,		srcINC,		srcINC,		srcINC
	.long srcDEC,	srcDEC,		srcDEC,		srcDEC,		srcDEC,		srcDEC,		srcDEC,		srcDEC
;@ 0x70
	.long es,		es,			es,			es,			es,			es,			es,			es
	.long srcRLC,	srcRRC,		srcRL,		srcRR,		srcSLA,		srcSRA,		srcSLL,		srcSRL
;@ 0x80
	.long srcADDRm,	srcADDRm,	srcADDRm,	srcADDRm,	srcADDRm,	srcADDRm,	srcADDRm,	srcADDRm
	.long srcADDmR,	srcADDmR,	srcADDmR,	srcADDmR,	srcADDmR,	srcADDmR,	srcADDmR,	srcADDmR
;@ 0x90
	.long srcADCRm,	srcADCRm,	srcADCRm,	srcADCRm,	srcADCRm,	srcADCRm,	srcADCRm,	srcADCRm
	.long srcADCmR,	srcADCmR,	srcADCmR,	srcADCmR,	srcADCmR,	srcADCmR,	srcADCmR,	srcADCmR
;@ 0xA0
	.long srcSUBRm,	srcSUBRm,	srcSUBRm,	srcSUBRm,	srcSUBRm,	srcSUBRm,	srcSUBRm,	srcSUBRm
	.long srcSUBmR,	srcSUBmR,	srcSUBmR,	srcSUBmR,	srcSUBmR,	srcSUBmR,	srcSUBmR,	srcSUBmR
;@ 0xB0
	.long srcSBCRm,	srcSBCRm,	srcSBCRm,	srcSBCRm,	srcSBCRm,	srcSBCRm,	srcSBCRm,	srcSBCRm
	.long srcSBCmR,	srcSBCmR,	srcSBCmR,	srcSBCmR,	srcSBCmR,	srcSBCmR,	srcSBCmR,	srcSBCmR
;@ 0xC0
	.long srcANDRm,	srcANDRm,	srcANDRm,	srcANDRm,	srcANDRm,	srcANDRm,	srcANDRm,	srcANDRm
	.long srcANDmR,	srcANDmR,	srcANDmR,	srcANDmR,	srcANDmR,	srcANDmR,	srcANDmR,	srcANDmR
;@ 0xD0
	.long srcXORRm,	srcXORRm,	srcXORRm,	srcXORRm,	srcXORRm,	srcXORRm,	srcXORRm,	srcXORRm
	.long srcXORmR,	srcXORmR,	srcXORmR,	srcXORmR,	srcXORmR,	srcXORmR,	srcXORmR,	srcXORmR
;@ 0xE0
	.long srcORRm,	srcORRm,	srcORRm,	srcORRm,	srcORRm,	srcORRm,	srcORRm,	srcORRm
	.long srcORmR,	srcORmR,	srcORmR,	srcORmR,	srcORmR,	srcORmR,	srcORmR,	srcORmR
;@ 0xF0
	.long srcCPRm,	srcCPRm,	srcCPRm,	srcCPRm,	srcCPRm,	srcCPRm,	srcCPRm,	srcCPRm
	.long srcCPmR,	srcCPmR,	srcCPmR,	srcCPmR,	srcCPmR,	srcCPmR,	srcCPmR,	srcCPmR

es:
	mov r11,r11
	mov r0,#0xE5
	t9fetch 0
;@----------------------------------------------------------------------------
srcPUSH:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcPUSHB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcPUSHW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	bl push16
	t9fetch 7
;@----------------------------------------------------------------------------
srcPUSHB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl push8
	t9fetch 7
;@----------------------------------------------------------------------------
srcRLD:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r2,[t9gprBank,#0x00]	;@ Reg A
	and r1,r2,#0xF0
	orr r0,r1,r0,ror#4
	strb r0,[t9gprBank,#0x00]	;@ Reg A
	and r1,r0,#0xFF
	and r2,r2,#0x0F
	orr r0,r2,r0,lsr#24
	add r2,t9optbl,#tlcsPzst
	ldrb r1,[r2,r1]				;@ Get PZS
	and t9f,t9f,#PSR_C			;@ Keep C
	orr t9f,t9f,r1
	bl t9StoreB_mem
	t9fetch 12
;@----------------------------------------------------------------------------
srcRRD:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r2,[t9gprBank,#0x00]	;@ Reg A
	and r1,r2,#0xF0
	mov r0,r0,ror#4
	orr r1,r1,r0,lsr#28
	strb r1,[t9gprBank,#0x00]	;@ Reg A
	orr r0,r0,r2,lsl#4
	add r2,t9optbl,#tlcsPzst
	ldrb r1,[r2,r1]				;@ Get PZS
	and t9f,t9f,#PSR_C			;@ Keep C
	orr t9f,t9f,r1
	and r0,r0,#0xFF
	bl t9StoreB_mem
	t9fetch 12

;@----------------------------------------------------------------------------
srcLDI:
srcLDD:
;@----------------------------------------------------------------------------
	adr lr,LDI_LDDret
;@----------------------------------------------------------------------------
srcLDI_LDDdo:
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	tst t9Reg,#1
	beq unknown_RR_Target
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]
	ands r1,t9opCode,#0x30		;@ Size
	and t9opCode,r0,#0x02		;@ Increase/Decrease
	rsb t9opCode,t9opCode,#0x01
	beq srcLDI_LDDB
	cmp r1,#0x10
	bxne lr
;@----------------------------------------------------------------------------
srcLDI_LDDW:
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	add r1,t9Mem,t9opCode,lsl#1
	str r1,[t9gprBank,t9Reg,lsl#2]
	sub t9Reg,t9Reg,#1
	bl t9LoadW_mem
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]
	add r1,t9Mem,t9opCode,lsl#1
	str r1,[t9gprBank,t9Reg,lsl#2]
	ldmfd sp!,{lr}
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcLDI_LDDB:
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	add r1,t9Mem,t9opCode
	str r1,[t9gprBank,t9Reg,lsl#2]
	sub t9Reg,t9Reg,#1
	bl t9LoadB_mem
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]
	add r1,t9Mem,t9opCode
	str r1,[t9gprBank,t9Reg,lsl#2]
	ldmfd sp!,{lr}
	b t9StoreB_mem
;@----------------------------------------------------------------------------
LDI_LDDret:
	ldrh r0,[t9gprBank,#0x04]	;@ Reg BC
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#0x04]	;@ Reg BC
	bic t9f,t9f,#PSR_H+PSR_P+PSR_n
	orrne t9f,t9f,#PSR_P
	t9fetch 10
;@----------------------------------------------------------------------------
srcLDIR:
srcLDDR:
;@----------------------------------------------------------------------------
	bl srcLDI_LDDdo
LDIR_LDDRret:
	ldrh r0,[t9gprBank,#0x04]	;@ Reg BC
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#0x04]	;@ Reg BC
	bic t9f,t9f,#PSR_H+PSR_P+PSR_n
	orrne t9f,t9f,#PSR_P
	subne t9pc,t9pc,#2
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 10

;@----------------------------------------------------------------------------
srcCPI:
srcCPD:
;@----------------------------------------------------------------------------
	adr lr,CPI_CPDret
;@----------------------------------------------------------------------------
srcCPI_CPDdo:
;@----------------------------------------------------------------------------
	and r0,r0,#0x02				;@ Increase/Decrease
	rsb r0,r0,#0x01
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]
	ands r1,t9opCode,#0x30		;@ Size
	beq srcCPI_CPDB
	cmp r1,#0x10
	bxne lr
;@----------------------------------------------------------------------------
srcCPI_CPDW:
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	add r1,t9Mem,r0,lsl#1
	str r1,[t9gprBank,t9Reg,lsl#2]
	bl t9LoadW_mem
	mov r1,r0
	ldrh r0,[t9gprBank,#0x00]	;@ Reg WA
	ldmfd sp!,{lr}
	b generic_SUB_W
;@----------------------------------------------------------------------------
srcCPI_CPDB:
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	add r1,t9Mem,r0
	str r1,[t9gprBank,t9Reg,lsl#2]
	bl t9LoadB_mem
	mov r1,r0
	ldrb r0,[t9gprBank,#0x00]	;@ Reg A
	ldmfd sp!,{lr}
	b generic_SUB_B
;@----------------------------------------------------------------------------
CPI_CPDret:
	ldrh r0,[t9gprBank,#0x04]	;@ Reg BC
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#0x04]	;@ Reg BC
	orr t9f,t9f,#PSR_P+PSR_n
	biceq t9f,t9f,#PSR_P
	t9fetch 8
;@----------------------------------------------------------------------------
srcCPIR:
srcCPDR:
;@----------------------------------------------------------------------------
	bl srcCPI_CPDdo
CPI_CPDRret:
	ldrh r0,[t9gprBank,#0x04]	;@ Reg BC
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#0x04]	;@ Reg BC
	orr t9f,t9f,#PSR_P+PSR_n
	biceq t9f,t9f,#PSR_P
	eor r0,t9f,#PSR_Z
	tstne r0,#PSR_Z
	subne t9pc,t9pc,#2
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 8

;@----------------------------------------------------------------------------
srcLD16m:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcLD16mB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcLD16mW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl t9StoreW
	t9fetch 8
;@----------------------------------------------------------------------------
srcLD16mB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl t9StoreB
	t9fetch 8

;@----------------------------------------------------------------------------
srcLD:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcLDB
	cmp r1,#0x20
	beq srcLDL
;@----------------------------------------------------------------------------
srcLDW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	bl t9LoadW_mem
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	bl t9LoadB_mem
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcEX:						;@ Exchange
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcEXB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcEXW:						;@ Exchange
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	strh r0,[t9gprBank,t9Reg]
	mov r0,r1
	bl t9StoreW_mem
	t9fetch 6
;@----------------------------------------------------------------------------
srcEXB:						;@ Exchange
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	bl t9LoadB_mem
	add t9Reg,t9gprBank,t9Reg,ror#30
	swpb r0,r0,[t9Reg]
	bl t9StoreB_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcADDi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcADDiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcADDiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_ADD_W
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcADDiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_ADD_B
	bl t9StoreB_mem
	t9fetch 7

;@----------------------------------------------------------------------------
srcADCi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcADCiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcADCiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_ADC_W
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcADCiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_ADC_B
	bl t9StoreB_mem
	t9fetch 7

;@----------------------------------------------------------------------------
srcSUBi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSUBiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcSUBiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_SUB_W
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcSUBiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_SUB_B
	bl t9StoreB_mem
	t9fetch 7

;@----------------------------------------------------------------------------
srcSBCi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSBCiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcSBCiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_SBC_W
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcSBCiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_SBC_B
	bl t9StoreB_mem
	t9fetch 7

;@----------------------------------------------------------------------------
srcANDi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcANDiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcANDiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_AND_W
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcANDiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_AND_B
	bl t9StoreB_mem
	t9fetch 7

;@----------------------------------------------------------------------------
srcXORi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcXORiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcXORiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_XOR_W
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcXORiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_XOR_B
	bl t9StoreB_mem
	t9fetch 7

;@----------------------------------------------------------------------------
srcORi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcORiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcORiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_OR_W
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcORiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_OR_B
	bl t9StoreB_mem
	t9fetch 7

;@----------------------------------------------------------------------------
srcCPi:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcCPiB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcCPiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_SUB_W
	t9fetch 6
;@----------------------------------------------------------------------------
srcCPiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_SUB_B
	t9fetch 6

;@----------------------------------------------------------------------------
unknown_RR_Target:
	mov r11,r11
	ldr r0,=0x0BADC0DE
	bx lr
	.pool
;@----------------------------------------------------------------------------
srcMUL:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcMULB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcMULW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg]
	t9fetch 26
;@----------------------------------------------------------------------------
srcMULB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	bl t9LoadB_mem
	mov t9Reg,t9Reg,lsl#2
	ldrb r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18

;@----------------------------------------------------------------------------
srcMULS:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcMULSB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcMULSW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	bl t9LoadW_mem
	mov r0,r0,lsl#16
	mov r0,r0,asr#16
	ldrsh r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg]
	t9fetch 26
;@----------------------------------------------------------------------------
srcMULSB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	bl t9LoadB_mem
	mov r0,r0,lsl#24
	mov r0,r0,asr#24
	mov t9Reg,t9Reg,lsl#2
	ldrsb r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18

;@----------------------------------------------------------------------------
srcDIV:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcDIVB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcDIVW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 30
;@----------------------------------------------------------------------------
srcDIVB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	bl t9LoadB_mem
	mov r1,r0
	mov t9Reg,t9Reg,lsl#2
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 22

;@----------------------------------------------------------------------------
srcDIVS:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcDIVSB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcDIVSW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r1,r0,lsl#16
	mov r1,r1,asr#16
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 32
;@----------------------------------------------------------------------------
srcDIVSB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	bl t9LoadB_mem
	mov r1,r0,lsl#24
	mov r1,r1,asr#24
	mov t9Reg,t9Reg,lsl#2
	ldrsh r0,[t9gprBank,t9Reg]
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 24

;@----------------------------------------------------------------------------
srcINC:						;@ Increment
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcINCB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcINCW:					;@ Increment
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_INC_W
	bl t9StoreW_mem
	t9fetch 6
;@----------------------------------------------------------------------------
srcINCB:					;@ Increment
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_INC_B
	bl t9StoreB_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcDEC:						;@ Decrement
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcDECB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcDECW:					;@ Decrement
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_DEC_W
	bl t9StoreW_mem
	t9fetch 6
;@----------------------------------------------------------------------------
srcDECB:					;@ Decrement
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_DEC_B
	bl t9StoreB_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcRLC:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcRLCB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcRLCW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	orrs r0,r0,r0,lsl#16
	eor r1,r0,r0,lsl#8
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P.
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	movs r0,r0,ror#15
	orrmi t9f,t9f,#PSR_S
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcRLCB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsl#25
	orrcs r0,r0,#0x01000000
	add r1,t9optbl,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	bl t9StoreB_mem
	t9fetch 8

;@----------------------------------------------------------------------------
srcRRC:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcRRCB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcRRCW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	orr r0,r0,r0,lsl#16
	movs r0,r0,ror#1
	eor r1,r0,r0,lsl#8
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C|PSR_S
	orreq t9f,t9f,#PSR_Z
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcRRCB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsr#1
	orrcs r0,r0,#0x00000080
	add r1,t9optbl,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	bl t9StoreB_mem
	t9fetch 8

;@----------------------------------------------------------------------------
srcRL:						;@ Rotate Left
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcRLB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcRLW:						;@ Rotate Left
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	tst t9f,t9f,lsr#2			;@ Get C
	adc r0,r0,r0
	movs r1,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcRLB:						;@ Rotate Left
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	tst t9f,t9f,lsr#2			;@ Get C
	adc r0,r0,r0
	movs r1,r0,lsl#24
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	bl t9StoreB_mem
	t9fetch 8

;@----------------------------------------------------------------------------
srcRR:						;@ Rotate Right
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcRRB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcRRW:						;@ Rotate Right
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r0,r0,lsl#16
	tst t9f,t9f,lsr#2			;@ Get C
	mov r1,r0,rrx
	movs r0,r1,asr#16
	eor r1,r1,r1,lsl#8
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcRRB:						;@ Rotate Right
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	tst t9f,#PSR_C
	orrne r0,r0,#0x00000100
	movs r0,r0,lsr#1
	add r1,t9optbl,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	bl t9StoreB_mem
	t9fetch 8

;@----------------------------------------------------------------------------
srcSLA:
srcSLL:						;@ Should this insert 1 into bit#0 like the Z80?
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSLAB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcSLAW:
srcSLLW:					;@ Shift Left Logical
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	movs r0,r0,lsl#17
	eor r1,r0,r0,lsl#8
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	mov r0,r0,lsr#16
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcSLAB:
srcSLLB:					;@ Shift Left Logical
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsl#25
	add r1,t9optbl,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	bl t9StoreB_mem
	t9fetch 8

;@----------------------------------------------------------------------------
srcSRA:						;@ Shift Right Arithmetic
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSRAB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcSRAW:					;@ Shift Right Arithmetic
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	movs r0,r0,lsl#16
	mov r0,r0,asr#1
	eor r1,r0,r0,lsl#8
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	movs r0,r0,lsr#16
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcSRAB:					;@ Shift Right Arithmetic
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	and r1,r0,#0x80
	orrs r0,r1,r0,lsr#1
	add r1,t9optbl,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	bl t9StoreB_mem
	t9fetch 8

;@----------------------------------------------------------------------------
srcSRL:						;@ Shift Right Logical
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSRLB
	cmp r1,#0x10
	bne es
;@----------------------------------------------------------------------------
srcSRLW:					;@ Shift Right Logical
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	movs r0,r0,lsr#1
	eor r1,r0,r0,lsr#8
	and r1,r1,#0xFF
	add r2,t9optbl,#tlcsPzst
	ldrb t9f,[r2,r1]			;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	bl t9StoreW_mem
	t9fetch 8
;@----------------------------------------------------------------------------
srcSRLB:					;@ Shift Right Logical
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsr#1
	add r1,t9optbl,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	bl t9StoreB_mem
	t9fetch 8

;@----------------------------------------------------------------------------
srcADDRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcADDRmB
	cmp r1,#0x20
	beq srcADDRmL
;@----------------------------------------------------------------------------
srcADDRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	bl generic_ADD_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADDRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_ADD_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADDRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADD_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcADDmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcADDmRB
	cmp r1,#0x20
	beq srcADDmRL
;@----------------------------------------------------------------------------
srcADDmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADD_W
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcADDmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_ADD_B
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcADDmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADD_L
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcADCRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcADCRmB
	cmp r1,#0x20
	beq srcADCRmL
;@----------------------------------------------------------------------------
srcADCRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	bl generic_ADC_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADCRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_ADC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADCRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADC_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcADCmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcADCmRB
	cmp r1,#0x20
	beq srcADCmRL
;@----------------------------------------------------------------------------
srcADCmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADC_W
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcADCmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_ADC_B
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcADCmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADC_L
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcSUBRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSUBRmB
	cmp r1,#0x20
	beq srcSUBRmL
;@----------------------------------------------------------------------------
srcSUBRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r1,r0
	mov t9Reg,t9Reg,lsl#2
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SUB_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcSUBRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	mov r1,r0
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcSUBRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcSUBmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSUBmRB
	cmp r1,#0x20
	beq srcSUBmRL
;@----------------------------------------------------------------------------
srcSUBmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_W
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcSUBmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcSUBmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_L
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcSBCRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSBCRmB
	cmp r1,#0x20
	beq srcSBCRmL
;@----------------------------------------------------------------------------
srcSBCRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r1,r0
	mov t9Reg,t9Reg,lsl#2
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SBC_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcSBCRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	mov r1,r0
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SBC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcSBCRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcSBCmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcSBCmRB
	cmp r1,#0x20
	beq srcSBCmRL
;@----------------------------------------------------------------------------
srcSBCmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_W
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcSBCmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_SBC_B
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcSBCmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_L
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcANDRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcANDRmB
	cmp r1,#0x20
	beq srcANDRmL
;@----------------------------------------------------------------------------
srcANDRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	bl generic_AND_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcANDRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_AND_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcANDRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_AND_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcANDmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcANDmRB
	cmp r1,#0x20
	beq srcANDmRL
;@----------------------------------------------------------------------------
srcANDmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_AND_W
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcANDmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_AND_B
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcANDmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_AND_L
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcORRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcORRmB
	cmp r1,#0x20
	beq srcORRmL
;@----------------------------------------------------------------------------
srcORRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	bl generic_OR_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcORRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_OR_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcORRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_OR_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcORmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcORmRB
	cmp r1,#0x20
	beq srcORmRL
;@----------------------------------------------------------------------------
srcORmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_OR_W
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcORmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_OR_B
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcORmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_OR_L
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcXORRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcXORRmB
	cmp r1,#0x20
	beq srcXORRmL
;@----------------------------------------------------------------------------
srcXORRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	bl generic_XOR_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcXORRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_XOR_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcXORRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_XOR_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcXORmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcXORmRB
	cmp r1,#0x20
	beq srcXORmRL
;@----------------------------------------------------------------------------
srcXORmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_XOR_W
	bl t9StoreW_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcXORmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_XOR_B
	bl t9StoreB_mem
	t9fetch 4
;@----------------------------------------------------------------------------
srcXORmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_XOR_L
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcCPRm:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcCPRmB
	cmp r1,#0x20
	beq srcCPRmL
;@----------------------------------------------------------------------------
srcCPRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_W
	t9fetch 4
;@----------------------------------------------------------------------------
srcCPRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	mov r1,r0
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	t9fetch 4
;@----------------------------------------------------------------------------
srcCPRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_L
	t9fetch 6

;@----------------------------------------------------------------------------
srcCPmR:
;@----------------------------------------------------------------------------
	ands r1,t9opCode,#0x30		;@ Size
	beq srcCPmRB
	cmp r1,#0x20
	beq srcCPmRL
;@----------------------------------------------------------------------------
srcCPmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_W
	t9fetch 4
;@----------------------------------------------------------------------------
srcCPmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	t9fetch 4
;@----------------------------------------------------------------------------
srcCPmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_L
	t9fetch 6

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
