//**********************************************************************************************
// display_screens.h
// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
//**********************************************************************************************

#ifndef DISPLAY_SCREENS_H_
#define DISPLAY_SCREENS_H_

#include <types.h>
#include <display.h>
#include <NT7534.h>

#define NR_SCREEN   5

#define TITLE_SIZE  15


typedef void ( *pDISPLAY_SCREEN_FUNCTION ) (byte *pTexts[NR_ROWS]);

typedef struct{
    char title[TITLE_SIZE];    
    pDISPLAY_SCREEN_FUNCTION function;
}tSCREEN;



//obsahuje jednotlive screeny
extern flash tSCREEN sSCREEN_GROUP[NR_SCREEN];

#endif /* DISPLAY_SCREENS_H_ */