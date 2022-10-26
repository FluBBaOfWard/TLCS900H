//
//  TLCS900H.h
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2022 Fredrik Ahlström. All rights reserved.
//

#ifndef TLCS900H_HEADER
#define TLCS900H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
	u32 tlcsGprBanks[4][8];
	u32 tlcsLastBank;
//	tlcsSrW:
	u8 tlcsF;				// sr & f needs to be together and aligned at halfword.
	u8 tlcsSrB;
	u8 tlcsFDash;
	u8 tlcsStatusRFP;		// Register File Pointer
	u32 tlcsCycles;
	u32 tlcsPcAsm;
	u32 tlcsCurrentGprBank;
	u32 tlcsCurrentMapBank;
	u32 tlcsDMAStartVector;
	u32 tlcsDmaS[4];
	u32 tlcsDmaD[4];
	u16 tlcsDmaC;
	u8 tlcsDmaM[4*3+2];
	u8 tlcsIPending[64];
	u8 tlcsIntPrio[16];
	u32 tlcsTimerClock[4];
	u8 tlcsTimer[4];
	u8 tlcsTimerThreshold[4];
	u32 tlcsTimerHInt;
	u8 tlcsTRun;
	u8 tlcsT01Mod;
	u8 tlcsT23Mod;
	u8 tlcsTrdc;
	u8 tlcsTFFCR;
	u8 tlcsTFF1;
	u8 tlcsTFF3;
	u8 tlcsCycShift;
	void *tff3Function;
	void *romBaseLo;
	void *romBaseHi;
	void *biosBase;
	void *readRomPtrLo;
	void *readRomPtrHi;
	u8 tlcsPzst[256];		// PZSTable

} TLCS900HCore;

extern TLCS900HCore tlcs900HState;

void tlcs900HReset(int type);

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
