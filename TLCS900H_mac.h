//
//  TLCS900H_mac.h
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2021 Fredrik Ahlström. All rights reserved.
//


#include "TLCS900H.i"
							;@ ARM flags
	.equ PSR_S, 0x00000008		;@ Negative
	.equ PSR_Z, 0x00000004		;@ Zero
	.equ PSR_C, 0x00000002		;@ Carry
	.equ PSR_V, 0x00000001		;@ Overflow/Parity
	.equ PSR_P, 0x00000001		;@ Overflow/Parity

	.equ PSR_n, 0x00000080		;@ Was the last opcode add or sub?
	.equ PSR_H, 0x00000010		;@ Half carry


							;@ TLCS-900H flags, bit 3 & 5 always 0.
	.equ SF, 0x80				;@ Sign (negative)
	.equ ZF, 0x40				;@ Zero
	.equ HF, 0x10				;@ half carry
	.equ PF, 0x04				;@ Overflow/Parity
	.equ VF, 0x04				;@ Overflow/Parity
	.equ NF, 0x02				;@ Was the last opcode + or -
	.equ CF, 0x01				;@ Carry



	.macro t9fetch count
	subs t9cycles,t9cycles,#(\count)*T9CYCLE
	b tlcs_loop
	.endm

	.macro t9eatcycles count
	sub t9cycles,t9cycles,#(\count)*T9CYCLE
	.endm
