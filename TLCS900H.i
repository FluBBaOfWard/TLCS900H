//
//  TLCS900H.i
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2021 Fredrik Ahlström. All rights reserved.
//

				;@ r0,r1,r2&r3=temp regs
t9Mem			.req r4	;@ Used by src and dst opcodes
t9Reg2			.req r4	;@ Used by reg opcodes
t9Reg			.req r5	;@ Used by reg opcodes
t9opCode		.req r6
t9f				.req r7
t9cycles		.req r8
t9pc			.req r9
t9optbl			.req r10
t9gprBank		.req r11
;@t9opCode2		.req r12	;@ keep this at r12 (scratch for APCS)
				;@ r13=SP
				;@ r14=LR
				;@ r15=PC

	.struct 0		;@ Changes section so make sure it's set before real code.

tlcs_ErrorVal:		.long 0
tlcs_GprBank:		.space 4*8*4
tlcs_LastBank:		.long 0
tlcs_sr_w:
tlcs_f:				.byte 0		;@ sr & f needs to be together and aligned at halfword.
tlcs_sr_b:			.byte 0
tlcs_f_dash:		.byte 0
tlcs_StatusRFP:		.byte 0		;@ Register File Pointer
tlcs_Cycles:		.long 0
tlcs_PcAsm:			.long 0
tlcs_CurrentGprBank:	.long 0
tlcs_CurrentMapBank:	.long 0
tlcs_DMAStartVector:	.long 0
tlcs_DmaS:			.space 4*4
tlcs_DmaD:			.space 4*4
tlcs_DmaC:			.short 0
tlcs_DmaM:			.space 4*3+2
tlcs_ipending:		.space 64
tlcs_IntPrio:		.space 16
tlcs_TimerClock:	.space 4*4
tlcs_Timer:			.long 0
tlcs_TimerThreshold:	.long 0
tlcs_TimerHInt:		.long 0
tlcs_TRun:			.byte 0
tlcs_T01Mod:		.byte 0
tlcs_T23Mod:		.byte 0
tlcs_trdc:			.byte 0
tlcs_tffcr:			.byte 0
tlcs_cycShift:		.byte 0
tlcs_padding0:		.space 2	;@ align

romBaseLo:			.long 0
romBaseHi:			.long 0
biosBase:			.long 0
readRomPtrLo:		.long 0
readRomPtrHi:		.long 0
tlcs_pzst:			.space 256

;@----------------------------------------------------------------------------
;@ TLCS900h EQUs
;@----------------------------------------------------------------------------
	.equ TIMER_BASE_RATE,	32		;@ 1	//ticks

	.equ TIMER_T1_RATE,		(8 * TIMER_BASE_RATE)
	.equ TIMER_T4_RATE,		(32 * TIMER_BASE_RATE)
	.equ TIMER_T16_RATE,	(128 * TIMER_BASE_RATE)
	.equ TIMER_T256_RATE,	(2048 * TIMER_BASE_RATE)

	.equ T9_HINT_RATE,	515
	.equ T9CYC_SHIFT,	4
	.equ T9CYCLE,		1<<T9CYC_SHIFT
