//
//  TLCS900H_single.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2024 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "TLCS900H_mac.h"

	.global sngNOP
	.global sngNORMAL
	.global sngMAX
	.global sngHALT
	.global sngLD8_8
	.global sngLD8_16
	.global sngRCF
	.global sngSCF
	.global sngCCF
	.global sngZCF
	.global sngJP16
	.global sngJP24
	.global sngPUSH8
	.global sngPUSH16
	.global sngPUSHA
	.global sngPUSHF
	.global sngPUSHSR
	.global sngPOPA
	.global sngPOPF
	.global sngPOPSR
	.global sngRET
	.global sngRETD
	.global sngRETI
	.global sngINCF
	.global sngDECF
	.global sngLDF
	.global sngEI
	.global sngEX
	.global sngCALL16
	.global sngCALL24
	.global sngCALR
	.global sngLDiRW
	.global sngLDiRA
	.global sngLDiRB
	.global sngLDiRC
	.global sngLDiRD
	.global sngLDiRE
	.global sngLDiRH
	.global sngLDiRL
	.global sngLDW
	.global sngLDL
	.global sngPUSHW
	.global sngPUSHL
	.global sngPOPW
	.global sngPOPL

	.global sngJR_never
	.global sngJR_lt
	.global sngJR_le
	.global sngJR_ule
	.global sngJR_ov
	.global sngJR_mi
	.global sngJR_z
	.global sngJR_c
	.global sngJR
	.global sngJR_ge
	.global sngJR_gt
	.global sngJR_ugt
	.global sngJR_nov
	.global sngJR_pl
	.global sngJR_nz
	.global sngJR_nc
	.global sngJRL_never
	.global sngJRL_lt
	.global sngJRL_le
	.global sngJRL_ule
	.global sngJRL_ov
	.global sngJRL_mi
	.global sngJRL_z
	.global sngJRL_c
	.global sngJRL
	.global sngJRL_ge
	.global sngJRL_gt
	.global sngJRL_ugt
	.global sngJRL_nov
	.global sngJRL_pl
	.global sngJRL_nz
	.global sngJRL_nc
	.global sngLDX
	.global sngSWI
	.global sngSWI2

	.syntax unified
	.arm

;@----------------------------------------------------------------------------
#ifdef GBA
	.section .iwram, "ax", %progbits	;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
	.align 2
;@----------------------------------------------------------------------------
;@----------------------------------------------------------------------------
sngNOP:						;@ 0x00, No Operation
;@----------------------------------------------------------------------------
	t9fetch 2
;@----------------------------------------------------------------------------
sngNORMAL:					;@ 0x01, flag thing not on TLSC-900H
;@----------------------------------------------------------------------------
;@----------------------------------------------------------------------------
sngMAX:						;@ 0x04, flag thing not on TLSC-900H
;@----------------------------------------------------------------------------
	t9fetch 4
;@----------------------------------------------------------------------------
sngHALT:					;@ 0x05, Halt CPU
;@----------------------------------------------------------------------------
	sub t9pc,t9pc,#1
	movs r0,t9cycles,asr#T9CYC_SHIFT+2			;@
	bicpl t9cycles,t9cycles,r0,lsl#T9CYC_SHIFT+2	;@ Consume all cycles in steps of 4.
	t9fetch 8
;@----------------------------------------------------------------------------
sngLD8_8:					;@ 0x08, Store immediate byte in low memory.
;@----------------------------------------------------------------------------
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	bl t9StoreB_Low
	t9fetch 5
;@----------------------------------------------------------------------------
sngLD8_16:					;@ 0x0A, Store immediate word in low memory.
;@----------------------------------------------------------------------------
	ldrb t9Mem,[t9pc],#1
	ldrb r0,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r0,r0,r2,lsl#8
	bl t9StoreW_mem
	t9fetch 6

;@----------------------------------------------------------------------------
sngRCF:						;@ 0x10, Reset Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_H+PSR_C+PSR_n	;@ Clear HC and (V or N), manual not clear about it.
	t9fetch 2
