//
//  TLCS900H.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2024 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "TLCS900H_mac.h"

	.global tlcs900HReset
	.global tlcsRestoreAndRunXCycles
	.global tlcsRunXCycles
	.global tlcs900HSaveState
	.global tlcs900HLoadState
	.global tlcs900HGetStateSize
	.global tlcs900HRedirectOpcode
	.global tlcsLoop
	.global tlcsEnd
	.global pushSR
	.global pop8
	.global pop16
	.global pop32
	.global ExR32
	.global ExDec
	.global ExInc
	.global generic_DIV_B
	.global generic_DIV_W
	.global generic_ADD_B
	.global generic_ADD_B_reg
	.global generic_ADD_B_mem
	.global generic_ADD_W
	.global generic_ADD_W_reg
	.global generic_ADD_L_reg
	.global generic_ADC_B
	.global generic_ADC_B_reg
	.global generic_ADC_B_mem
	.global generic_ADC_W
	.global generic_ADC_W_reg
	.global generic_ADC_L_reg
	.global generic_AND_B
	.global generic_AND_B_reg
	.global generic_AND_B_mem
	.global generic_AND_W
	.global generic_AND_W_reg
	.global generic_AND_L_reg
	.global generic_DEC_B
	.global generic_INC_B
	.global generic_OR_B
	.global generic_OR_B_reg
	.global generic_OR_B_mem
	.global generic_OR_W
	.global generic_OR_W_reg
	.global generic_OR_L_reg
	.global generic_SBC_B
	.global generic_SBC_B_reg
	.global generic_SBC_W
	.global generic_SBC_W_reg
	.global generic_SBC_L
	.global generic_SBC_L_reg
	.global generic_SUB_B
	.global generic_SUB_B_reg
	.global generic_SUB_B_mem
	.global generic_SUB_W
	.global generic_SUB_W_reg
	.global generic_SUB_L
	.global generic_SUB_L_reg
	.global generic_XOR_B
	.global generic_XOR_B_reg
	.global generic_XOR_B_mem
	.global generic_XOR_W
	.global generic_XOR_W_reg
	.global generic_XOR_L_reg
	.global conditionCode
	.global statusIFF
	.global setStatusReg
	.global setStatusIFF
	.global setStatusRFP
	.global encode_r0_pc
	.global reencode_pc
	.global storeTLCS900
	.global loadTLCS900
	.global unknown_RR_Target
	.global regError
	.global srcError
	.global dstError

	.global tlcs900HState

;@----------------------------------------------------------------------------
	.syntax unified
	.arm

#ifdef COUNT_OP_CODES
#if GBA
	.section .sbss				;@ For the GBA
#else
	.section .bss				;@ For anything else
#endif
opcodeCounter:
	.space 256*4
#endif

#ifdef NDS
	.section .itcm						;@ For the NDS ARM9
#elif GBA
	.section .iwram, "ax", %progbits	;@ For the GBA
#else
	.section .text						;@ For anything else
#endif
	.align 2
