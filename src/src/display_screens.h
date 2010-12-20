//**********************************************************************************************
// display_screens.h
// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
//**********************************************************************************************

#ifndef DISPLAY_SCREENS_H_
#define DISPLAY_SCREENS_H_

#include <types.h>
#include <display.h>
#include <NT7534.h>

#define NR_SCREEN   8

#define TITLE_SIZE  15


typedef byte ( *pDISPLAY_SCREEN_FUNCTION ) (byte *pTexts[NR_ROWS]);

typedef struct{
    char title[TITLE_SIZE];    
    pDISPLAY_SCREEN_FUNCTION function;
}tSCREEN;

typedef struct{
    byte nr_selected_module; // 0 - all, 1-4 module
}tSCREEN_DATA;




//obsahuje jednotlive screeny
extern flash tSCREEN sSCREEN_GROUP[NR_SCREEN];
extern tSCREEN_DATA sScreen_data;

void Display_screens_setStrings(byte screen_index, byte* pTexts[NR_ROWS]);

#endif /* DISPLAY_SCREENS_H_ */