//**********************************************************************************************
// display_screen.c 
// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
//**********************************************************************************************
// - uzivatelske screeny
// - sf (screen function) naplni 8 stringu pro 8 radku disple
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

void sf_board(byte* pTexts[NR_ROWS]);
void sf_resume(byte* pTexts[NR_ROWS]);
void sf_voltages(byte* pTexts[NR_ROWS]);
void sf_currents(byte* pTexts[NR_ROWS]);
void sf_powers(byte* pTexts[NR_ROWS]);
void sf_energies(byte* pTexts[NR_ROWS]);
void sf_vrms(byte* pTexts[NR_ROWS]);
void sf_irms(byte* pTexts[NR_ROWS]);
void sf_act(byte* pTexts[NR_ROWS]);
void sf_app(byte* pTexts[NR_ROWS]);
void sf_eapos_eaneg(byte* pTexts[NR_ROWS]);

flash tSCREEN sSCREEN_GROUP[NR_SCREEN] = {   
    {"BOARD", sf_board},
    {"RESUME", sf_resume},
    {"VOLTAGE", sf_voltages},
    {"CURRENT", sf_currents},
//    {"ACT", sf_act}, 
    {"POWER", sf_powers}                                   
};

//
void sf_board(byte* pTexts[NR_ROWS]){
              
    tMESSMODUL *pMessmodul = &sMm[0];        
    
    sprintf(pTexts[0] ,"      RMII BOARD     ");
    sprintf(pTexts[1] ,"     ============    ");      
    sprintf(pTexts[2] ," HW ver.: "); strcatf(pTexts[2], HW_VERSION_S); strcatf(pTexts[2], "     ");
    sprintf(pTexts[3] ," SW ver.: "); strcatf(pTexts[3], SW_VERSION_S); strcatf(pTexts[3], "     ");  
    sprintf(pTexts[4] ,"                          ");                  
    sprintf(pTexts[5] ," IP: %u.%u.%u.%u           ", sXport.ip_address[0], sXport.ip_address[1], sXport.ip_address[2], sXport.ip_address[3]);
    sprintf(pTexts[6] ," MAC: %02X%02X%02X%02X%02X%02X   ", sXport.mac_address[0], sXport.mac_address[1], sXport.mac_address[2], sXport.mac_address[3], sXport.mac_address[4], sXport.mac_address[5]);
    sprintf(pTexts[7] ,"                          ");             
}

//
void sf_resume(byte* pTexts[NR_ROWS]){
              
    tMESSMODUL *pMessmodul = &sMm[0];        
    
    sprintf(pTexts[0] ,"       RESUME    ");
    sprintf(pTexts[1] ,"     ============    ");      
    sprintf(pTexts[2] ," U lines: %u         ", Messmodul_getCountVoltage());
    sprintf(pTexts[3] ," I lines: %u         ", Messmodul_getCountCurrent());                                              
    sprintf(pTexts[4] ,"                          ");
    sprintf(pTexts[5] ," Frequence: %u.%u Hz      ", pMessmodul->values.frequence/1000, pMessmodul->values.frequence%1000);                                
    sprintf(pTexts[6] ," Temperature: %u.%u°C      ", pMessmodul->values.temperature/10,pMessmodul->values.temperature%10);
    sprintf(pTexts[7] ,"                          ");
        
}

//VOLTAGES
void sf_voltages(byte* pTexts[NR_ROWS]){
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       VOLTAGE       ");
    sprintf(pTexts[1] ,"      =========      ");
    sprintf(pTexts[2] ,"                       ");   
    sprintf(pTexts[3] ,"      L1: %u.%u [V]    ", pMessmodul->values.voltage[0]/10, pMessmodul->values.voltage[0]%10);
    sprintf(pTexts[4] ,"      L2: %u.%u [V]    ", pMessmodul->values.voltage[1]/10, pMessmodul->values.voltage[1]%10);
    sprintf(pTexts[5] ,"      L3: %u.%u [V]    ", pMessmodul->values.voltage[2]/10, pMessmodul->values.voltage[1]%10);
    sprintf(pTexts[6] ,"                       ");
    sprintf(pTexts[7] ,"                       ");
        
}

//CURRENTS
void sf_currents(byte* pTexts[NR_ROWS]){
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       CURRENT        ");
    sprintf(pTexts[1] ,"      =========       ");   
    sprintf(pTexts[2] ,"                      ");
    sprintf(pTexts[3] ,"      L1: %u.%u [A]      ", pMessmodul->values.current[0]/100, pMessmodul->values.current[0]%100,);
    sprintf(pTexts[4] ,"      L2: %u.%u [A]      ", pMessmodul->values.current[1]/100, pMessmodul->values.current[1]%100,);
    sprintf(pTexts[5] ,"      L3: %u.%u [A]      ", pMessmodul->values.current[2]/100, pMessmodul->values.current[2]%100,);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}

//POWER
void sf_powers(byte* pTexts[NR_ROWS]){    
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"        POWER         ");
    sprintf(pTexts[1] ,"      =========       ");  
    sprintf(pTexts[2] ,"                      ");
    sprintf(pTexts[3] ,"      L1: %ld.%d [W]   ", pMessmodul->values.power[0]/10, abs(pMessmodul->values.power[0]%10));
    sprintf(pTexts[4] ,"      L2: %ld.%d [W]   ", pMessmodul->values.power[1]/10, abs(pMessmodul->values.power[1]%10));
    sprintf(pTexts[5] ,"      L3: %ld.%d [W]   ", pMessmodul->values.power[2]/10, abs(pMessmodul->values.power[0]%10));
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}

//POWER
void sf_energies(byte* pTexts[NR_ROWS]){    
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"        ENERGY        ");
    sprintf(pTexts[1] ,"      =========       ");  
    sprintf(pTexts[2] ,"                      ");
    sprintf(pTexts[3] ,"      L1: %u [Wh]     ", pMessmodul->values.energy[0]);
    sprintf(pTexts[4] ,"      L2: %u [Wh]     ", pMessmodul->values.energy[1]);
    sprintf(pTexts[5] ,"      L3: %u [Wh]     ", pMessmodul->values.energy[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}

//POWER FACTOR
void sf_powerfactors(byte* pTexts[NR_ROWS]){    
    
    tMESSMODUL *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       POWER FACTOR   ");
    sprintf(pTexts[1] ,"      ==============  ");  
    sprintf(pTexts[2] ,"                      ");
    sprintf(pTexts[3] ,"      L1: %u [Wh]     ", pMessmodul->values.pf[0]);
    sprintf(pTexts[4] ,"      L2: %u [Wh]     ", pMessmodul->values.pf[1]);
    sprintf(pTexts[5] ,"      L3: %u [Wh]     ", pMessmodul->values.pf[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}

/*************/
/* REGISTERS */
/*************/

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
        
}

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
        
}

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
        
}

/* ENERGY */
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
        
}
