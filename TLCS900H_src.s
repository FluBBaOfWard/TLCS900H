//
//  TLCS900H_src.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2024 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "TLCS900H_mac.h"

	.global srcExXWAB
	.global srcExXBCB
	.global srcExXDEB
	.global srcExXHLB
	.global srcExXIXB
	.global srcExXIYB
	.global srcExXIZB
	.global srcExXSPB
	.global srcExXRRW
	.global srcExXRRL
	.global srcExXWAdB
	.global srcExXBCdB
	.global srcExXDEdB
	.global srcExXHLdB
	.global srcExXIXdB
	.global srcExXIYdB
	.global srcExXIZdB
	.global srcExXSPdB
	.global srcExXRRdW
	.global srcExXRRdL
	.global srcEx8B
	.global srcEx8W
	.global srcEx8L
	.global srcEx16B
	.global srcEx16W
	.global srcEx16L
	.global srcEx24B
	.global srcEx24W
	.global srcEx24L
	.global srcExR32B
	.global srcExR32W
	.global srcExR32L
	.global srcExDecB
	.global srcExDecW
	.global srcExDecL
	.global srcExIncB
	.global srcExIncW
	.global srcExIncL

// Byte opcodes for src
	.global srcPUSHB
	.global srcRLD
	.global srcRRD
	.global srcLDIB
	.global srcLDIRB
	.global srcLDDB
	.global srcLDDRB
	.global srcCPIB
	.global srcCPIRB
	.global srcCPDB
	.global srcCPDRB
	.global srcLD16mB
	.global srcLDB_W
	.global srcLDB_A
	.global srcLDB_B
	.global srcLDB_C
	.global srcLDB_D
	.global srcLDB_E
	.global srcLDB_H
	.global srcLDB_L
	.global srcEXB
	.global srcADDiB
	.global srcADCiB
	.global srcSUBiB
	.global srcSBCiB
	.global srcANDiB
	.global srcXORiB
	.global srcORiB
	.global srcCPiB
	.global srcMULB
	.global srcMULSB
	.global srcDIVB
	.global srcDIVSB
	.global srcINCB
	.global srcDECB
	.global srcRLCB
	.global srcRRCB
	.global srcRLB
	.global srcRRB
	.global srcSLAB
	.global srcSRAB
	.global srcSLLB
	.global srcSRLB
	.global srcADDRmB
	.global srcADDmRB
	.global srcADCRmB
	.global srcADCmRB
	.global srcSUBRmB
	.global srcSUBmRB
	.global srcSBCRmB
	.global srcSBCmRB
	.global srcANDRmB
	.global srcANDmRB
	.global srcXORRmB
	.global srcXORmRB
	.global srcORRmB
	.global srcORmRB
	.global srcCPRmB
	.global srcCPmRWB
	.global srcCPmRAB
	.global srcCPmRBB
	.global srcCPmRCB
	.global srcCPmRDB
	.global srcCPmREB
	.global srcCPmRHB
	.global srcCPmRLB

// Word opcodes for src
	.global srcPUSHW
	.global srcLDIW
	.global srcLDIRW
	.global srcLDDW
	.global srcLDDRW
	.global srcCPIW
	.global srcCPIRW
	.global srcCPDW
	.global srcCPDRW
	.global srcLD16mW
	.global srcLDW
	.global srcEXW
	.global srcADDiW
	.global srcADCiW
	.global srcSUBiW
	.global srcSBCiW
	.global srcANDiW
	.global srcXORiW
	.global srcORiW
	.global srcCPiW
	.global srcMULW
	.global srcMULSW
	.global srcDIVW
	.global srcDIVSW
	.global srcINCW
	.global srcDECW
	.global srcRLCW
	.global srcRRCW
	.global srcRLW
	.global srcRRW
	.global srcSLAW
	.global srcSRAW
	.global srcSLLW
	.global srcSRLW
	.global srcADDRmW
	.global srcADDmRW
	.global srcADCRmW
	.global srcADCmRW
	.global srcSUBRmW
	.global srcSUBmRW
	.global srcSBCRmW
	.global srcSBCmRW
	.global srcANDRmW
	.global srcANDmRW
	.global srcXORRmW
	.global srcXORmRW
	.global srcORRmW
	.global srcORmRW
	.global srcCPRmW
	.global srcCPmRW

