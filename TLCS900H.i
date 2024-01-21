//
//  TLCS900H.i
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2024 Fredrik Ahlström. All rights reserved.
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

	.struct -1024*4		;@ Changes section so make sure it's set before real code.
tlcsSrcOpCodesB:	.space 256*4
tlcsSrcOpCodesW:	.space 256*4
tlcsSrcOpCodesL:	.space 256*4
tlcsRegOpCodesB:	.space 256*4
tlcsOpCodes:		.space 256*4
tlcsPzst:			.space 256	;@ PZSTable
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
tlcsCurrentGprBank:	.long 0
tlcsCurrentMapBank:	.long 0
tlcsPadding1:		.long 0, 0
tlcsDmaS:			.space 4*4
tlcsDmaD:			.space 4*4
tlcsDmaC:			.short 0
tlcsDmaM:			.space 4*3+2
tlcsIPending:		.space 36
tlcsTRun:			.byte 0		;@ 0x20 TRUN
tlcsTimerCmp0:		.byte 0		;@ 0x22 TREG0
tlcsTimerCmp1:		.byte 0		;@ 0x23 TREG1
tlcsT01Mod:			.byte 0		;@ 0x24 T01MOD
tlcsTFFCR:			.byte 0		;@ 0x25 Timer Flip Flop Control Register
tlcsTimerCmp2:		.byte 0		;@ 0x26 TREG2
tlcsTimerCmp3:		.byte 0		;@ 0x27 TREG3
tlcsT23Mod:			.byte 0		;@ 0x28 T23MOD
tlcsTrdc:			.byte 0		;@ 0x29 Timer Register Double Buffer Control
tlcsWdMode:			.byte 0		;@ 0x6E Watchdog Mode
tlcsTFF1:			.byte 0		;@ Timer Flip Flop 1 output
tlcsTFF3:			.byte 0		;@ Timer Flip Flop 3 output
tlcsIntPrio:		.space 12	;@ 0x70-0x7B
tlcsDMAStartVector:	.long 0		;@ 0x7C-0x7F
tlcsTimerClock:		.space 4*4
tlcsUpCounter:		.long 0
tlcsCycShift:		.byte 0
tlcsIrqPrio:		.byte 0
tlcsIrqVec:			.byte 0
tlcsIrqDirty:		.byte 0
tlcsHaltMode:		.byte 0
tlcsPadding2:		.space 3
tlcsStateEnd:

tff3Function:		.long 0
romBaseLo:			.long 0
romBaseHi:			.long 0
biosBase:			.long 0
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

	.equ RegW, 0x01
	.equ RegA, 0x00
	.equ RegB, 0x05
	.equ RegC, 0x04
	.equ RegD, 0x09
	.equ RegE, 0x08
	.equ RegH, 0x0D
	.equ RegL, 0x0C
	.equ RWA,  0x00
	.equ RXWA, 0x00
	.equ RBC,  0x04
	.equ RXBC, 0x04
	.equ RDE,  0x08
	.equ RXDE, 0x08
	.equ RHL,  0x0C
	.equ RXHL, 0x0C
	.equ RIX,  0x10
	.equ RXIX, 0x10
	.equ RIY,  0x14
	.equ RXIY, 0x14
	.equ RIZ,  0x18
	.equ RXIZ, 0x18
	.equ RSP,  0x1C
	.equ RXSP, 0x1C
