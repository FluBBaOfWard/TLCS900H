//
//  TLCS900H.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2023 Fredrik Ahlström. All rights reserved.
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
	.global push8
	.global push16
	.global push32
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
	.global generic_ADD_W
	.global generic_ADD_L
	.global generic_ADC_B
	.global generic_ADC_W
	.global generic_ADC_L
	.global generic_AND_B
	.global generic_AND_W
	.global generic_AND_L
	.global generic_DEC_B
	.global generic_DEC_W
	.global generic_INC_B
	.global generic_INC_W
	.global generic_OR_B
	.global generic_OR_W
	.global generic_OR_L
	.global generic_SBC_B
	.global generic_SBC_W
	.global generic_SBC_L
	.global generic_SUB_B
	.global generic_SUB_W
	.global generic_SUB_L
	.global generic_XOR_B
	.global generic_XOR_W
	.global generic_XOR_L
	.global conditionCode
	.global setStatusRFP
	.global changedSR
	.global statusIFF
	.global setStatusIFF
	.global encode_r0_pc
	.global reencode_pc
	.global decode_pc_r0
	.global storeTLCS900
	.global loadTLCS900

	.global tlcs900HState

;@----------------------------------------------------------------------------
	.syntax unified
	.arm

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

asmE:
	mov r11,r11
	ldr r0,=0xEEEEEEEE
	sub t9pc,t9pc,#1
	ldr r0,=debugCrashInstruction
	mov lr,pc
	bx r0