;@----------------------------------------------------------------------------
sngSCF:						;@ 0x11, Set Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_H|PSR_n	;@ Clear HN
	orr t9f,t9f,#PSR_C			;@ Set C
	t9fetch 2
;@----------------------------------------------------------------------------
sngCCF:						;@ 0x12, Complement Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_n			;@ Clear N, actually H is unknown as well (old C?).
	eor t9f,t9f,#PSR_C			;@ Invert C
	t9fetch 2
;@----------------------------------------------------------------------------
sngZCF:						;@ 0x13, Zero to Carry Flag
;@----------------------------------------------------------------------------
	bic t9f,t9f,#PSR_n|PSR_C	;@ Clear N, actually H is unknown as well (old C?).
	tst t9f,#PSR_Z				;@ Z
	orreq t9f,t9f,#PSR_C		;@ Inverted Z to C
	t9fetch 2
;@----------------------------------------------------------------------------
sngJP16:					;@ 0x1A, Jump to 16bit address
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr t9pc,r0,r1,lsl#8
	bl reencode_pc
	t9fetch 7
;@----------------------------------------------------------------------------
sngJP24:					;@ 0x1B, Jump to 24bit address
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	orr r0,r0,r1,lsl#8
	orr t9pc,r0,r2,lsl#16
	bl reencode_pc
	t9fetch 7

;@----------------------------------------------------------------------------
sngPUSH8:					;@ 0x09 Push immediate byte
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	bl push8
	t9fetch 4
;@----------------------------------------------------------------------------
sngPUSH16:					;@ 0x0B Push immediate word
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	bl push16
	t9fetch 5
;@----------------------------------------------------------------------------
sngPUSHA:					;@ 0x14 Push register A
;@----------------------------------------------------------------------------
	ldrb r0,[t9gprBank,#RegA]
	bl push8
	t9fetch 3
;@----------------------------------------------------------------------------
sngPUSHF:					;@ 0x18 Push Flag register
;@----------------------------------------------------------------------------
	and r0,t9f,#PSR_H
	and r1,t9f,#PSR_S|PSR_Z
	orr r0,r0,r1,lsl#4
	movs r1,t9f,lsl#31
	orrmi r0,r0,#VF
	and r1,t9f,#PSR_n
	adc r0,r0,r1,lsr#6			;@ NF & CF

	bl push8
	t9fetch 3
;@----------------------------------------------------------------------------
sngPUSHSR:					;@ 0x02 Push Status Register
;@----------------------------------------------------------------------------
	bl pushSR
	t9fetch 4
;@----------------------------------------------------------------------------
sngPOPA:					;@ 0x15 Pop register A
;@----------------------------------------------------------------------------
	bl pop8
	strb r0,[t9gprBank,#RegA]
	t9fetch 4
;@----------------------------------------------------------------------------
sngPOPF:					;@ 0x19 Pop Flag register
;@----------------------------------------------------------------------------
	bl pop8

	and t9f,r0,#HF
	tst r0,#CF
	orrne t9f,t9f,#PSR_C
	and r1,r0,#SF|ZF
	movs r0,r0,lsl#30
	adc t9f,t9f,r1,lsr#4		;@ Also sets V/P Flag.
	orrmi t9f,t9f,#PSR_n

	t9fetch 4
;@----------------------------------------------------------------------------
sngPOPSR:					;@ 0x03 Pop Status Register
;@----------------------------------------------------------------------------
	bl pop16
	bl setStatusReg
	bl checkInterrupt

	t9fetch 6

;@----------------------------------------------------------------------------
sngRETI:					;@ 0x07 Return from Interrupt
;@----------------------------------------------------------------------------
	bl pop16
	bl setStatusReg

	bl pop32
	bl encode_r0_pc

	bl checkInterrupt

	t9fetch 12
;@----------------------------------------------------------------------------
sngINCF:					;@ 0x0C Increment Register File Pointer
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsSrB]
	add r0,r0,#1
	bl setStatusRFP
	t9fetch 2
;@----------------------------------------------------------------------------
sngDECF:					;@ 0x0D Decrement Register File Pointer
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsSrB]
	sub r0,r0,#1
	bl setStatusRFP
	t9fetch 2
