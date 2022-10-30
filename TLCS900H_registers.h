//
//  TLCS900H_registers.h
//  TLCS900H
//
//  Created by Fredrik Ahlström on 2008-04-02.
//  Copyright © 2008-2022 Fredrik Ahlström. All rights reserved.
//

#ifndef __TLCS900H_REGISTERS__
#define __TLCS900H_REGISTERS__


extern u8 statusRFP;
extern const s8 registersOfsMap[4][256];
extern u8 *currentGprBank;

#define rCodeB(r)	(*(currentGprBank+registersOfsMap[statusRFP][(r)]))
#define rCodeW(r)	(*((u16*)(currentGprBank+registersOfsMap[statusRFP][(r) & ~1])))
#define rCodeL(r)	(*((u32*)(currentGprBank+registersOfsMap[statusRFP][(r) & ~3])))

#endif	// __TLCS900H_REGISTERS__
