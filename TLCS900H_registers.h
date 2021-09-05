
#ifndef __TLCS900H_REGISTERS__
#define __TLCS900H_REGISTERS__


extern u8 statusRFP;
extern s8 registersOfsMap[4][256];
extern u8 *currentGprBank;

#define rCodeB(r)	(*(currentGprBank+registersOfsMap[statusRFP][(r)]))
#define rCodeW(r)	(*((u16*)currentGprBank+registersOfsMap[statusRFP][(r) & ~1]))
#define rCodeL(r)	(*((u32*)currentGprBank+registersOfsMap[statusRFP][(r) & ~3]))

#endif	// __TLCS900H_REGISTERS__
