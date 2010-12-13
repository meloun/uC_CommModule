//**********************************************************************************************
// display_screen.c 
// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
//**********************************************************************************************
// - uzivatelske screeny
// - sf (screen function) naplni X stringu daty
//      - STRNCPY() proti preteceni
//      - vraci dalsi volny radek (vstup pro getFooter()) 
// - SCREEN_GROUP potom definuje jake obrazovky a v jakem poradi se zobrazuji
//**********************************************************************************************

#include <stdlib.h>
#include <hw_def.h>
#include <types.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include <NT7534.h>
#include <display.h>
#include <display_screens.h>
#include <messmodules.h>
#include "comm_xport.h"

byte sf_board(byte* pTexts[NR_ROWS]);
byte sf_resume(byte* pTexts[NR_ROWS]);
byte sf_voltages(byte* pTexts[NR_ROWS]);
byte sf_currents(byte* pTexts[NR_ROWS]);
byte sf_powers(byte* pTexts[NR_ROWS]);
byte sf_powers_act(byte* pTexts[NR_ROWS]);
//byte sf_powers_app(byte* pTexts[NR_ROWS]);
byte sf_powerfactors(byte* pTexts[NR_ROWS]);
byte sf_energies_act(byte* pTexts[NR_ROWS]);
//byte sf_energies_app(byte* pTexts[NR_ROWS]);

//byte sf_vrms(byte* pTexts[NR_ROWS]);
//byte sf_irms(byte* pTexts[NR_ROWS]);
//byte sf_act(byte* pTexts[NR_ROWS]);
//byte sf_app(byte* pTexts[NR_ROWS]);
//byte sf_eapos_eaneg(byte* pTexts[NR_ROWS]);

flash tSCREEN sSCREEN_GROUP[NR_SCREEN] = {   
    {"BOARD", sf_board},
    {"RESUME", sf_resume},
    {"VOLTAGE", sf_voltages},
    {"CURRENT", sf_currents},
    {"POWER", sf_powers_act},
    {"POWERFACTOR", sf_powerfactors},                                       
    {"ENERGY", sf_energies_act}
};

#define AUX_STRING_SIZE     40

//title, underline
void getHeader(byte index, byte* pTexts[NR_ROWS]){
    byte aux_string[AUX_STRING_SIZE];  

    //check string length
    if(strlenf(sSCREEN_GROUP[index].title)>TITLE_SIZE)
        return;    
    
    //title
    strcpy(aux_string , "        "); strcatf(aux_string, sSCREEN_GROUP[index].title); strcatf(aux_string, "     ");
    strncpy(pTexts[0], aux_string, NR_COLUMNS);

    //underline         
    strncpy(pTexts[1] ,"      ============    ", NR_COLUMNS);
                               
}

//clear unused rows, pagging
void getFooter(byte first_unused_row, byte index, byte* pTexts[NR_ROWS]){
    byte i;
    byte aux_string[AUX_STRING_SIZE];  
     
    //clear unused rows
    for(i=first_unused_row; i<(NR_ROWS-1); i++)
        strncpy(pTexts[i] , "                    ", NR_COLUMNS);
    
    //pagging
    sprintf(aux_string, "                 %u/%u", index+1, NR_SCREEN);
    strncpy(pTexts[NR_ROWS-1], aux_string, NR_COLUMNS);

}

//global function, set all strings
void Display_screens_setStrings(byte index, byte* pTexts[NR_ROWS]){
    byte nr_row;
    
    //title, underline (row 0,1)
    getHeader(index, pTexts);
    
    nr_row = sSCREEN_GROUP[index].function(pTexts);
    
    //clear unused rows, pagging
    getFooter(nr_row, index, pTexts);
}


//******************************************
// SCREEN FUNCTIONS
//*******************************************

