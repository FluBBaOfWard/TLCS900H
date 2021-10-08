#ifdef __arm__

#include "TLCS900H_mac.h"
#include "../K2GE/K2GE.i"

	.global intCheckPending
	.global updateTimers
	.global setInterrupt
	.global TestIntHDMA_External
	.global resetDMA
	.global resetTimers
	.global resetInterrupts
	.global timer_read8
	.global timer_write8
	.global int_write8
	.global int_read8


#ifdef GBA
	.section .ewram, "ax"		;@ For the GBA
#else
	.section .text				;@ For everything else
#endif
	.align 2
;@---------------------------------------------------------------------------
resetDMA:
;@---------------------------------------------------------------------------
	add r0,t9optbl,#tlcs_DmaS
	mov r1,#0
	mov r2,#12					;@ 12*4
	b memset_					;@ Clear DMA regs
;@---------------------------------------------------------------------------
resetTimers:
;@---------------------------------------------------------------------------
	add r0,t9optbl,#tlcs_TimerClock
	mov r1,#0
	mov r2,#6					;@ 6*4
	b memset_					;@ Clear Timer regs
;@---------------------------------------------------------------------------
resetInterrupts:
;@---------------------------------------------------------------------------
	mov r0,#0
	strb r0,[t9optbl,#tlcs_TRun]
	strb r0,[t9optbl,#tlcs_T01Mod]
	strb r0,[t9optbl,#tlcs_T23Mod]
	strb r0,[t9optbl,#tlcs_trdc]
	strb r0,[t9optbl,#tlcs_tffcr]
	str r0,[t9optbl,#tlcs_DMAStartVector]

	add r0,t9optbl,#tlcs_ipending
	mov r1,#0
	mov r2,#16					;@ 16*4
	b memset_					;@ Clear INT regs

;@---------------------------------------------------------------------------
int_write8:					;@ r0 = value, r1 = address
;@---------------------------------------------------------------------------
	mov r1,r1,lsl#28
	and r2,r0,#0x70
	cmp r2,#0x70
	biceq r0,r0,#0x70
	and r2,r0,#0x07
	cmp r2,#0x07
	biceq r0,r0,#0x07
	add r2,t9optbl,#tlcs_IntPrio
	strb r0,[r2,r1,lsr#28]
	ldr pc,[pc,r1,lsr#26]
	.long 0
	.long int_wr_70
	.long int_wr_71
	.long int_wr_72
	.long int_wr_73
	.long int_wr_74
	.long int_wr_75
	.long int_wr_76
	.long int_wr_77
	.long int_wr_78
	.long int_wr_79
	.long int_wr_7A
	.long int_wr_7B
	.long int_wr_7C
	.long int_wr_7D
	.long int_wr_7E
	.long int_wr_7F
int_wr_70:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x0A]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x1C]
	b intCheckPending
int_wr_71:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x0B]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x0C]
	b intCheckPending
int_wr_72:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x0D]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x0E]
	b intCheckPending
int_wr_73:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x10]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x11]
	b intCheckPending
int_wr_74:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x12]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x13]
int_wr_75:
int_wr_76:
	b intCheckPending
int_wr_77:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x18]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x19]
int_wr_78:
	b intCheckPending
int_wr_79:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x1D]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x1E]
	b intCheckPending