;@----------------------------------------------------------------------------
tlcsRestoreAndRunXCycles:				;@ r0 = cycles to add
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	bl loadTLCS900
;@----------------------------------------------------------------------------
tlcsRunXCycles:							;@ r0 = cycles to add
;@----------------------------------------------------------------------------
	ldrb r1,[t9ptr,#tlcsCycShift]
	add t9cycles,t9cycles,r0,lsl r1
	bl updateTimers				;@ updateTimers(int cycles)
	bl checkInterrupt
	cmp t9cycles,#0

tlcsLoop:
#ifdef DEBUG
	ldr r12,[t9ptr,#tlcsLastBank]
	sub r12,t9pc,r12
	mov r12,r12
	b debugContinue
	.short 0x6464,0x0000
	.string "PC %r12%"
	.align 2
debugContinue:
#endif
#ifdef COUNT_OP_CODES
	ldrb r0,[t9pc]
	ldr r1,=opcodeCounter
	ldr r0,[r1,r0,lsl#2]!
	add r0,r0,#1
	cmp r0,#0x1000000
	bpl dumpOpCodes
	str r0,[r1]
	cmp t9cycles,#0
#endif
	ldrbpl t9opCode,[t9pc],#1
	ldrpl pc,[t9ptr,t9opCode,lsl#2]
tlcsEnd:
	ldmfd sp!,{lr}
;@----------------------------------------------------------------------------
storeTLCS900:
;@----------------------------------------------------------------------------
	strb t9f,[t9ptr,#tlcsF]
	str t9pc,[t9ptr,#tlcsPcAsm]
	str t9cycles,[t9ptr,#tlcsCycles]
	bx lr
;@----------------------------------------------------------------------------
loadTLCS900:
;@----------------------------------------------------------------------------
	ldrb t9f,[t9ptr,#tlcsF]
	ldr t9cycles,[t9ptr,#tlcsCycles]
	ldr t9pc,[t9ptr,#tlcsPcAsm]
	ldr t9gprBank,[t9ptr,#tlcsCurrentGprBank]
	bx lr

;@----------------------------------------------------------------------------
pushSR:
;@----------------------------------------------------------------------------
	and r0,t9f,#PSR_H
	and r1,t9f,#PSR_S|PSR_Z
	orr r0,r0,r1,lsl#4
	movs r1,t9f,lsl#31
	orrmi r0,r0,#VF
	and r1,t9f,#PSR_n
	adc r0,r0,r1,lsr#6			;@ NF & CF

	ldrb r1,[t9ptr,#tlcsSrB]
	orr r0,r0,r1,lsl#8
	b push16
;@----------------------------------------------------------------------------
pop8:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#RXSP]
	add r1,r0,#1
	str r1,[t9gprBank,#RXSP]
	b t9LoadB
;@----------------------------------------------------------------------------
pop16:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#RXSP]
	add r1,r0,#2
	str r1,[t9gprBank,#RXSP]
	b t9LoadW
;@----------------------------------------------------------------------------
pop32:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#RXSP]
	add r1,r0,#4
	str r1,[t9gprBank,#RXSP]
	b t9LoadL

;@----------------------------------------------------------------------------
ExR32:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	cmp r0,#0x03
	beq exr32_03
	cmp r0,#0x07
	beq exr32_07
	cmp r0,#0x13			;@ Undocumented. See CPU manual p43
	beq exr32_13

	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,r0]
	bic t9Reg,t9Reg,#3
	ldr t9Mem,[t9gprBank,t9Reg]
	ands r0,r0,#3
	beq exr32End
	ldrb r0,[t9pc],#1
	add t9Mem,t9Mem,r0
	ldrsb r0,[t9pc],#1
	add t9Mem,t9Mem,r0,lsl#8
exr32End:
	t9eatcycles 5
	bx lr

exr32_03:					;@ r32+r8
	ldrb r0,[t9pc],#1
	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,r0]
	bic t9Reg,t9Reg,#3
	ldr t9Mem,[t9gprBank,t9Reg]
	ldrb r0,[t9pc],#1
	ldrsb t9Reg,[r2,r0]
	ldrsb r0,[t9gprBank,t9Reg]
	add t9Mem,t9Mem,r0

	t9eatcycles 8
	bx lr

exr32_07:					;@ r32+r16
	ldrb r0,[t9pc],#1
	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,r0]
	bic t9Reg,t9Reg,#3
	ldr t9Mem,[t9gprBank,t9Reg]
	ldrb r0,[t9pc],#1
	ldrsb t9Reg,[r2,r0]
	bic t9Reg,t9Reg,#1
	ldrsh r0,[t9gprBank,t9Reg]
	add t9Mem,t9Mem,r0

	t9eatcycles 8
	bx lr

exr32_13:					;@ pc+d16
	ldrb t9Mem,[t9pc],#1
	ldrsb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#8
	ldr r0,[t9ptr,#tlcsLastBank]
	sub r0,t9pc,r0
	add t9Mem,t9Mem,r0
	t9eatcycles 8
	bx lr
;@----------------------------------------------------------------------------
ExDec:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	and t9Reg,r0,#0xFC
	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,t9Reg]
	ldr t9Mem,[t9gprBank,t9Reg]
	ands r0,r0,#3
	addeq r0,r0,#0x80000000
;@	cmp r0,#3
;@	beq UnknownOpCode
	sub t9Mem,t9Mem,r0,ror#31
	str t9Mem,[t9gprBank,t9Reg]

	t9eatcycles 3
	bx lr
;@----------------------------------------------------------------------------
ExInc:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	and t9Reg,r0,#0xFC
	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,t9Reg]
	ldr t9Mem,[t9gprBank,t9Reg]
	ands r0,r0,#3
	addeq r0,r0,#0x80000000
;@	cmp r0,#3
;@	beq UnknownOpCode
	add r0,t9Mem,r0,ror#31
	str r0,[t9gprBank,t9Reg]

	t9eatcycles 3
	bx lr

;@UnknownOpCode:
;@	mov r11,r11
;@	add r0,r0,#1
;@	bx lr

;@----------------------------------------------------------------------------
	

;@----------------------------------------------------------------------------
conditionCode:				;@ (int cc)
;@----------------------------------------------------------------------------
	eor r1,t9f,#PSR_C
	mov r1,r1,lsl#28
	and r2,r0,#0x0F
	mov r0,#0
	msr cpsr_f,r1				;@ S,Z,V&C
	add pc,pc,r2,lsl#3
	mov r11,r11

cc_false:
	mov r0,#0
	bx lr
cc_lt:
	movlt r0,#1
	bx lr
cc_le:
	movle r0,#1
	bx lr
cc_ls:
	movls r0,#1
	bx lr
cc_vs:
	movvs r0,#1
	bx lr
cc_mi:
	movmi r0,#1
	bx lr
cc_eq:
	moveq r0,#1
	bx lr
cc_cs:
	movcc r0,#1
	bx lr
cc_al:
	mov r0,#1
	bx lr
cc_ge:
	movge r0,#1
	bx lr
cc_gt:
	movgt r0,#1
	bx lr
cc_hi:
	movhi r0,#1
	bx lr
cc_vc:
	movvc r0,#1
	bx lr
cc_pl:
	movpl r0,#1
	bx lr
cc_ne:
	movne r0,#1
	bx lr
cc_cc:
	movcs r0,#1
	bx lr


;@	case 0:	return 0;	//(F)
;@	case 1:	if (FLAG_S ^ FLAG_V) return 1; else return 0;	//(LT)
;@	case 2:	if (FLAG_Z | (FLAG_S ^ FLAG_V)) return 1; else return 0;	//(LE)
;@	case 3:	if (FLAG_C | FLAG_Z) return 1; else return 0;	//(ULE)
;@	case 4:	if (FLAG_V) return 1; else return 0;	//(OV)
;@	case 5:	if (FLAG_S) return 1; else return 0;	//(MI)
;@	case 6:	if (FLAG_Z) return 1; else return 0;	//(Z)
;@	case 7:	if (FLAG_C) return 1; else return 0;	//(C)
;@	case 8:	return 1;	//always True
;@	case 9:	if (FLAG_S ^ FLAG_V) return 0; else return 1;	//(GE)
;@	case 10: if (FLAG_Z | (FLAG_S ^ FLAG_V)) return 0; else return 1;	//(GT)
;@	case 11: if (FLAG_C | FLAG_Z) return 0; else return 1;	//(UGT)
;@	case 12: if (FLAG_V) return 0; else return 1;	//(NOV)
;@	case 13: if (FLAG_S) return 0; else return 1;	//(PL)
;@	case 14: if (FLAG_Z) return 0; else return 1;	//(NZ)
;@	case 15: if (FLAG_C) return 0; else return 1;	//(NC)

;@----------------------------------------------------------------------------
generic_DIV_B:				;@ r0= u16 val, r1= u8 div
;@----------------------------------------------------------------------------
	orr t9f,t9f,#PSR_V
	cmp r1,#0					;@ Div by zero
	moveq r1,r0,lsr#8
	andeq r0,r0,#0xFF
	eoreq r1,r1,#0xFF
	orreq r0,r1,r0,lsl#8
	bxeq lr

#ifdef GBA
	swi 0x060000				;@ GBA BIOS Div, r0/r1.
#elif NDS
	swi 0x090000				;@ NDS BIOS Div, r0/r1.
#else
	#error "Needs an implementation of division"
#endif
	cmp r0,#0x100
	bicmi t9f,t9f,#PSR_V
	and r0,r0,#0xFF
	and r1,r1,#0xFF
	orr r0,r0,r1,lsl#8
	bx lr
;@----------------------------------------------------------------------------
generic_DIV_W:				;@ r0= u32 val, r1= u16 div
;@----------------------------------------------------------------------------
	orr t9f,t9f,#PSR_V
	cmp r1,#0					;@ Div by zero
	moveq r1,r0,lsl#16
	mvneq r0,r0
	orreq r0,r1,r0,lsr#16
	bxeq lr

#ifdef GBA
	swi 0x060000				;@ GBA BIOS Div, r0/r1.
#elif NDS
	swi 0x090000				;@ NDS BIOS Div, r0/r1.
#else
	#error "Needs an implementation of division"
#endif
	cmp r0,#0x10000
	bicmi t9f,t9f,#PSR_V
	mov r0,r0,lsl#16
	mov r0,r0,lsr#16
	orr r0,r0,r1,lsl#16
	bx lr

;@----------------------------------------------------------------------------
generic_AND_B_mem:			;@ r0=dst
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
;@----------------------------------------------------------------------------
generic_AND_B_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
;@----------------------------------------------------------------------------
generic_AND_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	and r0,r0,r1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orr t9f,t9f,#PSR_H
	bx lr
;@----------------------------------------------------------------------------
generic_AND_W_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
;@----------------------------------------------------------------------------
generic_AND_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	and r0,r0,r1
	movs r1,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	orr t9f,t9f,#PSR_H+PSR_S+PSR_Z
	bicpl t9f,t9f,#PSR_S
	bicne t9f,t9f,#PSR_Z
	bx lr
;@----------------------------------------------------------------------------
generic_AND_L_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	ands r0,r0,r1
	eor r1,r0,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	orr t9f,t9f,#PSR_H+PSR_S+PSR_Z
	bicpl t9f,t9f,#PSR_S
	bicne t9f,t9f,#PSR_Z
	bx lr
;@----------------------------------------------------------------------------
generic_OR_B_mem:			;@ r0=dst
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
;@----------------------------------------------------------------------------
generic_OR_B_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
;@----------------------------------------------------------------------------
generic_OR_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	orr r0,r0,r1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	bx lr
;@----------------------------------------------------------------------------
generic_OR_W_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
;@----------------------------------------------------------------------------
generic_OR_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	orr r0,r0,r1
	movs r1,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	bx lr
;@----------------------------------------------------------------------------
generic_OR_L_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	orrs r0,r0,r1
	eor r1,r0,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	bx lr
;@----------------------------------------------------------------------------
generic_XOR_B_mem:			;@ r0=dst
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
;@----------------------------------------------------------------------------
generic_XOR_B_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
;@----------------------------------------------------------------------------
generic_XOR_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	eor r0,r0,r1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	bx lr
;@----------------------------------------------------------------------------
generic_XOR_W_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
;@----------------------------------------------------------------------------
generic_XOR_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	eor r0,r0,r1
	movs r1,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	bx lr
;@----------------------------------------------------------------------------
generic_XOR_L_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	eors r0,r0,r1
	eor r1,r0,r0,lsl#16
	eor r1,r1,r1,lsl#8
	add r2,t9ptr,#tlcsPzst
	ldrb t9f,[r2,r1,lsr#24]		;@ Get PZS
	bic t9f,t9f,#PSR_S|PSR_Z
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	bx lr
;@----------------------------------------------------------------------------
generic_ADD_B_mem:			;@ r0=dst
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
;@----------------------------------------------------------------------------
generic_ADD_B_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
;@----------------------------------------------------------------------------
generic_ADD_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#24

	mov r2,r0,lsl#4				;@ Prepare for check of half carry
	adds r0,r0,r1,lsl#24
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	cmn r2,r1,lsl#28
	orrcs t9f,t9f,#PSR_H

	mov r0,r0,lsr#24
	bx lr
;@----------------------------------------------------------------------------
generic_ADD_W_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
;@----------------------------------------------------------------------------
generic_ADD_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#16

	mov r2,r0,lsl#12			;@ Prepare for check of half carry
	adds r0,r0,r1,lsl#16
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	cmn r2,r1,lsl#28
	orrcs t9f,t9f,#PSR_H

	mov r0,r0,lsr#16
	bx lr
;@----------------------------------------------------------------------------
generic_ADD_L_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	mov r2,r0,lsl#4				;@ Prepare for check of half carry
	adds r0,r0,r1
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	cmn r2,r1,lsl#4
	orrcs t9f,t9f,#PSR_H

	bx lr
;@----------------------------------------------------------------------------
generic_ADC_B_mem:			;@ r0=dst
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
;@----------------------------------------------------------------------------
generic_ADC_B_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
;@----------------------------------------------------------------------------
generic_ADC_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#24

	movs t9f,t9f,lsr#2			;@ Get C
	subcs r1,r1,#0x100
	eor t9f,r1,r0,lsr#24		;@ Prepare for check of half carry
	adcs r0,r0,r1,ror#8
	mrs r1,cpsr					;@ S,Z,V&C
	eor t9f,t9f,r0,lsr#24
	and t9f,t9f,#PSR_H			;@ H, correct
	orr t9f,t9f,r1,lsr#28

	mov r0,r0,lsr#24
	bx lr
;@----------------------------------------------------------------------------
generic_ADC_W_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
;@----------------------------------------------------------------------------
generic_ADC_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#16

	movs t9f,t9f,lsr#2			;@ Get C
	subcs r1,r1,#0x10000
	eor t9f,r1,r0,lsr#16		;@ Prepare for check of half carry
	adcs r0,r0,r1,ror#16
	mrs r1,cpsr					;@ S,Z,V&C
	eor t9f,t9f,r0,lsr#16
	and t9f,t9f,#PSR_H			;@ H, correct
	orr t9f,t9f,r1,lsr#28

	mov r0,r0,lsr#16
	bx lr
;@----------------------------------------------------------------------------
generic_ADC_L_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
	movs t9f,t9f,lsr#2			;@ Get C
	eor t9f,r0,r1				;@ Prepare for check of half carry
	adcs r0,r0,r1
	mrs r1,cpsr					;@ S,Z,V&C
	eor t9f,t9f,r0
	and t9f,t9f,#PSR_H			;@ H, correct
	orr t9f,t9f,r1,lsr#28

	bx lr
;@----------------------------------------------------------------------------
generic_DEC_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#24

	orr t9f,t9f,#PSR_n+PSR_H+PSR_S+PSR_V+PSR_Z	;@ Save carry & set n
	mov r2,r0,lsl#4				;@ Prepare for H check
	subs r0,r0,r1,lsl#24
	bicpl t9f,t9f,#PSR_S
	bicne t9f,t9f,#PSR_Z
	bicvc t9f,t9f,#PSR_V
	cmp r2,r1,lsl#28
	biccs t9f,t9f,#PSR_H

	mov r0,r0,lsr#24
	bx lr
;@----------------------------------------------------------------------------
generic_INC_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#24

	and t9f,t9f,#PSR_C			;@ Save carry & clear n
	mov r2,r0,lsl#4				;@ Prepare for H check
	adds r0,r0,r1,lsl#24
	orrmi t9f,t9f,#PSR_S
	orreq t9f,t9f,#PSR_Z
	orrvs t9f,t9f,#PSR_V
	cmn r2,r1,lsl#28
	orrcs t9f,t9f,#PSR_H

	mov r0,r0,lsr#24
	bx lr
;@----------------------------------------------------------------------------
generic_SUB_B_mem:			;@ r0=dst
;@----------------------------------------------------------------------------
	movs t9Reg,t9Reg,lsr#1
	orrcc t9Reg,t9Reg,#0x40000000
;@----------------------------------------------------------------------------
generic_SUB_B_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
;@----------------------------------------------------------------------------
generic_SUB_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#24

	mov r2,r0,lsl#4 			;@ Prepare for check of half carry
	subs r0,r0,r1,lsl#24
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	eor t9f,t9f,#PSR_C|PSR_n	;@ Invert C and set n
	cmp r2,r1,lsl#28
	orrcc t9f,t9f,#PSR_H

	mov r0,r0,lsr#24
	bx lr
;@----------------------------------------------------------------------------
generic_SUB_W_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
;@----------------------------------------------------------------------------
generic_SUB_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#16

	mov r2,r0,lsl#12 			;@ Prepare for check of half carry
	subs r0,r0,r1,lsl#16
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	eor t9f,t9f,#PSR_C|PSR_n	;@ Invert C and set n
	cmp r2,r1,lsl#28
	orrcc t9f,t9f,#PSR_H

	mov r0,r0,lsr#16
	bx lr
;@----------------------------------------------------------------------------
generic_SUB_L_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
;@----------------------------------------------------------------------------
generic_SUB_L:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r2,r0,lsl#28 			;@ Prepare for check of half carry
	subs r0,r0,r1
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	eor t9f,t9f,#PSR_C|PSR_n	;@ Invert C and set n
	cmp r2,r1,lsl#28
	orrcc t9f,t9f,#PSR_H

	bx lr
;@----------------------------------------------------------------------------
generic_SBC_B_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrb r1,[t9gprBank,t9Reg,ror#30]
;@----------------------------------------------------------------------------
generic_SBC_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r0,r0,lsl#24

	and t9f,t9f,#PSR_C
	subs r1,r1,t9f,lsl#7		;@ Fix up r1 and set correct C.
	eor t9f,r1,r0,lsr#24		;@ Prepare for check of H
	sbcs r0,r0,r1,ror#8
	mrs r1,cpsr
	eor t9f,t9f,r0,lsr#24
	and t9f,t9f,#PSR_H			;@ H, correct
	orr t9f,t9f,r1,lsr#28		;@ S,Z,V&C
	eor t9f,t9f,#PSR_C|PSR_n	;@ Invert C and set n.

	mov r0,r0,lsr#24
	bx lr
;@----------------------------------------------------------------------------
generic_SBC_W_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldrh r1,[t9gprBank,t9Reg]
;@----------------------------------------------------------------------------
generic_SBC_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	and t9f,t9f,#PSR_C
	subs r1,r1,t9f,lsl#15		;@ Fix up r1 and set correct C.
	mov r1,r1,ror#16
	mov r2,r0,lsl#28			;@ Prepare for check of H
	rscs r0,r1,r0,lsl#16
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	eor t9f,t9f,#PSR_C|PSR_n	;@ Invert C and set n.
	cmp r2,r1,lsl#12
	orrcc t9f,t9f,#PSR_H

	mov r0,r0,lsr#16
	bx lr
;@----------------------------------------------------------------------------
generic_SBC_L_reg:			;@ r0=dst
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,t9Reg,lsl#2]
;@----------------------------------------------------------------------------
generic_SBC_L:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	and t9f,t9f,#PSR_C
	cmp t9f,t9f,lsl#1			;@ Set correct C.
	eor r2,r0,r1				;@ Prepare for check of H.
	sbcs r0,r0,r1
	mrs t9f,cpsr				;@ S,Z,V&C
	eor r2,r2,r0
	and r2,r2,#PSR_H
	orr t9f,r2,t9f,lsr#28
	eor t9f,t9f,#PSR_C|PSR_n	;@ Invert C and set n.

	bx lr
;@----------------------------------------------------------------------------
#if GBA
	.section .ewram, "ax", %progbits	;@ For the GBA
	.align 2
#endif
;@----------------------------------------------------------------------------
;@----------------------------------------------------------------------------
statusIFF:					;@ r0 out = current IFF
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsSrB]
	mov r0,r0,lsr#4
	and r0,r0,#0x7
	bx lr
;@----------------------------------------------------------------------------
setStatusIFF:				;@ r0 bit 0-2 = new IFF
;@----------------------------------------------------------------------------
	ldrb r1,[t9ptr,#tlcsSrB]
	bic r1,r1,#0x70
	orr r1,r1,r0,lsl#4
	strb r1,[t9ptr,#tlcsSrB]
	bx lr
;@----------------------------------------------------------------------------
setStatusReg:				;@ r0 bit 8,9 = new Register File Pointer, 12-14 = new IFF
;@----------------------------------------------------------------------------
	and t9f,r0,#HF
	tst r0,#CF
	orrne t9f,t9f,#PSR_C
	and r1,r0,#SF|ZF
	movs r2,r0,lsl#30
	adc t9f,t9f,r1,lsr#4		;@ Also sets V/P Flag.
	orrmi t9f,t9f,#PSR_n

	mov r0,r0,lsr#8
	and r0,r0,#0xFB				;@ RFP bit 2 always 0
	orr r0,r0,#0x88				;@ System and Maximum always set.
	b setSR
;@----------------------------------------------------------------------------
setStatusRFP:				;@ r0 bit 0,1 = new Register File Pointer
;@----------------------------------------------------------------------------
	and r0,r0,#0x03
	ldrb r1,[t9ptr,#tlcsSrB]
	bic r1,r1,#0x07
	orr r0,r1,r0
setSR:
	strb r0,[t9ptr,#tlcsSrB]
;@----------------------------------------------------------------------------
;@changedSR:
;@----------------------------------------------------------------------------
	ldrb r1,[t9ptr,#tlcsStatusRFP]
	and r0,r0,#0x03
	subs r1,r0,r1
	bxeq lr
	strb r0,[t9ptr,#tlcsStatusRFP]

	ldr r2,=registersOfsMap
	add r2,r2,r0,lsl#8					;@ x256
	str r2,[t9ptr,#tlcsCurrentMapBank]

	stmfd sp!,{r4}
	add t9gprBank,t9gprBank,#4*4
	ldmia t9gprBank,{r1-r4}				;@ Move IX, IY, IZ & SP to new location.
	add t9gprBank,t9ptr,#tlcsGprBanks
	add t9gprBank,t9gprBank,r0,lsl#5	;@ gprBank size = 4*8
	add r0,t9gprBank,#4*4
	stmia r0,{r1-r4}
	ldmfd sp!,{r4}

	str t9gprBank,[t9ptr,#tlcsCurrentGprBank]
	bx lr
;@----------------------------------------------------------------------------
encode_r0_pc:
;@----------------------------------------------------------------------------
	bic t9pc,r0,#0xFF000000		;@ use t9pc as garbage register.
;@----------------------------------------------------------------------------
reencode_pc:
;@----------------------------------------------------------------------------
	bic r0,t9pc,#0xFF000000
	stmfd sp!,{lr}
	bl t9LoadB					;@ Returns value in r0 & translated address in r1.
	sub t9pc,r1,t9pc			;@ Get offset
	str t9pc,[t9ptr,#tlcsLastBank]
	mov t9pc,r1
	ldmfd sp!,{lr}
	bx lr

;@----------------------------------------------------------------------------
#if GBA
	.section .ewram, "ax", %progbits	;@ For the GBA
#else
	.section .text						;@ For anything else
#endif
;@----------------------------------------------------------------------------
unknown_RR_Target:
	mov r11,r11
	ldr r0,=0x0BADC0DE
	bx lr
;@----------------------------------------------------------------------------
asmE:
	mov r11,r11
	ldr r0,=0xEEEEEEEE
	sub t9pc,t9pc,#1
	ldr r0,=debugCrashInstruction
	ldr lr,=tlcsEnd
	bx r0
;@----------------------------------------------------------------------------
regError:
	mov r11,r11
	mov r0,#0xE6
	t9fetch 0
;@----------------------------------------------------------------------------
srcError:
	mov r11,r11
	mov r0,#0xE5
	t9fetch 0
;@----------------------------------------------------------------------------
dstError:
	mov r11,r11
	mov r0,#0xED
	t9fetch 0


#ifdef COUNT_OP_CODES
;@----------------------------------------------------------------------------
dumpOpCodes:
;@----------------------------------------------------------------------------
	mov r0,#0
	ldr r2,=opcodeCounter
dumpLoop:
	ldr r1,[r2,r0,lsl#2]
	mov r12,r12
	b dumpContinue
	.short 0x6464,0x0000
	.string "%r1%\n"
	.align 2
dumpContinue:
	add r0,r0,#1
	cmp r0,#0x100
	bne dumpLoop
die:
	b die

	.pool
#endif
;@----------------------------------------------------------------------------
tlcs900HReset:				;@ r0=t9ptr, r1=tff3Function
;@----------------------------------------------------------------------------
	stmfd sp!,{r4-r11,lr}
	mov t9ptr,r0
	str r1,[t9ptr,#tff3Function]

	bl resetInterrupts
	bl resetTimers
	bl resetDMA

	// Reset registers
	add r0,t9ptr,#tlcsGprBanks
	mov r1,#8*4
	bl memclr_
#ifdef COUNT_OP_CODES
	ldr r0,=opcodeCounter
	mov r1,#256
	bl memclr_
#endif

	add t9gprBank,t9ptr,#tlcsGprBanks
	str t9gprBank,[t9ptr,#tlcsCurrentGprBank]
	ldr r0,=registersOfsMap
	str r0,[t9ptr,#tlcsCurrentMapBank]
	mov r0,#0
	strb r0,[t9ptr,#tlcsFDash]
	strb r0,[t9ptr,#tlcsStatusRFP]
	mov r0,#0x100
	str r0,[t9gprBank,#RXSP]
	mov r0,#0xF8				;@ Sys=1, IE=7, Max=1, RFP=0.
	strb r0,[t9ptr,#tlcsSrB]
	mov r0,#T9CYC_SHIFT
	strb r0,[t9ptr,#tlcsCycShift]

	ldr r0,=0xFFFF00				;@ 0xFFFF00 vector->startPC
	bl t9LoadL
	bl encode_r0_pc
	str t9pc,[t9ptr,#tlcsPcAsm]

	ldmfd sp!,{r4-r11,lr}
	bx lr

;@----------------------------------------------------------------------------
tlcs900HSaveState:			;@ In r0=destination, r1=t9ptr. Out r0=size.
	.type   tlcs900HSaveState STT_FUNC
;@----------------------------------------------------------------------------
	stmfd sp!,{r4,t9ptr,lr}

	mov r4,r0
	mov t9ptr,r1

	mov r2,#tlcsStateEnd-tlcsStateStart	;@ Right now ?
	bl memcpy

	;@ Convert copied PC to not offseted.
	ldr r0,[r4,#tlcsPcAsm]			;@ Offsetted tlcsPc
	ldr r2,[t9ptr,#tlcsLastBank]
	sub r0,r0,r2
	str r0,[r4,#tlcsPcAsm]			;@ Normal tlcsPc

	ldmfd sp!,{r4,t9ptr,lr}
	mov r0,#tlcsStateEnd-tlcsStateStart	;@ Right now ?
	bx lr
;@----------------------------------------------------------------------------
tlcs900HLoadState:			;@ In r0=t9ptr, r1=source. Out r0=size.
	.type   tlcs900HLoadState STT_FUNC
;@----------------------------------------------------------------------------
	stmfd sp!,{t9pc,t9ptr,lr}

	mov t9ptr,r0
	mov r2,#tlcsStateEnd-tlcsStateStart	;@ Right now ?
	bl memcpy

	ldr t9pc,[t9ptr,#tlcsPcAsm]	;@ Normal tlcsPc
	bl reencode_pc
	str t9pc,[t9ptr,#tlcsPcAsm]	;@ Rewrite offseted tlcsPc

	ldmfd sp!,{t9pc,t9ptr,lr}
;@----------------------------------------------------------------------------
tlcs900HGetStateSize:		;@ Out r0=state size.
	.type   tlcs900HGetStateSize STT_FUNC
;@----------------------------------------------------------------------------
	mov r0,#tlcsStateEnd-tlcsStateStart	;@ Right now ?
	bx lr
;@----------------------------------------------------------------------------
tlcs900HRedirectOpcode:		;@ In r0=opcode, r1=address.
	.type   tlcs900HRedirectOpcode STT_FUNC
;@----------------------------------------------------------------------------
	ldr r2,=tlcsOpz
	str r1,[r2,r0,lsl#2]
	bx lr
;@----------------------------------------------------------------------------
#ifdef NDS
	.section .dtcm, "ax", %progbits				;@ For the NDS
#elif GBA
	.section .iwram, "ax", %progbits			;@ For the GBA
#else
	.section .text
#endif
;@----------------------------------------------------------------------------
//srcOpCodesB:
;@ 0x00
	.long srcError,	srcError,	srcError,	srcError,	srcPUSHB,	srcError,	srcRLD,		srcRRD
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x10
	.long srcLDIB,	srcLDIRB,	srcLDDB,	srcLDDRB,	srcCPIB,	srcCPIRB,	srcCPDB,	srcCPDRB
	.long srcError,	srcLD16mB,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x20
	.long srcLDB_W,	srcLDB_A,	srcLDB_B,	srcLDB_C,	srcLDB_D,	srcLDB_E,	srcLDB_H,	srcLDB_L
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x30
	.long srcEXB,	srcEXB,		srcEXB,		srcEXB,		srcEXB,		srcEXB,		srcEXB,		srcEXB
	.long srcADDiB,	srcADCiB,	srcSUBiB,	srcSBCiB,	srcANDiB,	srcXORiB,	srcORiB,	srcCPiB
;@ 0x40
	.long srcError,	srcMULB,	srcError,	srcMULB,	srcError,	srcMULB,	srcError,	srcMULB
	.long srcError,	srcMULSB,	srcError,	srcMULSB,	srcError,	srcMULSB,	srcError,	srcMULSB
;@ 0x50
	.long srcError,	srcDIVB,	srcError,	srcDIVB,	srcError,	srcDIVB,	srcError,	srcDIVB
	.long srcError,	srcDIVSB,	srcError,	srcDIVSB,	srcError,	srcDIVSB,	srcError,	srcDIVSB
;@ 0x60
	.long srcINCB,	srcINCB,	srcINCB,	srcINCB,	srcINCB,	srcINCB,	srcINCB,	srcINCB
	.long srcDECB,	srcDECB,	srcDECB,	srcDECB,	srcDECB,	srcDECB,	srcDECB,	srcDECB
;@ 0x70
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcRLCB,	srcRRCB,	srcRLB,		srcRRB,		srcSLAB,	srcSRAB,	srcSLLB,	srcSRLB
;@ 0x80
	.long srcADDRmB,srcADDRmB,	srcADDRmB,	srcADDRmB,	srcADDRmB,	srcADDRmB,	srcADDRmB,	srcADDRmB
	.long srcADDmRB,srcADDmRB,	srcADDmRB,	srcADDmRB,	srcADDmRB,	srcADDmRB,	srcADDmRB,	srcADDmRB
;@ 0x90
	.long srcADCRmB,srcADCRmB,	srcADCRmB,	srcADCRmB,	srcADCRmB,	srcADCRmB,	srcADCRmB,	srcADCRmB
	.long srcADCmRB,srcADCmRB,	srcADCmRB,	srcADCmRB,	srcADCmRB,	srcADCmRB,	srcADCmRB,	srcADCmRB
;@ 0xA0
	.long srcSUBRmB,srcSUBRmB,	srcSUBRmB,	srcSUBRmB,	srcSUBRmB,	srcSUBRmB,	srcSUBRmB,	srcSUBRmB
	.long srcSUBmRB,srcSUBmRB,	srcSUBmRB,	srcSUBmRB,	srcSUBmRB,	srcSUBmRB,	srcSUBmRB,	srcSUBmRB
;@ 0xB0
	.long srcSBCRmB,srcSBCRmB,	srcSBCRmB,	srcSBCRmB,	srcSBCRmB,	srcSBCRmB,	srcSBCRmB,	srcSBCRmB
	.long srcSBCmRB,srcSBCmRB,	srcSBCmRB,	srcSBCmRB,	srcSBCmRB,	srcSBCmRB,	srcSBCmRB,	srcSBCmRB
;@ 0xC0
	.long srcANDRmB,srcANDRmB,	srcANDRmB,	srcANDRmB,	srcANDRmB,	srcANDRmB,	srcANDRmB,	srcANDRmB
	.long srcANDmRB,srcANDmRB,	srcANDmRB,	srcANDmRB,	srcANDmRB,	srcANDmRB,	srcANDmRB,	srcANDmRB
;@ 0xD0
	.long srcXORRmB,srcXORRmB,	srcXORRmB,	srcXORRmB,	srcXORRmB,	srcXORRmB,	srcXORRmB,	srcXORRmB
	.long srcXORmRB,srcXORmRB,	srcXORmRB,	srcXORmRB,	srcXORmRB,	srcXORmRB,	srcXORmRB,	srcXORmRB
;@ 0xE0
	.long srcORRmB,	srcORRmB,	srcORRmB,	srcORRmB,	srcORRmB,	srcORRmB,	srcORRmB,	srcORRmB
	.long srcORmRB,	srcORmRB,	srcORmRB,	srcORmRB,	srcORmRB,	srcORmRB,	srcORmRB,	srcORmRB
;@ 0xF0
	.long srcCPRmB,	srcCPRmB,	srcCPRmB,	srcCPRmB,	srcCPRmB,	srcCPRmB,	srcCPRmB,	srcCPRmB
	.long srcCPmRWB,srcCPmRAB,	srcCPmRBB,	srcCPmRCB,	srcCPmRDB,	srcCPmREB,	srcCPmRHB,	srcCPmRLB
;@----------------------------------------------------------------------------
//srcOpCodesW:
;@ 0x00
	.long srcError,	srcError,	srcError,	srcError,	srcPUSHW,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x10
	.long srcLDIW,	srcLDIRW,	srcLDDW,	srcLDDRW,	srcCPIW,	srcCPIRW,	srcCPDW,	srcCPDRW
	.long srcError,	srcLD16mW,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x20
	.long srcLDW,	srcLDW,		srcLDW,		srcLDW,		srcLDW,		srcLDW,		srcLDW,		srcLDW
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x30
	.long srcEXW,	srcEXW,		srcEXW,		srcEXW,		srcEXW,		srcEXW,		srcEXW,		srcEXW
	.long srcADDiW,	srcADCiW,	srcSUBiW,	srcSBCiW,	srcANDiW,	srcXORiW,	srcORiW,	srcCPiW
;@ 0x40
	.long srcMULW,	srcMULW,	srcMULW,	srcMULW,	srcMULW,	srcMULW,	srcMULW,	srcMULW
	.long srcMULSW,	srcMULSW,	srcMULSW,	srcMULSW,	srcMULSW,	srcMULSW,	srcMULSW,	srcMULSW
;@ 0x50
	.long srcDIVW,	srcDIVW,	srcDIVW,	srcDIVW,	srcDIVW,	srcDIVW,	srcDIVW,	srcDIVW
	.long srcDIVSW,	srcDIVSW,	srcDIVSW,	srcDIVSW,	srcDIVSW,	srcDIVSW,	srcDIVSW,	srcDIVSW
;@ 0x60
	.long srcINCW,	srcINCW,	srcINCW,	srcINCW,	srcINCW,	srcINCW,	srcINCW,	srcINCW
	.long srcDECW,	srcDECW,	srcDECW,	srcDECW,	srcDECW,	srcDECW,	srcDECW,	srcDECW
;@ 0x70
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcRLCW,	srcRRCW,	srcRLW,		srcRRW,		srcSLAW,	srcSRAW,	srcSLLW,	srcSRLW
;@ 0x80
	.long srcADDRmW,srcADDRmW,	srcADDRmW,	srcADDRmW,	srcADDRmW,	srcADDRmW,	srcADDRmW,	srcADDRmW
	.long srcADDmRW,srcADDmRW,	srcADDmRW,	srcADDmRW,	srcADDmRW,	srcADDmRW,	srcADDmRW,	srcADDmRW
;@ 0x90
	.long srcADCRmW,srcADCRmW,	srcADCRmW,	srcADCRmW,	srcADCRmW,	srcADCRmW,	srcADCRmW,	srcADCRmW
	.long srcADCmRW,srcADCmRW,	srcADCmRW,	srcADCmRW,	srcADCmRW,	srcADCmRW,	srcADCmRW,	srcADCmRW
;@ 0xA0
	.long srcSUBRmW,srcSUBRmW,	srcSUBRmW,	srcSUBRmW,	srcSUBRmW,	srcSUBRmW,	srcSUBRmW,	srcSUBRmW
	.long srcSUBmRW,srcSUBmRW,	srcSUBmRW,	srcSUBmRW,	srcSUBmRW,	srcSUBmRW,	srcSUBmRW,	srcSUBmRW
;@ 0xB0
	.long srcSBCRmW,srcSBCRmW,	srcSBCRmW,	srcSBCRmW,	srcSBCRmW,	srcSBCRmW,	srcSBCRmW,	srcSBCRmW
	.long srcSBCmRW,srcSBCmRW,	srcSBCmRW,	srcSBCmRW,	srcSBCmRW,	srcSBCmRW,	srcSBCmRW,	srcSBCmRW
;@ 0xC0
	.long srcANDRmW,srcANDRmW,	srcANDRmW,	srcANDRmW,	srcANDRmW,	srcANDRmW,	srcANDRmW,	srcANDRmW
	.long srcANDmRW,srcANDmRW,	srcANDmRW,	srcANDmRW,	srcANDmRW,	srcANDmRW,	srcANDmRW,	srcANDmRW
;@ 0xD0
	.long srcXORRmW,srcXORRmW,	srcXORRmW,	srcXORRmW,	srcXORRmW,	srcXORRmW,	srcXORRmW,	srcXORRmW
	.long srcXORmRW,srcXORmRW,	srcXORmRW,	srcXORmRW,	srcXORmRW,	srcXORmRW,	srcXORmRW,	srcXORmRW
;@ 0xE0
	.long srcORRmW,	srcORRmW,	srcORRmW,	srcORRmW,	srcORRmW,	srcORRmW,	srcORRmW,	srcORRmW
	.long srcORmRW,	srcORmRW,	srcORmRW,	srcORmRW,	srcORmRW,	srcORmRW,	srcORmRW,	srcORmRW
;@ 0xF0
	.long srcCPRmW,	srcCPRmW,	srcCPRmW,	srcCPRmW,	srcCPRmW,	srcCPRmW,	srcCPRmW,	srcCPRmW
	.long srcCPmRW,	srcCPmRW,	srcCPmRW,	srcCPmRW,	srcCPmRW,	srcCPmRW,	srcCPmRW,	srcCPmRW
;@----------------------------------------------------------------------------
//srcOpCodesL:
;@ 0x00
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x10
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x20
	.long srcLDL,	srcLDL,		srcLDL,		srcLDL,		srcLDL,		srcLDL,		srcLDL,		srcLDL
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x30
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x40
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x50
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x60
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x70
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
	.long srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError,	srcError
;@ 0x80
	.long srcADDRmL,srcADDRmL,	srcADDRmL,	srcADDRmL,	srcADDRmL,	srcADDRmL,	srcADDRmL,	srcADDRmL
	.long srcADDmRL,srcADDmRL,	srcADDmRL,	srcADDmRL,	srcADDmRL,	srcADDmRL,	srcADDmRL,	srcADDmRL
;@ 0x90
	.long srcADCRmL,srcADCRmL,	srcADCRmL,	srcADCRmL,	srcADCRmL,	srcADCRmL,	srcADCRmL,	srcADCRmL
	.long srcADCmRL,srcADCmRL,	srcADCmRL,	srcADCmRL,	srcADCmRL,	srcADCmRL,	srcADCmRL,	srcADCmRL
;@ 0xA0
	.long srcSUBRmL,srcSUBRmL,	srcSUBRmL,	srcSUBRmL,	srcSUBRmL,	srcSUBRmL,	srcSUBRmL,	srcSUBRmL
	.long srcSUBmRL,srcSUBmRL,	srcSUBmRL,	srcSUBmRL,	srcSUBmRL,	srcSUBmRL,	srcSUBmRL,	srcSUBmRL
;@ 0xB0
	.long srcSBCRmL,srcSBCRmL,	srcSBCRmL,	srcSBCRmL,	srcSBCRmL,	srcSBCRmL,	srcSBCRmL,	srcSBCRmL
	.long srcSBCmRL,srcSBCmRL,	srcSBCmRL,	srcSBCmRL,	srcSBCmRL,	srcSBCmRL,	srcSBCmRL,	srcSBCmRL
;@ 0xC0
	.long srcANDRmL,srcANDRmL,	srcANDRmL,	srcANDRmL,	srcANDRmL,	srcANDRmL,	srcANDRmL,	srcANDRmL
	.long srcANDmRL,srcANDmRL,	srcANDmRL,	srcANDmRL,	srcANDmRL,	srcANDmRL,	srcANDmRL,	srcANDmRL
;@ 0xD0
	.long srcXORRmL,srcXORRmL,	srcXORRmL,	srcXORRmL,	srcXORRmL,	srcXORRmL,	srcXORRmL,	srcXORRmL
	.long srcXORmRL,srcXORmRL,	srcXORmRL,	srcXORmRL,	srcXORmRL,	srcXORmRL,	srcXORmRL,	srcXORmRL
;@ 0xE0
	.long srcORRmL,	srcORRmL,	srcORRmL,	srcORRmL,	srcORRmL,	srcORRmL,	srcORRmL,	srcORRmL
	.long srcORmRL,	srcORmRL,	srcORmRL,	srcORmRL,	srcORmRL,	srcORmRL,	srcORmRL,	srcORmRL
;@ 0xF0
	.long srcCPRmL,	srcCPRmL,	srcCPRmL,	srcCPRmL,	srcCPRmL,	srcCPRmL,	srcCPRmL,	srcCPRmL
	.long srcCPmRL,	srcCPmRL,	srcCPmRL,	srcCPmRL,	srcCPmRL,	srcCPmRL,	srcCPmRL,	srcCPmRL
;@----------------------------------------------------------------------------
//regOpCodesB:
;@ 0x00
	.long regError,	regError,	regError,	regLDirB,	regPUSHB,	regPOPB,	regCPLB,	regNEGB
	.long regMULiB,	regMULSiB,	regDIViB,	regDIVSiB,	regError,	regError,	regError,	regError
;@ 0x10
	.long regDAA,	regError,	regError,	regError,	regError,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regDJNZB,	regError,	regError,	regError
;@ 0x20
	.long regANDCFiB,regORCFiB,	regXORCFiB,	regLDCFiB,	regSTCFiB,	regError,	regError,	regError
	.long regANDCFAB,regORCFAB,	regXORCFAB,	regLDCFAB,	regSTCFAB,	regError,	regLDCcrrB,	regLDCrcrB
;@ 0x30
	.long regRESB,	regSETB,	regCHGB,	regBITB,	regTSETB,	regError,	regError,	regError
	.long regError,	regError,	regError,	regError,	regError,	regError,	regError,	regError
;@ 0x40
	.long regError,	regMULB,	regError,	regMULB,	regError,	regMULB,	regError,	regMULB
	.long regError,	regMULSB,	regError,	regMULSB,	regError,	regMULSB,	regError,	regMULSB
;@ 0x50
	.long regError,	regDIVB,	regError,	regDIVB,	regError,	regDIVB,	regError,	regDIVB
	.long regError,	regDIVSB,	regError,	regDIVSB,	regError,	regDIVSB,	regError,	regDIVSB
;@ 0x60
	.long regINCB,	regINCB,	regINCB,	regINCB,	regINCB,	regINCB,	regINCB,	regINCB
	.long regDECB,	regDECB,	regDECB,	regDECB,	regDECB,	regDECB,	regDECB,	regDECB
;@ 0x70
	.long regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB
	.long regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB,	regSCCB
;@ 0x80
	.long regADDBW,	regADDBA,	regADDBB,	regADDBC,	regADDBD,	regADDBE,	regADDBH,	regADDBL
	.long regLDRrBW,regLDRrBA,	regLDRrBB,	regLDRrBC,	regLDRrBD,	regLDRrBE,	regLDRrBH,	regLDRrBL
;@ 0x90
	.long regADCBW,	regADCBA,	regADCBB,	regADCBC,	regADCBD,	regADCBE,	regADCBH,	regADCBL
	.long regLDrRBW,regLDrRBA,	regLDrRBB,	regLDrRBC,	regLDrRBD,	regLDrRBE,	regLDrRBH,	regLDrRBL
;@ 0xA0
	.long regSUBRW,	regSUBRA,	regSUBRB,	regSUBRC,	regSUBRD,	regSUBRE,	regSUBRH,	regSUBRL
	.long regLDr3B,	regLDr3B,	regLDr3B,	regLDr3B,	regLDr3B,	regLDr3B,	regLDr3B,	regLDr3B
;@ 0xB0
	.long regSBCBW,	regSBCBA,	regSBCBB,	regSBCBC,	regSBCBD,	regSBCBE,	regSBCBH,	regSBCBL
	.long regEXB,	regEXB,		regEXB,		regEXB,		regEXB,		regEXB,		regEXB,		regEXB
;@ 0xC0
	.long regANDBW,	regANDBA,	regANDBB,	regANDBC,	regANDBD,	regANDBE,	regANDBH,	regANDBL
	.long regADDiB,	regADCiB,	regSUBiB,	regSBCiB,	regANDiB,	regXORiB,	regORiB,	regCPiB
;@ 0xD0
	.long regXORBW,	regXORBA,	regXORBB,	regXORBC,	regXORBD,	regXORBE,	regXORBH,	regXORBL
	.long regCPr3B,	regCPr3B,	regCPr3B,	regCPr3B,	regCPr3B,	regCPr3B,	regCPr3B,	regCPr3B
;@ 0xE0
	.long regORBW,	regORBA,	regORBB,	regORBC,	regORBD,	regORBE,	regORBH,	regORBL
	.long regRLCiB,	regRRCiB,	regRLiB,	regRRiB,	regSLAiB,	regSRAiB,	regSLLiB,	regSRLiB
;@ 0xF0
	.long regCPBW,	regCPBA,	regCPBB,	regCPBC,	regCPBD,	regCPBE,	regCPBH,	regCPBL
	.long regRLCAB,	regRRCAB,	regRLAB,	regRRAB,	regSLAAB,	regSRAAB,	regSLLAB,	regSRLAB
;@----------------------------------------------------------------------------
tlcs900HState:
tlcsOpz:
;@ 0x00
	.long sngNOP,		sngNORMAL,	sngPUSHSR,	sngPOPSR,	sngMAX,		sngHALT,	sngEI,		sngRETI
	.long sngLD8_8,		sngPUSH8,	sngLD8_16,	sngPUSH16,	sngINCF,	sngDECF,	sngRET,		sngRETD
;@ 0x10
	.long sngRCF,		sngSCF,		sngCCF,		sngZCF,		sngPUSHA,	sngPOPA,	sngEX,		sngLDF
	.long sngPUSHF,		sngPOPF,	sngJP16,	sngJP24,	sngCALL16,	sngCALL24,	sngCALR,	asmE
;@ 0x20
	.long sngLDiRW,		sngLDiRA,	sngLDiRB,	sngLDiRC,	sngLDiRD,	sngLDiRE,	sngLDiRH,	sngLDiRL
	.long sngPUSHW,		sngPUSHW,	sngPUSHW,	sngPUSHW,	sngPUSHW,	sngPUSHW,	sngPUSHW,	sngPUSHW
;@ 0x30
	.long sngLDW,		sngLDW,		sngLDW,		sngLDW,		sngLDW,		sngLDW,		sngLDW,		sngLDW
	.long sngPUSHL,		sngPUSHL,	sngPUSHL,	sngPUSHL,	sngPUSHL,	sngPUSHL,	sngPUSHL,	sngPUSHL
;@ 0x40
	.long sngLDL,		sngLDL,		sngLDL,		sngLDL,		sngLDL,		sngLDL,		sngLDL,		sngLDL
	.long sngPOPW,		sngPOPW,	sngPOPW,	sngPOPW,	sngPOPW,	sngPOPW,	sngPOPW,	sngPOPW
;@ 0x50
	.long asmE,			asmE,		asmE,		asmE,		asmE,		asmE,		asmE,		asmE
	.long sngPOPL,		sngPOPL,	sngPOPL,	sngPOPL,	sngPOPL,	sngPOPL,	sngPOPL,	sngPOPL
;@ 0x60
	.long sngJR_never,	sngJR_lt,	sngJR_le,	sngJR_ule,	sngJR_ov,	sngJR_mi,	sngJR_z,	sngJR_c
	.long sngJR,		sngJR_ge,	sngJR_gt,	sngJR_ugt,	sngJR_nov,	sngJR_pl,	sngJR_nz,	sngJR_nc
;@ 0x70
	.long sngJRL_never,	sngJRL_lt,	sngJRL_le,	sngJRL_ule,	sngJRL_ov,	sngJRL_mi,	sngJRL_z,	sngJRL_c
	.long sngJRL,		sngJRL_ge,	sngJRL_gt,	sngJRL_ugt,	sngJRL_nov,	sngJRL_pl,	sngJRL_nz,	sngJRL_nc
;@ 0x80
	.long srcExXWAB,	srcExXBCB,	srcExXDEB,	srcExXHLB,	srcExXIXB,	srcExXIYB,	srcExXIZB,	srcExXSPB
	.long srcExXWAdB,	srcExXBCdB,	srcExXDEdB,	srcExXHLdB,	srcExXIXdB,	srcExXIYdB,	srcExXIZdB,	srcExXSPdB
;@ 0x90
	.long srcExXRRW,	srcExXRRW,	srcExXRRW,	srcExXRRW,	srcExXRRW,	srcExXRRW,	srcExXRRW,	srcExXRRW
	.long srcExXRRdW,	srcExXRRdW,	srcExXRRdW,	srcExXRRdW,	srcExXRRdW,	srcExXRRdW,	srcExXRRdW,	srcExXRRdW
;@ 0xA0
	.long srcExXRRL,	srcExXRRL,	srcExXRRL,	srcExXRRL,	srcExXRRL,	srcExXRRL,	srcExXRRL,	srcExXRRL
	.long srcExXRRdL,	srcExXRRdL,	srcExXRRdL,	srcExXRRdL,	srcExXRRdL,	srcExXRRdL,	srcExXRRdL,	srcExXRRdL
;@ 0xB0
	.long dstExXWA,		dstExXBC,	dstExXDE,	dstExXHL,	dstExXIX,	dstExXIY,	dstExXIZ,	dstExXSP
	.long dstExXWAd,	dstExXBCd,	dstExXDEd,	dstExXHLd,	dstExXIXd,	dstExXIYd,	dstExXIZd,	dstExXSPd
;@ 0xC0
	.long srcEx8B,		srcEx16B,	srcEx24B,	srcExR32B,	srcExDecB,	srcExIncB,	asmE,		regRCB
	.long regB_W,		regB_A,		regB_B,		regB_C,		regB_D,		regB_E,		regB_H,		regB_L
;@ 0xD0
	.long srcEx8W,		srcEx16W,	srcEx24W,	srcExR32W,	srcExDecW,	srcExIncW,	asmE,		regRCW
	.long regWA,		regBC,		regDE,		regHL,		regIX,		regIY,		regIZ,		regSP
;@ 0xE0
	.long srcEx8L,		srcEx16L,	srcEx24L,	srcExR32L,	srcExDecL,	srcExIncL,	asmE,		regRCL
	.long reg_L,		reg_L,		reg_L,		reg_L,		reg_L,		reg_L,		reg_L,		reg_L
;@ 0xF0
	.long dstEx8,		dstEx16,	dstEx24,	dstExR32,	dstExDec,	dstExInc,	asmE,		sngLDX
	.long sngSWI,		sngSWI,		sngSWI,		sngSWI,		sngSWI,		sngSWI,		sngSWI,		sngSWI
// PZSTable
	.byte PSR_Z|PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0, 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P
	.byte 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P, PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0
	.byte 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P, PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0
	.byte PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0, 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P
	.byte 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P, PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0
	.byte PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0, 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P
	.byte PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0, 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P
	.byte 0, PSR_P, PSR_P, 0, PSR_P, 0, 0, PSR_P, PSR_P, 0, 0, PSR_P, 0, PSR_P, PSR_P, 0
	.byte PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S
	.byte PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S
	.byte PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S
	.byte PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S
	.byte PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S
	.byte PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S
	.byte PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S
	.byte PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S, PSR_S+PSR_P, PSR_S, PSR_S+PSR_P, PSR_S, PSR_S, PSR_P+PSR_S

	.space 4*8*4	;@ tlcsGprBanks
	.long 0			;@ tlcsLastBank
	.short	0		;@ tlcsF, tlcsSrB
	.byte 0			;@ tlcsFDash
	.byte 0			;@ tlcsStatusRFP
	.long 0			;@ tlcsCycles
	.long 0			;@ tlcsPcAsm
	.long 0			;@ tlcsDMAStartVector
	.long 0			;@ tlcsCurrentGprBank
	.long 0			;@ tlcsCurrentMapBank
	.long 0			;@ tlcsPadding1
	.space 4*4		;@ tlcsDmaS
	.space 4*4		;@ tlcsDmaD
	.space 4*4		;@ tlcsDmaC/DmaM
	.space 64		;@ tlcsIPending
	.space 16		;@ tlcsIntPrio
	.space 4*4		;@ tlcsTimerClock
	.space 4		;@ tlcsUpCounter
	.space 4		;@ tlcsTimerCompare
	.byte 0			;@ tlcsTRun
	.byte 0			;@ tlcsT01Mod
	.byte 0			;@ tlcsT23Mod
	.byte 0			;@ tlcsTrdc
	.byte 0			;@ tlcsTFFCR
	.byte 0			;@ tlcsTFF1
	.byte 0			;@ tlcsTFF3
	.byte 0			;@ tlcsCycShift
	.byte 0			;@ tlcsTimerHInt_
	.space 3		;@ tlcsPadding0

	.long 0			;@ tff3Function
	.long 0			;@ romBaseLo
	.long 0			;@ romBaseHi
	.long 0			;@ biosBase

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
