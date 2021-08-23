#ifdef __arm__

#include "TLCS900H.i"
#include "TLCS900H_mac.h"

	.global reg_B
	.global reg_W
	.global reg_L
	.global regRCB
	.global regRCW
	.global regRCL


	.syntax unified
	.arm

#ifdef GBA
	.section .ewram, "ax"		;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
;@----------------------------------------------------------------------------
;@ 71 size checks.
;@----------------------------------------------------------------------------
regRCB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r1,[t9optbl,#tlcs_CurrentMapBank]
	ldrsb t9Reg,[r1,r0]
	mov t9Reg,t9Reg,ror#2
	t9eatcycles 1
	ldrb r0,[t9pc],#1
	adr r1,regOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
regRCL:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r1,[t9optbl,#tlcs_CurrentMapBank]
	ldrsb t9Reg,[r1,r0]
	mov t9Reg,t9Reg,asr#2
	t9eatcycles 1
	ldrb r0,[t9pc],#1
	adr r1,regOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
reg_L:
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	ldrb r0,[t9pc],#1
	adr r1,regOpCodes
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
reg_B:
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	ldrb r0,[t9pc],#1
	ldr pc,[pc,r0,lsl#2]
	.long 0
regOpCodes:
;@ 0x00
	.long er,		er,			er,			regLDi,		regPUSH,	regPOP,		regCPL,		regNEG
	.long regMULi,	regMULSi,	regDIVi,	regDIVSi,	regLINK,	regUNLK,	regBS1F,	regBS1B
;@ 0x10
	.long regDAA,	er,			regEXTZ,	regEXTS,	regPAA,		er,			er,			er
	.long er,		er,			er,			er,			regDJNZ,	er,			er,			er
;@ 0x20
	.long regANDCFi,regORCFi,	regXORCFi,	regLDCFi,	regSTCFi,	er,			er,			er
	.long regANDCFA,regORCFA,	regXORCFA,	regLDCFA,	regSTCFA,	er,			regLDCcrr,	regLDCrcr
;@ 0x30
	.long regRES,	regSET,		regCHG,		regBIT,		regTSET,	er,			er,			er
	.long er,		er,			er,			er,			er,			er,			er,			er
;@ 0x40
	.long regMUL,	regMUL,		regMUL,		regMUL,		regMUL,		regMUL,		regMUL,		regMUL
	.long regMULS,	regMULS,	regMULS,	regMULS,	regMULS,	regMULS,	regMULS,	regMULS
;@ 0x50
	.long regDIV,	regDIV,		regDIV,		regDIV,		regDIV,		regDIV,		regDIV,		regDIV
	.long regDIVS,	regDIVS,	regDIVS,	regDIVS,	regDIVS,	regDIVS,	regDIVS,	regDIVS
;@ 0x60
	.long regINC,	regINC,		regINC,		regINC,		regINC,		regINC,		regINC,		regINC
	.long regDEC,	regDEC,		regDEC,		regDEC,		regDEC,		regDEC,		regDEC,		regDEC
;@ 0x70
	.long regSCC,	regSCC,		regSCC,		regSCC,		regSCC,		regSCC,		regSCC,		regSCC
	.long regSCC,	regSCC,		regSCC,		regSCC,		regSCC,		regSCC,		regSCC,		regSCC
;@ 0x80
	.long regADD,	regADD,		regADD,		regADD,		regADD,		regADD,		regADD,		regADD
	.long regLDRr,	regLDRr,	regLDRr,	regLDRr,	regLDRr,	regLDRr,	regLDRr,	regLDRr
;@ 0x90
	.long regADC,	regADC,		regADC,		regADC,		regADC,		regADC,		regADC,		regADC
	.long regLDrR,	regLDrR,	regLDrR,	regLDrR,	regLDrR,	regLDrR,	regLDrR,	regLDrR
;@ 0xA0
	.long regSUB,	regSUB,		regSUB,		regSUB,		regSUB,		regSUB,		regSUB,		regSUB
	.long regLDr3,	regLDr3,	regLDr3,	regLDr3,	regLDr3,	regLDr3,	regLDr3,	regLDr3
;@ 0xB0
	.long regSBC,	regSBC,		regSBC,		regSBC,		regSBC,		regSBC,		regSBC,		regSBC
	.long regEX,	regEX,		regEX,		regEX,		regEX,		regEX,		regEX,		regEX
;@ 0xC0
	.long regAND,	regAND,		regAND,		regAND,		regAND,		regAND,		regAND,		regAND
	.long regADDi,	regADCi,	regSUBi,	regSBCi,	regANDi,	regXORi,	regORi,		regCPi
;@ 0xD0
	.long regXOR,	regXOR,		regXOR,		regXOR,		regXOR,		regXOR,		regXOR,		regXOR
	.long regCPr3,	regCPr3,	regCPr3,	regCPr3,	regCPr3,	regCPr3,	regCPr3,	regCPr3
;@ 0xE0
	.long regOR,	regOR,		regOR,		regOR,		regOR,		regOR,		regOR,		regOR
	.long regRLCi,	regRRCi,	regRLi,		regRRi,		regSLAi,	regSRAi,	regSLLi,	regSRLi
;@ 0xF0
	.long regCP,	regCP,		regCP,		regCP,		regCP,		regCP,		regCP,		regCP
	.long regRLCA,	regRRCA,	regRLA,		regRRA,		regSLAA,	regSRAA,	regSLLA,	regSRLA

;@----------------------------------------------------------------------------
regRCW:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r1,[t9optbl,#tlcs_CurrentMapBank]
	ldrsb t9Reg,[r1,r0]
	bic t9Reg,t9Reg,#1
	
	t9eatcycles 1
	ldrb r0,[t9pc],#1
	adr r1,regOpCodesW
	ldr pc,[r1,r0,lsl#2]
;@----------------------------------------------------------------------------
reg_W:
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	mov t9Reg,t9Reg,lsl#2
	ldrb r0,[t9pc],#1
	ldr pc,[pc,r0,lsl#2]
	.long 0
regOpCodesW:
;@ 0x00
	.long er,		er,			er,			regLDiW,	regPUSHW,	regPOPW,	regCPLW,	regNEGW
	.long regMULiW,	regMULSiW,	regDIViW,	regDIVSiW,	er,			er,			regBS1F,	regBS1B
;@ 0x10
	.long er,		er,			regEXTZW,	regEXTSW,	regPAAW,	er,			regMIRR,	er
	.long er,		regMULA,	er,			er,			regDJNZW,	er,			er,			er
;@ 0x20
	.long regANDCFiW,regORCFiW,	regXORCFiW,	regLDCFiW,	regSTCFiW,	er,			er,			er
	.long regANDCFAW,regORCFAW,	regXORCFAW,	regLDCFAW,	regSTCFAW,	er,			regLDCcrrW,	regLDCrcrW
;@ 0x30
	.long regRESW,	regSETW,	regCHGW,	regBITW,	regTSET,	er,			er,			er
	.long regMINC1,	regMINC2,	regMINC4,	er,			regMDEC1,	regMDEC2,	regMDEC4,	er
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
	.long regSUBW,	regSUBW,	regSUBW,	regSUBW,	regSUBW,	regSUBW,	regSUBW,	regSUBW
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
	.long regRLCi,	regRRCi,	regRLi,		regRRi,		regSLAi,	regSRAi,	regSLLi,	regSRLi
;@ 0xF0
	.long regCPW,	regCPW,		regCPW,		regCPW,		regCPW,		regCPW,		regCPW,		regCPW
	.long regRLCA,	regRRCA,	regRLA,		regRRA,		regSLAA,	regSRAA,	regSLLA,	regSRLA

er:
	mov r11,r11
	mov r0,#0xE6
	t9fetch 0
;@----------------------------------------------------------------------------

;@----------------------------------------------------------------------------
regLDi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne regLDiL
;@----------------------------------------------------------------------------
regLDiB:
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
regPUSH:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne regPUSHL
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
regPOP:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne regPOPL
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
regCPL:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regCPLB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mvn r0,r0
	strb r0,[t9gprBank,t9Reg,ror#30]
	orr t9f,t9f,#PSR_H|PSR_n
	t9fetch 4
;@----------------------------------------------------------------------------
regCPLW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mvn r0,r0
	strh r0,[t9gprBank,t9Reg]
	orr t9f,t9f,#PSR_H|PSR_n
	t9fetch 4

;@----------------------------------------------------------------------------
regNEG:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regNEGB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	mov r0,#0
	bl generic_SUB_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 5
;@----------------------------------------------------------------------------
regNEGW:
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
	mov r0,#0
	bl generic_SUB_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 5

;@----------------------------------------------------------------------------
regMULi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regMULiB:
;@----------------------------------------------------------------------------
	movs r0,t9opCode,lsr#1
	bcc unknown_RR_Target
	mov t9Reg,t9Reg,ror#30
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
regMULSi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regMULSiB:
;@----------------------------------------------------------------------------
	movs r0,t9opCode,lsr#1
	bcc unknown_RR_Target
	mov t9Reg,t9Reg,ror#30
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
regDIVi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regDIViB:
;@----------------------------------------------------------------------------
	movs r0,t9opCode,lsr#1
	bcc unknown_RR_Target
	mov t9Reg,t9Reg,ror#30
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
regDIVSi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x30			;@ Size
	bne er
;@----------------------------------------------------------------------------
regDIVSiB:
;@----------------------------------------------------------------------------
	movs r0,t9opCode,lsr#1
	bcc unknown_RR_Target
	mov t9Reg,t9Reg,ror#30
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
regLINK:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl push32
	ldr r0,[t9gprBank,#0x1C]	;@ XSP
	str r0,[t9gprBank,t9Reg,lsl#2]
	ldrb r1,[t9pc],#1
	ldrsb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	add r0,r0,r1
	str r0,[t9gprBank,#0x1C]	;@ XSP
	t9fetch 10

;@----------------------------------------------------------------------------
regUNLK:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	str r0,[t9gprBank,#0x1C]	;@ XSP
	bl pop32
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regBS1F:					;@ Bit Search 1 Forward
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_V
	ldrh r0,[t9gprBank,t9Reg]
	mov r1,#0
bs1fLoop:
	movs r0,r0,lsr#1
	bcs bs1fEnd
	add r1,r1,#1
	bne bs1fLoop
	orr t9f,t9f,#PSR_V
bs1fEnd:
	strb r1,[t9gprBank,#0x00]	;@ Reg A
	t9fetch 4
;@----------------------------------------------------------------------------
regBS1B:					;@ Bit Search 1 Backward
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_V
	ldrh r0,[t9gprBank,t9Reg]
	mov r0,r0,lsl#16
	mov r1,#15
bs1bLoop:
	movs r0,r0,lsl#1
	bcs bs1bEnd
	sub r1,r1,#1
	bne bs1bLoop
	orr t9f,t9f,#PSR_V
bs1bEnd:
	strb r1,[t9gprBank,#0x00]	;@ Reg A
	t9fetch 4

;@----------------------------------------------------------------------------
regDAA:
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

	ands t9f,t9f,#PSR_n			;@ Check if last instruction was add or sub.
	orrcs t9f,t9f,#PSR_C		;@ The ands doesn't change carry as long as it doesn't have to shift the imidiate value.

	rsbne r0,r0,#0
	add r2,r2,r0
	add r0,t9optbl,#tlcs_pzst
	ldrb r0,[r0,r2,lsr#24]		;@ Get PZS
	orr t9f,t9f,r0
	eor r1,r1,r2,ror#28
	tst r1,#0x1
	orrne t9f,t9f,#PSR_H

	mov r0,r2,lsr#24
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6

;@----------------------------------------------------------------------------
regEXTZ:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	beq er
;@----------------------------------------------------------------------------
regEXTZL:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	str r1,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regEXTZW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg]
	strh r1,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regEXTS:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	beq er
;@----------------------------------------------------------------------------
regEXTSL:
;@----------------------------------------------------------------------------
	mov t9Reg,t9Reg,lsl#2
	ldrsh r0,[t9gprBank,t9Reg]
	str r0,[t9gprBank,t9Reg]
	t9fetch 5
;@----------------------------------------------------------------------------
regEXTSW:
;@----------------------------------------------------------------------------
	ldrsb r0,[t9gprBank,t9Reg]
	strh r0,[t9gprBank,t9Reg]
	t9fetch 5

;@----------------------------------------------------------------------------
regPAA:						 ;@ Pointer Adjustment Accumulator
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	beq er
;@----------------------------------------------------------------------------
regPAAL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	and r1,r0,#1
	add r0,r0,r1
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 4
;@----------------------------------------------------------------------------
regPAAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	and r1,r0,#1
	add r0,r0,r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regMIRR:
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
regMULA:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#0x08]	;@ XDE
	bl t9LoadW
	mov t9Reg2,r0,lsl#16
	mov t9Reg2,t9Reg2,asr#16
	ldr r0,[t9gprBank,#0x0C]	;@ XHL
	sub r1,r0,#2
	str r1,[t9gprBank,#0x0C]	;@ XHL
	bl t9LoadW
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
regDJNZ:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regDJNZB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	subs r0,r0,#1
	strb r0,[t9gprBank,t9Reg,ror#30]
	ldrsb r1,[t9pc],#1
	addne t9pc,t9pc,r1
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 7
;@----------------------------------------------------------------------------
regDJNZW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	subs r0,r0,#1
	strh r0,[t9gprBank,t9Reg]
	ldrsb r1,[t9pc],#1
	addne t9pc,t9pc,r1
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 7

;@----------------------------------------------------------------------------
regANDCFi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regANDCFiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9pc],#1
	tst r1,#0x08
	and r1,r1,#0x0F
	mov r2,#1
	tsteq r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regANDCFiW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regORCFi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regORCFiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regORCFiW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regXORCFi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regXORCFiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regXORCFiW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regLDCFi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regLDCFiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9pc],#1
	tst r1,#0x08
	and r1,r1,#0x0F
	mov r2,#1
	biceq t9f,t9f,#PSR_C
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regLDCFiW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	bic t9f,t9f,#PSR_C
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regSTCFi:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regSTCFiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	bic r0,r0,r2,lsl r1
	tst t9f,#PSR_C
	orrne r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regSTCFiW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	bic r0,r0,r2,lsl r1
	tst t9f,#PSR_C
	orrne r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regANDCFA:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regANDCFAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	tst r1,#0x08
	and r1,r1,#0x07
	mov r2,#1
	tsteq r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regANDCFAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	biceq t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regORCFA:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regORCFAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regORCFAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regXORCFA:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regXORCFAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4
;@----------------------------------------------------------------------------
regXORCFAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst r0,r2,lsl r1
	eorne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regLDCFA:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regLDCFAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	tst r1,#0x08
	bne ldcfaEnd
	and r1,r1,#0x0F
	mov r2,#1
	bic t9f,t9f,#PSR_C
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
ldcfaEnd:
	t9fetch 4
;@----------------------------------------------------------------------------
regLDCFAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	bic t9f,t9f,#PSR_C
	tst r0,r2,lsl r1
	orrne t9f,t9f,#PSR_C
	t9fetch 4

;@----------------------------------------------------------------------------
regSTCFA:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regSTCFAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl r1
	orrne r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regSTCFAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	ldrb r1,[t9gprBank,#0x00]	;@ Reg A
	and r1,r1,#0x0F
	mov r2,#1
	tst t9f,#PSR_C
	biceq r0,r0,r2,lsl r1
	orrne r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regLDCcrr:					;@ Should this also include interrupt nesting counter? (0x7C on TLCS-900/H1, has 8 DMA channels.)
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	tst t9opCode,#0x20			;@ Size
	bne regLDCcrrL
;@----------------------------------------------------------------------------
regLDCcrrB:					;@ Load Control Register cr, r
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	tst r0,#0xD1				;@ Allow 0x22, 0x26, 0x2A & 0x2E
	addeq r2,t9optbl,#tlcs_DmaS
	strbeq r1,[r2,r0]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCcrrW:					;@ Load Control Register cr, r
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	ldrh r1,[t9gprBank,t9Reg]
	tst r0,#0xD3				;@ Allow 0x20, 0x24, 0x28 & 0x2C
	addeq r2,t9optbl,#tlcs_DmaS
	strheq r1,[r2,r0]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCcrrL:					;@ Load Control Register cr, r
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	tst r0,#0xE3				;@ Only allow 0x00, 0x04, 0x08, 0x0C, 0x10, 0x14, 0x18 & 0x1C
	addeq r2,t9optbl,#tlcs_DmaS
	streq r1,[r2,r0]
	t9fetch 8

;@----------------------------------------------------------------------------
regLDCrcr:					;@ Load Control Register r, cr
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	tst t9opCode,#0x30			;@ Size
	bne regLDCrcrL
;@----------------------------------------------------------------------------
regLDCrcrB:					;@ Load Control Register r, cr
;@----------------------------------------------------------------------------
	tst r0,#0xD1				;@ Only allow 0x22, 0x26, 0x2A & 0x2E
	addeq r2,t9optbl,#tlcs_DmaS
	ldrbeq r0,[r2,r0]
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCrcrW:					;@ Load Control Register r, cr
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1			;@ CR
	tst r0,#0xD3				;@ Only allow 0x20, 0x24, 0x28 & 0x2C
	addeq r2,t9optbl,#tlcs_DmaS
	ldrheq r0,[r2,r0]
	strh r0,[t9gprBank,t9Reg]
	t9fetch 8
;@----------------------------------------------------------------------------
regLDCrcrL:					;@ Load Control Register r, cr
;@----------------------------------------------------------------------------
	tst r0,#0xE3				;@ Allow 0x00, 0x04, 0x08, 0x0C, 0x10, 0x14, 0x18 & 0x1C
	addeq r2,t9optbl,#tlcs_DmaS
	ldreq r0,[r2,r0]
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 8

;@----------------------------------------------------------------------------
regRES:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x30			;@ Size
	bne er
;@----------------------------------------------------------------------------
regRESB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bic r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regRESW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	ldrh r0,[t9gprBank,t9Reg]
	bic r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regSET:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regSETB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	orr r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regSETW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	ldrh r0,[t9gprBank,t9Reg]
	orr r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regCHG:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regCHGB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	eor r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regCHGW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	ldrh r0,[t9gprBank,t9Reg]
	eor r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regBIT:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regBITB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	t9fetch 4
;@----------------------------------------------------------------------------
regBITW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	ldrh r0,[t9gprBank,t9Reg]
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	t9fetch 4

;@----------------------------------------------------------------------------
regTSET:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regTSETB:					;@ Test and Set
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	orr r0,r0,r2,lsl r1
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regTSETW:					;@ Test and Set
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	and r1,r1,#0x0F
	mov r2,#1
	bic t9f,t9f,#PSR_Z|PSR_n	;@ S & V set to undefined value.
	orr t9f,t9f,#PSR_H
	ldrh r0,[t9gprBank,t9Reg]
	tst r0,r2,lsl r1
	orreq t9f,t9f,#PSR_Z
	orr r0,r0,r2,lsl r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4

;@----------------------------------------------------------------------------
regMINC1:					;@ Modulo Increment 1
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
regMINC2:					;@ Modulo Increment 2
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
regMINC4:					;@ Modulo Increment 4
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
regMDEC1:					;@ Modulo Decrement 1
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
regMDEC2:					;@ Modulo Decrement 2
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
regMDEC4:					;@ Modulo Decrement 4
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
regMUL:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regMULB:
;@----------------------------------------------------------------------------
	movs t9Reg2,r0,lsr#1		;@ From Second
	bcc unknown_RR_Target
	and t9Reg2,t9Reg2,#0x03
	mov t9Reg2,t9Reg2,lsl#2
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	ldrb r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regMULW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r1,[t9gprBank,t9Reg]
	ldrh r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regMULS:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regMULSB:
;@----------------------------------------------------------------------------
	movs t9Reg2,r0,lsr#1		;@ From Second
	bcc unknown_RR_Target
	mov t9Reg,t9Reg,ror#30
	and t9Reg2,t9Reg2,#0x03
	mov t9Reg2,t9Reg2,lsl#2
	ldrsb r1,[t9gprBank,t9Reg]
	ldrsb r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regMULSW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	mov t9Reg2,t9Reg2,lsl#2
	ldrsh r1,[t9gprBank,t9Reg]
	ldrsh r0,[t9gprBank,t9Reg2]	;@ reg R
	mul r0,r1,r0
	str r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regDIV:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ size
	bne er
;@----------------------------------------------------------------------------
regDIVB:
;@----------------------------------------------------------------------------
	movs t9Reg2,r0,lsr#1		;@ From Second
	bcc unknown_RR_Target
	and t9Reg2,t9Reg2,#0x03
	mov t9Reg2,t9Reg2,lsl#2
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	ldrh r0,[t9gprBank,t9Reg2]	;@ reg R
	bl generic_DIV_B
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regDIVW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regDIVS:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regDIVSB:
;@----------------------------------------------------------------------------
	movs t9Reg2,r0,lsr#1		;@ From Second
	bcc unknown_RR_Target
	mov t9Reg,t9Reg,ror#30
	and t9Reg2,t9Reg2,#0x03
	mov t9Reg2,t9Reg2,lsl#2
	ldrsb r1,[t9gprBank,t9Reg]
	ldrsh r0,[t9gprBank,t9Reg2]	;@ reg R
	bl generic_DIV_W
	strh r0,[t9gprBank,t9Reg2]	;@ reg R
	t9fetch 18
;@----------------------------------------------------------------------------
regDIVSW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrsh r1,[t9gprBank,t9Reg]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	bl generic_DIV_W
	str r0,[t9gprBank,t9Reg2,lsl#2];@ reg R
	t9fetch 26

;@----------------------------------------------------------------------------
regINC:
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	moveq r1,#0x08
	tst t9opCode,#0x20			;@ size
	bne regINCL
;@----------------------------------------------------------------------------
regINCB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_INC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regINCW:
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	moveq r1,#0x08
	ldrh r0,[t9gprBank,t9Reg]
	add r0,r0,r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regINCL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	add r0,r0,r1
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 5

;@----------------------------------------------------------------------------
regDEC:
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	moveq r1,#0x08
	tst t9opCode,#0x20			;@ Size
	bne regDECL
;@----------------------------------------------------------------------------
regDECB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_DEC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regDECW:
;@----------------------------------------------------------------------------
	ands r1,r0,#0x07			;@ From Second
	moveq r1,#0x08
	ldrh r0,[t9gprBank,t9Reg]
	sub r0,r0,r1
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regDECL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	sub r0,r0,r1
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 5

;@----------------------------------------------------------------------------
regSCC:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regSCCB:
;@----------------------------------------------------------------------------
	bl conditionCode
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regSCCW:
;@----------------------------------------------------------------------------
	bl conditionCode
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6

;@----------------------------------------------------------------------------
regLDRr:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regLDRrL
;@----------------------------------------------------------------------------
regLDRrB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regLDRrW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r0,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regLDRrL:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 4

;@----------------------------------------------------------------------------
regLDrR:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regLDrRL
;@----------------------------------------------------------------------------
regLDrRB:
;@----------------------------------------------------------------------------
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
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
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 4

;@----------------------------------------------------------------------------
regADD:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regADDL
;@----------------------------------------------------------------------------
regADDB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_ADD_B
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regADDW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_ADD_W
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regADDL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_ADD_L
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regADC:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regADCL
;@----------------------------------------------------------------------------
regADCB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_ADC_B
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regADCW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_ADC_W
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regADCL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_ADC_L
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regSUB:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regSUBL
;@----------------------------------------------------------------------------
regSUBB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_SUB_B
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regSUBW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_SUB_W
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regSUBL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SUB_L
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regSBC:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regSBCL
;@----------------------------------------------------------------------------
regSBCB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_SBC_B
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regSBCW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_SBC_W
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regSBCL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SBC_L
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regLDr3:
;@----------------------------------------------------------------------------
	and r0,r0,#0x07				;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regLDr3L
;@----------------------------------------------------------------------------
regLDr3B:
;@----------------------------------------------------------------------------
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
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 4

;@----------------------------------------------------------------------------
regEX:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regEXL
;@----------------------------------------------------------------------------
regEXB:
;@----------------------------------------------------------------------------
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
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	ldr r1,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	str r1,[t9gprBank,t9Reg,lsl#2]
	t9fetch 5

;@----------------------------------------------------------------------------
regADDi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regADDiL
;@----------------------------------------------------------------------------
regADDiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_ADD_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regADDiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_ADD_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regADDiL:
;@----------------------------------------------------------------------------
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADD_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regADCi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regADCiL
;@----------------------------------------------------------------------------
regADCiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_ADC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regADCiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_ADC_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regADCiL:
;@----------------------------------------------------------------------------
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_ADC_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regSUBi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regSUBiL
;@----------------------------------------------------------------------------
regSUBiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regSUBiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SUB_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regSUBiL:
;@----------------------------------------------------------------------------
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SUB_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regSBCi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regSBCiL
;@----------------------------------------------------------------------------
regSBCiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SBC_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regSBCiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SBC_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regSBCiL:
;@----------------------------------------------------------------------------
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_SBC_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regCPi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regCPiL
;@----------------------------------------------------------------------------
regCPiB:
;@----------------------------------------------------------------------------
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
regANDi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regANDiL
;@----------------------------------------------------------------------------
regANDiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_AND_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regANDiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_AND_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regANDiL:
;@----------------------------------------------------------------------------
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_AND_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regORi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regORiL
;@----------------------------------------------------------------------------
regORiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_OR_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regORiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_OR_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regORiL:
;@----------------------------------------------------------------------------
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_OR_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regXORi:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	tst t9opCode,#0x20			;@ Size
	bne regXORiL
;@----------------------------------------------------------------------------
regXORiB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_XOR_B
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 4
;@----------------------------------------------------------------------------
regXORiW:
;@----------------------------------------------------------------------------
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_XOR_W
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
regXORiL:
;@----------------------------------------------------------------------------
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#8
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#16
	ldrb r2,[t9pc],#1
	orr r1,r1,r2,lsl#24
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl generic_XOR_L
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 7

;@----------------------------------------------------------------------------
regAND:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regANDL
;@----------------------------------------------------------------------------
regANDB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_AND_B
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regANDW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_AND_W
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regANDL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_AND_L
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regOR:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regORL
;@----------------------------------------------------------------------------
regORB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_OR_B
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regORW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_OR_W
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regORL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_OR_L
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regXOR:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regXORL
;@----------------------------------------------------------------------------
regXORB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_XOR_B
	strb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regXORW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	mov t9Reg2,t9Reg2,lsl#2
	ldrh r0,[t9gprBank,t9Reg2]	;@ Reg R
	bl generic_XOR_W
	strh r0,[t9gprBank,t9Reg2]	;@ Reg R
	t9fetch 4
;@----------------------------------------------------------------------------
regXORL:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_XOR_L
	str r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	t9fetch 7

;@----------------------------------------------------------------------------
regCPr3:
;@----------------------------------------------------------------------------
	tst t9opCode,#0x20			;@ Size
	bne er
;@----------------------------------------------------------------------------
regCPr3B:
;@----------------------------------------------------------------------------
	and r1,r0,#0x07				;@ From Second
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	bl generic_SUB_B
	t9fetch 4
;@----------------------------------------------------------------------------
regCPr3W:
;@----------------------------------------------------------------------------
	and r1,r0,#0x07				;@ From Second
	ldrh r0,[t9gprBank,t9Reg]
	bl generic_SUB_W
	t9fetch 4

;@----------------------------------------------------------------------------
regCP:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	tst t9opCode,#0x20			;@ Size
	bne regCP_L
;@----------------------------------------------------------------------------
regCPB:
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
	movs t9Reg2,t9Reg2,lsr#1
	orrcc t9Reg2,t9Reg2,#0x40000000
	ldrb r0,[t9gprBank,t9Reg2,ror#30];@ Reg R
	bl generic_SUB_B
	t9fetch 4
;@----------------------------------------------------------------------------
regCPW:
;@----------------------------------------------------------------------------
	and t9Reg2,r0,#0x07			;@ From Second
	ldrh r1,[t9gprBank,t9Reg]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SUB_W
	t9fetch 4
;@----------------------------------------------------------------------------
regCP_L:					;@ regCPL (complement) already exists
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ldr r0,[t9gprBank,t9Reg2,lsl#2];@ Reg R
	bl generic_SUB_L
	t9fetch 7

;@----------------------------------------------------------------------------
regRLCA:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#0x00]	;@ Reg A
	b rlca_e
;@----------------------------------------------------------------------------
regRLCi:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rlca_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
	ands r0,t9opCode,#0x30		;@ Size
	beq regRLCB
	cmp r0,#0x10
	beq regRLCW
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
regRLCB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	orr r0,r0,r0,lsl#8
	orr r0,r0,r0,lsl#16
	movs r0,r0,lsl r12
	add r1,t9optbl,#tlcs_pzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regRLCW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	orr r0,r0,r0,lsl#16
	movs r0,r0,lsl r12
	eor r1,r0,r0,lsl#8
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	mov r0,r0,lsr#16
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6

;@----------------------------------------------------------------------------
regRRCA:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#0x00]	;@ Reg A
	b rrca_e
;@----------------------------------------------------------------------------
regRRCi:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rrca_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
	ands r0,t9opCode,#0x30		;@ Size
	beq regRRCB
	cmp r0,#0x10
	beq regRRCW
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
regRRCB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	orr r0,r0,r0,lsl#8
	orr r0,r0,r0,lsl#16
	movs r0,r0,ror r12
	add r1,t9optbl,#tlcs_pzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
;@----------------------------------------------------------------------------
regRRCW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	orr r0,r0,r0,lsl#16
	movs r0,r0,ror r12
	eor r1,r0,r0,lsl#8
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C|PSR_S
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6

;@----------------------------------------------------------------------------
regRLA:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#0x00]	;@ Reg A
	b rla_e
;@----------------------------------------------------------------------------
regRLi:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rla_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
	ands r0,t9opCode,#0x30		;@ Size
	beq regRLB
	cmp r0,#0x10
	beq regRLW
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
regRLB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r0,r0,lsl#24
	tst t9f,#PSR_C
	orrne r0,r0,#0x00800000
	orr r0,r0,r0,lsr#9
	orr r0,r0,r0,lsr#18
	movs r0,r0,lsl r12
	add r1,t9optbl,#tlcs_pzst
	ldrb t9f,[r1,r0,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	mov r0,r0,lsr#24
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
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
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	movs r0,r0,lsr#16
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6

;@----------------------------------------------------------------------------
regRRA:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#0x00]	;@ Reg A
	b rra_e
;@----------------------------------------------------------------------------
regRRi:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
rra_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
	ands r0,t9opCode,#0x30		;@ Size
	beq regRRB
	cmp r0,#0x10
	beq regRRW
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
regRRB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	tst t9f,#PSR_C
	orrne r0,r0,#0x100
	orr r0,r0,r0,lsl#9
	orr r0,r0,r0,lsl#18
	movs r0,r0,lsr r12
	and r0,r0,#0xFF
	add r1,t9optbl,#tlcs_pzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6
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
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	movs r0,r0,lsr#16
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6

;@----------------------------------------------------------------------------
regSLAA:
regSLLA:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#0x00]	;@ Reg A
	b sla_e
;@----------------------------------------------------------------------------
regSLAi:
regSLLi:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
sla_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
	ands r0,t9opCode,#0x30		;@ Size
	beq regSLAB
	cmp r0,#0x10
	beq regSLAW
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
regSLAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r0,r0,lsl r12
	movs r1,r0,lsl#24
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSLAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mov r0,r0,lsl r12
	movs r1,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6+2

;@----------------------------------------------------------------------------
regSRAA:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#0x00]	;@ Reg A
	b sra_e
;@----------------------------------------------------------------------------
regSRAi:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
sra_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
	ands r0,t9opCode,#0x30		;@ Size
	beq regSRAB
	cmp r0,#0x10
	beq regSRAW
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
regSRAB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	mov r0,r0,lsl#24
	mov r0,r0,asr r12
	movs r0,r0,lsr#24
	add r1,t9optbl,#tlcs_pzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSRAW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	mov r0,r0,lsl#16
	mov r0,r0,asr r12
	eor r1,r0,r0,lsl#8
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	movs r0,r0,asr#16
	orrmi t9f,t9f,#PSR_S
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6+2

;@----------------------------------------------------------------------------
regSRLA:
;@----------------------------------------------------------------------------
	ldrb r12,[t9gprBank,#0x00]	;@ Reg A
	b srl_e
;@----------------------------------------------------------------------------
regSRLi:
;@----------------------------------------------------------------------------
	ldrb r12,[t9pc],#1
srl_e:
	ands r12,r12,#0x0F
	moveq r12,#0x10
	sub t9cycles,t9cycles,r12,lsl#T9CYC_SHIFT+1
	ands r0,t9opCode,#0x30		;@ Size
	beq regSRLB
	cmp r0,#0x10
	beq regSRLW
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
regSRLB:
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,t9Reg,ror#30]
	movs r0,r0,lsr r12
	add r1,t9optbl,#tlcs_pzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orrcs t9f,t9f,#PSR_C
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 6+2
;@----------------------------------------------------------------------------
regSRLW:
;@----------------------------------------------------------------------------
	ldrh r0,[t9gprBank,t9Reg]
	movs r0,r0,lsr r12
	eor r1,r0,r0,lsr#8
	and r1,r1,#0xFF
	add r2,t9optbl,#tlcs_pzst
	ldrb t9f,[r2,r1]			;@ Get P
	bic t9f,t9f,#PSR_S|PSR_Z
	orrcs t9f,t9f,#PSR_C
	orreq t9f,t9f,#PSR_Z
	strh r0,[t9gprBank,t9Reg]
	t9fetch 6+2

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
