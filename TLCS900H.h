#ifndef TLCS900H_HEADER
#define TLCS900H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
	u32 tlcs_ErrorVal;
	u32 tlcs_GprBank[4][8];
	u32 tlcs_LastBank;
//	tlcs_sr_w:
	u8 tlcs_f;				// sr & f needs to be together and aligned at halfword.
	u8 tlcs_sr_b;
	u8 tlcs_f_dash;
	u8 tlcs_StatusRFP;		// Register File Pointer
	u32 tlcs_Cycles;
	u32 tlcs_PcAsm;
	u32 tlcs_CurrentGprBank;
	u32 tlcs_CurrentMapBank;
	u32 tlcs_DMAStartVector;
	u32 tlcs_DmaS[4];
	u32 tlcs_DmaD[4];
	u16 tlcs_DmaC;
	u8 tlcs_DmaM[4*3+2];
	u8 tlcs_ipending[64];
	u8 tlcs_IntPrio[16];
	u32 tlcs_TimerClock[4];
	u8 tlcs_Timer[4];
	u8 tlcs_TimerThreshold[4];
	u32 tlcs_TimerHInt;
	u8 tlcs_TRun;
	u8 tlcs_T01Mod;
	u8 tlcs_T23Mod;
	u8 tlcs_trdc;
	u8 tlcs_tffcr;
	u8 tlcs_cycShift;
	u8 tlcs_padding0[2];	// align
	void *romBaseLo;
	void *romBaseHi;
	void *biosBase;
	void *readRomPtrLo;
	void *readRomPtrHi;
	u8 tlcs_pzst[256];

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

void tlcs900HSetIRQPin(bool set);
void tlcs900HSetNMIPin(bool set);
void tlcs900HRestoreAndRunXCycles(int cycles);
void tlcs900HRunXCycles(int cycles);
void tlcs900HCheckIRQs(void);

#ifdef __cplusplus
}
#endif

#endif // TLCS900H_HEADER
