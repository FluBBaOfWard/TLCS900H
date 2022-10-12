//
//  TLCS900H_int.s
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2022 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "TLCS900H_mac.h"
#include "../K2GE/K2GE.i"

	.global intCheckPending
	.global updateTimers
	.global setInterrupt
	.global setInterruptExternal
	.global resetDMA
	.global resetTimers
	.global resetInterrupts
	.global timerRead8
	.global timerWrite8
	.global intWrite8
	.global intRead8


#ifdef GBA
	.section .ewram, "ax"		;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
	.align 2
;@---------------------------------------------------------------------------
resetDMA:
;@---------------------------------------------------------------------------
	add r0,t9optbl,#tlcsDmaS
	mov r1,#0
	mov r2,#12					;@ 12*4
	b memset_					;@ Clear DMA regs
;@---------------------------------------------------------------------------
resetTimers:
;@---------------------------------------------------------------------------
	add r0,t9optbl,#tlcsTimerClock
	mov r1,#0
	mov r2,#6					;@ 6*4
	b memset_					;@ Clear Timer regs
;@---------------------------------------------------------------------------
resetInterrupts:
;@---------------------------------------------------------------------------
	mov r0,#0
	strb r0,[t9optbl,#tlcsTRun]
	strb r0,[t9optbl,#tlcsT01Mod]
	strb r0,[t9optbl,#tlcsT23Mod]
	strb r0,[t9optbl,#tlcsTrdc]
	strb r0,[t9optbl,#tlcsTffcr]
	str r0,[t9optbl,#tlcsDMAStartVector]

	add r0,t9optbl,#tlcsIPending
	mov r1,#0
	mov r2,#16					;@ 16*4
	b memset_					;@ Clear INT regs

;@---------------------------------------------------------------------------
intWrite8:					;@ r0 = value, r1 = address
;@---------------------------------------------------------------------------
	mov r1,r1,lsl#28
	and r2,r0,#0x70
	cmp r2,#0x70
	biceq r0,r0,#0x70
	and r2,r0,#0x07
	cmp r2,#0x07
	biceq r0,r0,#0x07
	add r2,t9optbl,#tlcsIntPrio
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
	streqb r1,[t9optbl,#tlcsIPending+0x0A]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x1C]
	b intCheckPending
intWr71:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcsIPending+0x0B]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x0C]
	b intCheckPending
intWr72:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcsIPending+0x0D]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x0E]
	b intCheckPending
intWr73:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcsIPending+0x10]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x11]
	b intCheckPending
intWr74:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcsIPending+0x12]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x13]
intWr75:
intWr76:
	b intCheckPending
intWr77:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcsIPending+0x18]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x19]
intWr78:
	b intCheckPending
intWr79:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcsIPending+0x1D]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x1E]
	b intCheckPending
intWr7A:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcsIPending+0x1F]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcsIPending+0x20]
intWr7B:
	b intCheckPending

