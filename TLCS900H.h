//
//  TLCS900H.h
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2024 Fredrik Ahlström. All rights reserved.
//

#ifndef TLCS900H_HEADER
#define TLCS900H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
	u32 opCodes[256];
	u8 pzst[256];		// PZSTable
	u32 gprBanks[4][8];
	u32 lastBank;
//	tlcsSrW:
	u8 f;				// sr & f needs to be together and aligned at halfword.
	u8 srB;
	u8 fDash;
	u8 statusRFP;		// Register File Pointer
	u32 cycles;
	u32 pcAsm;
	u32 dmaStartVector;
	u32 currentGprBank;
	u32 currentMapBank;
	u32 padding1;
	u32 dmaS[4];
	u32 dmaD[4];
	u16 dmaC;
	u8 dmaM[4*3+2];
	u8 iPending[64];
	u8 intPrio[16];
	u32 timerClock[4];
	u8 upCounter[4];
	u8 timerCompare[4];
	u8 tRun;
	u8 t01Mod;
	u8 t23Mod;
	u8 trdc;
	u8 tFFCR;
	u8 tFF1;
	u8 tFF3;
	u8 cycShift;
	u8 irqPrio;
	u8 irqVec;
	u8 irqDirty;
//	u8 timerHInt_;
	u8 padding0[1];
	void *tff3Function;
	void *romBaseLo;
	void *romBaseHi;
	void *biosBase;

} TLCS900HCore;

extern TLCS900HCore tlcs900HState;

/**
 * Reset the specified cpu core.
 * @param  *cpu: The TLCS900HCore cpu to reset.
 * @param  *ff3Func: Pointer to new FlipFlop 3 function .
 */
void tlcs900HReset(TLCS900HCore *cpu, void *ff3Func);

/**
 * Saves the state of the cpu to the destination.
 * @param  *destination: Where to save the state.
 * @param  *cpu: The TLCS900HCore cpu to save.
 * @return The size of the state.
 */
int tlcs900HSaveState(void *destination, const TLCS900HCore *cpu);

/**
 * Loads the state of the cpu from the source.
 * @param  *cpu: The TLCS900HCore cpu to load a state into.
 * @param  *source: Where to load the state from.
 * @return The size of the state.
 */
int tlcs900HLoadState(TLCS900HCore *cpu, const void *source);

/**
 * Gets the state size of an TLCS900HCore state.
 * @return The size of the state.
 */
int tlcs900HGetStateSize(void);

/**
 * Redirect/patch an opcode to a new function.
 * @param  opcode: Which opcode to redirect.
 * @param  *function: Pointer to new function .
 */
void tlcs900HRedirectOpcode(int opcode, void *function);

void tlcs900HRestoreAndRunXCycles(int cycles);
void tlcs900HRunXCycles(int cycles);

#ifdef __cplusplus
}
#endif

#endif // TLCS900H_HEADER
