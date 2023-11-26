//
//  TLCS900H_src.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2023 Fredrik Ahlström. All rights reserved.
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
;@ 43 size checks.
;@----------------------------------------------------------------------------
srcExXRR:
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]	;@ XRR
	ldrb r2,[t9pc],#1
	and t9Reg,r2,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r2,lsl#2]
;@----------------------------------------------------------------------------
srcExXRRd:
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]	;@ XRR
	ldrsb r0,[t9pc],#1
	add t9Mem,t9Mem,r0
	t9eatcycles 2
	ldrb r2,[t9pc],#1
	and t9Reg,r2,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r2,lsl#2]
;@----------------------------------------------------------------------------
srcEx8:
	ldrb t9Mem,[t9pc],#1
	t9eatcycles 2
	ldrb r2,[t9pc],#1
	and t9Reg,r2,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r2,lsl#2]
;@----------------------------------------------------------------------------
srcEx24:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#8
	ldrb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#16
	t9eatcycles 3
	ldrb r2,[t9pc],#1
	and t9Reg,r2,#0x07
	adr r1,srcOpCodes
	ldr pc,[r1,r2,lsl#2]
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
	ldrb r2,[t9pc],#1
	and t9Reg,r2,#0x07
	ldr pc,[pc,r2,lsl#2]
	mov r11,r11
srcOpCodes:
;@ 0x00
	.long srcError,	srcError,	srcError,	srcError,	srcPUSH,	srcError,	srcRLD,		srcRRD
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x10
	.long srcLDI,	srcLDIR,	srcLDD,		srcLDDR,	srcCPI,		srcCPIR,	srcCPD,		srcCPDR
	.long srcError,	srcLD16m,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x20
	.long srcLD,	srcLD,		srcLD,		srcLD,		srcLD,		srcLD,		srcLD,		srcLD
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
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
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
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

;@----------------------------------------------------------------------------
srcPUSH:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcPUSHW
	bcs srcError
;@----------------------------------------------------------------------------
srcPUSHB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl push8
	t9fetch 7
;@----------------------------------------------------------------------------
srcPUSHW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	bl push16
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
	add r2,t9ptr,#tlcsPzst
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
	add r2,t9ptr,#tlcsPzst
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
	movs r1,t9opCode,lsl#27		;@ Size
	and t9opCode,r2,#0x02		;@ Increase/Decrease
	rsb t9opCode,t9opCode,#0x01
	bmi srcLDI_LDDW
	bcs srcError
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
	and r2,r2,#0x02				;@ Increase/Decrease
	rsb r2,r2,#0x01
	and t9Reg,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9Reg,lsl#2]
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcCPI_CPDW
	bcs srcError
;@----------------------------------------------------------------------------
srcCPI_CPDB:
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	add r1,t9Mem,r2
	str r1,[t9gprBank,t9Reg,lsl#2]
	bl t9LoadB_mem
	mov r1,r0
	ldrb r0,[t9gprBank,#0x00]	;@ Reg A
	ldmfd sp!,{lr}
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcCPI_CPDW:
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	add r1,t9Mem,r2,lsl#1
	str r1,[t9gprBank,t9Reg,lsl#2]
	bl t9LoadW_mem
	mov r1,r0
	ldrh r0,[t9gprBank,#0x00]	;@ Reg WA
	ldmfd sp!,{lr}
	b generic_SUB_W
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
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcLD16mW
	bcs srcError
;@----------------------------------------------------------------------------
srcLD16mB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb t9Mem,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr t9Mem,t9Mem,r2,lsl#8
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcLD16mW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb t9mem,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr t9mem,t9mem,r2,lsl#8
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcLD:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcLDW
	bcs srcLDL
;@----------------------------------------------------------------------------
srcLDB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	strh r0,[t9gprBank,t9Reg]
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
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcEXW
	bcs srcError
;@----------------------------------------------------------------------------
srcEXB:						;@ Exchange
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	add t9Reg,t9gprBank,t9Reg,ror#30
	swpb r0,r0,[t9Reg]
	adr lr,fetch6
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcEXW:						;@ Exchange
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	strh r0,[t9gprBank,t9Reg]
	mov r0,r1
	adr lr,fetch6
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcADDi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcADDiW
	bcs srcError
;@----------------------------------------------------------------------------
srcADDiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_ADD_B
;@----------------------------------------------------------------------------
srcADDiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_ADD_W

;@----------------------------------------------------------------------------
srcADCi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcADCiW
	bcs srcError
;@----------------------------------------------------------------------------
srcADCiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_ADC_B
;@----------------------------------------------------------------------------
srcADCiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_ADC_W

;@----------------------------------------------------------------------------
srcSUBi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSUBiW
	bcs srcError
;@----------------------------------------------------------------------------
srcSUBiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcSUBiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_SUB_W

;@----------------------------------------------------------------------------
srcSBCi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSBCiW
	bcs srcError
;@----------------------------------------------------------------------------
srcSBCiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_SBC_B
;@----------------------------------------------------------------------------
srcSBCiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_SBC_W

;@----------------------------------------------------------------------------
srcANDi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcANDiW
	bcs srcError
;@----------------------------------------------------------------------------
srcANDiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_AND_B
;@----------------------------------------------------------------------------
srcANDiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_AND_W

;@----------------------------------------------------------------------------
srcXORi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcXORiW
	bcs srcError
;@----------------------------------------------------------------------------
srcXORiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_XOR_B
;@----------------------------------------------------------------------------
srcXORiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_XOR_W

;@----------------------------------------------------------------------------
srcORi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcORiW
	bcs srcError
;@----------------------------------------------------------------------------
srcORiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	bl generic_OR_B
strBFetch7:
	bl t9StoreB_mem
fetch7:
	t9fetchR 7
;@----------------------------------------------------------------------------
srcORiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_OR_W

;@----------------------------------------------------------------------------
srcCPi:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcCPiW
	bcs srcError
;@----------------------------------------------------------------------------
srcCPiB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldrb r1,[t9pc],#1
	adr lr,fetch6
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcCPiW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,fetch6
	b generic_SUB_W

;@----------------------------------------------------------------------------
srcMUL:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcMULW
	bcs srcError
;@----------------------------------------------------------------------------
srcMULB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	mov t9Reg,t9Reg,lsl#2
	ldrb r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
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
srcMULS:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcMULSW
	bcs srcError
;@----------------------------------------------------------------------------
srcMULSB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	mov r0,r0,lsl#24
	mov r0,r0,asr#24
	mov t9Reg,t9Reg,lsl#2
	ldrsb r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
;@----------------------------------------------------------------------------
srcMULSW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	mov r0,r0,lsl#16
	mov r0,r0,asr#16
	ldrsh r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg]
	t9fetch 26

;@----------------------------------------------------------------------------
srcDIV:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcDIVW
	bcs srcError
;@----------------------------------------------------------------------------
srcDIVB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	mov r1,r0
	mov t9Reg,t9Reg,lsl#2
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 22
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
srcDIVS:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcDIVSW
	bcs srcError
;@----------------------------------------------------------------------------
srcDIVSB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	bcc unknown_RR_Target
	mov r1,r0,lsl#24
	mov r1,r1,asr#24
	mov t9Reg,t9Reg,lsl#2
	ldrsh r0,[t9gprBank,t9Reg]
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 24
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

strWFetch8:
	bl t9StoreW_mem
fetch8:
	t9fetchR 8
;@----------------------------------------------------------------------------
srcINC:						;@ Increment
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcINCW
	bcs srcError
;@----------------------------------------------------------------------------
srcINCB:					;@ Increment
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_INC_B
	adr lr,fetch6
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcINCW:					;@ Increment
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ands r1,t9Reg,#7
	moveq r1,#8

	mov r0,r0,lsl#16
	and t9f,t9f,#PSR_C			;@ Save carry & clear n
	mov r2,r0,lsl#4				;@ Prepare for H check
	adds r0,r0,r1,lsl#16
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	orrvs t9f,t9f,#PSR_V
	cmn r2,r1,lsl#20
	orrcs t9f,t9f,#PSR_H
	mov r0,r0,lsr#16

	bl t9StoreW_mem
fetch6:
	t9fetchR 6
;@----------------------------------------------------------------------------
srcDEC:						;@ Decrement
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcDECW
	bcs srcError
;@----------------------------------------------------------------------------
srcDECB:					;@ Decrement
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_DEC_B
	adr lr,fetch6
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcDECW:					;@ Decrement
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ands r1,t9Reg,#7
	moveq r1,#8

	mov r0,r0,lsl#16
	orr t9f,t9f,#PSR_n+PSR_H+PSR_S+PSR_V+PSR_Z	;@ Save carry & set n
	mov r2,r0,lsl#4				;@ Prepare for H check
	subs r0,r0,r1,lsl#16
	bicpl t9f,t9f,#PSR_S
	bicne t9f,t9f,#PSR_Z
	bicvc t9f,t9f,#PSR_V
	cmp r2,r1,lsl#20
	biccs t9f,t9f,#PSR_H
	mov r0,r0,lsr#16

	adr lr,fetch6
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcRLC:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcRLCW
	bcs srcError
;@----------------------------------------------------------------------------
srcRLCB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsl#25
	orrcs r0,r0,#0x01000000
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcRLCW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	orrs r0,r0,r0,lsl#16
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P.
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	movs r0,r0,ror#15
	orrmi t9f,t9f,#PSR_S
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcRRC:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcRRCW
	bcs srcError
;@----------------------------------------------------------------------------
srcRRCB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsr#1
	orrcs r0,r0,#0x00000080
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcRRCW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	orr r0,r0,r0,lsl#16
	movs r0,r0,ror#1
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C|PSR_S
	orreq t9f,t9f,#PSR_Z
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcRL:						;@ Rotate Left
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcRLW
	bcs srcError
;@----------------------------------------------------------------------------
srcRLB:						;@ Rotate Left
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	tst t9f,t9f,lsr#2			;@ Get C
	adc r0,r0,r0
	movs r1,r0,lsl#24
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcRLW:						;@ Rotate Left
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	tst t9f,t9f,lsr#2			;@ Get C
	adc r0,r0,r0
	movs r1,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcRR:						;@ Rotate Right
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcRRW
	bcs srcError
;@----------------------------------------------------------------------------
srcRRB:						;@ Rotate Right
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	tst t9f,#PSR_C
	orrne r0,r0,#0x00000100
	movs r0,r0,lsr#1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcRRW:						;@ Rotate Right
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r0,r0,lsl#16
	tst t9f,t9f,lsr#2			;@ Get C
	mov r1,r0,rrx
	movs r0,r1,asr#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcSLA:
srcSLL:						;@ Should this insert 1 into bit#0 like the Z80?
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSLAW
	bcs srcError
;@----------------------------------------------------------------------------
srcSLAB:
srcSLLB:					;@ Shift Left Logical
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsl#25
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcSLAW:
srcSLLW:					;@ Shift Left Logical
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	movs r0,r0,lsl#17
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	mov r0,r0,lsr#16
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcSRA:						;@ Shift Right Arithmetic
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSRAW
	bcs srcError
;@----------------------------------------------------------------------------
srcSRAB:					;@ Shift Right Arithmetic
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	and r1,r0,#0x80
	orrs r0,r1,r0,lsr#1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcSRAW:					;@ Shift Right Arithmetic
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	movs r0,r0,lsl#16
	mov r0,r0,asr#1
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	movs r0,r0,lsr#16
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcSRL:						;@ Shift Right Logical
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSRLW
	bcs srcError
;@----------------------------------------------------------------------------
srcSRLB:					;@ Shift Right Logical
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs r0,r0,lsr#1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcSRLW:					;@ Shift Right Logical
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	movs r0,r0,lsr#1
	eor r1,r0,r0,lsr#8
	and r1,r1,#0xFF
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1]			;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcADDRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcADDRmW
	bcs srcADDRmL
;@----------------------------------------------------------------------------
srcADDRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_ADD_B_mem
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADDRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	bl generic_ADD_W_reg
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADDRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_ADD_L_reg
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcADDmR:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcADDmRW
	bcs srcADDmRL
;@----------------------------------------------------------------------------
srcADDmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_ADD_B_mem
	adr lr,fetch4
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcADDmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADD_W
	adr lr,fetch4
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcADDmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_ADD_L_reg
	adr lr,fetch6
	b t9StoreL_mem

;@----------------------------------------------------------------------------
srcADCRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcADCRmW
	bcs srcADCRmL
;@----------------------------------------------------------------------------
srcADCRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_ADC_B_mem
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADCRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	bl generic_ADC_W_reg
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcADCRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_ADC_L_reg
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcADCmR:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcADCmRW
	bcs srcADCmRL
;@----------------------------------------------------------------------------
srcADCmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_ADC_B_mem
	adr lr,fetch4
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcADCmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADC_W
	adr lr,fetch4
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcADCmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_ADC_L_reg
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcSUBRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSUBRmW
	bcs srcSUBRmL
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
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSUBmRW
	bcs srcSUBmRL
;@----------------------------------------------------------------------------
srcSUBmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	bl generic_SUB_B_reg
	adr lr,fetch4
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcSUBmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_W
	adr lr,fetch4
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcSUBmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_SUB_L_reg
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcSBCRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSBCRmW
	bcs srcSBCRmL
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
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcSBCmRW
	bcs srcSBCmRL
;@----------------------------------------------------------------------------
srcSBCmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	bl generic_SBC_B_reg
	bl t9StoreB_mem
fetch4:
	t9fetchR 4
;@----------------------------------------------------------------------------
srcSBCmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_W
	adr lr,fetch4
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcSBCmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_SBC_L_reg
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcANDRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcANDRmW
	bcs srcANDRmL
;@----------------------------------------------------------------------------
srcANDRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_AND_B_mem
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcANDRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	bl generic_AND_W_reg
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcANDRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_AND_L_reg
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcANDmR:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcANDRmW
	bcs srcANDRmL
;@----------------------------------------------------------------------------
srcANDmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_AND_B_mem
	adr lr,fetch4
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcANDmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_AND_W
	adr lr,fetch4
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcANDmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_AND_L_reg
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcORRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcORRmW
	bcs srcORRmL
;@----------------------------------------------------------------------------
srcORRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_OR_B_mem
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcORRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	bl generic_OR_W_reg
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcORRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_OR_L_reg
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcORmR:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcORmRW
	bcs srcORmRL
;@----------------------------------------------------------------------------
srcORmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_OR_B_mem
	adr lr,fetch4
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcORmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_OR_W
	adr lr,fetch4
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcORmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_OR_L_reg
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcXORRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcXORRmW
	bcs srcXORRmL
;@----------------------------------------------------------------------------
srcXORRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_XOR_B_mem
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
srcXORRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov t9Reg,t9Reg,lsl#2
	bl generic_XOR_W_reg
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcXORRmL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_XOR_L_reg
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcXORmR:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcXORmRW
	bcs srcXORmRL
;@----------------------------------------------------------------------------
srcXORmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	bl generic_XOR_B_mem
	adr lr,fetch4
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcXORmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_XOR_W
	adr lr,fetch4
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcXORmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_XOR_L_reg
	bl t9StoreL_mem
	t9fetch 6

;@----------------------------------------------------------------------------
srcCPRm:
;@----------------------------------------------------------------------------
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcCPRmW
	bcs srcCPRmL
;@----------------------------------------------------------------------------
srcCPRmB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	mov r1,r0
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	adr lr,fetch4
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcCPRmW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	adr lr,fetch4
	b generic_SUB_W
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
	movs r1,t9opCode,lsl#27		;@ Size
	bmi srcCPmRW
	bcs srcCPmRL
;@----------------------------------------------------------------------------
srcCPmRB:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	adr lr,fetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
srcCPmRW:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,fetch4
	b generic_SUB_W
;@----------------------------------------------------------------------------
srcCPmRL:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	bl generic_SUB_L_reg
	t9fetch 6

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