int_wr_7A:
	tst r0,#0x08
	streqb r1,[t9optbl,#tlcs_ipending+0x1F]
	tst r0,#0x80
	streqb r1,[t9optbl,#tlcs_ipending+0x20]
int_wr_7B:
	b intCheckPending

int_wr_7C:
int_wr_7D:
int_wr_7E:
int_wr_7F:
	and r0,r0,#0x3F
	and r1,r1,#0x30000000
	add r2,t9optbl,#tlcs_DMAStartVector
	strb r0,[r2,r1,lsr#28]
	bx lr
;@---------------------------------------------------------------------------
int_read8:					;@ r0 = address
;@---------------------------------------------------------------------------
	and r1,r0,#0x0F
	mov r0,#0
	ldr pc,[pc,r1,lsl#2]
	.long 0
	.long int_rd_70
	.long int_rd_71
	.long int_rd_72
	.long int_rd_73
	.long int_rd_74
	.long int_rd_75
	.long int_rd_76
	.long int_rd_77
	.long int_rd_78
	.long int_rd_79
	.long int_rd_7A
	.long int_rd_7B
	.long int_rd_7C
	.long int_rd_7D
	.long int_rd_7E
	.long int_rd_7F
int_rd_70:
	ldrb r1,[t9optbl,#tlcs_ipending+0x0A]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x1C]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
int_rd_71:
	ldrb r1,[t9optbl,#tlcs_ipending+0x0B]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x0C]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
int_rd_72:
	ldrb r1,[t9optbl,#tlcs_ipending+0x0D]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x0E]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
int_rd_73:
	ldrb r1,[t9optbl,#tlcs_ipending+0x10]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x11]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
int_rd_74:
	ldrb r1,[t9optbl,#tlcs_ipending+0x12]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x13]
	cmp r1,#0
	orrne r0,r0,#0x80
int_rd_75:
int_rd_76:
	bx lr
int_rd_77:
	ldrb r1,[t9optbl,#tlcs_ipending+0x18]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x19]
	cmp r1,#0
	orrne r0,r0,#0x80
int_rd_78:
	bx lr
int_rd_79:
	ldrb r1,[t9optbl,#tlcs_ipending+0x1D]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x1E]
	cmp r1,#0
	orrne r0,r0,#0x80
	bx lr
int_rd_7A:
	ldrb r1,[t9optbl,#tlcs_ipending+0x1F]
	cmp r1,#0
	orrne r0,r0,#0x08
	ldrb r1,[t9optbl,#tlcs_ipending+0x20]
	cmp r1,#0
	orrne r0,r0,#0x80
int_rd_7B:
	bx lr
int_rd_7C:
int_rd_7D:
int_rd_7E:
int_rd_7F:
	and r1,r1,#0x03
	add r0,t9optbl,#tlcs_DMAStartVector
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
	add r2,t9optbl,#tlcs_ipending
	strb r3,[r2,r0]
;@---------------------------------------------------------------------------
;@TestMicroDMA:				;@ r0 = index
;@---------------------------------------------------------------------------
	ldr r2,[t9optbl,#tlcs_DMAStartVector]
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

	ldr r0,[t9optbl,#tlcs_LastBank]
	sub r0,t9pc,r0
	bl push32
	bl pushSR

	;@ INTNEST should be updated too.

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
TestIntHDMA_External:		;@ r0 = index
	.type TestIntHDMA_External STT_FUNC
;@---------------------------------------------------------------------------
	stmfd sp!,{t9f,t9pc,t9optbl,t9gprBank,lr}
	ldr t9optbl,=tlcs900HState
	bl loadTLCS900
	bl setAndTestInterrupt
	bl storeTLCS900
	ldmfd sp!,{t9f,t9pc,t9optbl,t9gprBank,lr}
	bx lr
;@---------------------------------------------------------------------------
setInterrupt:				;@ r0 = index
;@---------------------------------------------------------------------------
	mov r1,#0x07
	add r2,t9optbl,#tlcs_ipending
	strb r1,[r2,r0]
	bx lr
;@---------------------------------------------------------------------------
setAndTestInterrupt:		;@ r0 = index
;@---------------------------------------------------------------------------
	mov r1,#0x07
	add r2,t9optbl,#tlcs_ipending
	strb r1,[r2,r0]
;@---------------------------------------------------------------------------
intCheckPending:
;@---------------------------------------------------------------------------
	stmfd sp!,{lr}
	bl statusIFF
	ldmfd sp!,{lr}
	add r2,t9optbl,#tlcs_ipending
	add r3,t9optbl,#tlcs_IntPrio

	ldrb r1,[r2,#0x0B]			;@ VBlank
	cmp r1,#0
	beq intDontCheck_0x0B
	ldrb r1,[r3,#0x1]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x0B
	ble interrupt
intDontCheck_0x0B:

	ldrb r1,[r2,#0x0C]			;@ Z80
	cmp r1,#0
	beq intDontCheck_0x0C
	ldrb r1,[r3,#0x1]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x0C
	ble interrupt
intDontCheck_0x0C:

	ldrb r1,[r2,#0x10]			;@ Timer0
	cmp r1,#0
	beq intDontCheck_0x10
	ldrb r1,[r3,#0x3]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x10
	ble interrupt
intDontCheck_0x10:

	ldrb r1,[r2,#0x11]			;@ Timer1
	cmp r1,#0
	beq intDontCheck_0x11
	ldrb r1,[r3,#0x3]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x11
	ble interrupt
intDontCheck_0x11:

	ldrb r1,[r2,#0x12]			;@ Timer2
	cmp r1,#0
	beq intDontCheck_0x12
	ldrb r1,[r3,#0x4]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x12
	ble interrupt
intDontCheck_0x12:

	ldrb r1,[r2,#0x13]			;@ Timer3
	cmp r1,#0
	beq intDontCheck_0x13
	ldrb r1,[r3,#0x4]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x13
	ble interrupt
intDontCheck_0x13:

	ldrb r1,[r2,#0x18]			;@ Serial TX 0
	cmp r1,#0
	beq intDontCheck_0x18
	ldrb r1,[r3,#0x7]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x18
	ble interrupt
intDontCheck_0x18:

	ldrb r1,[r2,#0x19]			;@ Serial RX 0
	cmp r1,#0
	beq intDontCheck_0x19
	ldrb r1,[r3,#0x7]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x19
	ble interrupt
intDontCheck_0x19:

	ldrb r1,[r2,#0x1C]			;@ D/A conversion finnished
	cmp r1,#0
	beq intDontCheck_0x1C
	ldrb r1,[r3,#0x0]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1C
	ble interrupt
intDontCheck_0x1C:

	ldrb r1,[r2,#0x1D]			;@ DMA0 END
	cmp r1,#0
	beq intDontCheck_0x1D
	ldrb r1,[r3,#0x9]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1D
	ble interrupt
intDontCheck_0x1D:

	ldrb r1,[r2,#0x1E]			;@ DMA1 END
	cmp r1,#0
	beq intDontCheck_0x1E
	ldrb r1,[r3,#0x9]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1E
	ble interrupt
intDontCheck_0x1E:

	ldrb r1,[r2,#0x1F]			;@ DMA2 END
	cmp r1,#0
	beq intDontCheck_0x1F
	ldrb r1,[r3,#0xA]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x1F
	ble interrupt
intDontCheck_0x1F:

	ldrb r1,[r2,#0x20]			;@ DMA3 END
	cmp r1,#0
	beq intDontCheck_0x20
	ldrb r1,[r3,#0xA]
	mov r1,r1,lsr#4
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x20
	ble interrupt
intDontCheck_0x20:

	ldrb r1,[r2,#0x0A]			;@ RTC Alarm IRQ
	cmp r1,#0
	beq intDontCheck_0x0A
	ldrb r1,[r3,#0x0]
	and r1,r1,#0x07
	cmp r0,r1
	movle r0,#0x0A
	ble interrupt
intDontCheck_0x0A:

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
	ldrb r4,[t9optbl,#tlcs_TRun]
	tst r4,#0x01
	beq noTimer0
;@----------------------------------------------------------------------------
								;@ TIMER0
	ldrb r2,[t9optbl,#tlcs_Timer]
	ldrb r1,[t9optbl,#tlcs_T01Mod]
	ands r1,r1,#0x03
	bne t0c2
t0c0:							;@ TIMER0 case 0
		ldr r0,=T9_HINT_RATE
		ldr r12,[t9optbl,#tlcs_TimerHInt]
		add r12,r12,r6
		cmp r12,r0
		subpl r12,r12,r0
		str r12,[t9optbl,#tlcs_TimerHInt]
		bmi noTimer0
		ldr geptr,=k2GE_0
		bl GetHInt
		cmp r0,#0				;@ HInt
		addne r2,r2,#1
		b timer0End

t0c2:
	cmp r1,#0x02
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER0 case 1
	ldreq r0,=TIMER_T4_RATE		;@ TIMER0 case 2
	ldrhi r0,=TIMER_T16_RATE	;@ TIMER0 case 3
	ldr r12,[t9optbl,#tlcs_TimerClock]
	add r12,r12,r6				;@ r6 = cputicks
t0c2Loop:
		cmp r12,r0
		subpl r12,r12,r0
		addpl r2,r2,#1
		bpl t0c2Loop
		str r12,[t9optbl,#tlcs_TimerClock]

timer0End:
	ldrb r0,[t9optbl,#tlcs_TimerThreshold]
	cmp r0,#1
	cmppl r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcs_Timer]
	movpl r5,#1					;@ Timer0 = TRUE
	movpl r0,#0x10
	blpl setInterrupt

noTimer0:
	tst r4,#0x02
	beq noTimer1
;@----------------------------------------------------------------------------
								;@ TIMER1
	ldrb r2,[t9optbl,#tlcs_Timer+1]
	ldrb r1,[t9optbl,#tlcs_T01Mod]
	ands r1,r1,#0x0C
	bne t1c2
t1c0:							;@ TIMER1 case 0
		cmp r5,#0				;@ Timer0 chain
		addne r2,r2,#1
		b timer1End

t1c2:
	cmp r1,#0x08
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER1 case 1
	ldreq r0,=TIMER_T16_RATE	;@ TIMER1 case 2
	ldrhi r0,=TIMER_T256_RATE	;@ TIMER1 case 3
	ldr r12,[t9optbl,#tlcs_TimerClock+4]
	add r12,r12,r6				;@ r6 = cputicks
t1c2Loop:
		cmp r12,r0
		subpl r12,r12,r0
		addpl r2,r2,#1
		bpl t1c2Loop
		str r12,[t9optbl,#tlcs_TimerClock+4]

timer1End:
	ldrb r0,[t9optbl,#tlcs_TimerThreshold+1]
	cmp r0,#1
	cmppl r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcs_Timer+1]
	movpl r0,#0x11
	blpl setInterrupt

noTimer1:
	mov r5,#0					;@ Timer2 = FALSE
	tst r4,#0x04
	beq noTimer2
;@----------------------------------------------------------------------------
								;@ TIMER2
	ldrb r2,[t9optbl,#tlcs_Timer+2]
	ldrb r1,[t9optbl,#tlcs_T23Mod]
	ands r1,r1,#0x03
	beq noTimer2				;@ TIMER2 case 0, nothing

t2c2:
	cmp r1,#0x02
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER2 case 1
	ldreq r0,=TIMER_T4_RATE		;@ TIMER2 case 2
	ldrhi r0,=TIMER_T16_RATE	;@ TIMER2 case 3
	ldr r12,[t9optbl,#tlcs_TimerClock+8]
	add r12,r12,r6				;@ r6 = cputicks
t2c2Loop:
		cmp r12,r0
		subpl r12,r12,r0
		addpl r2,r2,#1
		bpl t2c2Loop
		str r12,[t9optbl,#tlcs_TimerClock+8]

timer2End:
	ldrb r0,[t9optbl,#tlcs_TimerThreshold+2]
	cmp r0,#1
	cmppl r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcs_Timer+2]
	movpl r5,#1					;@ Timer2 = TRUE
	movpl r0,#0x12
	blpl setInterrupt

noTimer2:
	tst r4,#0x08
	beq noTimer3
;@----------------------------------------------------------------------------
								;@ TIMER3
	ldrb r2,[t9optbl,#tlcs_Timer+3]
	ldrb r1,[t9optbl,#tlcs_T23Mod]
	ands r1,r1,#0x0C
	bne t3c2
t3c0:							;@ TIMER3 case 0
		cmp r5,#0				;@ Timer2 chain
		addne r2,r2,#1
		b timer3End

t3c2:
	cmp r1,#0x08
	ldrmi r0,=TIMER_T1_RATE		;@ TIMER3 case 1
	ldreq r0,=TIMER_T16_RATE	;@ TIMER3 case 2
	ldrhi r0,=TIMER_T256_RATE	;@ TIMER3 case 3
	ldr r12,[t9optbl,#tlcs_TimerClock+12]
	add r12,r12,r6				;@ r6 = cputicks
t3c2Loop:
		cmp r12,r0
		subpl r12,r12,r0
		addpl r2,r2,#1
		bpl t3c2Loop
		str r12,[t9optbl,#tlcs_TimerClock+12]

timer3End:
	ldrb r0,[t9optbl,#tlcs_TimerThreshold+3]
	cmp r0,#1
	cmppl r2,r0
	subpl r2,r2,r0
	strb r2,[t9optbl,#tlcs_Timer+3]
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
	add r6,t9optbl,#tlcs_DmaS
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
timer_read8:				;@ r0 = address, Bios reads from 0x20, 0x25 & 0x28 at least
;@----------------------------------------------------------------------------
	cmp r0,#0x20
	ldreqb r0,[t9optbl,#tlcs_TRun]
	bxeq lr
	cmp r0,#0x24
	ldreqb r0,[t9optbl,#tlcs_T01Mod]
	bxeq lr
	cmp r0,#0x25
	ldreqb r0,[t9optbl,#tlcs_tffcr]
	bxeq lr
	cmp r0,#0x28
	ldreqb r0,[t9optbl,#tlcs_T23Mod]
	bxeq lr
	cmp r0,#0x29
	ldreqb r0,[t9optbl,#tlcs_trdc]
	bxeq lr
	mov r0,#4					;@ Cool Boarders reads from 0x28 & 0x22 and wants 4...?
	bx lr
;@----------------------------------------------------------------------------
timer_write8:				;@ r0 = value, r1 = address
;@----------------------------------------------------------------------------
	ands r1,r1,#0x0F
	beq TRUN_W
	adr r2,timerTable
	ldr r2,[r2,r1,lsl#2]
	cmp r2,#0
	strneb r0,[r2]
	bx lr
timerTable:
	.long 0
	.long 0
	.long timer_threshold
	.long timer_threshold+1
	.long T01MOD
	.long TFFCR
	.long timer_threshold+2
	.long timer_threshold+3
	.long T23MOD
	.long TRDC
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
	.long 0
;@----------------------------------------------------------------------------
TRUN_W:
;@----------------------------------------------------------------------------
	strb r0,[t9optbl,#tlcs_TRun]
	ldr r2,[t9optbl,#tlcs_Timer]
	tst r0,#0x01
	biceq r2,r2,#0x000000FF
	tst r0,#0x02
	biceq r2,r2,#0x0000FF00
	tst r0,#0x04
	biceq r2,r2,#0x00FF0000
	tst r0,#0x08
	biceq r2,r2,#0xFF000000
	str r2,[t9optbl,#tlcs_Timer]		;@ str ?
	bx lr

;@----------------------------------------------------------------------------

#endif // #ifdef __arm__