;@----------------------------------------------------------------------------
push8:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,#0x1C]	;@ XSP
	sub r1,r1,#1
	str r1,[t9gprBank,#0x1C]
	b t9StoreB

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
	orr r1,r1,#0x88				;@ System and Maximum always set.
	orr r0,r0,r1,lsl#8
;@----------------------------------------------------------------------------
push16:
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,#0x1C]	;@ XSP
	sub r1,r1,#2
	str r1,[t9gprBank,#0x1C]
	b t9StoreW
;@----------------------------------------------------------------------------
push32:						;@ Also used from interrupt
;@----------------------------------------------------------------------------
	ldr r1,[t9gprBank,#0x1C]	;@ XSP
	sub r1,r1,#4
	str r1,[t9gprBank,#0x1C]
	b t9StoreL
;@----------------------------------------------------------------------------
pop8:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#0x1C]	;@ XSP
	add r1,r0,#1
	str r1,[t9gprBank,#0x1C]
	b t9LoadB
;@----------------------------------------------------------------------------
pop16:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#0x1C]	;@ XSP
	add r1,r0,#2
	str r1,[t9gprBank,#0x1C]
	b t9LoadW
;@----------------------------------------------------------------------------
pop32:
;@----------------------------------------------------------------------------
	ldr r0,[t9gprBank,#0x1C]	;@ XSP
	add r1,r0,#4
	str r1,[t9gprBank,#0x1C]
	b t9LoadL

;@----------------------------------------------------------------------------
ExR32:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	cmp r0,#0x03
	beq exr32_03
	cmp r0,#0x07
	beq exr32_07
	cmp r0,#0x13
	beq exr32_13

	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,r0]
	bic t9Reg,t9Reg,#3
	ldr t9Mem,[t9gprBank,t9Reg]
	and r0,r0,#3
	cmp r0,#1
	bne exr32End
	ldrb r0,[t9pc],#1
	add t9Mem,t9Mem,r0
	ldrsb r0,[t9pc],#1
	add t9Mem,t9Mem,r0,lsl#8
exr32End:
	t9eatcycles 5
	bx lr

exr32_03:
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

exr32_07:
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

exr32_13:			;@ Used by LDAR
	ldrb t9Mem,[t9pc],#1
	ldrsb r0,[t9pc],#1
	orr t9Mem,t9Mem,r0,lsl#8
	ldr r0,[t9ptr,#tlcsLastBank]
	sub r0,t9pc,r0
	add t9Mem,t9Mem,r0
	t9eatcycles 8				;@ Unconfirmed... doesn't make much difference
	bx lr
;@----------------------------------------------------------------------------
ExDec:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,r0]
	bic t9Reg,t9Reg,#3
	ldr t9Mem,[t9gprBank,t9Reg]
	mov r0,r0,ror#2
	movs r0,r0,lsr#29
	addeq r0,r0,#1
;@	cmp r0,#6
;@	beq UnknownOpCode
	sub t9Mem,t9Mem,r0
	str t9Mem,[t9gprBank,t9Reg]

	t9eatcycles 3
	bx lr
;@----------------------------------------------------------------------------
ExInc:
;@----------------------------------------------------------------------------
	ldrb r0,[t9pc],#1
	ldr r2,[t9ptr,#tlcsCurrentMapBank]
	ldrsb t9Reg,[r2,r0]
	bic t9Reg,t9Reg,#3
	ldr t9Mem,[t9gprBank,t9Reg]
	mov r0,r0,ror#2
	movs r0,r0,lsr#29
	addeq r0,r0,#1
;@	cmp r0,#6
;@	beq UnknownOpCode
	add r0,t9Mem,r0
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
generic_AND_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	and r0,r0,r1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	orr t9f,t9f,#PSR_H
	bx lr
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
generic_AND_L:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
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
generic_OR_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	orr r0,r0,r1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	bx lr
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
generic_OR_L:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
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
generic_XOR_B:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	eor r0,r0,r1
	add r1,t9ptr,#tlcsPzst
	ldrb t9f,[r1,r0]			;@ Get PZS
	bx lr
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
generic_XOR_L:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
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
generic_ADD_L:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
	mov r2,r0,lsl#4				;@ Prepare for check of half carry
	adds r0,r0,r1
	mrs t9f,cpsr				;@ S,Z,V&C
	mov t9f,t9f,lsr#28
	cmn r2,r1,lsl#4
	orrcs t9f,t9f,#PSR_H

	bx lr
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
generic_ADC_L:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
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
generic_DEC_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
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
generic_INC_W:				;@ r0=dst, r1=src
;@----------------------------------------------------------------------------
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
	bx lr
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
;@	cmp r0,#1
;@	moveq r0,#0
	bx lr
;@----------------------------------------------------------------------------
setStatusIFF:				;@ r0 = new IFF
;@----------------------------------------------------------------------------
	and r1,r0,#0x07
	ldrb r0,[t9ptr,#tlcsSrB]
	bic r0,r0,#0x70
	orr r0,r0,r1,lsl#4
	strb r0,[t9ptr,#tlcsSrB]
	bx lr
;@----------------------------------------------------------------------------
setStatusRFP:				;@ r0 = new Register File Pointer
;@----------------------------------------------------------------------------
	and r1,r0,#0x07
	ldrb r0,[t9ptr,#tlcsSrB]
	bic r0,r0,#0x07
	orr r0,r0,r1
	strb r0,[t9ptr,#tlcsSrB]
;@----------------------------------------------------------------------------
changedSR:
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsSrB]
	ldrb r1,[t9ptr,#tlcsStatusRFP]
	and r0,r0,#0x03
	cmp r0,r1
	bxeq lr
	strb r0,[t9ptr,#tlcsStatusRFP]

	ldr r1,=registersOfsMap
	add r1,r1,r0,lsl#8					;@ x256
	str r1,[t9ptr,#tlcsCurrentMapBank]

	stmfd sp!,{r1-r4}
	add t9gprBank,t9gprBank,#4*4
	ldmia t9gprBank,{r1-r4}				;@ Move IX, IY, IZ & SP to new location.
	add t9gprBank,t9ptr,#tlcsGprBanks
	add t9gprBank,t9gprBank,r0,lsl#5	;@ gprBank size = 4*8
	add r0,t9gprBank,#4*4
	stmia r0,{r1-r4}
	ldmfd sp!,{r1-r4}

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
decode_pc_r0:
;@----------------------------------------------------------------------------
	ldr r0,[t9ptr,#tlcsLastBank]
	sub r0,t9pc,r0
	bx lr

;@----------------------------------------------------------------------------
#if GBA
	.section .ewram, "ax", %progbits	;@ For the GBA
#else
	.section .text						;@ For anything else
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

	add t9gprBank,t9ptr,#tlcsGprBanks
	str t9gprBank,[t9ptr,#tlcsCurrentGprBank]
	ldr r0,=registersOfsMap
	str r0,[t9ptr,#tlcsCurrentMapBank]
	mov r0,#0
	strb r0,[t9ptr,#tlcsFDash]
	strb r0,[t9ptr,#tlcsStatusRFP]
	mov r0,#0x100
	str r0,[t9gprBank,#0x1C]	;@ XSP
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
tlcs900HState:
tlcsOpz:
;@ 0x00
	.long sngNOP,		sngNORMAL,	sngPUSHSR,	sngPOPSR,	sngMAX,		sngHALT,	sngEI,		sngRETI
	.long sngLD8_8,		sngPUSH8,	sngLD8_16,	sngPUSH16,	sngINCF,	sngDECF,	sngRET,		sngRETD
;@ 0x10
	.long sngRCF,		sngSCF,		sngCCF,		sngZCF,		sngPUSHA,	sngPOPA,	sngEX,		sngLDF
	.long sngPUSHF,		sngPOPF,	sngJP16,	sngJP24,	sngCALL16,	sngCALL24,	sngCALR,	asmE
;@ 0x20
	.long sngLDB,		sngLDB,		sngLDB,		sngLDB,		sngLDB,		sngLDB,		sngLDB,		sngLDB
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
	.long srcExXRR,		srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR
	.long srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd
;@ 0x90
	.long srcExXRR,		srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR
	.long srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd
;@ 0xA0
	.long srcExXRR,		srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR,	srcExXRR
	.long srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd,	srcExXRRd
;@ 0xB0
	.long dstExXRR,		dstExXRR,	dstExXRR,	dstExXRR,	dstExXRR,	dstExXRR,	dstExXRR,	dstExXRR
	.long dstExXRRd,	dstExXRRd,	dstExXRRd,	dstExXRRd,	dstExXRRd,	dstExXRRd,	dstExXRRd,	dstExXRRd
;@ 0xC0
	.long srcEx8,		srcEx16,	srcEx24,	srcExR32,	srcExDec,	srcExInc,	asmE,		regRCB
	.long reg_B,		reg_B,		reg_B,		reg_B,		reg_B,		reg_B,		reg_B,		reg_B
;@ 0xD0
	.long srcEx8,		srcEx16,	srcEx24,	srcExR32,	srcExDec,	srcExInc,	asmE,		regRCW
	.long reg_W,		reg_W,		reg_W,		reg_W,		reg_W,		reg_W,		reg_W,		reg_W
;@ 0xE0
	.long srcEx8,		srcEx16,	srcEx24,	srcExR32,	srcExDec,	srcExInc,	asmE,		regRCL
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
	.byte 0			;@ tlcsTimerHInt
	.byte 0			;@ tlcsTRun
	.byte 0			;@ tlcsT01Mod
	.byte 0			;@ tlcsT23Mod
	.byte 0			;@ tlcsTrdc
	.byte 0			;@ tlcsTFFCR
	.byte 0			;@ tlcsTFF1
	.byte 0			;@ tlcsTFF3
	.byte 0			;@ tlcsCycShift
	.space 3		;@ tlcsPadding0

	.long 0			;@ tff3Function
	.long 0			;@ romBaseLo
	.long 0			;@ romBaseHi
	.long 0			;@ biosBase
	.long 0			;@ readRomPtrLo
	.long 0			;@ readRomPtrHi

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
