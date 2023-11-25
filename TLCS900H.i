//
//  TLCS900H.i
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2023 Fredrik Ahlström. All rights reserved.
//

				;@ r0,r1,r2&r3=temp regs
t9Mem			.req r4	;@ Used by src and dst opcodes
t9Reg2			.req r4	;@ Used by reg opcodes
t9Reg			.req r5	;@ Used by reg opcodes
t9opCode		.req r6
t9f				.req r7
t9cycles		.req r8
t9pc			.req r9
t9ptr			.req r10
t9gprBank		.req r11
;@t9opCode2		.req r12	;@ keep this at r12 (scratch for APCS)
				;@ r13=SP
				;@ r14=LR
				;@ r15=PC

	.struct 0		;@ Changes section so make sure it's set before real code.

tlcsStateStart:
tlcsGprBanks:		.space 4*8*4
tlcsLastBank:		.long 0
tlcsSrW:
tlcsF:				.byte 0		;@ sr & f needs to be together and aligned at halfword.
tlcsSrB:			.byte 0
tlcsFDash:			.byte 0
tlcsStatusRFP:		.byte 0		;@ Register File Pointer
tlcsCycles:			.long 0
tlcsPcAsm:			.long 0
tlcsDMAStartVector:	.long 0
tlcsCurrentGprBank:	.long 0
tlcsCurrentMapBank:	.long 0
tlcsPadding1:		.long 0
tlcsDmaS:			.space 4*4
tlcsDmaD:			.space 4*4
tlcsDmaC:			.short 0
tlcsDmaM:			.space 4*3+2
tlcsIPending:		.space 64
tlcsIntPrio:		.space 16
tlcsTimerClock:		.space 4*4
tlcsUpCounter:		.long 0
tlcsTimerCompare:	.long 0
tlcsTimerHInt:		.byte 0
tlcsTRun:			.byte 0
tlcsT01Mod:			.byte 0
tlcsT23Mod:			.byte 0
tlcsTrdc:			.byte 0		;@ Timer Register Double Buffer Control
tlcsTFFCR:			.byte 0		;@ Timer Flip Flop Control Register
tlcsTFF1:			.byte 0		;@ Timer Flip Flop 1 output
tlcsTFF3:			.byte 0		;@ Timer Flip Flop 3 output
tlcsCycShift:		.byte 0
tlcsPadding0:		.space 3
tlcsStateEnd:

tff3Function:		.long 0
romBaseLo:			.long 0
romBaseHi:			.long 0
biosBase:			.long 0
readRomPtrLo:		.long 0
readRomPtrHi:		.long 0
tlcsPzst:			.space 256	;@ PZSTable
tlcsSize:

;@----------------------------------------------------------------------------
;@ TLCS900h EQUs
;@----------------------------------------------------------------------------
	.equ TIMER_BASE_RATE,	16		;@ 1	// Ticks

	.equ TIMER_T1_RATE,		(8 * TIMER_BASE_RATE)
	.equ TIMER_T4_RATE,		(32 * TIMER_BASE_RATE)
	.equ TIMER_T16_RATE,	(128 * TIMER_BASE_RATE)
	.equ TIMER_T256_RATE,	(2048 * TIMER_BASE_RATE)

	.equ T9_HINT_RATE,	515
	.equ T9CYC_SHIFT,	4
	.equ T9CYCLE,		1<<T9CYC_SHIFT
