
#ifndef __TLCS900H_REGISTERS__
#define __TLCS900H_REGISTERS__


extern u8 statusRFP;
extern int8 registersOfsMap[4][256];
extern uint8 *currentGprBank;

#define rCodeB(r)	(*(currentGprBank+registersOfsMap[statusRFP][(r)]))
#define rCodeW(r)	(*((uint16*)currentGprBank+registersOfsMap[statusRFP][(r) & ~1]))
#define rCodeL(r)	(*((uint32*)currentGprBank+registersOfsMap[statusRFP][(r) & ~3]))

#endif	// __TLCS900H_REGISTERS__