// Long word opcodes for src
srcOpCodesL:
	.global srcLDL
	.global srcADDRmL
	.global srcADDmRL
	.global srcADCRmL
	.global srcADCmRL
	.global srcSUBRmL
	.global srcSUBmRL
	.global srcSBCRmL
	.global srcSBCmRL
	.global srcANDRmL
	.global srcANDmRL
	.global srcXORRmL
	.global srcXORmRL
	.global srcORRmL
	.global srcORmRL
	.global srcCPRmL
	.global srcCPmRL

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
srcExXWAB:
srcExXBCB:
srcExXDEB:
srcExXHLB:
srcExXIXB:
srcExXIYB:
srcExXIZB:
srcExXSPB:
	and t9opCode,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]	;@ XRR
	b srcExB
;@----------------------------------------------------------------------------
srcExXWAdB:
srcExXBCdB:
srcExXDEdB:
srcExXHLdB:
srcExXIXdB:
srcExXIYdB:
srcExXIZdB:
srcExXSPdB:
	and t9opCode,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]	;@ XRR
	ldrsb r0,[t9pc],#1
	t9eatcycles 2
	add t9Mem,t9Mem,r0
	b srcExB
;@----------------------------------------------------------------------------
srcEx8B:
	ldrb t9Mem,[t9pc],#1
	t9eatcycles 2
	b srcExB
;@----------------------------------------------------------------------------
srcEx16B:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	t9eatcycles 2
	orr t9Mem,t9Mem,r0,lsl#8
	b srcExB
;@----------------------------------------------------------------------------
srcEx24B:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	t9eatcycles 3
	orr t9Mem,t9Mem,r0,lsl#8
	orr t9Mem,t9Mem,r1,lsl#16
	b srcExB
;@----------------------------------------------------------------------------
srcExR32B:
	ldr lr,=srcExB
	b ExR32
;@----------------------------------------------------------------------------
srcExDecB:
	ldr lr,=srcExB
	b ExDec
;@----------------------------------------------------------------------------
srcExIncB:
	ldr lr,=srcExB
	b ExInc

;@----------------------------------------------------------------------------
srcExXRRW:
	and t9opCode,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]	;@ XRR
	b srcExW
;@----------------------------------------------------------------------------
srcExXRRdW:
	and t9opCode,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]	;@ XRR
	ldrsb r0,[t9pc],#1
	t9eatcycles 2
	add t9Mem,t9Mem,r0
	b srcExW
;@----------------------------------------------------------------------------
srcEx8W:
	ldrb t9Mem,[t9pc],#1
	t9eatcycles 2
	b srcExW
;@----------------------------------------------------------------------------
srcEx16W:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	t9eatcycles 2
	orr t9Mem,t9Mem,r0,lsl#8
	b srcExW
;@----------------------------------------------------------------------------
srcEx24W:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	t9eatcycles 3
	orr t9Mem,t9Mem,r0,lsl#8
	orr t9Mem,t9Mem,r1,lsl#16
	b srcExW
;@----------------------------------------------------------------------------
srcExR32W:
	ldr lr,=srcExW
	b ExR32
;@----------------------------------------------------------------------------
srcExDecW:
	ldr lr,=srcExW
	b ExDec
;@----------------------------------------------------------------------------
srcExIncW:
	ldr lr,=srcExW
	b ExInc
;@----------------------------------------------------------------------------

;@----------------------------------------------------------------------------
srcExXRRL:
	and t9opCode,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]	;@ XRR
	b srcExL
;@----------------------------------------------------------------------------
srcExXRRdL:
	and t9opCode,t9opCode,#0x07
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]	;@ XRR
	ldrsb r0,[t9pc],#1
	t9eatcycles 2
	add t9Mem,t9Mem,r0
	b srcExL
;@----------------------------------------------------------------------------
srcEx8L:
	ldrb t9Mem,[t9pc],#1
	t9eatcycles 2
	b srcExL
;@----------------------------------------------------------------------------
srcEx16L:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	t9eatcycles 2
	orr t9Mem,t9Mem,r0,lsl#8
	b srcExL
;@----------------------------------------------------------------------------
srcEx24L:
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	t9eatcycles 3
	orr t9Mem,t9Mem,r0,lsl#8
	orr t9Mem,t9Mem,r1,lsl#16
	b srcExL