intWr7C:
intWr7D:
intWr7E:
intWr7F:
	and r0,r0,#0x3F
	and r1,r1,#0x30000000
	add r2,t9optbl,#tlcsDMAStartVector
	strb r0,[r2,r1,lsr#28]
	bx lr
;@---------------------------------------------------------------------------
intRead8:					;@ r0 = address
;@---------------------------------------------------------------------------
	and r1,r0,#0x0F
	mov r0,#0
	ldr pc,[pc,r1,lsl#2]
	.long 0
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
intRd70:
	ldrb r1,[t9optbl,#tlcsIPending+0x0A]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x1C]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd71:
	ldrb r1,[t9optbl,#tlcsIPending+0x0B]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x0C]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd72:
	ldrb r1,[t9optbl,#tlcsIPending+0x0D]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x0E]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd73:
	ldrb r1,[t9optbl,#tlcsIPending+0x10]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x11]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd74:
	ldrb r1,[t9optbl,#tlcsIPending+0x12]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x13]
	cmp r1,#0
	orrne r0,r0,#0x80
intRd75:
intRd76:
	bx lr
intRd77:
	ldrb r1,[t9optbl,#tlcsIPending+0x18]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x19]
	cmp r1,#0
	orrne r0,r0,#0x80
intRd78:
	bx lr
intRd79:
	ldrb r1,[t9optbl,#tlcsIPending+0x1D]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x1E]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
intRd7A:
	ldrb r1,[t9optbl,#tlcsIPending+0x1F]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcsIPending+0x20]
	cmp r1,#0
	orrne r0,r0,#0x80
intRd7B:
	bx lr
intRd7C:
intRd7D:
intRd7E:
intRd7F:
	and r1,r1,#0x03
	add r0,t9optbl,#tlcsDMAStartVector
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
interrupt:					;@ r0 = index, r1 = int level
;@---------------------------------------------------------------------------
	mov r3,#0
	add r2,t9optbl,#tlcsIPending
	strb r3,[r2,r0]
;@---------------------------------------------------------------------------
;@TestMicroDMA:				;@ r0 = index
;@---------------------------------------------------------------------------
	ldr r2,[t9optbl,#tlcsDMAStartVector]
	and r3,r2,#0xFF
	cmp r3,r0
	moveq r0,#0
	beq DMA_update

	and r3,r2,#0xFF00
	cmp r3,r0,lsl#8
	moveq r0,#1
	beq DMA_update

	and r3,r2,#0xFF0000
	cmp r3,r0,lsl#16
	moveq r0,#2
	beq DMA_update

	cmp r0,r2,lsr#24
	moveq r0,#3
	beq DMA_update
;@---------------------------------------------------------------------------
	stmfd sp!,{r0,r1,lr}

	ldrb r1,[t9pc]
	cmp r1,#0x05				;@ Halt?
	addeq t9pc,t9pc,#1

	ldr r0,[t9optbl,#tlcsLastBank]
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
	add r0,r0,#0x01
	cmp r0,#0x07
	movhi r0,#0x07
	bl setStatusIFF

interruptEnd:
	ldmfd sp!,{lr}
	bx lr

;@---------------------------------------------------------------------------
setInterruptExternal:		;@ r0 = index
	.type setInterruptExternal STT_FUNC
;@---------------------------------------------------------------------------
	stmfd sp!,{t9optbl,lr}
	ldr t9optbl,=tlcs900HState
	bl setInterrupt
	ldmfd sp!,{t9optbl,lr}
	bx lr
;@---------------------------------------------------------------------------
setInterrupt:				;@ r0 = index
;@---------------------------------------------------------------------------
	mov r1,#0x07
	add r2,t9optbl,#tlcsIPending
	strb r1,[r2,r0]
	bx lr
;@---------------------------------------------------------------------------
intCheckPending:
;@---------------------------------------------------------------------------
	stmfd sp!,{lr}
	bl statusIFF
	ldmfd sp!,{lr}
	add r2,t9optbl,#tlcsIPending
	add r3,t9optbl,#tlcsIntPrio

	ldrb r1,[r2,#0x0B]			;@ VBlank
	cmp r1,#0
	beq intDontCheck0x0B
	ldrb r1,[r3,#0x1]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x0B
	ble interrupt
intDontCheck0x0B:

	ldrb r1,[r2,#0x0C]			;@ Z80
	cmp r1,#0
	beq intDontCheck0x0C
	ldrb r1,[r3,#0x1]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x0C
	ble interrupt
intDontCheck0x0C:

	ldrb r1,[r2,#0x10]			;@ Timer0
	cmp r1,#0
	beq intDontCheck0x10
	ldrb r1,[r3,#0x3]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x10
	ble interrupt
intDontCheck0x10:

	ldrb r1,[r2,#0x11]			;@ Timer1
	cmp r1,#0
	beq intDontCheck0x11
	ldrb r1,[r3,#0x3]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x11
	ble interrupt
intDontCheck0x11:

	ldrb r1,[r2,#0x12]			;@ Timer2
	cmp r1,#0
	beq intDontCheck0x12
	ldrb r1,[r3,#0x4]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x12
	ble interrupt
intDontCheck0x12:

	ldrb r1,[r2,#0x13]			;@ Timer3
	cmp r1,#0
	beq intDontCheck0x13
	ldrb r1,[r3,#0x4]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x13
	ble interrupt
intDontCheck0x13:

	ldrb r1,[r2,#0x18]			;@ Serial TX 0
	cmp r1,#0
	beq intDontCheck0x18
	ldrb r1,[r3,#0x7]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x18
	ble interrupt
intDontCheck0x18:

	ldrb r1,[r2,#0x19]			;@ Serial RX 0
	cmp r1,#0
	beq intDontCheck0x19
	ldrb r1,[r3,#0x7]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x19
	ble interrupt
intDontCheck0x19:

	ldrb r1,[r2,#0x1C]			;@ D/A conversion finnished
	cmp r1,#0
	beq intDontCheck0x1C
	ldrb r1,[r3,#0x0]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1C
	ble interrupt
intDontCheck0x1C:

	ldrb r1,[r2,#0x1D]			;@ DMA0 END
	cmp r1,#0
	beq intDontCheck0x1D
	ldrb r1,[r3,#0x9]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1D
	ble interrupt
intDontCheck0x1D:

	ldrb r1,[r2,#0x1E]			;@ DMA1 END
	cmp r1,#0
	beq intDontCheck0x1E
	ldrb r1,[r3,#0x9]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1E
	ble interrupt
intDontCheck0x1E:

	ldrb r1,[r2,#0x1F]			;@ DMA2 END
	cmp r1,#0
	beq intDontCheck0x1F
	ldrb r1,[r3,#0xA]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1F
	ble interrupt
intDontCheck0x1F:

	ldrb r1,[r2,#0x20]			;@ DMA3 END
	cmp r1,#0
	beq intDontCheck0x20
	ldrb r1,[r3,#0xA]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x20
	ble interrupt
intDontCheck0x20:

	ldrb r1,[r2,#0x0A]			;@ RTC Alarm IRQ
	cmp r1,#0
	beq intDontCheck0x0A
	ldrb r1,[r3,#0x0]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x0A
	ble interrupt
intDontCheck0x0A:

	ldrb r1,[r2,#0x08]			;@ Power button, NMI?
	cmp r1,#0
	movne r1,#0x06
	movne r0,#0x08
	bne interrupt

	ldrb r1,[r2,#0x09]			;@ Watch dog timer, NMI?
	cmp r1,#0
	movne r1,#0x06
	movne r0,#0x09
	bne interrupt

	bx lr
;@----------------------------------------------------------------------------
updateTimers:				;@ r0 = cputicks (515)
;@----------------------------------------------------------------------------
	stmfd sp!,{r4-r6,lr}

	mov r6,r0
	mov r5,#0					;@ r5 = h_int / timer0 / timer1
	ldrb r4,[t9optbl,#tlcsTRun]
	tst r4,#0x01
	beq noTimer0
;@----------------------------------------------------------------------------
								;@ TIMER0
	ldrb r2,[t9optbl,#tlcsTimer]
	ldrb r1,[t9optbl,#tlcsT01Mod]
	ands r1,r1,#0x03
	bne t0c2
t0c0:							;@ TIMER0 case 0
		ldr r0,=T9_HINT_RATE
		ldr r12,[t9optbl,#tlcsTimerHInt]
		add r12,r12,r6
		cmp r12,r0
		subpl r12,r12,r0
		str r12,[t9optbl,#tlcsTimerHInt]
		bmi noTimer0
		ldr geptr,=k2GE_0
		bl GetHInt				;@ HInt, this should only return 0 or 1.
		add r2,r2,r0
		b timer0End

t0c2:
	cmp r1,#0x02
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER0 case 1
	ldreq r0,=TIMER_T4_RATE		;@ TIMER0 case 2
	ldrhi r0,=TIMER_T16_RATE	;@ TIMER0 case 3
	ldr r12,[t9optbl,#tlcsTimerClock]
	add r12,r12,r6				;@ r6 = cputicks
t0c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subpl r12,r12,r0
		bpl t0c2Loop
		str r12,[t9optbl,#tlcsTimerClock]

timer0End:
	ldrb r0,[t9optbl,#tlcsTimerThreshold]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcsTimer]
	movpl r5,#1					;@ Timer0 = TRUE
	movpl r0,#0x10
	blpl setInterrupt

noTimer0:
	tst r4,#0x02
	beq noTimer1
;@----------------------------------------------------------------------------
								;@ TIMER1
	ldrb r2,[t9optbl,#tlcsTimer+1]
	ldrb r1,[t9optbl,#tlcsT01Mod]
	ands r1,r1,#0x0C
	bne t1c2
t1c0:							;@ TIMER1 case 0
		add r2,r2,r5			;@ Timer0 chain
		b timer1End

t1c2:
	cmp r1,#0x08
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER1 case 1
	ldreq r0,=TIMER_T16_RATE	;@ TIMER1 case 2
	ldrhi r0,=TIMER_T256_RATE	;@ TIMER1 case 3
	ldr r12,[t9optbl,#tlcsTimerClock+4]
	add r12,r12,r6				;@ r6 = cputicks
t1c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subpl r12,r12,r0
		bpl t1c2Loop
		str r12,[t9optbl,#tlcsTimerClock+4]

timer1End:
	ldrb r0,[t9optbl,#tlcsTimerThreshold+1]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcsTimer+1]
	movpl r0,#0x11
	blpl setInterrupt

noTimer1:
	mov r5,#0					;@ Timer2 = FALSE
	tst r4,#0x04
	beq noTimer2
;@----------------------------------------------------------------------------
								;@ TIMER2
	ldrb r1,[t9optbl,#tlcsT23Mod]
	ands r1,r1,#0x03
	beq noTimer2				;@ TIMER2 case 0, nothing
	ldrb r2,[t9optbl,#tlcsTimer+2]

t2c2:
	cmp r1,#0x02
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER2 case 1
	ldreq r0,=TIMER_T4_RATE		;@ TIMER2 case 2
	ldrhi r0,=TIMER_T16_RATE	;@ TIMER2 case 3
	ldr r12,[t9optbl,#tlcsTimerClock+8]
	add r12,r12,r6				;@ r6 = cputicks
t2c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subpl r12,r12,r0
		bpl t2c2Loop
		str r12,[t9optbl,#tlcsTimerClock+8]

timer2End:
	ldrb r0,[t9optbl,#tlcsTimerThreshold+2]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcsTimer+2]
	movpl r5,#1					;@ Timer2 = TRUE
	movpl r0,#0x12
	blpl setInterrupt

noTimer2:
	tst r4,#0x08
	beq noTimer3
;@----------------------------------------------------------------------------
								;@ TIMER3
	ldrb r2,[t9optbl,#tlcsTimer+3]
	ldrb r1,[t9optbl,#tlcsT23Mod]
	ands r1,r1,#0x0C
	bne t3c2
t3c0:							;@ TIMER3 case 0
		add r2,r2,r5			;@ Timer2 chain
		b timer3End

t3c2:
	cmp r1,#0x08
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER3 case 1
	ldreq r0,=TIMER_T16_RATE	;@ TIMER3 case 2
	ldrhi r0,=TIMER_T256_RATE	;@ TIMER3 case 3
	ldr r12,[t9optbl,#tlcsTimerClock+12]
	add r12,r12,r6				;@ r6 = cputicks
t3c2Loop:
		cmp r12,r0
		addpl r2,r2,#1
		subpl r12,r12,r0
		bpl t3c2Loop
		str r12,[t9optbl,#tlcsTimerClock+12]

timer3End:
	ldrb r0,[t9optbl,#tlcsTimerThreshold+3]
	cmp r0,#0
	moveq r0,#0x100
	cmp r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcsTimer+3]
	bmi noTimer3
	mov r0,#1
	bl cpu1SetIRQ
	mov r0,#0x13
	bl setInterrupt

noTimer3:
	bl intCheckPending
	ldmfd sp!,{r4-r6,lr}
	bx lr
;@----------------------------------------------------------------------------
DMA_update:					;@ r0 = channel
;@----------------------------------------------------------------------------
	stmfd sp!,{r5,r6,lr}
;@	mov r11,r11
	and r5,r0,#0x03
	add r6,t9optbl,#tlcsDmaS
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
								;@ Missin SRC+DST_INC/DEC (copy mode)?
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
	add r0,r5,#0x1D
	bl setInterrupt
	add r1,r5,#0x7C				;@ Clear old vector.
	mov r0,#0
	bl t9StoreB
dmaEnd:
	ldmfd sp!,{r5,r6,lr}
	bx lr
;@----------------------------------------------------------------------------
timerRead8:					;@ r0 = address, Bios reads from 0x20, 0x25 & 0x28 at least
;@----------------------------------------------------------------------------
	and r0,r0,#0x0F
	adr r2,timerTable
	ldr r2,[r2,r0,lsl#2]
	cmp r2,#0
	ldrneb r0,[t9optbl,r2]
	moveq r0,#4					;@ Cool Boarders reads from 0x28 & 0x22 and wants 4...?
	bx lr
;@----------------------------------------------------------------------------
timerWrite8:				;@ r0 = value, r1 = address
;@----------------------------------------------------------------------------
	ands r1,r1,#0x0F
	beq tRunW
	adr r2,timerTable
	ldr r2,[r2,r1,lsl#2]
	cmp r2,#0
	strneb r0,[t9optbl,r2]
	bx lr
timerTable:
	.long tlcsTRun
	.long 0
	.long tlcsTimerThreshold
	.long tlcsTimerThreshold+1
	.long tlcsT01Mod
	.long tlcsTffcr
	.long tlcsTimerThreshold+2
	.long tlcsTimerThreshold+3
	.long tlcsT23Mod
	.long tlcsTrdc
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
;@----------------------------------------------------------------------------
tRunW:
;@----------------------------------------------------------------------------
	strb r0,[t9optbl,#tlcsTRun]
	ldr r2,[t9optbl,#tlcsTimer]
	tst r0,#0x01
	biceq r2,r2,#0x000000FF
	tst r0,#0x02
	biceq r2,r2,#0x0000FF00
	tst r0,#0x04
	biceq r2,r2,#0x00FF0000
	tst r0,#0x08
	biceq r2,r2,#0xFF000000
	str r2,[t9optbl,#tlcsTimer]	;@ str ?
	bx lr

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