//board
byte sf_board(byte* pTexts[NR_ROWS]){                         
    byte aux_string[AUX_STRING_SIZE];        
          
    strcpy(aux_string , " HW ver.: "); strcatf(aux_string, HW_VERSION_S); strcatf(aux_string, "    ");
    strncpy(pTexts[2], aux_string, NR_COLUMNS); 
                       
    strcpy(aux_string , " SW ver.: "); strcatf(aux_string, SW_VERSION_S); strcatf(aux_string, "    ");
    strncpy(pTexts[3], aux_string, NR_COLUMNS);
               
    strncpy(pTexts[4], "                     ", NR_COLUMNS);     
                  
    sprintf(aux_string ," IP: %3u.%3u.%3u.%3u        ", sXport.ip_address[0], sXport.ip_address[1], sXport.ip_address[2], sXport.ip_address[3]);
    strncpy(pTexts[5], aux_string, NR_COLUMNS);    
    
    sprintf(aux_string ," MAC: %02X%02X%02X%02X%02X%02X   ", sXport.mac_address[0], sXport.mac_address[1], sXport.mac_address[2], sXport.mac_address[3], sXport.mac_address[4], sXport.mac_address[5]);
    strncpy(pTexts[6], aux_string, NR_COLUMNS);         
    
    return NR_ROWS-1;              
}

//
byte sf_resume(byte* pTexts[NR_ROWS]){
    
    byte aux_string[AUX_STRING_SIZE];               
    tMESSMODUL *pMessmodul = &sMm[0];               
    
    sprintf(aux_string ," U lines: %u         ", Messmodul_getCountVoltage());
    strncpy(pTexts[2], aux_string, NR_COLUMNS);
            
    sprintf(aux_string ," I lines: %u         ", Messmodul_getCountCurrent());
    strncpy(pTexts[3], aux_string, NR_COLUMNS);        
                                                  
    strncpy(pTexts[4] ,"                          ", NR_COLUMNS);
    
    sprintf(aux_string ," Frequence: %u.%u Hz      ", pMessmodul->values.frequence/1000, pMessmodul->values.frequence%1000);
    strncpy(pTexts[5], aux_string, NR_COLUMNS);
                                    
    sprintf(aux_string ," Temperature: %u.%u°C      ", pMessmodul->values.temperature/10,pMessmodul->values.temperature%10);
    strncpy(pTexts[6], aux_string, NR_COLUMNS);        
    
    return NR_ROWS-1;
        
}

//VOLTAGES
byte sf_voltages(byte* pTexts[NR_ROWS]){
    byte aux_string[AUX_STRING_SIZE];    
    tMESSMODUL *pMessmodul = &sMm[0]; 
    word i;   
    
    strncpy(pTexts[2] ,"                     ", NR_COLUMNS);
    
    
    for(i=0; i<3;i++){
        sprintf(aux_string ,"      L1: %u.%u [V]    ", pMessmodul->values.voltage[i]/10, pMessmodul->values.voltage[i]%10);                 
        strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
    }              
        
    
    return NR_ROWS-2;           
}

//CURRENTS
byte sf_currents(byte* pTexts[NR_ROWS]){
    byte aux_string[AUX_STRING_SIZE]; 
    tMESSMODUL *pMessmodul = &sMm[0]; 
    word i;   
    
  
    strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
    
    for(i=0; i<3;i++){         
        sprintf(aux_string ,"      L1: %u.%02u [A]      ", pMessmodul->values.current[i]/100, pMessmodul->values.current[i]%100,);
        strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
    }        
    
    return NR_ROWS-2;
        
}

/*******************************************/
// POWER
/*******************************************/

//active & apparent power
byte sf_powers(byte* pTexts[NR_ROWS]){    
    byte aux_string[AUX_STRING_SIZE];
    tMESSMODUL *pMessmodul = &sMm[0];
    word i;    
     
    strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
    
    for(i=0; i<3;i++){ 
        sprintf(aux_string ," L1: %ld.%d [W] | %ld.%d [VA]", pMessmodul->values.power_act[i]/10, abs(pMessmodul->values.power_act[i]%10), pMessmodul->values.power_app[i]/10, abs(pMessmodul->values.power_app[i]%10));
        strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
    }  
    
    return NR_ROWS-2;
}

