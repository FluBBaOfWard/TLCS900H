//
//  TLCS900H_reg.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2024 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "TLCS900H_mac.h"

	.global regB_W
	.global regB_A
	.global regB_B
	.global regB_C
	.global regB_D
	.global regB_E
	.global regB_H
	.global regB_L
	.global regWA
	.global regBC
	.global regDE
	.global regHL
	.global regIX
	.global regIY
	.global regIZ
	.global regSP
	.global reg_L
	.global regRCB
	.global regRCW
	.global regRCL

	.global regLDirB
	.global regPUSHB
	.global regPOPB
	.global regCPLB
	.global regNEGB
	.global regMULiB
	.global regMULSiB
	.global regDIViB
	.global regDIVSiB
	.global regDAA
	.global regDJNZB
	.global regANDCFiB
	.global regORCFiB
	.global regXORCFiB
	.global regLDCFiB
	.global regSTCFiB
	.global regANDCFAB
	.global regORCFAB
	.global regXORCFAB
	.global regLDCFAB
	.global regSTCFAB
	.global regLDCcrrB
	.global regLDCrcrB
	.global regRESB
	.global regSETB
	.global regCHGB
	.global regBITB
	.global regTSETB
	.global regMULB
	.global regMULSB
	.global regDIVB
	.global regDIVSB
	.global regINCB
	.global regDECB
	.global regSCCB
	.global regADDBW
	.global regADDBA
	.global regADDBB
	.global regADDBC
	.global regADDBD
	.global regADDBE
	.global regADDBH
	.global regADDBL
	.global regLDRrBW
	.global regLDRrBA
	.global regLDRrBB
	.global regLDRrBC
	.global regLDRrBD
	.global regLDRrBE
	.global regLDRrBH
	.global regLDRrBL
	.global regADCBW
	.global regADCBA
	.global regADCBB
	.global regADCBC
	.global regADCBD
	.global regADCBE
	.global regADCBH
	.global regADCBL
	.global regLDrRBW
	.global regLDrRBA
	.global regLDrRBB
	.global regLDrRBC
	.global regLDrRBD
	.global regLDrRBE
	.global regLDrRBH
	.global regLDrRBL
	.global regSUBRW
	.global regSUBRA
	.global regSUBRB
	.global regSUBRC
	.global regSUBRD
	.global regSUBRE
	.global regSUBRH
	.global regSUBRL
	.global regLDr3B
	.global regSBCBW
	.global regSBCBA
	.global regSBCBB
	.global regSBCBC
	.global regSBCBD
	.global regSBCBE
	.global regSBCBH
	.global regSBCBL
	.global regEXB
	.global regANDBW
	.global regANDBA
	.global regANDBB
	.global regANDBC
	.global regANDBD
	.global regANDBE
	.global regANDBH
	.global regANDBL
	.global regADDiB
	.global regADCiB
	.global regSUBiB
	.global regSBCiB
	.global regANDiB
	.global regXORiB
	.global regORiB
	.global regCPiB
	.global regXORBW
	.global regXORBA
	.global regXORBB
	.global regXORBC
	.global regXORBD
	.global regXORBE
	.global regXORBH
	.global regXORBL
	.global regCPr3B
	.global regORBW
	.global regORBA
	.global regORBB
	.global regORBC
	.global regORBD
	.global regORBE
	.global regORBH
	.global regORBL
	.global regRLCiB
	.global regRRCiB
	.global regRLiB
	.global regRRiB
	.global regSLAiB
	.global regSRAiB
	.global regSLLiB
	.global regSRLiB
	.global regCPBW
	.global regCPBA
	.global regCPBB
	.global regCPBC
	.global regCPBD
	.global regCPBE
	.global regCPBH
	.global regCPBL
	.global regRLCAB
	.global regRRCAB
	.global regRLAB
	.global regRRAB
	.global regSLAAB
	.global regSRAAB
	.global regSLLAB
	.global regSRLAB


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
regRCB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r1,[t9ptr,#tlcsCurrentMapBank]
	t9eatcycles 1
	ldrsb t9Reg,[r1,r0]
	mov t9Reg,t9Reg,ror#2
	ldrb r0,[t9pc],#1
	add r1,t9ptr,#tlcsRegOpCodesB
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
regB_W:
regB_B:
regB_C:
regB_D:
regB_E:
regB_H:
regB_L:
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9pc],#1
	add r1,t9ptr,#tlcsRegOpCodesB
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
regB_A:
;@----------------------------------------------------------------------------
	mov t9Reg,#0x00000000
	ldrb r0,[t9pc],#1
	add r1,t9ptr,#tlcsRegOpCodesB
	ldr pc,[r1,r0,lsl#2]

;@----------------------------------------------------------------------------
regRCW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r1,[t9ptr,#tlcsCurrentMapBank]
	bic r0,r0,#1
	ldrsb t9Reg,[r1,r0]
	t9eatcycles 1
	ldrb r0,[t9pc],#1
	adr r1,regOpCodesW
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
regWA:
regBC:
regDE:
regHL:
regIX:
regIY:
regIZ:
regSP:
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	mov t9Reg,t9Reg,lsl#2
	ldrb r0,[t9pc],#1
	ldr pc,[pc,r0,lsl#2]
	.long 0
regOpCodesW:
;@ 0x00
	.long regError,	regError,	regError,	regLDiW,	regPUSHW,	regPOPW,	regCPLW,	regNEGW
	.long regMULiW,	regMULSiW,	regDIViW,	regDIVSiW,	regError,	regError,	regBS1F,	regBS1B
;@ 0x10
	.long regError,	regError,	regEXTZW,	regEXTSW,	regPAAW,	regError,	regMIRR,	regError
	.long regError,	regMULA,	regError,	regError,	regDJNZW,	regError,	regError,	regError
;@ 0x20
	.long regANDCFiW,regORCFiW,	regXORCFiW,	regLDCFiW,	regSTCFiW,	regError,	regError,	regError
	.long regANDCFAW,regORCFAW,	regXORCFAW,	regLDCFAW,	regSTCFAW,	regError,	regLDCcrrW,	regLDCrcrW
;@ 0x30
	.long regRESW,	regSETW,	regCHGW,	regBITW,	regTSETW,	regError,	regError,	regError
	.long regMINC1,	regMINC2,	regMINC4,	regError,	regMDEC1,	regMDEC2,	regMDEC4,	regError
;@ 0x40
	.long regMULW,	regMULW,	regMULW,	regMULW,	regMULW,	regMULW,	regMULW,	regMULW
	.long regMULSW,	regMULSW,	regMULSW,	regMULSW,	regMULSW,	regMULSW,	regMULSW,	regMULSW
;@ 0x50
	.long regDIVW,	regDIVW,	regDIVW,	regDIVW,	regDIVW,	regDIVW,	regDIVW,	regDIVW
	.long regDIVSW,	regDIVSW,	regDIVSW,	regDIVSW,	regDIVSW,	regDIVSW,	regDIVSW,	regDIVSW
;@ 0x60
	.long regINCW,	regINCW,	regINCW,	regINCW,	regINCW,	regINCW,	regINCW,	regINCW
	.long regDECW,	regDECW,	regDECW,	regDECW,	regDECW,	regDECW,	regDECW,	regDECW
;@ 0x70
	.long regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW
	.long regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW,	regSCCW
;@ 0x80
	.long regADDW,	regADDW,	regADDW,	regADDW,	regADDW,	regADDW,	regADDW,	regADDW
	.long regLDRrW,	regLDRrW,	regLDRrW,	regLDRrW,	regLDRrW,	regLDRrW,	regLDRrW,	regLDRrW
;@ 0x90
	.long regADCW,	regADCW,	regADCW,	regADCW,	regADCW,	regADCW,	regADCW,	regADCW
	.long regLDrRW,	regLDrRW,	regLDrRW,	regLDrRW,	regLDrRW,	regLDrRW,	regLDrRW,	regLDrRW
;@ 0xA0
	.long regSUBWA,	regSUBBC,	regSUBDE,	regSUBHL,	regSUBIX,	regSUBIY,	regSUBIZ,	regSUBSP
	.long regLDr3W,	regLDr3W,	regLDr3W,	regLDr3W,	regLDr3W,	regLDr3W,	regLDr3W,	regLDr3W
;@ 0xB0
	.long regSBCW,	regSBCW,	regSBCW,	regSBCW,	regSBCW,	regSBCW,	regSBCW,	regSBCW
	.long regEXW,	regEXW,		regEXW,		regEXW,		regEXW,		regEXW,		regEXW,		regEXW
;@ 0xC0
	.long regANDW,	regANDW,	regANDW,	regANDW,	regANDW,	regANDW,	regANDW,	regANDW
	.long regADDiW,	regADCiW,	regSUBiW,	regSBCiW,	regANDiW,	regXORiW,	regORiW,	regCPiW
;@ 0xD0
	.long regXORW,	regXORW,	regXORW,	regXORW,	regXORW,	regXORW,	regXORW,	regXORW
	.long regCPr3W,	regCPr3W,	regCPr3W,	regCPr3W,	regCPr3W,	regCPr3W,	regCPr3W,	regCPr3W
;@ 0xE0
	.long regORW,	regORW,		regORW,		regORW,		regORW,		regORW,		regORW,		regORW
	.long regRLCiW,	regRRCiW,	regRLiW,	regRRiW,	regSLAiW,	regSRAiW,	regSLLiW,	regSRLiW
;@ 0xF0
	.long regCPW,	regCPW,		regCPW,		regCPW,		regCPW,		regCPW,		regCPW,		regCPW
	.long regRLCAW,	regRRCAW,	regRLAW,	regRRAW,	regSLAAW,	regSRAAW,	regSLLAW,	regSRLAW

;@----------------------------------------------------------------------------
regRCL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r1,[t9ptr,#tlcsCurrentMapBank]
	t9eatcycles 1
	ldrsb t9Reg,[r1,r0]
	ldrb r0,[t9pc],#1
	mov t9Reg,t9Reg,asr#2
	adr r1,regOpCodesL
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
reg_L:
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	ldrb r0,[t9pc],#1
	ldr pc,[pc,r0,lsl#2]
	.long 0
regOpCodesL:
;@ 0x00
	.long regError,	regError,	regError,	regLDiL,	regPUSHL,	regPOPL,	regError,	regError
	.long regError,	regError,	regError,	regError,	regLINK,	regUNLK,	regError,	regError
;@ 0x10
	.long regError,	regError,	regEXTZL,	regEXTSL,	regPAAL,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
;@ 0x20
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regError,	regError,	regLDCcrrL,	regLDCrcrL
;@ 0x30
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
;@ 0x40
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
;@ 0x50
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
;@ 0x60
	.long regINCL,	regINCL,	regINCL,	regINCL,	regINCL,	regINCL,	regINCL,	regINCL
	.long regDECL,	regDECL,	regDECL,	regDECL,	regDECL,	regDECL,	regDECL,	regDECL
;@ 0x70
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
;@ 0x80
	.long regADDL,	regADDL,	regADDL,	regADDL,	regADDL,	regADDL,	regADDL,	regADDL
	.long regLDRrL,	regLDRrL,	regLDRrL,	regLDRrL,	regLDRrL,	regLDRrL,	regLDRrL,	regLDRrL
;@ 0x90
	.long regADCL,	regADCL,	regADCL,	regADCL,	regADCL,	regADCL,	regADCL,	regADCL
	.long regLDrRL,	regLDrRL,	regLDrRL,	regLDrRL,	regLDrRL,	regLDrRL,	regLDrRL,	regLDrRL
;@ 0xA0
	.long regSUBL,	regSUBL,	regSUBL,	regSUBL,	regSUBL,	regSUBL,	regSUBL,	regSUBL
	.long regLDr3L,	regLDr3L,	regLDr3L,	regLDr3L,	regLDr3L,	regLDr3L,	regLDr3L,	regLDr3L
;@ 0xB0
	.long regSBCL,	regSBCL,	regSBCL,	regSBCL,	regSBCL,	regSBCL,	regSBCL,	regSBCL
	.long regEXL,	regEXL,		regEXL,		regEXL,		regEXL,		regEXL,		regEXL,		regEXL
;@ 0xC0
	.long regANDL,	regANDL,	regANDL,	regANDL,	regANDL,	regANDL,	regANDL,	regANDL
	.long regADDiL,	regADCiL,	regSUBiL,	regSBCiL,	regANDiL,	regXORiL,	regORiL,	regCPiL
;@ 0xD0
	.long regXORL,	regXORL,	regXORL,	regXORL,	regXORL,	regXORL,	regXORL,	regXORL
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
;@ 0xE0
	.long regORL,	regORL,		regORL,		regORL,		regORL,		regORL,		regORL,		regORL
	.long regRLCiL,	regRRCiL,	regRLiL,	regRRiL,	regSLAiL,	regSRAiL,	regSLLiL,	regSRLiL
;@ 0xF0
	.long regCP_L,	regCP_L,	regCP_L,	regCP_L,	regCP_L,	regCP_L,	regCP_L,	regCP_L
	.long regRLCAL,	regRRCAL,	regRLAL,	regRRAL,	regSLAAL,	regSRAAL,	regSLLAL,	regSRLAL

;@----------------------------------------------------------------------------
regLDirB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDiW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDiL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#16
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#24
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6

;@----------------------------------------------------------------------------
regPUSHB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl push8
	t9fetch 5
;@----------------------------------------------------------------------------
regPUSHW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	bl push16
	t9fetch 5
;@----------------------------------------------------------------------------
regPUSHL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl push32
	t9fetch 7

;@----------------------------------------------------------------------------
regPOPB:
;@----------------------------------------------------------------------------
	bl pop8
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 5
;@----------------------------------------------------------------------------
regPOPW:
;@----------------------------------------------------------------------------
	bl pop16
	strh r0,[t9gprBank,t9Reg]
	t9fetch 5
;@----------------------------------------------------------------------------
regPOPL:
;@----------------------------------------------------------------------------
	bl pop32
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regCPLB:					;@ Complement
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mvn r0,r0
	strb r0,[t9gprBank,t9Reg,ror#30]
	orr t9f,t9f,#PSR_H|PSR_n
	t9fetch 4
;@----------------------------------------------------------------------------
regCPLW:					;@ Complement
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mvn r0,r0
	strh r0,[t9gprBank,t9Reg]
	orr t9f,t9f,#PSR_H|PSR_n
	t9fetch 4

;@----------------------------------------------------------------------------
regNEGB:					;@ Negate
;@----------------------------------------------------------------------------
	mov r0,#0
	bl generic_SUB_B_reg
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regNEGW:					;@ Negate
;@----------------------------------------------------------------------------
	mov r0,#0
	bl generic_SUB_W_reg
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regMULiB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsl#2
	bcs unknown_RR_Target
	ldrb r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
;@----------------------------------------------------------------------------
regMULiW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg]
	t9fetch 26

;@----------------------------------------------------------------------------
regMULSiB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsl#2
	bcs unknown_RR_Target
	ldrsb r0,[t9gprBank,t9Reg]
	ldrsb r1,[t9pc],#1
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
;@----------------------------------------------------------------------------
regMULSiW:
;@----------------------------------------------------------------------------
	ldrsh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrsb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg]
	t9fetch 26

;@----------------------------------------------------------------------------
regDIViB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsl#2
	bcs unknown_RR_Target
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
;@----------------------------------------------------------------------------
regDIViW:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg]
	t9fetch 26

;@----------------------------------------------------------------------------
regDIVSiB:
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsl#2
	bcs unknown_RR_Target
	ldrsh r0,[t9gprBank,t9Reg]
	ldrsb r1,[t9pc],#1
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg]
	t9fetch 18
;@----------------------------------------------------------------------------
regDIVSiW:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrsb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg]
	t9fetch 26

;@----------------------------------------------------------------------------
regLINK:					;@ Link
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl push32
	ldr r0,[t9gprBank,#RXSP]
	str r0,[t9gprBank,t9Reg,lsl#2]
	ldrb r1,[t9pc],#1
	ldrsb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	add r0,r0,r1
	str r0,[t9gprBank,#RXSP]
	t9fetch 10

;@----------------------------------------------------------------------------
regUNLK:					;@ Unlink
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	str r0,[t9gprBank,#RXSP]
	bl pop32
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regBS1F:					;@ Bit Search 1 Forward
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	bic t9f,t9f,#PSR_V
	mov r1,#0
bs1fLoop:
	movs r0,r0,lsr#1
	bcs bs1fEnd
	add r1,r1,#1
	bne bs1fLoop
	orr t9f,t9f,#PSR_V			;@ Bit not found
bs1fEnd:
	strb r1,[t9gprBank,#RegA]
	t9fetch 4
;@----------------------------------------------------------------------------
regBS1B:					;@ Bit Search 1 Backward
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	bic t9f,t9f,#PSR_V
;@ Lookup the bit index using a 16-bit Debruijn sequence.
	mov r1,#0x09<<24
	orr r1,#0xAF<<16
	muls r0,r1,r0
	orreq t9f,t9f,#PSR_V
	mov r0,r0,lsr#28
	strb r0,[t9gprBank,#RegA]
	t9fetch 4

;@----------------------------------------------------------------------------
regDAA:						;@ Decimal Adjust Accumulator
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,r0,lsl#24

	mov r0,#0x60000000

	adds r1,r0,r2,ror#28		;@ Check low nybble and save top nybble for H check
	tstcc t9f,t9f,lsr#5			;@ PSR_H to carry.
	orrcs r0,r0,#0x06000000

	cmn r2,#0x66000000
	tstcc t9f,t9f,lsr#2			;@ PSR_C to carry.
	biccc r0,r0,#0x60000000

	and t9f,t9f,#PSR_n|PSR_C	;@ Mask out flags.
	tst t9f,#PSR_n				;@ Check if last instruction was add or sub.

	beq itWasAdd
	subs r2,r2,r0
	orrcc t9f,t9f,#PSR_C
	b carryDone
itWasAdd:
	adds r2,r2,r0
	orrcs t9f,t9f,#PSR_C
carryDone:
	add r0,t9ptr,#tlcsPzst
	ldrb r0,[r0,r2,lsr#24]		;@ Get PZS
	orr t9f,t9f,r0
	eor r1,r1,r2,ror#28
	tst r1,#0x1
	orrne t9f,t9f,#PSR_H

	mov r0,r2,lsr#24
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6

;@----------------------------------------------------------------------------
regEXTZW:					;@ Extend Zero
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg]
	strh r1,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regEXTZL:					;@ Extend Zero
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	str r1,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regEXTSW:					;@ Extend Sign
;@----------------------------------------------------------------------------
	ldrsb r0,[t9gprBank,t9Reg]
	strh r0,[t9gprBank,t9Reg]
	t9fetch 5
;@----------------------------------------------------------------------------
regEXTSL:					;@ Extend Sign
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	ldrsh r0,[t9gprBank,t9Reg]
	str r0,[t9gprBank,t9Reg]
	t9fetch 5

;@----------------------------------------------------------------------------
regPAAW:					;@ Pointer Adjustment Accumulator
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	and r1,r0,#1
	add r0,r0,r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regPAAL:					;@ Pointer Adjustment Accumulator
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and r1,r0,#1
	add r0,r0,r1
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 4

;@----------------------------------------------------------------------------
regMIRR:					;@ Mirror
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#16
mirrLoop:
	movs r0,r0,lsr#1
	adc r1,r1,r1
	subs r2,r2,#1
	bne mirrLoop
	strh r1,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regMULA:					;@ Multiply and Add
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#RXDE]
	bl t9LoadW
	mov t9Reg2,r0,lsl#16
	mov t9Reg2,t9Reg2,asr#16
	ldr r0,[t9gprBank,#RXHL]
	sub r1,r0,#2
	str r1,[t9gprBank,#RXHL]
	bl t9LoadW
	mov r0,r0,lsl#16
	mov r0,r0,asr#16
	mul r1,t9Reg2,r0
	ldr r0,[t9gprBank,t9Reg]
	bic t9f,t9f,#PSR_S+PSR_Z+PSR_V
	adds r0,r0,r1
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	orrvs t9f,t9f,#PSR_V

	str r0,[t9gprBank,t9Reg]
	t9fetch 31

;@----------------------------------------------------------------------------
regDJNZB:					;@ Decrement and Jump if Non Zero
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	subs r0,r0,#1
	strb r0,[t9gprBank,t9Reg,ror#30]
	ldrsb r1,[t9pc],#1
	addne t9pc,t9pc,r1
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetchR 7
;@----------------------------------------------------------------------------
regDJNZW:					;@ Decrement and Jump if Non Zero
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	subs r0,r0,#1
	strh r0,[t9gprBank,t9Reg]
	ldrsb r1,[t9pc],#1
	addne t9pc,t9pc,r1
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetchR 7

;@----------------------------------------------------------------------------
regANDCFiB:					;@ And Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
//	tst r1,#0x08				;@ Undefined
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regANDCFiW:					;@ And Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regLDCFiB:					;@ Load Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_C
;@----------------------------------------------------------------------------
regORCFiB:					;@ Or Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
//	tst r1,#0x08				;@ Undefined
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regLDCFiW:					;@ Load Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_C
;@----------------------------------------------------------------------------
regORCFiW:					;@ Or Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regXORCFiB:					;@ Xor Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
//	tst r1,#0x08				;@ Undefined
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regXORCFiW:					;@ Xor Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regSTCFiB:					;@ Store Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
	and r1,r1,#0x0F
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl r1
	orrne r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regSTCFiW:					;@ Store Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl r1
	orrne r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regANDCFAB:					;@ And Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
//	tst r1,#0x08				;@ Undefined
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regANDCFAW:					;@ And Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regLDCFAB:					;@ Load Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_C
;@----------------------------------------------------------------------------
regORCFAB:					;@ Or Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
//	tst r1,#0x08				;@ Undefined
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regLDCFAW:					;@ Load Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_C
;@----------------------------------------------------------------------------
regORCFAW:					;@ Or Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regXORCFAB:					;@ Xor Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
//	tst r1,#0x08				;@ Undefined
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regXORCFAW:					;@ Xor Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regSTCFAB:					;@ Store Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
	and r1,r1,#0x0F
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl r1
	orrne r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regSTCFAW:					;@ Store Carry Flag
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,#RegA]
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl r1
	orrne r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
;@ Should this also include interrupt nesting counter? (0x7C on TLCS-900/H1, has 8 DMA channels.)
;@----------------------------------------------------------------------------
regLDCcrrB:					;@ Load Control Register cr, r
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	tst r0,#0xD1				;@ Allow 0x22, 0x26, 0x2A & 0x2E
	addeq r2,t9ptr,#tlcsDmaS
	strbeq r1,[r2,r0]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCcrrW:					;@ Load Control Register cr, r
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	ldrh r1,[t9gprBank,t9Reg]
	tst r0,#0xD3				;@ Allow 0x20, 0x24, 0x28 & 0x2C
	addeq r2,t9ptr,#tlcsDmaS
	strheq r1,[r2,r0]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCcrrL:					;@ Load Control Register cr, r
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	tst r0,#0xE3				;@ Only allow 0x00, 0x04, 0x08, 0x0C, 0x10, 0x14, 0x18 & 0x1C
	addeq r2,t9ptr,#tlcsDmaS
	streq r1,[r2,r0]
	t9fetch 8

;@----------------------------------------------------------------------------
regLDCrcrB:					;@ Load Control Register r, cr
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	tst r0,#0xD1				;@ Only allow 0x22, 0x26, 0x2A & 0x2E
	addeq r2,t9ptr,#tlcsDmaS
	ldrbeq r0,[r2,r0]
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCrcrW:					;@ Load Control Register r, cr
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	tst r0,#0xD3				;@ Only allow 0x20, 0x24, 0x28 & 0x2C
	addeq r2,t9ptr,#tlcsDmaS
	ldrheq r0,[r2,r0]
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCrcrL:					;@ Load Control Register r, cr
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	tst r0,#0xE3				;@ Allow 0x00, 0x04, 0x08, 0x0C, 0x10, 0x14, 0x18 & 0x1C
	addeq r2,t9ptr,#tlcsDmaS
	ldreq r0,[r2,r0]
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regRESB:					;@ Reset Bit
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
	and r1,r1,#0x0F
	bic r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regRESW:					;@ Reset Bit
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	bic r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regSETB:					;@ Set Bit
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
	and r1,r1,#0x0F
	orr r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regSETW:					;@ Set Bit
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	orr r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regCHGB:					;@ Change Bit
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
	and r1,r1,#0x0F
	eor r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regCHGW:					;@ Change Bit
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	eor r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regBITB:					;@ Bit Test
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
	and r1,r1,#0x0F
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	t9fetch 4
;@----------------------------------------------------------------------------
regBITW:					;@ Bit Test
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	t9fetch 4

;@----------------------------------------------------------------------------
regTSETB:					;@ Test and Set
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r2,#1
	and r1,r1,#0x0F
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	orr r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regTSETW:					;@ Test and Set
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrh r0,[t9gprBank,t9Reg]
	mov r2,#1
	and r1,r1,#0x0F
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	orr r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regMINC1:					;@ 0x38 Modulo Increment 1
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	add r2,r0,#1
	and r2,r2,r1
	bic r0,r0,r1
	orr r0,r0,r2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8
;@----------------------------------------------------------------------------
regMINC2:					;@ 0x39 Modulo Increment 2
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	add r2,r0,#2
	and r2,r2,r1
	bic r0,r0,r1
	orr r0,r0,r2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8
;@----------------------------------------------------------------------------
regMINC4:					;@ 0x3A Modulo Increment 4
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	add r2,r0,#4
	and r2,r2,r1
	bic r0,r0,r1
	orr r0,r0,r2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8

;@----------------------------------------------------------------------------
regMDEC1:					;@ 0x3C Modulo Decrement 1
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	sub r2,r0,#1
	and r2,r2,r1
	bic r0,r0,r1
	orr r0,r0,r2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8
;@----------------------------------------------------------------------------
regMDEC2:					;@ 0x3D Modulo Decrement 2
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	sub r2,r0,#2
	and r2,r2,r1
	bic r0,r0,r1
	orr r0,r0,r2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8
;@----------------------------------------------------------------------------
regMDEC4:					;@ 0x3E Modulo Decrement 4
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	sub r2,r0,#4
	and r2,r2,r1
	bic r0,r0,r1
	orr r0,r0,r2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8

;@----------------------------------------------------------------------------
regMULB:					;@ Multiply
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x06			;@ From Second
	mov t9Reg2,t9Reg2,lsl#1
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	ldrb r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regMULW:					;@ Multiply
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	ldrh r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regMULSB:					;@ Multiply Signed
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x06			;@ From Second
	mov t9Reg,t9Reg,ror#30
	mov t9Reg2,t9Reg2,lsl#1
	ldrsb r1,[t9gprBank,t9Reg]
	ldrsb r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regMULSW:					;@ Multiply Signed
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrsh r1,[t9gprBank,t9Reg]
	ldrsh r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regDIVB:					;@ Division
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x06			;@ From Second
	mov t9Reg2,t9Reg2,lsl#1
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	ldrh r0,[t9gprBank,t9Reg2]	;@ reg R
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regDIVW:					;@ Division
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regDIVSB:					;@ Division Signed
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x06			;@ From Second
	mov t9Reg,t9Reg,ror#30
	mov t9Reg2,t9Reg2,lsl#1
	ldrsb r1,[t9gprBank,t9Reg]
	ldrsh r0,[t9gprBank,t9Reg2]	;@ reg R
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regDIVSW:					;@ Division Signed
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrsh r1,[t9gprBank,t9Reg]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regINCB:					;@ Increment
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	moveq r1,#0x08
	bl generic_INC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regINCW:					;@ Increment
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	ldrh r0,[t9gprBank,t9Reg]
	moveq r1,#0x08
	add r0,r0,r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regINCL:					;@ Increment
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	moveq r1,#0x08
	add r0,r0,r1
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 5

;@----------------------------------------------------------------------------
regDECB:					;@ Decrement
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	moveq r1,#0x08
	bl generic_DEC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regDECW:					;@ Decrement
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	ldrh r0,[t9gprBank,t9Reg]
	moveq r1,#0x08
	sub r0,r0,r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regDECL:					;@ Decrement
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	moveq r1,#0x08
	sub r0,r0,r1
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 5

;@----------------------------------------------------------------------------
regSCCB:					;@ Set Condition Code
;@----------------------------------------------------------------------------
	bl conditionCode
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regSCCW:					;@ Set Condition Code
;@----------------------------------------------------------------------------
	bl conditionCode
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6

;@----------------------------------------------------------------------------
regLDRrBW:
regLDRrBB:
regLDRrBC:
regLDRrBD:
regLDRrBE:
regLDRrBH:
regLDRrBL:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	and t9Reg2,r0,#0x07			;@ From Second
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	strb r1,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regLDRrBA:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	strb r0,[t9gprBank,#RegA]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDRrW:
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	strh r1,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regLDRrL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	and t9Reg2,r0,#0x07			;@ From Second
	str r1,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 4

;@----------------------------------------------------------------------------
regLDrRBW:
regLDrRBB:
regLDrRBC:
regLDrRBD:
regLDrRBE:
regLDrRBH:
regLDrRBL:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDrRBA:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDrRW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDrRL:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 4

;@----------------------------------------------------------------------------
regADDBW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	adr lr,strBWFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDBA:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	adr lr,strBAFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDBB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	adr lr,strBBFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDBC:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	adr lr,strBCFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDBD:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	adr lr,strBDFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDBE:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	adr lr,strBEFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDBH:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	adr lr,strBHFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDBL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	adr lr,strBLFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_ADD_W_reg
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regADDL:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_ADD_L_reg
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regADCBW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	adr lr,strBWFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCBA:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	adr lr,strBAFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCBB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	adr lr,strBBFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCBC:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	adr lr,strBCFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCBD:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	adr lr,strBDFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCBE:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	adr lr,strBEFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCBH:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	adr lr,strBHFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCBL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	adr lr,strBLFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_ADC_W_reg
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regADCL:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_ADC_L_reg
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regSUBRW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	adr lr,strBWFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBRA:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	adr lr,strBAFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBRB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	adr lr,strBBFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBRC:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	adr lr,strBCFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBRD:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	adr lr,strBDFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBRE:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	adr lr,strBEFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBRH:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	adr lr,strBHFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBRL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	adr lr,strBLFetch4
	b generic_SUB_B_reg
;@----------------------------------------------------------------------------
regSUBWA:
regSUBDE:
regSUBHL:
regSUBIX:
regSUBIY:
regSUBIZ:
regSUBSP:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_SUB_W_reg
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regSUBBC:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,#RBC]
	bl generic_SUB_W_reg
	strh r0,[t9gprBank,#RBC]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSUBL:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SUB_L_reg
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regSBCBW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	bl generic_SBC_B_reg
strBWFetch4:
	strb r0,[t9gprBank,#RegW]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCBA:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	bl generic_SBC_B_reg
strBAFetch4:
	strb r0,[t9gprBank,#RegA]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCBB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	bl generic_SBC_B_reg
strBBFetch4:
	strb r0,[t9gprBank,#RegB]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCBC:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	bl generic_SBC_B_reg
strBCFetch4:
	strb r0,[t9gprBank,#RegC]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCBD:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	bl generic_SBC_B_reg
strBDFetch4:
	strb r0,[t9gprBank,#RegD]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCBE:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	bl generic_SBC_B_reg
strBEFetch4:
	strb r0,[t9gprBank,#RegE]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCBH:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	bl generic_SBC_B_reg
strBHFetch4:
	strb r0,[t9gprBank,#RegH]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCBL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	bl generic_SBC_B_reg
strBLFetch4:
	strb r0,[t9gprBank,#RegL]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_SBC_W_reg
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regSBCL:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SBC_L_reg
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regANDBW:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	adr lr,strBWFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDBA:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	adr lr,strBAFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDBB:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	adr lr,strBBFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDBC:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	adr lr,strBCFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDBD:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	adr lr,strBDFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDBE:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	adr lr,strBEFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDBH:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	adr lr,strBHFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDBL:					;@ And
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	adr lr,strBLFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDW:					;@ And
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_AND_W_reg
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regANDL:					;@ And
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_AND_L_reg
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regORBW:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	adr lr,strBWFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORBA:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	adr lr,strBAFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORBB:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	adr lr,strBBFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORBC:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	adr lr,strBCFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORBD:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	adr lr,strBDFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORBE:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	adr lr,strBEFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORBH:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	adr lr,strBHFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORBL:					;@ Logical OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	adr lr,strBLFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORW:						;@ Logical OR
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_OR_W_reg
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regORL:						;@ Logical OR
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_OR_L_reg
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regXORBW:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	adr lr,strBWFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORBA:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	adr lr,strBAFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORBB:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	adr lr,strBBFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORBC:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	adr lr,strBCFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORBD:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	adr lr,strBDFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORBE:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	adr lr,strBEFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORBH:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	adr lr,strBHFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORBL:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	adr lr,strBLFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORW:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_XOR_W_reg
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regXORL:					;@ Exclusive OR
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_XOR_L_reg
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regLDr3B:
;@----------------------------------------------------------------------------
	and r0,r0,#0x07				;@ From Second
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDr3W:
;@----------------------------------------------------------------------------
	and r0,r0,#0x07				;@ From Second
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regLDr3L:
;@----------------------------------------------------------------------------
	and r0,r0,#0x07				;@ From Second
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 4

;@----------------------------------------------------------------------------
regEXB:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	movs t9Reg2,t9Reg2,lsr#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r1,[t9gprBank,t9Reg2,ror#30];@ Reg R
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	strb r1,[t9gprBank,t9Reg,ror#30]
	t9fetch 5
;@----------------------------------------------------------------------------
regEXW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r0,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r1,[t9gprBank,t9Reg2]	;@ Reg R
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	strh r1,[t9gprBank,t9Reg]
	t9fetch 5
;@----------------------------------------------------------------------------
regEXL:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	ldr r1,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	str r1,[t9gprBank,t9Reg,lsl#2]
	t9fetch 5

;@----------------------------------------------------------------------------
regADDiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	adr lr,setRegBFetch4
	b generic_ADD_B_reg
;@----------------------------------------------------------------------------
regADDiW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	adr lr,setRegWFetch4
	b generic_ADD_W_reg
;@----------------------------------------------------------------------------
regADDiL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#16
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#24
	adr lr,setRegLFetch7
	b generic_ADD_L_reg

;@----------------------------------------------------------------------------
regADCiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	adr lr,setRegBFetch4
	b generic_ADC_B_reg
;@----------------------------------------------------------------------------
regADCiW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	adr lr,setRegWFetch4
	b generic_ADC_W_reg
;@----------------------------------------------------------------------------
regADCiL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#16
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#24
	adr lr,setRegLFetch7
	b generic_ADC_L_reg

;@----------------------------------------------------------------------------
regSUBiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	adr lr,setRegBFetch4
	b generic_SUB_B
;@----------------------------------------------------------------------------
regSUBiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	adr lr,setRegWFetch4
	b generic_SUB_W
;@----------------------------------------------------------------------------
regSUBiL:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	adr lr,setRegLFetch7
	b generic_SUB_L

;@----------------------------------------------------------------------------
regSBCiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SBC_B
setRegBFetch4:
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SBC_W
setRegWFetch4:
	strh r0,[t9gprBank,t9Reg]
	t9fetchR 4
;@----------------------------------------------------------------------------
regSBCiL:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_L
setRegLFetch7:
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetchR 7

;@----------------------------------------------------------------------------
regCPiB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	t9fetch 4
;@----------------------------------------------------------------------------
regCPiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SUB_W
	t9fetch 4
;@----------------------------------------------------------------------------
regCPiL:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_L
	t9fetch 7

;@----------------------------------------------------------------------------
regANDiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	adr lr,setRegBFetch4
	b generic_AND_B_reg
;@----------------------------------------------------------------------------
regANDiW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	adr lr,setRegWFetch4
	b generic_AND_W_reg
;@----------------------------------------------------------------------------
regANDiL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#16
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#24
	adr lr,setRegLFetch7
	b generic_AND_L_reg

;@----------------------------------------------------------------------------
regORiB:					;@ Logical OR immediate
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	adr lr,setRegBFetch4
	b generic_OR_B_reg
;@----------------------------------------------------------------------------
regORiW:					;@ Logical OR immediate
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	adr lr,setRegWFetch4
	b generic_OR_W_reg
;@----------------------------------------------------------------------------
regORiL:					;@ Logical OR immediate
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#16
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#24
	adr lr,setRegLFetch7
	b generic_OR_L_reg

;@----------------------------------------------------------------------------
regXORiB:					;@ Exclusive OR immediate
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	adr lr,setRegBFetch4
	b generic_XOR_B_reg
;@----------------------------------------------------------------------------
regXORiW:					;@ Exclusive OR immediate
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	adr lr,setRegWFetch4
	b generic_XOR_W_reg
;@----------------------------------------------------------------------------
regXORiL:					;@ Exclusive OR immediate
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#16
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#24
	adr lr,setRegLFetch7
	b generic_XOR_L_reg

;@----------------------------------------------------------------------------
regCPr3B:					;@ Compare
;@----------------------------------------------------------------------------
	and r1,r0,#0x07				;@ From Second
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	t9fetch 4
;@----------------------------------------------------------------------------
regCPr3W:					;@ Compare
;@----------------------------------------------------------------------------
	and r1,r0,#0x07				;@ From Second
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SUB_W
	t9fetch 4

;@----------------------------------------------------------------------------
regCPBW:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegW]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPBA:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPBB:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegB]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPBC:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegC]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPBD:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegD]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPBE:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegE]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPBH:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegH]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPBL:					;@ Compare
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegL]
	bl generic_SUB_B_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCPW:						;@ Compare
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SUB_W_reg
	t9fetch 4
;@----------------------------------------------------------------------------
regCP_L:					;@ Compare long, regCPL (complement) already exists
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SUB_L_reg
	t9fetch 7

;@----------------------------------------------------------------------------
regRLCAB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rlcab_e
;@----------------------------------------------------------------------------
regRLCiB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rlcab_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRLCB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	orr r0,r0,r0,lsl#8
	orr r0,r0,r0,lsl#16
	movs r0,r0,lsl r12
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regRLCAW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rlcaw_e
;@----------------------------------------------------------------------------
regRLCiW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rlcaw_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRLCW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	orr r0,r0,r0,lsl#16
	movs r0,r0,lsl r12
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	mov r0,r0,lsr#16
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6
;@----------------------------------------------------------------------------
regRLCAL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rlcal_e
;@----------------------------------------------------------------------------
regRLCiL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rlcal_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRLCL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and t9f,t9f,#PSR_P			;@ Unknown
	movs r1,r0,lsl r12
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	rsb r12,r12,#0x20
	orrs r0,r1,r0,lsr r12
	orreq t9f,t9f,#PSR_Z
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regRRCAB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rrcab_e
;@----------------------------------------------------------------------------
regRRCiB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rrcab_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRRCB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	orr r0,r0,r0,lsl#8
	orr r0,r0,r0,lsl#16
	movs r0,r0,ror r12
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regRRCAW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rrcaw_e
;@----------------------------------------------------------------------------
regRRCiW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rrcaw_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRRCW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	orr r0,r0,r0,lsl#16
	movs r0,r0,ror r12
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C|PSR_S
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6
;@----------------------------------------------------------------------------
regRRCAL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rrcal_e
;@----------------------------------------------------------------------------
regRRCiL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rrcal_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRRCL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and t9f,t9f,#PSR_P			;@ Unknown
	movs r0,r0,ror r12
	orrcs t9f,t9f,#PSR_C|PSR_S
	orreq t9f,t9f,#PSR_Z
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regRLAB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rlab_e
;@----------------------------------------------------------------------------
regRLiB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rlab_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRLB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r0,r0,lsl#24
	tst t9f,#PSR_C
	orrne r0,r0,#0x00800000
	orr r0,r0,r0,lsr#9
	orr r0,r0,r0,lsr#18
	movs r0,r0,lsl r12
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regRLAW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rlaw_e
;@----------------------------------------------------------------------------
regRLiW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rlaw_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRLW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mov r0,r0,lsl#16
	tst t9f,#PSR_C
	orrne r0,r0,#0x00008000
	orr r0,r0,r0,lsr#17
	movs r0,r0,lsl r12
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	movs r0,r0,lsr#16
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6
;@----------------------------------------------------------------------------
regRLAL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rlal_e
;@----------------------------------------------------------------------------
regRLiL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rlal_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRLL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and r2,t9f,#PSR_C			;@ Bit#1
	and t9f,t9f,#PSR_P			;@ Unknown
	movs r1,r0,lsl r12
	rsb r12,r12,#33
	orr r1,r1,r2,ror r12
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	rsb r12,r12,#32
	orrs r0,r1,r0,lsr r12
	orreq t9f,t9f,#PSR_Z
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regRRAB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rrab_e
;@----------------------------------------------------------------------------
regRRiB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rrab_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRRB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	tst t9f,#PSR_C
	orrne r0,r0,#0x100
	orr r0,r0,r0,lsl#9
	orr r0,r0,r0,lsl#18
	movs r0,r0,lsr r12
	and r0,r0,#0xFF
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regRRAW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rraw_e
;@----------------------------------------------------------------------------
regRRiW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rraw_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRRW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	tst t9f,#PSR_C
	orrne r0,r0,#0x10000
	orr r0,r0,r0,lsl#17
	mov r0,r0,ror#16
	movs r0,r0,ror r12
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	movs r0,r0,lsr#16
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6
;@----------------------------------------------------------------------------
regRRAL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b rral_e
;@----------------------------------------------------------------------------
regRRiL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rral_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regRRL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and r2,t9f,#PSR_C			;@ Bit#1
	and t9f,t9f,#PSR_P			;@ Unknown
	movs r1,r0,lsr r12
	orrcs t9f,t9f,#PSR_C
	rsb r12,r12,#33
	orr r0,r1,r0,lsl r12
	sub r12,r12,#1
	orrs r0,r0,r2,lsl r12
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regSLAAB:
regSLLAB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b slab_e
;@----------------------------------------------------------------------------
regSLAiB:
regSLLiB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
slab_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSLAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r0,r0,lsl r12
	movs r1,r0,lsl#24
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSLAAW:
regSLLAW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b slaw_e
;@----------------------------------------------------------------------------
regSLAiW:
regSLLiW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
slaw_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSLAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mov r0,r0,lsl r12
	movs r1,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSLAAL:
regSLLAL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b slal_e
;@----------------------------------------------------------------------------
regSLAiL:
regSLLiL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
slal_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSLAL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and t9f,t9f,#PSR_P			;@ Unknown
	movs r0,r0,lsl r12
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8+2

;@----------------------------------------------------------------------------
regSRAAB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b srab_e
;@----------------------------------------------------------------------------
regSRAiB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
srab_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSRAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r0,r0,lsl#24
	mov r0,r0,asr r12
	movs r0,r0,lsr#24
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSRAAW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b sraw_e
;@----------------------------------------------------------------------------
regSRAiW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
sraw_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSRAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mov r0,r0,lsl#16
	mov r0,r0,asr r12
	eor r1,r0,r0,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	movs r0,r0,asr#16
	orrmi t9f,t9f,#PSR_S
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSRAAL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b sral_e
;@----------------------------------------------------------------------------
regSRAiL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
sral_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSRAL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and t9f,t9f,#PSR_P			;@ Unknown
	movs r0,r0,asr r12
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8+2

;@----------------------------------------------------------------------------
regSRLAB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b srlb_e
;@----------------------------------------------------------------------------
regSRLiB:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
srlb_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSRLB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	movs r0,r0,lsr r12
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSRLAW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b srlw_e
;@----------------------------------------------------------------------------
regSRLiW:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
srlw_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSRLW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	movs r0,r0,lsr r12
	eor r1,r0,r0,lsr#8
	and r1,r1,#0xFF
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1]			;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSRLAL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#RegA]
	b srll_e
;@----------------------------------------------------------------------------
regSRLiL:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
srll_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
;@----------------------------------------------------------------------------
regSRLL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and t9f,t9f,#PSR_P			;@ Unknown
	movs r0,r0,lsr r12
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8+2

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