;@----------------------------------------------------------------------------
sngLDF:						;@ 0x17 Load Register File Pointer
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	bl setStatusRFP
	t9fetch 2
;@----------------------------------------------------------------------------
sngEI:						;@ 0x06 Enable Interrupt
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	bl setStatusIFF
	bl checkInterrupt
	t9fetch 5
;@----------------------------------------------------------------------------
sngEX:						;@ 0x16 Exchange F & F'
;@----------------------------------------------------------------------------
	mov r0,t9f
	ldrb t9f,[t9ptr,#tlcsFDash]
	strb r0,[t9ptr,#tlcsFDash]
	t9fetch 2

;@----------------------------------------------------------------------------
sngCALL16:					;@ 0x1C Call 16bit address
;@----------------------------------------------------------------------------
	ldr r0,[t9ptr,#tlcsLastBank]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	sub r0,t9pc,r0
	orr t9pc,r1,r2,lsl#8		;@ New pc
	bl push32					;@ Push old pc
	bl reencode_pc
	t9fetch 12
;@----------------------------------------------------------------------------
sngCALL24:					;@ 0x1D Call 24bit address
;@----------------------------------------------------------------------------
	ldr r0,[t9ptr,#tlcsLastBank]
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	ldrb r3,[t9pc],#1
	sub r0,t9pc,r0
	orr r1,r1,r2,lsl#8
	orr t9pc,r1,r3,lsl#16		;@ New pc
	bl push32					;@ Push old pc
	bl reencode_pc
	t9fetch 12
;@----------------------------------------------------------------------------
sngCALR:					;@ 0x1E Call Relative PC+d16
;@----------------------------------------------------------------------------
	ldr r0,[t9ptr,#tlcsLastBank]
	ldrb r1,[t9pc],#1
	ldrsb r2,[t9pc],#1
	orr r2,r1,r2,lsl#8			;@ Offset
	sub r0,t9pc,r0				;@ New pc
	add t9pc,t9pc,r2
	bl push32					;@ Push old pc
	t9fetch 12

;@----------------------------------------------------------------------------
sngLDiRW:					;@ 0x20 Load immediate byte to W
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	strb r0,[t9gprBank,#RegW]
	t9fetch 2
;@----------------------------------------------------------------------------
sngLDiRA:					;@ 0x21 Load immediate byte to A
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	strb r0,[t9gprBank,#RegA]
	t9fetch 2
;@----------------------------------------------------------------------------
sngLDiRB:					;@ 0x22 Load immediate byte to B
sngLDiRC:					;@ 0x23 Load immediate byte to C
sngLDiRD:					;@ 0x24 Load immediate byte to D
sngLDiRE:					;@ 0x25 Load immediate byte to E
sngLDiRH:					;@ 0x26 Load immediate byte to H
sngLDiRL:					;@ 0x27 Load immediate byte to L
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	and t9Reg,t9opCode,#0x07
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
	strb r0,[t9gprBank,t9Reg,ror#30]
	t9fetch 2
;@----------------------------------------------------------------------------
sngLDW:						;@ 0x30-0x37 Load immediate word to reg
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	and t9Reg,t9opCode,#0x07
	mov t9Reg,t9Reg,lsl#2
	orr r0,r0,r1,lsl#8
	strh r0,[t9gprBank,t9Reg]
	t9fetch 3
;@----------------------------------------------------------------------------
sngLDL:						;@ 0x40-0x47 Load immediate long to reg
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	ldrb r2,[t9pc],#1
	ldrb r3,[t9pc],#1
	and t9Reg,t9opCode,#0x07
	orr r0,r0,r1,lsl#8
	orr r0,r0,r2,lsl#16
	orr r0,r0,r3,lsl#24
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 5
;@----------------------------------------------------------------------------
sngPUSHW:					;@ 0x28-0x2F Push word
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl push16
	t9fetch 3
;@----------------------------------------------------------------------------
sngPUSHL:					;@ 0x38-0x3F Push long
;@----------------------------------------------------------------------------
	and t9Reg,t9opCode,#0x07
	ldr r0,[t9gprBank,t9Reg,lsl#2]
	bl push32
	t9fetch 5
;@----------------------------------------------------------------------------
sngPOPW:					;@ 0x48-0x4F Pop word
;@----------------------------------------------------------------------------
	bl pop16
	and t9Reg,t9opCode,#0x07
	mov t9Reg,t9Reg,lsl#2
	strh r0,[t9gprBank,t9Reg]
	t9fetch 4
;@----------------------------------------------------------------------------
sngPOPL:					;@ 0x58-0x5F Pop long
;@----------------------------------------------------------------------------
	bl pop32
	and t9Reg,t9opCode,#0x07
	str r0,[t9gprBank,t9Reg,lsl#2]
	t9fetch 6
;@----------------------------------------------------------------------------
sngRET:						;@ 0x0E Return
;@----------------------------------------------------------------------------
	bl pop32
	bl encode_r0_pc
	t9fetch 9
;@----------------------------------------------------------------------------
sngRETD:					;@ 0x0F Return and Deallocate
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrb r1,[t9pc],#1
	orr t9pc,r0,r1,lsl#8		;@ Use t9pc as temp register.
	bl pop32

	ldr r1,[t9gprBank,#RXSP]
	add r1,r1,t9pc
	str r1,[t9gprBank,#RXSP]
	bl encode_r0_pc

	t9fetch 9
;@----------------------------------------------------------------------------
sngJR_never:				;@ 0x60, Jump Relative never
;@----------------------------------------------------------------------------
	add t9pc,t9pc,#1
	t9fetchr 4
;@----------------------------------------------------------------------------
sngJR_lt:					;@ 0x61, Jump Relative Less Than
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	eor r1,t9f,t9f,lsr#3		;@ S^V
	tst r1,#PSR_V
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_le:					;@ 0x62, Jump Relative Less or Equal
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	mov r1,t9f,lsl#28
	msr cpsr_flg,r1
	addle t9pc,t9pc,r0
	suble t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_ule:					;@ 0x63, Jump Relative Unsigned Less or Equal
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	orr r1,t9f,t9f,lsr#1		;@ C|Z
	tst r1,#PSR_C
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_ov:					;@ 0x64, Jump Relative Overflow
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_V
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_mi:					;@ 0x65, Jump Relative Minus
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_S
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetchr 4
;@----------------------------------------------------------------------------
sngJR_z:					;@ 0x66, Jump Relative Zero
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_Z
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetchr 4
;@----------------------------------------------------------------------------
sngJR_c:					;@ 0x67, Jump Relative Carry
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_C
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR:						;@ 0x68, Jump Relative
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	add t9pc,t9pc,r0
	t9fetchr 8
;@----------------------------------------------------------------------------
sngJR_ge:					;@ 0x69, Jump Relative Greater or Equal
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	eor r1,t9f,t9f,lsr#3		;@ S^V
	tst r1,#PSR_V
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_gt:					;@ 0x6A, Jump Relative Greater Than
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	mov r1,t9f,lsl#28
	msr cpsr_flg,r1
	addgt t9pc,t9pc,r0
	subgt t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_ugt:					;@ 0x6B, Jump Relative Unsigned Greater Than
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	orr r1,t9f,t9f,lsr#1		;@ C|Z
	tst r1,#PSR_C
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_nov:					;@ 0x6C, Jump Relative Not Overflow
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_V
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJR_pl:					;@ 0x6D, Jump Relative Plus
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_S
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetchr 4
;@----------------------------------------------------------------------------
sngJR_nz:					;@ 0x6E, Jump Relative Not Zero
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_Z
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetchr 4
;@----------------------------------------------------------------------------
sngJR_nc:					;@ 0x6F, Jump Relative Not Carry
;@----------------------------------------------------------------------------
	ldrsb r0,[t9pc],#1
	tst t9f,#PSR_C
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4

;@----------------------------------------------------------------------------
sngJRL_never:				;@ 0x70 Jump Relative Long, Never
;@----------------------------------------------------------------------------
	add t9pc,t9pc,#2
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_lt:					;@ 0x71 Jump Relative Long, Less Than
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	eor r1,t9f,t9f,lsr#3		;@ S^V
	tst r1,#PSR_V
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_le:					;@ 0x72 Jump Relative Long, Less or Equal
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	mov r1,t9f,lsl#28
	msr cpsr_flg,r1
	addle t9pc,t9pc,r0
	suble t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_ule:					;@ 0x73 Jump Relative Long, Unsigned Less or Equal
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	orr r1,t9f,t9f,lsr#1		;@ C|Z
	tst r1,#PSR_C
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_ov:					;@ 0x74 Jump Relative Long, Overflow
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_V
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_mi:					;@ 0x75 Jump Relative Long, Minus
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_S
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_z:					;@ 0x76 Jump Relative Long, Zero
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_Z
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_c:					;@ 0x77 Jump Relative Long, Carry
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_C
	addne t9pc,t9pc,r0
	subne t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL:						;@ 0x78 Jump Relative Long
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	add t9pc,t9pc,r0
	t9fetch 8
;@----------------------------------------------------------------------------
sngJRL_ge:					;@ 0x79 Jump Relative Long, Greater or Equal
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	eor r1,t9f,t9f,lsr#3		;@ S^V
	tst r1,#PSR_V
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_gt:					;@ 0x7A Jump Relative Long, Greater Than
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	mov r1,t9f,lsl#28
	msr cpsr_flg,r1
	addgt t9pc,t9pc,r0
	subgt t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_ugt:					;@ 0x7B Jump Relative Long, Unsigned Greater
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	orr r1,t9f,t9f,lsr#1		;@ C|Z
	tst r1,#PSR_C
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_nov:					;@ 0x7C Jump Relative Long, Not Overflow
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_V
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_pl:					;@ 0x7D Jump Relative Long, Plus
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_S
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_nz:					;@ 0x7E Jump Relative Long, Not Zero
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_Z
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4
;@----------------------------------------------------------------------------
sngJRL_nc:					;@ 0x7F Jump Relative Long, Not Carry
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldrsb r1,[t9pc],#1
	orr r0,r0,r1,lsl#8
	tst t9f,#PSR_C
	addeq t9pc,t9pc,r0
	subeq t9cycles,t9cycles,#4*T9CYCLE
	t9fetch 4

;@----------------------------------------------------------------------------
sngLDX:						;@ 0xF7 Load eXtract
;@----------------------------------------------------------------------------
	add t9pc,t9pc,#1			;@ Skip 1 byte
	ldrb t9Mem,[t9pc],#2		;@ Skip more
	ldrb r0,[t9pc],#2			;@ Skip even more
	bl t9StoreB_Low
	t9fetch 9
;@----------------------------------------------------------------------------
;@sngSWI_0:					;@ 0xF8 Reset.
;@----------------------------------------------------------------------------
;@sngSWI_1:					;@ 0xF9 System call handler/Default interrupt.
;@----------------------------------------------------------------------------
sngSWI2:					;@ 0xFA Illegal instruction interrupt.
;@----------------------------------------------------------------------------
	mov t9opCode,#2
;@----------------------------------------------------------------------------
;@sngSWI_3:					;@ 0xFB User SWI.
;@----------------------------------------------------------------------------
;@sngSWI_4:					;@ 0xFC User SWI.
;@----------------------------------------------------------------------------
;@sngSWI_5:					;@ 0xFD User SWI.
;@----------------------------------------------------------------------------
;@sngSWI_6:					;@ 0xFE User SWI.
;@----------------------------------------------------------------------------
;@sngSWI_7:					;@ 0xFF Unknown debug?
;@----------------------------------------------------------------------------
sngSWI:
;@----------------------------------------------------------------------------
	ldr r0,[t9ptr,#tlcsLastBank]
	sub r0,t9pc,r0
	bl push32
	bl pushSR

	ldr r1,=0xFFFF00			;@ Interrupt vector
	and r0,t9opCode,#0x07
	add r0,r1,r0,lsl#2
	bl t9LoadL
	bl encode_r0_pc
	t9fetch 19

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