//active power
byte sf_powers_act(byte* pTexts[NR_ROWS]){    
    byte aux_string[AUX_STRING_SIZE]; 
    tMESSMODUL *pMessmodul = &sMm[0]; 
    word i;    
      
    strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
    
    for(i=0; i<3;i++){
        sprintf(aux_string ,"      L1: %ld.%d [W]   ", pMessmodul->values.power_act[i]/10, abs(pMessmodul->values.power_act[i]%10));
        strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
    }               
    
    return NR_ROWS-2;
        
}

//ACTIVE POWER
byte sf_energies_act(byte* pTexts[NR_ROWS]){    
    byte aux_string[AUX_STRING_SIZE];
    tMESSMODUL *pMessmodul = &sMm[0];
    word i;     
    
    strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
    
    for(i=0; i<3;i++){
        sprintf(aux_string ,"      L1: %u [Wh]     ", pMessmodul->values.energy_act[i]);
        strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
    }         
    
    return NR_ROWS-2;
        
}

//POWER FACTOR
byte sf_powerfactors(byte* pTexts[NR_ROWS]){    
    byte aux_string[AUX_STRING_SIZE]; 
    tMESSMODUL *pMessmodul = &sMm[0]; 
    word i;    
      
    strncpy(pTexts[2] ,"                      ", NR_COLUMNS);  

    for(i=0; i<3;i++){  
        sprintf(aux_string ,"      L1: %u        ", pMessmodul->values.power_factor[i]);        
        strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
    }        
    
    return NR_ROWS-2;
        
}

/*************/
/* REGISTERS */
/*************/
/*
void sf_vrms(byte* pTexts[NR_ROWS]){
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       VRMS           ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %lu [V]     ", pMessmodul->values.vrms[0]>>8);
    sprintf(pTexts[4] ,"      L2: %lu [V]     ", pMessmodul->values.vrms[1]>>8);
    sprintf(pTexts[5] ,"      L3: %lu [V]     ", pMessmodul->values.vrms[2]>>8);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}*/

/*
void sf_irms(byte* pTexts[NR_ROWS]){
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       IRMS           ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %lu [A]     ", pMessmodul->values.irms[0]>>8);
    sprintf(pTexts[4] ,"      L2: %lu [A]     ", pMessmodul->values.irms[1]>>8);
    sprintf(pTexts[5] ,"      L3: %lu [A]     ", pMessmodul->values.irms[2]>>8);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}*/
/*
void sf_act(byte* pTexts[NR_ROWS]){
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       ACT            ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %ld [W]     ", pMessmodul->values.act[0]);
    sprintf(pTexts[4] ,"      L2: %ld [W]     ", pMessmodul->values.act[1]);
    sprintf(pTexts[5] ,"      L3: %ld [W]     ", pMessmodul->values.act[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}

void sf_app(byte* pTexts[NR_ROWS]){
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       APP            ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %ld [VA]     ", pMessmodul->values.app[0]);
    sprintf(pTexts[4] ,"      L2: %ld [VA]     ", pMessmodul->values.app[1]);
    sprintf(pTexts[5] ,"      L3: %ld [VA]     ", pMessmodul->values.app[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
} */

/* ENERGY */
/*
void sf_eapos_eaneg(byte* pTexts[NR_ROWS]){
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"      EAPOS, EANEG    ");
    sprintf(pTexts[1] ,"      ============    ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"  L1: %ld , %ld       ", pMessmodul->values.eapos[0], pMessmodul->values.eaneg[0]);
    sprintf(pTexts[4] ,"  L2: %ld , %ld       ", pMessmodul->values.eapos[1], pMessmodul->values.eaneg[1]);
    sprintf(pTexts[5] ,"  L3: %ld , %ld       ", pMessmodul->values.eapos[2], pMessmodul->values.eaneg[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}*/
