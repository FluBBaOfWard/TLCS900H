//
//  TLCS900H_int.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2024 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "TLCS900H_mac.h"
#include "../K2GE/K2GE.i"

	.global intCheckPending
	.global updateTimers
	.global clockTimer0
	.global setInterrupt
	.global checkInterrupt
	.global setVBlankInterrupt
	.global resetDMA
	.global resetTimers
	.global resetInterrupts
	.global t9LoadB_Low
	.global t9StoreB_Low

	.syntax unified
	.arm

#ifdef GBA
	.section .ewram, "ax"		;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
	.align 2
;@---------------------------------------------------------------------------
resetDMA:
;@---------------------------------------------------------------------------
	add r0,t9ptr,#tlcsDmaS
	mov r1,#0
	mov r2,#12					;@ 12*4
	b memset_					;@ Clear DMA regs
;@---------------------------------------------------------------------------
resetTimers:
;@---------------------------------------------------------------------------
	add r0,t9ptr,#tlcsTimerClock
	mov r1,#0
	mov r2,#6					;@ 6*4
	b memset_					;@ Clear Timer regs
;@---------------------------------------------------------------------------
resetInterrupts:
;@---------------------------------------------------------------------------
	mov r1,#0
	strb r1,[t9ptr,#tlcsTRun]
	strb r1,[t9ptr,#tlcsT01Mod]
	strb r1,[t9ptr,#tlcsT23Mod]
	strb r1,[t9ptr,#tlcsTrdc]
	strb r1,[t9ptr,#tlcsTFFCR]
	str r1,[t9ptr,#tlcsDMAStartVector]

	add r0,t9ptr,#tlcsIPending
	mov r2,#10					;@ 10*4
	b memset_					;@ Clear INT regs

;@----------------------------------------------------------------------------
t9LoadB_Low:
;@----------------------------------------------------------------------------
	and r0,r0,#0xFF
	ldr pc,[pc,r0,lsl#2]
	.long 0
;@ 0x00
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0x10
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0x20
	.long timerRunR				;@ 0x20
	.long timerBadR				;@ 0x21
	.long timer0R				;@ 0x22
	.long timer1R				;@ 0x23
	.long timerT01ModR			;@ 0x24
	.long timerTffcrR			;@ 0x25
	.long timer2R				;@ 0x26
	.long timer3R				;@ 0x27
	.long timerT23ModR			;@ 0x28
	.long timerTrdcR			;@ 0x29
	.long timerBadR				;@ 0x2A
	.long timerBadR				;@ 0x2B
	.long timerBadR				;@ 0x2C
	.long timerBadR				;@ 0x2D
	.long timerBadR				;@ 0x2E
	.long timerBadR				;@ 0x2F
;@ 0x30
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0x40
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0x50
	.long serialDataR
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0x60
	.long adcR
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0x70
	.long intRd70
	.long intRd71
	.long intRd72
	.long intRd73
	.long intRd74
	.long intRd75
	.long intRd76
	.long intRd77
	.long intRd78
	.long intRd79
	.long intRd7A
	.long intRd7B
	.long intRd7C
	.long intRd7D
	.long intRd7E
	.long intRd7F
;@ 0x80
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0x90
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0xA0
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0xB0
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0xC0
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0xD0
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0xE0
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
;@ 0xF0
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead
	.long lowMemRead

;@----------------------------------------------------------------------------
serialDataR:				;@ 0x50
;@----------------------------------------------------------------------------
	mov r2,#0
	strb r2,[t9ptr,#tlcsIPending+0x18]
	strb r0,[t9ptr,#tlcsIrqDirty]
	b lowMemRead
;@----------------------------------------------------------------------------
adcR:						;@ 0x60
;@----------------------------------------------------------------------------
	mov r2,#0
	strb r2,[t9ptr,#tlcsIPending+0x1C]
	strb r0,[t9ptr,#tlcsIrqDirty]
;@----------------------------------------------------------------------------
lowMemRead:
;@----------------------------------------------------------------------------
	ldr r2,=systemMemory
	ldrb r0,[r2,r0]
	bx lr
;@----------------------------------------------------------------------------
t9StoreB_Low:
;@----------------------------------------------------------------------------
	and r0,r0,#0xFF
	and r1,t9Mem,#0xFF
	ldr r2,=systemMemory
	ldrb r3,[r2,r1]
	strb r0,[r2,r1]

	cmp r1,#0xB2				;@ COMMStatus
	beq setCommStatus

	cmp r1,#0xB8				;@ Soundchip enable/disable, 0x55 On 0xAA Off.
	beq setMuteT6W28

	cmp r1,#0xB9				;@ Z80 enable/disable, 0x55 On 0xAA Off.
	beq Z80_SetEnable

	cmp r1,#0xBA				;@ Z80 NMI
	beq Z80_nmi_do

	cmp r1,#0xA0				;@ T6W28, Right
	beq T6W28_R_W
	cmp r1,#0xA1				;@ T6W28, Left
	beq T6W28_L_W
	cmp r1,#0xA2				;@ T6W28 DAC, Left
	beq T6W28_DAC_L_W
	cmp r1,#0xA3				;@ T6W28 DAC, Right
	beq T6W28_DAC_R_W

	cmp r1,#0x6F				;@ Watchdog
	beq watchDogW

	cmp r1,#0x6D				;@ Battery A/D start
	beq ADStart

	cmp r1,#0x80				;@ CpuSpeed
	beq cpuSpeedW

	and r2,r1,#0xF0
	cmp r2,#0x20
	beq timerWrite8

	cmp r2,#0x70
	beq intWrite8

//	cmp r1,#0xB3				;@ Power button NMI on/off.
	bx lr

;@----------------------------------------------------------------------------
watchDogW:					;@ 0x6F
;@----------------------------------------------------------------------------
	bx lr
;@----------------------------------------------------------------------------
cpuSpeedW:					;@ 0x80
;@----------------------------------------------------------------------------
	and r0,r0,#0x07
	cmp r0,#4
	movpl r0,#4
	subs r1,r0,r3
	bxeq lr
//	mov t9cycles,t9cycles,ror r1	;@ melonDS doesn't like this.
	movpl t9cycles,t9cycles,asr r1
	movmi t9cycles,t9cycles,lsl#1
	strb r0,[r2,#0x80]
	rsb r0,r0,#T9CYC_SHIFT
	strb r0,[t9ptr,#tlcsCycShift]
	bx lr

;@----------------------------------------------------------------------------
setCommStatus:				;@ 0xB2
;@----------------------------------------------------------------------------
	and r0,r0,#1
	strb r0,[r2,r1]				;@ r2 = systemMemory
	bx lr
;@----------------------------------------------------------------------------
timerWrite8:				;@ 0x20-0x2F, r0 = value, r1 = address
;@----------------------------------------------------------------------------
	and r2,r1,#0x0F
	ldr pc,[pc,r2,lsl#2]
	.long 0
	.long timerRunW				;@ 0x20
	.long timerBadW				;@ 0x21
	.long timer0W				;@ 0x22
	.long timer1W				;@ 0x23
	.long timerT01ModW			;@ 0x24
	.long timerTffcrW			;@ 0x25
	.long timer2W				;@ 0x26
	.long timer3W				;@ 0x27
	.long timerT23ModW			;@ 0x28
	.long timerTrdcW			;@ 0x29
	.long timerBadW				;@ 0x2A
	.long timerBadW				;@ 0x2B
	.long timerBadW				;@ 0x2C
	.long timerBadW				;@ 0x2D
	.long timerBadW				;@ 0x2E
	.long timerBadW				;@ 0x2F

;@---------------------------------------------------------------------------
intWrite8:					;@ 0x70-0x7F, r0 = value, r1 = address
;@---------------------------------------------------------------------------
	mov r1,r1,lsl#28
	and r2,r0,#0x70
	cmp r2,#0x70
	biceq r0,r0,#0x70
	and r2,r0,#0x07
	cmp r2,#0x07
	biceq r0,r0,#0x07
	add r2,t9ptr,#tlcsIntPrio
	strb r0,[r2,r1,lsr#28]
	ldr pc,[pc,r1,lsr#26]
	.long 0
	.long intWr70
	.long intWr71
	.long intWr72
	.long intWr73
	.long intWr74
	.long intWr75
	.long intWr76
	.long intWr77
	.long intWr78
	.long intWr79
	.long intWr7A
	.long intWr7B
	.long intWr7C
	.long intWr7D
	.long intWr7E
	.long intWr7F
intWr70:
	tst r0,#0x08
	strbeq r1,[t9ptr,#tlcsIPending+0x0A]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x1C]
	b markIrqDirty
intWr71:
	tst r0,#0x08
	strbeq r1,[t9ptr,#tlcsIPending+0x0B]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x0C]
	b markIrqDirty
intWr72:
	tst r0,#0x08
	strbeq r1,[t9ptr,#tlcsIPending+0x0D]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x0E]
	b markIrqDirty
intWr73:
	tst r0,#0x08
	strbeq r1,[t9ptr,#tlcsIPending+0x10]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x11]
	b markIrqDirty
intWr74:
	tst r0,#0x08
	strbeq r1,[t9ptr,#tlcsIPending+0x12]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x13]
	b markIrqDirty
intWr77:
;@	tst r0,#0x08
;@	strbeq r1,[t9ptr,#tlcsIPending+0x18]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x19]
	b markIrqDirty
intWr79:
	tst r0,#0x08
	strbeq r1,[t9ptr,#tlcsIPending+0x1D]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x1E]
	b markIrqDirty
intWr7A:
	tst r0,#0x08
	strbeq r1,[t9ptr,#tlcsIPending+0x1F]
	tst r0,#0x80
	strbeq r1,[t9ptr,#tlcsIPending+0x20]
markIrqDirty:
	mov r0,#1
	strb r0,[t9ptr,#tlcsIrqDirty]
intWr75:
intWr76:
intWr78:
intWr7B:
	bx lr

intWr7C:
intWr7D:
intWr7E:
intWr7F:
	and r0,r0,#0x1F
	and r1,r1,#0x30000000
	add r2,t9ptr,#tlcsDMAStartVector
	strb r0,[r2,r1,lsr#28]
	bx lr
;@----------------------------------------------------------------------------
intRd70:
	ldrb r0,[t9ptr,#tlcsIPending+0x0A]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x1C]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd71:
	ldrb r0,[t9ptr,#tlcsIPending+0x0B]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x0C]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd72:
	ldrb r0,[t9ptr,#tlcsIPending+0x0D]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x0E]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd73:
	ldrb r0,[t9ptr,#tlcsIPending+0x10]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x11]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd74:
	ldrb r0,[t9ptr,#tlcsIPending+0x12]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x13]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd77:
	ldrb r0,[t9ptr,#tlcsIPending+0x18]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x19]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd79:
	ldrb r0,[t9ptr,#tlcsIPending+0x1D]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x1E]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd7A:
	ldrb r0,[t9ptr,#tlcsIPending+0x1F]
	cmp r0,#0
	movne r0,#0x08
	ldrb r1,[t9ptr,#tlcsIPending+0x20]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd75:
intRd76:
intRd78:
intRd7B:
	mov r0,#0
	bx lr
intRd7C:
intRd7D:
intRd7E:
intRd7F:
	and r1,r1,#0x03
	add r0,t9ptr,#tlcsDMAStartVector
	ldrb r0,[r0,r1]
	bx lr

;@---------------------------------------------------------------------------
#ifdef NDS
	.section .itcm						;@ For the NDS ARM9
#elif GBA
	.section .iwram, "ax", %progbits	;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
	.align 2
;@---------------------------------------------------------------------------
checkInterrupt:
;@---------------------------------------------------------------------------
;@---------------------------------------------------------------------------
;@TestMicroDMA:
;@---------------------------------------------------------------------------
	ldr r3,[t9ptr,#tlcsDMAStartVector]
	cmp r3,#0
	bne DMATest
testInterrupt:
	ldrb r1,[t9ptr,#tlcsIrqDirty]
	cmp r1,#0
	stmfd sp!,{lr}
	blne intCheckPending
	ldmfd sp!,{lr}
	ldrb r1,[t9ptr,#tlcsIrqPrio]
	cmp r1,#0
	bxeq lr
	ldrb r2,[t9ptr,#tlcsSrB]
	and r2,r2,#0x70
	cmp r1,r2,lsr#4
	bxmi lr

	ldrb r0,[t9ptr,#tlcsIrqVec]
	mov r3,#0
	add r2,t9ptr,#tlcsIPending
	strb r3,[r2,r0]
	strb r0,[t9ptr,#tlcsIrqDirty]
;@---------------------------------------------------------------------------
	stmfd sp!,{r0,r1,lr}

	ldrb r1,[t9pc]
	cmp r1,#0x05				;@ Halt?
	addeq t9pc,t9pc,#1

	ldr r0,[t9ptr,#tlcsLastBank]
	sub r0,t9pc,r0
	bl push32
	bl pushSR

	;@ INTNEST should be updated too!

	;@ Access the interrupt vector table to find the jump destination
	ldmfd sp!,{r0}				;@ Index
	ldr r1,=0xFFFF00			;@ Interrupt vectors
	add r0,r1,r0,lsl#2
	bl t9LoadL
	bl encode_r0_pc

	ldmfd sp!,{r0}				;@ Int level
	cmp r0,#0x07
	addmi r0,r0,#0x01
	bl setStatusIFF

	t9eatcycles 28
	ldmfd sp!,{lr}
	bx lr

;@---------------------------------------------------------------------------
setVBlankInterrupt:
;@---------------------------------------------------------------------------
	mov r0,#0x0B
;@---------------------------------------------------------------------------
setInterrupt:				;@ r0 = index
;@---------------------------------------------------------------------------
	mov r1,#0x07
	add r2,t9ptr,#tlcsIPending
	strb r1,[r2,r0]
	strb r1,[t9ptr,#tlcsIrqDirty]
	bx lr
;@---------------------------------------------------------------------------
intCheckPending:
;@---------------------------------------------------------------------------
	mov r0,#0
	strb r0,[t9ptr,#tlcsIrqDirty]

	ldrb r1,[t9ptr,#tlcsIPending+0x09]	;@ Watch dog timer, NMI.
	ands r1,r1,#0x07
	movne r0,#0x09

	ldrb r3,[t9ptr,#tlcsIPending+0x08]	;@ Power button, NMI.
	ands r3,r3,#0x07
	movne r1,#0x07
	movne r0,#0x08

	ldr r2,[t9ptr,#tlcsIntPrio+0x0]		;@ Prio for RTC/DA, Vbl/Z80, INT6/INT7 & Timer 0/1.
	ldrb r3,[t9ptr,#tlcsIPending+0x0A]	;@ RTC Alarm IRQ
	ands r3,r3,r2
	bne checkInt0x0A
intDontCheck0x0A:

	ldrb r3,[t9ptr,#tlcsIPending+0x0B]	;@ VBlank
	ands r3,r3,r2,lsr#8
	bne checkInt0x0B
intDontCheck0x0B:

	ldrb r3,[t9ptr,#tlcsIPending+0x0C]	;@ Z80
	ands r3,r3,r2,lsr#12
	bne checkInt0x0C
intDontCheck0x0C:

	ldrb r3,[t9ptr,#tlcsIPending+0x10]	;@ Timer0
	ands r3,r3,r2,lsr#24
	bne checkInt0x10
intDontCheck0x10:

	ldrb r3,[t9ptr,#tlcsIPending+0x11]	;@ Timer1
	ands r3,r3,r2,lsr#28
	bne checkInt0x11
intDontCheck0x11:

	ldr r2,[t9ptr,#tlcsIntPrio+0x4]		;@ Prio for Timer 2/3, T 4/5, T 6/7 & RX0/TX0.
	ldrb r3,[t9ptr,#tlcsIPending+0x12]	;@ Timer2
	ands r3,r3,r2
	bne checkInt0x12
intDontCheck0x12:

	ldrb r3,[t9ptr,#tlcsIPending+0x13]	;@ Timer3
	ands r3,r3,r2,lsr#4
	bne checkInt0x13
intDontCheck0x13:

	ldrb r3,[t9ptr,#tlcsIPending+0x18]	;@ Serial RX 0
	ands r3,r3,r2,lsr#24
	bne checkInt0x18
intDontCheck0x18:

	ldrb r3,[t9ptr,#tlcsIPending+0x19]	;@ Serial TX 0
	ands r3,r3,r2,lsr#28
	bne checkInt0x19
intDontCheck0x19:

	ldrb r2,[t9ptr,#tlcsIntPrio+0x0]	;@ Prio for RTC/DA
	ldrb r3,[t9ptr,#tlcsIPending+0x1C]	;@ D/A conversion finnished
	ands r3,r3,r2,lsr#4
	bne checkInt0x1C
intDontCheck0x1C:

	ldr r2,[t9ptr,#tlcsIntPrio+0x8]		;@ Prio for RX1/TX1, DMAEnd 0/1 & DMAEnd 2/3.
	ldrb r3,[t9ptr,#tlcsIPending+0x1D]	;@ DMA0 END
	ands r3,r3,r2,lsr#8
	bne checkInt0x1D
intDontCheck0x1D:

	ldrb r3,[t9ptr,#tlcsIPending+0x1E]	;@ DMA1 END
	ands r3,r3,r2,lsr#12
	bne checkInt0x1E
intDontCheck0x1E:

	ldrb r3,[t9ptr,#tlcsIPending+0x1F]	;@ DMA2 END
	ands r3,r3,r2,lsr#16
	bne checkInt0x1F
intDontCheck0x1F:

	ldrb r3,[t9ptr,#tlcsIPending+0x20]	;@ DMA3 END
	ands r3,r3,r2,lsr#20
	bne checkInt0x20
intDontCheck0x20:

	strb r0,[t9ptr,#tlcsIrqVec]
	strb r1,[t9ptr,#tlcsIrqPrio]
	bx lr

checkInt0x0A:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x0A
	b intDontCheck0x0A
checkInt0x0B:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x0B
	b intDontCheck0x0B
checkInt0x0C:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x0C
	b intDontCheck0x0C
checkInt0x10:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x10
	b intDontCheck0x10
checkInt0x11:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x11
	b intDontCheck0x11
checkInt0x12:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x12
	b intDontCheck0x12
checkInt0x13:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x13
	b intDontCheck0x13
checkInt0x18:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x18
	b intDontCheck0x18
checkInt0x19:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x19
	b intDontCheck0x19
checkInt0x1C:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x1C
	b intDontCheck0x1C
checkInt0x1D:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x1D
	b intDontCheck0x1D
checkInt0x1E:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x1E
	b intDontCheck0x1E
checkInt0x1F:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x1F
	b intDontCheck0x1F
checkInt0x20:
	cmp r1,r3
	movmi r1,r3
	movmi r0,#0x20
	b intDontCheck0x20
;@----------------------------------------------------------------------------
clockTimer0:
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsT01Mod]
	tst r0,#0x03
	bxne lr
	ldrb r0,[t9ptr,#tlcsTRun]
	tst r0,#0x01
	ldrbne r0,[t9ptr,#tlcsUpCounter]
	addne r0,r0,#1
	strbne r0,[t9ptr,#tlcsUpCounter]
	bx lr
;@----------------------------------------------------------------------------
updateTimers:				;@ r0 = cputicks (515)
;@----------------------------------------------------------------------------
	stmfd sp!,{r4-r6,lr}

	mov r6,r0
	mov r5,#0					;@ r5 = h_int / timer0 / timer1
	ldrb r4,[t9ptr,#tlcsTRun]
	tst r4,#0x80
	moveq r6,#0					;@ Clear clocks if master not enabled
	tst r4,#0x01
	beq noTimer0
;@----------------------------------------------------------------------------
								;@ TIMER0
	ldrb r2,[t9ptr,#tlcsUpCounter]
	ldrb r1,[t9ptr,#tlcsT01Mod]
	ands r1,r1,#0x03
	beq timer0End
t0c0:							;@ TIMER0 case 0
t0c2:
	cmp r1,#0x02
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER0 case 1
	ldreq r0,=TIMER_T4_RATE		;@ TIMER0 case 2
	ldrhi r0,=TIMER_T16_RATE	;@ TIMER0 case 3
	ldr r12,[t9ptr,#tlcsTimerClock]
	add r12,r12,r6				;@ r6 = cputicks
t0c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subspl r12,r12,r0
		bpl t0c2Loop
		str r12,[t9ptr,#tlcsTimerClock]

timer0End:
	ldrb r0,[t9ptr,#tlcsTimerCompare]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9ptr,#tlcsUpCounter]
	movpl r5,#1					;@ Timer0 = TRUE
	movpl r0,#0x10
	blpl setInterrupt

noTimer0:
	tst r4,#0x02
	beq noTimer1
;@----------------------------------------------------------------------------
								;@ TIMER1
	ldrb r2,[t9ptr,#tlcsUpCounter+1]
	ldrb r1,[t9ptr,#tlcsT01Mod]
	ands r1,r1,#0x0C
;@	bne t1c2
t1c0:							;@ TIMER1 case 0
		addeq r2,r2,r5			;@ Timer0 chain
		beq timer1End

t1c2:
	cmp r1,#0x08
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER1 case 1
	ldreq r0,=TIMER_T16_RATE	;@ TIMER1 case 2
	ldrhi r0,=TIMER_T256_RATE	;@ TIMER1 case 3
	ldr r12,[t9ptr,#tlcsTimerClock+4]
	add r12,r12,r6				;@ r6 = cputicks
t1c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subspl r12,r12,r0
		bpl t1c2Loop
		str r12,[t9ptr,#tlcsTimerClock+4]

timer1End:
	ldrb r0,[t9ptr,#tlcsTimerCompare+1]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9ptr,#tlcsUpCounter+1]
	movpl r0,#0x11
	blpl setInterrupt

noTimer1:
	mov r5,#0					;@ Timer2 = FALSE
	tst r4,#0x04
	beq noTimer2
;@----------------------------------------------------------------------------
								;@ TIMER2
	ldrb r1,[t9ptr,#tlcsT23Mod]
	ands r1,r1,#0x03
	beq noTimer2				;@ TIMER2 case 0, nothing
	ldrb r2,[t9ptr,#tlcsUpCounter+2]

t2c2:
	cmp r1,#0x02
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER2 case 1
	ldreq r0,=TIMER_T4_RATE		;@ TIMER2 case 2
	ldrhi r0,=TIMER_T16_RATE	;@ TIMER2 case 3
	ldr r12,[t9ptr,#tlcsTimerClock+8]
	add r12,r12,r6				;@ r6 = cputicks
t2c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subspl r12,r12,r0
		bpl t2c2Loop
		str r12,[t9ptr,#tlcsTimerClock+8]

timer2End:
	ldrb r0,[t9ptr,#tlcsTimerCompare+2]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9ptr,#tlcsUpCounter+2]
	bmi noTimer2
;@----------------------------------------------------------------------------
;@ clockFlipFlop3ByT2
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTFFCR]
	and r0,r0,#0x30
	cmp r0,#0x20
	bleq changeFlipFlop3
	mov r5,#1					;@ Timer2 = TRUE
	mov r0,#0x12
	bl setInterrupt

noTimer2:
	tst r4,#0x08
	beq noTimer3
;@----------------------------------------------------------------------------
								;@ TIMER3
	ldrb r2,[t9ptr,#tlcsUpCounter+3]
	ldrb r1,[t9ptr,#tlcsT23Mod]
	ands r1,r1,#0x0C
;@	bne t3c2
t3c0:							;@ TIMER3 case 0
		addeq r2,r2,r5			;@ Timer2 chain
		beq timer3End

t3c2:
	cmp r1,#0x08
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER3 case 1
	ldreq r0,=TIMER_T16_RATE	;@ TIMER3 case 2
	ldrhi r0,=TIMER_T256_RATE	;@ TIMER3 case 3
	ldr r12,[t9ptr,#tlcsTimerClock+12]
	add r12,r12,r6				;@ r6 = cputicks
t3c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subspl r12,r12,r0
		bpl t3c2Loop
		str r12,[t9ptr,#tlcsTimerClock+12]

timer3End:
	ldrb r0,[t9ptr,#tlcsTimerCompare+3]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9ptr,#tlcsUpCounter+3]
	bmi noTimer3
;@----------------------------------------------------------------------------
;@ clockFlipFlop3ByT3
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTFFCR]
	and r0,r0,#0x30
	cmp r0,#0x30
	bleq changeFlipFlop3
	mov r0,#0x13
	bl setInterrupt

noTimer3:
noTimers:
	ldmfd sp!,{r4-r6,lr}
	bx lr

;@----------------------------------------------------------------------------
changeFlipFlop3:
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTFF3]
	eor r0,r0,#1
;@----------------------------------------------------------------------------
setFlipFlop3:				;@ r0 bit 0 = TFF3 state
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTFF3]
	ldr pc,[t9ptr,#tff3Function]

;@----------------------------------------------------------------------------
DMATest:					;@ r3=DMAVectors
;@----------------------------------------------------------------------------
	add r2,t9ptr,#tlcsIPending
	movs r1,r3,lsl#27
	ldrbne r0,[r2,r1,lsr#27]
	cmpne r0,#0
	strbne r1,[r2,r1,lsr#27]
	movne r0,#0
	bne DMAUpdate

	ands r1,r3,#0x00001F00
	ldrbne r0,[r2,r1,lsr#8]
	cmpne r0,#0
	strbne r1,[r2,r1,lsr#8]
	movne r0,#1
	bne DMAUpdate

	ands r1,r3,#0x001F0000
	ldrbne r0,[r2,r1,lsr#16]
	cmpne r0,#0
	strbne r1,[r2,r1,lsr#16]
	movne r0,#2
	bne DMAUpdate

	ands r1,r3,#0x1F000000
	ldrbne r0,[r2,r1,lsr#24]
	cmpne r0,#0
	strbne r1,[r2,r1,lsr#24]
	beq testInterrupt
	mov r0,#3

;@----------------------------------------------------------------------------
DMAUpdate:					;@ r0 = channel
;@----------------------------------------------------------------------------
	stmfd sp!,{r5,r6,lr}
	and r5,r0,#0x03
	add r6,t9ptr,#tlcsDmaS
	ldr t9Mem,[r6,r5,lsl#2]!	;@ Source Adress
	ldrb r1,[r6,#0x22]			;@ DMA M
	and r1,r1,#0x1F
	ldr pc,[pc,r1,lsl#2]
	.long 0
	.long DMA_DSTInc_B
	.long DMA_DSTInc_W
	.long DMA_DSTInc_L
	.long DMA_Bad
	.long DMA_DSTDec_B
	.long DMA_DSTDec_W
	.long DMA_DSTDec_L
	.long DMA_Bad
	.long DMA_SRCInc_B
	.long DMA_SRCInc_W
	.long DMA_SRCInc_L
	.long DMA_Bad
	.long DMA_SRCDec_B
	.long DMA_SRCDec_W
	.long DMA_SRCDec_L
	.long DMA_Bad
	.long DMA_FixMode_B
	.long DMA_FixMode_W
	.long DMA_FixMode_L
	.long DMA_Bad
	.long DMA_CountMode
	.long DMA_CountMode
	.long DMA_CountMode
	.long DMA_CountMode
	.long DMA_Bad
	.long DMA_Bad
	.long DMA_Bad
	.long DMA_Bad
	.long DMA_Bad
	.long DMA_Bad
	.long DMA_Bad
	.long DMA_Bad

;@----------------------------------------------------------------------------
DMA_DSTInc_B:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	add r1,t9Mem,#1
	str r1,[r6,#0x10]			;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
DMA_DSTInc_W:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	add r1,t9Mem,#2
	str r1,[r6,#0x10]			;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreW_mem
;@----------------------------------------------------------------------------
DMA_DSTInc_L:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	add r1,t9Mem,#4
	str r1,[r6,#0x10]			;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 12
	b t9StoreL_mem
;@----------------------------------------------------------------------------
DMA_DSTDec_B:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	sub r1,t9Mem,#1
	str r1,[r6,#0x10]			;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
DMA_DSTDec_W:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	sub r1,t9Mem,#2
	str r1,[r6,#0x10]			;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreW_mem
;@----------------------------------------------------------------------------
DMA_DSTDec_L:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	sub r1,t9Mem,#4
	str r1,[r6,#0x10]			;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 12
	b t9StoreL_mem
;@----------------------------------------------------------------------------
DMA_SRCInc_B:
;@----------------------------------------------------------------------------
	add r1,t9Mem,#1
	str r1,[r6]					;@ Source Adress
	bl t9LoadB_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
DMA_SRCInc_W:
;@----------------------------------------------------------------------------
	add r1,t9Mem,#2
	str r1,[r6]					;@ Source Adress
	bl t9LoadW_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreW_mem
;@----------------------------------------------------------------------------
DMA_SRCInc_L:
;@----------------------------------------------------------------------------
	add r1,t9Mem,#4
	str r1,[r6]					;@ Source Adress
	bl t9LoadL_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 12
	b t9StoreL_mem
;@----------------------------------------------------------------------------
DMA_SRCDec_B:
;@----------------------------------------------------------------------------
	sub r1,t9Mem,#1
	str r1,[r6]					;@ Source Adress
	bl t9LoadB_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
DMA_SRCDec_W:
;@----------------------------------------------------------------------------
	sub r1,t9Mem,#2
	str r1,[r6]					;@ Source Adress
	bl t9LoadW_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreW_mem
;@----------------------------------------------------------------------------
DMA_SRCDec_L:
;@----------------------------------------------------------------------------
	sub r1,t9Mem,#4
	str r1,[r6]					;@ Source Adress
	bl t9LoadL_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 12
	b t9StoreL_mem
;@----------------------------------------------------------------------------
DMA_FixMode_B:
;@----------------------------------------------------------------------------
	bl t9LoadB_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreB_mem
;@----------------------------------------------------------------------------
DMA_FixMode_W:
;@----------------------------------------------------------------------------
	bl t9LoadW_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 8
	b t9StoreW_mem
;@----------------------------------------------------------------------------
DMA_FixMode_L:
;@----------------------------------------------------------------------------
	bl t9LoadL_mem
	ldr t9Mem,[r6,#0x10]		;@ Destination Adress
	adr lr,DMA_Finnish
	t9eatcycles 12
	b t9StoreL_mem
;@----------------------------------------------------------------------------
DMA_CountMode:
;@----------------------------------------------------------------------------
	add t9Mem,t9Mem,#1
	str t9Mem,[r6]				;@ Source Adress
	t9eatcycles 5
	b DMA_Finnish
;@----------------------------------------------------------------------------
DMA_Bad:
;@----------------------------------------------------------------------------
	mov r11,r11
	ldr r0,=0xD4ABAD
;@----------------------------------------------------------------------------
DMA_Finnish:
;@----------------------------------------------------------------------------
	ldrh r0,[r6,#0x20]			;@ DMA C
	subs r0,r0,#1				;@ Check if we're done.
	strh r0,[r6,#0x20]
	bne dmaEnd
	add t9Mem,r5,#0x7C			;@ Clear old vector.
	mov r0,#0
	bl t9StoreB_Low
	add r0,r5,#0x1D
	bl setInterrupt
dmaEnd:
	ldmfd sp!,{r5,r6,lr}
	b checkInterrupt			;@ Check for more Micro DMA & normal IRQ.

;@----------------------------------------------------------------------------
timerRunR:					;@ 0x20
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTRun]
	bx lr
;@----------------------------------------------------------------------------
timer0R:					;@ 0x22
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTimerCompare]
	bx lr
;@----------------------------------------------------------------------------
timer1R:					;@ 0x23
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTimerCompare+1]
	bx lr
;@----------------------------------------------------------------------------
timerT01ModR:				;@ 0x24
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsT01Mod]
	bx lr
;@----------------------------------------------------------------------------
timerTffcrR:				;@ 0x25
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTFFCR]
	orr r0,r0,#0xCC
	bx lr
;@----------------------------------------------------------------------------
timer2R:					;@ 0x26
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTimerCompare+2]
	bx lr
;@----------------------------------------------------------------------------
timer3R:					;@ 0x27
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTimerCompare+3]
	bx lr
;@----------------------------------------------------------------------------
timerT23ModR:				;@ 0x28
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsT23Mod]
	bx lr
;@----------------------------------------------------------------------------
timerTrdcR:					;@ 0x29
;@----------------------------------------------------------------------------
	ldrb r0,[t9ptr,#tlcsTrdc]
	bx lr
;@----------------------------------------------------------------------------
timerBadR:					;@ 0x2X
;@----------------------------------------------------------------------------
	mov r0,#0
	bx lr
;@----------------------------------------------------------------------------
timerRunW:					;@ 0x20
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTRun]
	tst r0,#0x80
	biceq r0,r0,#0x0F
	ldr r2,[t9ptr,#tlcsUpCounter]
	tst r0,#0x01
	biceq r2,r2,#0x000000FF
	tst r0,#0x02
	biceq r2,r2,#0x0000FF00
	tst r0,#0x04
	biceq r2,r2,#0x00FF0000
	tst r0,#0x08
	biceq r2,r2,#0xFF000000
	str r2,[t9ptr,#tlcsUpCounter]
	bx lr
;@----------------------------------------------------------------------------
timer0W:					;@ 0x22
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTimerCompare]
	bx lr
;@----------------------------------------------------------------------------
timer1W:					;@ 0x23
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTimerCompare+1]
	bx lr
;@----------------------------------------------------------------------------
timerT01ModW:				;@ 0x24
;@----------------------------------------------------------------------------
	ldrb r1,[t9ptr,#tlcsT01Mod]
	strb r0,[t9ptr,#tlcsT01Mod]
	eor r1,r1,r0
	mov r0,#0
	tst r1,#0x03				;@ Timer0 input clock changed?
	strne r0,[t9ptr,#tlcsTimerClock]
	tst r1,#0x0C				;@ Timer1 input clock changed?
	strne r0,[t9ptr,#tlcsTimerClock+4]
	bx lr
;@----------------------------------------------------------------------------
timerTffcrW:				;@ 0x25
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTFFCR]
	movs r0,r0,lsr#6
	beq changeFlipFlop3
	cmp r0,#0x03
	bxeq lr
	and r0,r0,#1
	b setFlipFlop3

;@----------------------------------------------------------------------------
timer2W:					;@ 0x26
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTimerCompare+2]
	bx lr
;@----------------------------------------------------------------------------
timer3W:					;@ 0x27
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTimerCompare+3]
	bx lr
;@----------------------------------------------------------------------------
timerT23ModW:				;@ 0x28
;@----------------------------------------------------------------------------
	ldrb r1,[t9ptr,#tlcsT23Mod]
	strb r0,[t9ptr,#tlcsT23Mod]
	eor r1,r1,r0
	mov r0,#0
	tst r1,#0x03				;@ Timer2 input clock changed?
	strne r0,[t9ptr,#tlcsTimerClock+8]
	tst r1,#0x0C				;@ Timer3 input clock changed?
	strne r0,[t9ptr,#tlcsTimerClock+12]
	bx lr
;@----------------------------------------------------------------------------
timerTrdcW:					;@ 0x29
;@----------------------------------------------------------------------------
	strb r0,[t9ptr,#tlcsTrdc]
	bx lr
;@----------------------------------------------------------------------------
timerBadW:					;@ 0x2X
;@----------------------------------------------------------------------------
	mov r11,r11					;@ No$GBA breakpoint
	ldr r2,=debugIOUnimplW
	bx lr

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