;@----------------------------------------------------------------------------
srcExR32L:
	ldr lr,=srcExL
	b ExR32
;@----------------------------------------------------------------------------
srcExDecL:
	ldr lr,=srcExL
	b ExDec
;@----------------------------------------------------------------------------
srcExIncL:
	ldr lr,=srcExL
	b ExInc
;@----------------------------------------------------------------------------

	.pool
;@----------------------------------------------------------------------------
srcPUSHB:
;@----------------------------------------------------------------------------
	bl push8
	t9fetch 7
;@----------------------------------------------------------------------------
srcPUSHW:
;@----------------------------------------------------------------------------
	bl push16
	t9fetch 7
;@----------------------------------------------------------------------------
srcRLD:
;@----------------------------------------------------------------------------
	ldrb r2,[t9gprBank,#RegA]
	and r1,r2,#0xF0
	orr r0,r1,r0,ror#4
	strb r0,[t9gprBank,#RegA]
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
	ldrb r2,[t9gprBank,#RegA]
	and r1,r2,#0xF0
	mov r0,r0,ror#4
	orr r1,r1,r0,lsr#28
	strb r1,[t9gprBank,#RegA]
	orr r0,r0,r2,lsl#4
	add r2,t9ptr,#tlcsPzst
	ldrb r1,[r2,r1]				;@ Get PZS
	and t9f,t9f,#PSR_C			;@ Keep C
	orr t9f,t9f,r1
	and r0,r0,#0xFF
	bl t9StoreB_mem
	t9fetch 12

;@----------------------------------------------------------------------------
LDI_LDDret:
	ldrh r0,[t9gprBank,#RBC]
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#RBC]
	bic t9f,t9f,#PSR_H+PSR_P+PSR_n
	orrne t9f,t9f,#PSR_P
	t9fetch 10
;@----------------------------------------------------------------------------
srcLDIB:
srcLDDB:
;@----------------------------------------------------------------------------
	adr lr,LDI_LDDret
;@----------------------------------------------------------------------------
srcLDI_LDDdoB:
;@----------------------------------------------------------------------------
//	and t9opCode,t9opCode,#0x07
	and t9Reg,t9Reg,#0x02		;@ Increase/Decrease
	rsb t9Reg,t9Reg,#0x01
;@----------------------------------------------------------------------------
srcLDI_LDDB:
;@----------------------------------------------------------------------------
	add r1,t9Mem,t9Reg
	str r1,[t9gprBank,t9opCode,lsl#2]
	bic t9opCode,t9opCode,#1
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]
	add r1,t9Mem,t9Reg
	str r1,[t9gprBank,t9opCode,lsl#2]
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcLDIW:
srcLDDW:
;@----------------------------------------------------------------------------
	adr lr,LDI_LDDret
;@----------------------------------------------------------------------------
srcLDI_LDDdoW:
;@----------------------------------------------------------------------------
//	and t9opCode,t9opCode,#0x07
	and t9Reg,t9Reg,#0x02		;@ Increase/Decrease
	rsb t9Reg,t9Reg,#0x01
;@----------------------------------------------------------------------------
srcLDI_LDDW:
;@----------------------------------------------------------------------------
	add r1,t9Mem,t9Reg,lsl#1
	str r1,[t9gprBank,t9opCode,lsl#2]
	bic t9opCode,t9opCode,#1
	ldr t9Mem,[t9gprBank,t9opCode,lsl#2]
	add r1,t9Mem,t9Reg,lsl#1
	str r1,[t9gprBank,t9opCode,lsl#2]
	b t9StoreW_mem
;@----------------------------------------------------------------------------
srcLDIRB:
srcLDDRB:
;@----------------------------------------------------------------------------
	adr lr,LDIR_LDDRret
	b srcLDI_LDDdoB
;@----------------------------------------------------------------------------
srcLDIRW:
srcLDDRW:
;@----------------------------------------------------------------------------
	bl srcLDI_LDDdoW
LDIR_LDDRret:
	ldrh r0,[t9gprBank,#RBC]
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#RBC]
	bic t9f,t9f,#PSR_H+PSR_P+PSR_n
	orrne t9f,t9f,#PSR_P
	subne t9pc,t9pc,#2
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 10

;@----------------------------------------------------------------------------
CPI_CPDret:
	ldrh r0,[t9gprBank,#RBC]
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#RBC]
	orr t9f,t9f,#PSR_P+PSR_n
	biceq t9f,t9f,#PSR_P
	t9fetch 8
;@----------------------------------------------------------------------------
srcCPIB:
srcCPDB:
;@----------------------------------------------------------------------------
	adr lr,CPI_CPDret
;@----------------------------------------------------------------------------
srcCPI_CPDdoB:
;@----------------------------------------------------------------------------
//	and t9opCode,t9opCode,#0x07
	and t9Reg,t9Reg,#0x02				;@ Increase/Decrease
	rsb t9Reg,t9Reg,#0x01
;@----------------------------------------------------------------------------
srcCPI_CPDB:
;@----------------------------------------------------------------------------
	add r1,t9Mem,t9Reg
	str r1,[t9gprBank,t9opCode,lsl#2]
	mov r1,r0
	ldrb r0,[t9gprBank,#RegA]
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcCPIW:
srcCPDW:
;@----------------------------------------------------------------------------
	adr lr,CPI_CPDret
;@----------------------------------------------------------------------------
srcCPI_CPDdoW:
;@----------------------------------------------------------------------------
//	and t9opCode,t9opCode,#0x07
	and t9Reg,t9Reg,#0x02				;@ Increase/Decrease
	rsb t9Reg,t9Reg,#0x01
;@----------------------------------------------------------------------------
srcCPI_CPDW:
;@----------------------------------------------------------------------------
	add r1,t9Mem,t9Reg,lsl#1
	str r1,[t9gprBank,t9opCode,lsl#2]
	mov r1,r0
	ldrh r0,[t9gprBank,#RWA]
	b generic_SUB_W
;@----------------------------------------------------------------------------
srcCPIRB:
srcCPDRB:
;@----------------------------------------------------------------------------
	adr lr,CPIR_CPDRret
	b srcCPI_CPDdoB
;@----------------------------------------------------------------------------
srcCPIRW:
srcCPDRW:
;@----------------------------------------------------------------------------
	bl srcCPI_CPDdoW
CPIR_CPDRret:
	ldrh r0,[t9gprBank,#RBC]
	subs r0,r0,#0x0001
	strh r0,[t9gprBank,#RBC]
	orr t9f,t9f,#PSR_P+PSR_n
	biceq t9f,t9f,#PSR_P
	eor r0,t9f,#PSR_Z
	tstne r0,#PSR_Z
	subne t9pc,t9pc,#2
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 8

;@----------------------------------------------------------------------------
srcLD16mB:
;@----------------------------------------------------------------------------
	ldrb t9Mem,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr t9Mem,t9Mem,r2,lsl#8
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcLD16mW:
;@----------------------------------------------------------------------------
	ldrb t9Mem,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr t9Mem,t9Mem,r2,lsl#8
	adr lr,fetch8
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcLDB_W:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegW]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDB_A:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegA]
	t9fetchR 4
;@----------------------------------------------------------------------------
srcLDB_B:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegB]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDB_C:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegC]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDB_D:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegD]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDB_E:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegE]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDB_H:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegH]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDB_L:
;@----------------------------------------------------------------------------
	strb r0,[t9gprBank,#RegL]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
srcLDL:
;@----------------------------------------------------------------------------
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
srcEXB:						;@ Exchange
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	add t9Reg,t9gprBank,t9Reg,ror#30
	swpb r0,r0,[t9Reg]
	adr lr,fetch6
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcEXW:						;@ Exchange
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	strh r0,[t9gprBank,t9Reg]
	mov r0,r1
	adr lr,fetch6
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcADDiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_ADD_B
;@----------------------------------------------------------------------------
srcADDiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_ADD_W

;@----------------------------------------------------------------------------
srcADCiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_ADC_B
;@----------------------------------------------------------------------------
srcADCiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_ADC_W

;@----------------------------------------------------------------------------
srcSUBiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcSUBiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_SUB_W

;@----------------------------------------------------------------------------
srcSBCiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_SBC_B
;@----------------------------------------------------------------------------
srcSBCiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_SBC_W

;@----------------------------------------------------------------------------
srcANDiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_AND_B
;@----------------------------------------------------------------------------
srcANDiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_AND_W

;@----------------------------------------------------------------------------
srcXORiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	adr lr,strBFetch7
	b generic_XOR_B
;@----------------------------------------------------------------------------
srcXORiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_XOR_W

;@----------------------------------------------------------------------------
srcORiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	bl generic_OR_B
strBFetch7:
	bl t9StoreB_mem
	t9fetchR 7
;@----------------------------------------------------------------------------
srcORiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,strWFetch8
	b generic_OR_W

;@----------------------------------------------------------------------------
srcCPiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	adr lr,fetch6
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcCPiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	adr lr,fetch6
	b generic_SUB_W

;@----------------------------------------------------------------------------
srcMULB:					;@ Multiply
;@----------------------------------------------------------------------------
	and t9Reg,t9Reg,#0x06
	mov t9Reg,t9Reg,lsl#1
	ldrb r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
;@----------------------------------------------------------------------------
srcMULW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg]
	t9fetch 26

;@----------------------------------------------------------------------------
srcMULSB:
;@----------------------------------------------------------------------------
	and t9Reg,t9Reg,#0x06
	mov t9Reg,t9Reg,lsl#1
	mov r0,r0,lsl#24
	mov r0,r0,asr#24
	ldrsb r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
;@----------------------------------------------------------------------------
srcMULSW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	mov r0,r0,lsl#16
	mov r0,r0,asr#16
	ldrsh r1,[t9gprBank,t9Reg]
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg]
	t9fetch 26

;@----------------------------------------------------------------------------
srcDIVB:
;@----------------------------------------------------------------------------
	and t9Reg,t9Reg,#0x06
	mov t9Reg,t9Reg,lsl#1
	mov r1,r0
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 22
;@----------------------------------------------------------------------------
srcDIVW:
;@----------------------------------------------------------------------------
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 30

;@----------------------------------------------------------------------------
srcDIVSB:
;@----------------------------------------------------------------------------
	and t9Reg,t9Reg,#0x06
	mov t9Reg,t9Reg,lsl#1
	mov r1,r0,lsl#24
	mov r1,r1,asr#24
	ldrsh r0,[t9gprBank,t9Reg]
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 24
;@----------------------------------------------------------------------------
srcDIVSW:
;@----------------------------------------------------------------------------
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
srcINCB:					;@ Increment
;@----------------------------------------------------------------------------
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_INC_B
	adr lr,fetch6
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcINCW:					;@ Increment
;@----------------------------------------------------------------------------
	ands r1,t9Reg,#7
	moveq r1,#8

	mov r0,r0,lsl#16
	and t9f,t9f,#PSR_C			;@ Save carry & clear n
	mov r2,r0,lsl#12			;@ Prepare for H check
	adds r0,r0,r1,lsl#16
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	orrvs t9f,t9f,#PSR_V
	cmn r2,r1,lsl#28
	orrcs t9f,t9f,#PSR_H
	mov r0,r0,lsr#16

	bl t9StoreW_mem
fetch6:
	t9fetchR 6
;@----------------------------------------------------------------------------
srcDECB:					;@ Decrement
;@----------------------------------------------------------------------------
	ands r1,t9Reg,#7
	moveq r1,#8
	bl generic_DEC_B
	adr lr,fetch6
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcDECW:					;@ Decrement
;@----------------------------------------------------------------------------
	ands r1,t9Reg,#7
	moveq r1,#8

	mov r0,r0,lsl#16
	orr t9f,t9f,#PSR_n+PSR_H+PSR_S+PSR_V+PSR_Z	;@ Save carry & set n
	mov r2,r0,lsl#12			;@ Prepare for H check
	subs r0,r0,r1,lsl#16
	bicpl t9f,t9f,#PSR_S
	bicne t9f,t9f,#PSR_Z
	bicvc t9f,t9f,#PSR_V
	cmp r2,r1,lsl#28
	biccs t9f,t9f,#PSR_H
	mov r0,r0,lsr#16

	adr lr,fetch6
	b t9StoreW_mem

;@----------------------------------------------------------------------------
srcRLCB:
;@----------------------------------------------------------------------------
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
srcRRCB:
;@----------------------------------------------------------------------------
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
srcRLB:						;@ Rotate Left
;@----------------------------------------------------------------------------
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
srcRRB:						;@ Rotate Right
;@----------------------------------------------------------------------------
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
srcSLAB:					;@ Should this insert 1 into bit#0 like the Z80?
srcSLLB:					;@ Shift Left Logical
;@----------------------------------------------------------------------------
	movs r0,r0,lsl#25
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcSLAW:					;@ Should this insert 1 into bit#0 like the Z80?
srcSLLW:					;@ Shift Left Logical
;@----------------------------------------------------------------------------
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
srcSRAB:					;@ Shift Right Arithmetic
;@----------------------------------------------------------------------------
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
srcSRLB:					;@ Shift Right Logical
;@----------------------------------------------------------------------------
	movs r0,r0,lsr#1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	adr lr,fetch8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
srcSRLW:					;@ Shift Right Logical
;@----------------------------------------------------------------------------
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
srcADDRmB:
;@----------------------------------------------------------------------------
	adr lr,regBFetch4
	b generic_ADD_B_mem
;@----------------------------------------------------------------------------
srcADDRmW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	adr lr,regWFetch4
	b generic_ADD_W_reg
;@----------------------------------------------------------------------------
srcADDRmL:
;@----------------------------------------------------------------------------
	adr lr,regLFetch6
	b generic_ADD_L_reg

;@----------------------------------------------------------------------------
srcADDmRB:
;@----------------------------------------------------------------------------
	adr lr,strBFetch4
	b generic_ADD_B_mem
;@----------------------------------------------------------------------------
srcADDmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,strWFetch4
	b generic_ADD_W
;@----------------------------------------------------------------------------
srcADDmRL:
;@----------------------------------------------------------------------------
	adr lr,strLFetch6
	b generic_ADD_L_reg

;@----------------------------------------------------------------------------
srcADCRmB:
;@----------------------------------------------------------------------------
	adr lr,regBFetch4
	b generic_ADC_B_mem
;@----------------------------------------------------------------------------
srcADCRmW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	adr lr,regWFetch4
	b generic_ADC_W_reg
;@----------------------------------------------------------------------------
srcADCRmL:
;@----------------------------------------------------------------------------
	adr lr,regLFetch6
	b generic_ADC_L_reg

;@----------------------------------------------------------------------------
srcADCmRB:
;@----------------------------------------------------------------------------
	adr lr,strBFetch4
	b generic_ADC_B_mem
;@----------------------------------------------------------------------------
srcADCmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,strWFetch4
	b generic_ADC_W
;@----------------------------------------------------------------------------
srcADCmRL:
;@----------------------------------------------------------------------------
	adr lr,strLFetch6
	b generic_ADC_L_reg

;@----------------------------------------------------------------------------
srcSUBRmB:
;@----------------------------------------------------------------------------
	mov r1,r0
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	adr lr,regBFetch4
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcSUBRmW:
;@----------------------------------------------------------------------------
	mov r1,r0
	mov t9Reg,t9Reg,lsl#2
	ldrh r0,[t9gprBank,t9Reg]
	adr lr,regWFetch4
	b generic_SUB_W
;@----------------------------------------------------------------------------
srcSUBRmL:
;@----------------------------------------------------------------------------
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	adr lr,regLFetch6
	b generic_SUB_L

;@----------------------------------------------------------------------------
srcSUBmRB:
;@----------------------------------------------------------------------------
	adr lr,strBFetch4
	b generic_SUB_B_mem
;@----------------------------------------------------------------------------
srcSUBmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,strWFetch4
	b generic_SUB_W
;@----------------------------------------------------------------------------
srcSUBmRL:
;@----------------------------------------------------------------------------
	adr lr,strLFetch6
	b generic_SUB_L_reg

;@----------------------------------------------------------------------------
srcSBCRmB:
;@----------------------------------------------------------------------------
	mov r1,r0
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SBC_B
regBFetch4:
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetchR 4
;@----------------------------------------------------------------------------
srcSBCRmW:
;@----------------------------------------------------------------------------
	mov r1,r0
	mov t9Reg,t9Reg,lsl#2
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SBC_W
regWFetch4:
	strh r0,[t9gprBank,t9Reg]
	t9fetchR 4
;@----------------------------------------------------------------------------
srcSBCRmL:
;@----------------------------------------------------------------------------
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_L
regLFetch6:
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetchR 6

;@----------------------------------------------------------------------------
srcSBCmRB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	bl generic_SBC_B_reg
strBFetch4:
	bl t9StoreB_mem
fetch4:
	t9fetchR 4
;@----------------------------------------------------------------------------
srcSBCmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_W
strWFetch4:
	bl t9StoreW_mem
	t9fetchR 4
;@----------------------------------------------------------------------------
srcSBCmRL:
;@----------------------------------------------------------------------------
	bl generic_SBC_L_reg
strLFetch6:
	bl t9StoreL_mem
	t9fetchR 6

;@----------------------------------------------------------------------------
srcANDRmB:
;@----------------------------------------------------------------------------
	adr lr,regBFetch4
	b generic_AND_B_mem
;@----------------------------------------------------------------------------
srcANDRmW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	adr lr,regWFetch4
	b generic_AND_W_reg
;@----------------------------------------------------------------------------
srcANDRmL:
;@----------------------------------------------------------------------------
	adr lr,regLFetch6
	b generic_AND_L_reg

;@----------------------------------------------------------------------------
srcANDmRB:
;@----------------------------------------------------------------------------
	adr lr,strBFetch4
	b generic_AND_B_mem
;@----------------------------------------------------------------------------
srcANDmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,strWFetch4
	b generic_AND_W
;@----------------------------------------------------------------------------
srcANDmRL:
;@----------------------------------------------------------------------------
	adr lr,strLFetch6
	b generic_AND_L_reg

;@----------------------------------------------------------------------------
srcORRmB:
;@----------------------------------------------------------------------------
	adr lr,regBFetch4
	b generic_OR_B_mem
;@----------------------------------------------------------------------------
srcORRmW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	adr lr,regWFetch4
	b generic_OR_W_reg
;@----------------------------------------------------------------------------
srcORRmL:
;@----------------------------------------------------------------------------
	adr lr,regLFetch6
	b generic_OR_L_reg

;@----------------------------------------------------------------------------
srcORmRB:
;@----------------------------------------------------------------------------
	adr lr,strBFetch4
	b generic_OR_B_mem
;@----------------------------------------------------------------------------
srcORmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,strWFetch4
	b generic_OR_W
;@----------------------------------------------------------------------------
srcORmRL:
;@----------------------------------------------------------------------------
	adr lr,strLFetch6
	b generic_OR_L_reg

;@----------------------------------------------------------------------------
srcXORRmB:
;@----------------------------------------------------------------------------
	adr lr,regBFetch4
	b generic_XOR_B_mem
;@----------------------------------------------------------------------------
srcXORRmW:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	adr lr,regWFetch4
	b generic_XOR_W_reg
;@----------------------------------------------------------------------------
srcXORRmL:
;@----------------------------------------------------------------------------
	adr lr,regLFetch6
	b generic_XOR_L_reg

;@----------------------------------------------------------------------------
srcXORmRB:
;@----------------------------------------------------------------------------
	adr lr,strBFetch4
	b generic_XOR_B_mem
;@----------------------------------------------------------------------------
srcXORmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,strWFetch4
	b generic_XOR_W
;@----------------------------------------------------------------------------
srcXORmRL:
;@----------------------------------------------------------------------------
	adr lr,strLFetch6
	b generic_XOR_L_reg

;@----------------------------------------------------------------------------
srcCPRmB:
;@----------------------------------------------------------------------------
	mov r1,r0
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	adr lr,fetch4
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcCPRmW:
;@----------------------------------------------------------------------------
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	adr lr,fetch4
	b generic_SUB_W
;@----------------------------------------------------------------------------
srcCPRmL:
;@----------------------------------------------------------------------------
	mov r1,r0
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_L
	t9fetch 6

;@----------------------------------------------------------------------------
srcCPmRWB:
srcCPmRBB:
srcCPmRCB:
srcCPmRDB:
srcCPmREB:
srcCPmRHB:
srcCPmRLB:
;@----------------------------------------------------------------------------
	adr lr,fetch4
	b generic_SUB_B_mem
;@----------------------------------------------------------------------------
srcCPmRAB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	adr lr,fetch4
	b generic_SUB_B
;@----------------------------------------------------------------------------
srcCPmRW:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	adr lr,fetch4
	b generic_SUB_W
;@----------------------------------------------------------------------------
srcCPmRL:
;@----------------------------------------------------------------------------
	bl generic_SUB_L_reg
	t9fetch 6

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
