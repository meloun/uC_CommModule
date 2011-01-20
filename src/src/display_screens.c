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
#include <display_manager.h>
#include <display_screens.h>
#include <messmodules.h>
//#include "comm_xport.h"

byte sf_board(byte* pTexts[NR_ROWS]);
byte sf_modules(byte* pTexts[NR_ROWS]);
byte sf_resume(byte* pTexts[NR_ROWS]);

//SCREEN FUNCTIONs
byte sf_voltages(byte* pTexts[NR_ROWS]);
byte sf_currents(byte* pTexts[NR_ROWS]);
byte sf_powers(byte* pTexts[NR_ROWS]);
byte sf_powers_act(byte* pTexts[NR_ROWS]);
byte sf_powers_app(byte* pTexts[NR_ROWS]);    
byte sf_energies_act(byte* pTexts[NR_ROWS]);
byte sf_energies_app(byte* pTexts[NR_ROWS]);
byte sf_powerfactors(byte* pTexts[NR_ROWS]); 


flash tSCREEN sSCREEN_GROUP[NR_SCREEN] = {
    {"BOARD", sf_board},       
    {"MODULES", sf_modules},
    {"RESUME", sf_resume},
    {"VOLTAGE", sf_voltages},
    {"CURRENT", sf_currents},
    {"POWERFACTOR", sf_powerfactors},
    {"POWER ACT", sf_powers_act},
    {"POWER APP", sf_powers_app},                                           
    {"ENERGY ACT", sf_energies_act},
    {"ENERGY APP", sf_energies_app}
};


tSCREEN_DATA sScreen_data;

#define AUX_STRING_SIZE     40

// GET_HEADER
// title, underline
void getHeader(byte screen_index, byte* pTexts[NR_ROWS]){
    byte aux_string[AUX_STRING_SIZE];  

    //check string length
    if(strlenf(sSCREEN_GROUP[screen_index].title)>TITLE_SIZE)
        return;    
    
    //title
    strcpyf(aux_string , "        "); strcatf(aux_string, sSCREEN_GROUP[screen_index].title); strcatf(aux_string, "     ");
    strncpy(pTexts[0], aux_string, NR_COLUMNS);

    //underline         
    strncpyf(pTexts[1] ,"      ============    ", NR_COLUMNS);
                               
}

// GET_FOOTER
// clear unused rows, pagging
void getFooter(byte first_unused_row, byte screen_index, byte* pTexts[NR_ROWS]){
    byte i;
    byte aux_string[AUX_STRING_SIZE];  
     
    //clear unused rows
    for(i=first_unused_row; i<(NR_ROWS-1); i++)
        strncpyf(pTexts[i] , "                    ", NR_COLUMNS);
    
    //pagging
    sprintf(aux_string, "                 %u/%u", screen_index+1, NR_SCREEN);
    strncpy(pTexts[NR_ROWS-1], aux_string, NR_COLUMNS);

}

//SET_STRINGS
//global function, set all strings
void Display_screens_setStrings(byte screen_index, byte* pTexts[NR_ROWS]){
    byte nr_row;
    
    //title, underline (row 0,1)
    getHeader(screen_index, pTexts);
    
    nr_row = sSCREEN_GROUP[screen_index].function(pTexts);
    
    //clear unused rows, pagging
    getFooter(nr_row, screen_index, pTexts);
}


//******************************************
// SCREEN FUNCTIONS
//*******************************************

// BOARD
byte sf_board(byte* pTexts[NR_ROWS]){                         
    byte aux_string[AUX_STRING_SIZE];        
          
    strcpyf(aux_string , " HW ver.: "); strcatf(aux_string, HW_VERSION_S); strcatf(aux_string, "      ");
    strncpy(pTexts[2], aux_string, NR_COLUMNS); 
                       
    strcpyf(aux_string , " SW ver.: "); strcatf(aux_string, SW_VERSION_S); strcatf(aux_string, "      ");
    strncpy(pTexts[3], aux_string, NR_COLUMNS);
               
    strncpyf(pTexts[4], "                     ", NR_COLUMNS);     
                  
    //sprintf(aux_string ," IP: %3u.%3u.%3u.%3u        ", sXport.ip_address[0], sXport.ip_address[1], sXport.ip_address[2], sXport.ip_address[3]);
    strncpy(pTexts[5], aux_string, NR_COLUMNS);    
    
    //sprintf(aux_string ," MAC: %02X%02X%02X%02X%02X%02X   ", sXport.mac_address[0], sXport.mac_address[1], sXport.mac_address[2], sXport.mac_address[3], sXport.mac_address[4], sXport.mac_address[5]);
    strncpy(pTexts[6], aux_string, NR_COLUMNS);         
    
    return NR_ROWS-1;              
}

// MODULES
byte sf_modules(byte* pTexts[NR_ROWS]){                         
    byte aux_string[AUX_STRING_SIZE];    
    
    strncpyf(pTexts[2] ,"                     ", NR_COLUMNS);       
          
    sprintf(aux_string ,"    Available: %u      ", sMm.nr_available_modules);
    strncpy(pTexts[3], aux_string, NR_COLUMNS); 

    strncpyf(pTexts[4] ,"                     ", NR_COLUMNS);     

    //selected module            
    sprintf(aux_string ,"    Selected: M%u      ", sScreen_data.nr_selected_module+1);
    strncpy(pTexts[5], aux_string, NR_COLUMNS);              

    return NR_ROWS-2;              
}

// RESUME
byte sf_resume(byte* pTexts[NR_ROWS]){
    
    byte aux_string[AUX_STRING_SIZE];               
    tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];               
    
    sprintf(aux_string ," U lines: %u         ", Messmodul_getCountVoltage(sScreen_data.nr_selected_module));
    strncpy(pTexts[2], aux_string, NR_COLUMNS);
            
    sprintf(aux_string ," I lines: %u         ", Messmodul_getCountCurrent(sScreen_data.nr_selected_module));
    strncpy(pTexts[3], aux_string, NR_COLUMNS);        
                                                  
    strncpyf(pTexts[4] ,"                          ", NR_COLUMNS);
    
    sprintf(aux_string ," Frequence: %u.%u Hz      ", pModule->values.frequence/1000, pModule->values.frequence%1000);
    strncpy(pTexts[5], aux_string, NR_COLUMNS);
                                    
    sprintf(aux_string ," Temperature: %u.%u°C      ", pModule->values.temperature/10,pModule->values.temperature%10);
    strncpy(pTexts[6], aux_string, NR_COLUMNS);        
    
    return NR_ROWS-1;
        
}

/*******************************************/
// VOLTAGES
/*******************************************/
#ifndef MM_CALIBRATION_MODE
    //NORMAL FUNCTION
    byte sf_voltages(byte* pTexts[NR_ROWS]){
        byte aux_string[AUX_STRING_SIZE];    
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;   
        
        strncpyf(pTexts[2] ,"                     ", NR_COLUMNS);        
        
        for(i=0; i<3;i++){
            sprintf(aux_string ,"    L%u: %u.%u [V]   M%u  ", i+1, pModule->values.voltage[i]/10, pModule->values.voltage[i]%10, sScreen_data.nr_selected_module+1);                 
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }                          
        
        return NR_ROWS-2;           
    }
#else 
    //CALIBRATION FUNCTION   
    byte sf_voltages(byte* pTexts[NR_ROWS]){
        byte aux_string[AUX_STRING_SIZE];    
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;   
        
        strncpyf(pTexts[2] ,"                     ", NR_COLUMNS);
        
        
        for(i=0; i<3;i++){
            sprintf(aux_string ," %6lu, %u.%u [V]   M%u  ", pModule->registers.v_x[i], pModule->values.voltage[i]/10, pModule->values.voltage[i]%10, sScreen_data.nr_selected_module+1);                 
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }              
            
        
        return NR_ROWS-2;           
    }
#endif

/*******************************************/
// CURRENTS
/*******************************************/
#ifndef MM_CALIBRATION_MODE
    //NORMAL FUNCTION
    byte sf_currents(byte* pTexts[NR_ROWS]){
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;   
        
      
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){         
            sprintf(aux_string ,"    L%u: %u.%02u [A] M%u  ", i+1, pModule->values.current[i]/100, pModule->values.current[i]%100, sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }        
        
        return NR_ROWS-2;
            
    } 
#else
    //CALIBRATION FUNCTION
    byte sf_currents(byte* pTexts[NR_ROWS]){
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;   
        
      
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){         
            sprintf(aux_string ," %6lu, %u.%02u [A] M%u  ",  pModule->registers.i_x[i], pModule->values.current[i]/100, pModule->values.current[i]%100, sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }        
        
        return NR_ROWS-2;
            
    }
#endif    


/*******************************************/
// ALL POWERS
/*******************************************/
    //active & apparent power
    byte sf_powers(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE];
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
        word i;    
         
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){ 
            sprintf(aux_string ," L%u: %ld.%d [W] | %ld.%d [VA]", i+1, pModule->values.power_act[i]/10, abs(pModule->values.power_act[i]%10), pModule->values.power_app[i]/10, abs(pModule->values.power_app[i]%10));
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }  
        
        return NR_ROWS-2;
    }


/*******************************************/
// ACTIVE POWERS
/*******************************************/
#ifndef MM_CALIBRATION_MODE
    byte sf_powers_act(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;    
          
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ,"    L%u: %ld.%d [W] M%u  ", i+1, pModule->values.power_act[i]/10, abs(pModule->values.power_act[i]%10), sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }               
        
        return NR_ROWS-2;
            
    }
#else
    //CALIBRATION FUNCTION
    byte sf_powers_act(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;    
          
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ," %6ld, %ld.%d [W] M%u  ",  pModule->registers.pwrp_x[i], pModule->values.power_act[i]/10, abs(pModule->values.power_act[i]%10), sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }               
        
        return NR_ROWS-2;
            
    }
#endif
/*******************************************/
// APPARENT POWERS
/*******************************************/
#ifndef MM_CALIBRATION_MODE
    byte sf_powers_app(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;    
          
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ,"    L%u: %ld.%d [W] M%u  ", i+1, pModule->values.power_app[i]/10, abs(pModule->values.power_app[i]%10), sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }               
        
        return NR_ROWS-2;
            
    }
#else
    //CALIBRATION FUNCTION
    byte sf_powers_app(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;    
          
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ," %6ld, %ld.%d [W] M%u  ",  pModule->registers.pwrs_x[i], pModule->values.power_app[i]/10, abs(pModule->values.power_app[i]%10), sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }               
        
        return NR_ROWS-2;
            
    }
#endif


/*******************************************/
// ACTIVE ENERGIES
/*******************************************/
#ifndef MM_CALIBRATION_MODE
    // NORMAL FUNCTION
    byte sf_energies_act(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE];
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
        word i;     
        
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ,"   L%u: %3ld [Wh]   M%u ", i+1, pModule->values.energy_act[i], sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }         
        
        return NR_ROWS-2;
            
    } 
#else
    //CALIBRATION FUNCTION
    byte sf_energies_act(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE];
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
        word i;     
        
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ," %6ld, %3ld [Wh] M%u ", pModule->registers.enrp_x[i], pModule->values.energy_act[i], sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }         
        
        return NR_ROWS-2;
            
    }    
#endif    

/*******************************************/
// ACTIVE ENERGIES
/*******************************************/
#ifndef MM_CALIBRATION_MODE
    // NORMAL FUNCTION
    byte sf_energies_app(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE];
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
        word i;     
        
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ,"   L%u: %3ld [Wh]   M%u ", i+1, pModule->values.energy_app[i], sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }         
        
        return NR_ROWS-2;
            
    } 
#else
    //CALIBRATION FUNCTION
    byte sf_energies_app(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE];
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
        word i;     
        
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
        
        for(i=0; i<3;i++){
            sprintf(aux_string ," %6ld, %3ld [Wh] M%u ", pModule->registers.enrs_x[i], pModule->values.energy_app[i], sScreen_data.nr_selected_module+1);
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }         
        
        return NR_ROWS-2;
            
    }    
#endif 

/*******************************************/
// POWER FACTOR
/*******************************************/
#ifndef MM_CALIBRATION_MODE
    // NORMAL FUNCTION
    byte sf_powerfactors(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;    
          
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);  

        for(i=0; i<3;i++){  
            sprintf(aux_string ,"    L%u: %6ld    M%u  ", i+1, pModule->values.power_factor[i], sScreen_data.nr_selected_module+1);        
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }        
        
        return NR_ROWS-2;
            
    }
#else
    //CALIBRATION FUNCTION
    byte sf_powerfactors(byte* pTexts[NR_ROWS]){    
        byte aux_string[AUX_STRING_SIZE]; 
        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module]; 
        word i;    
          
        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);  

        for(i=0; i<3;i++){  
            sprintf(aux_string ," %6ld, %6ld M%u  ",  pModule->registers.pf_x[i], pModule->values.power_factor[i], sScreen_data.nr_selected_module+1);        
            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
        }        
        
        return NR_ROWS-2;
            
    }
#endif



/*************/
/* REGISTERS */
/*************/
/*
void sf_vrms(byte* pTexts[NR_ROWS]){
    
    tMESSMODULES *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       VRMS           ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %lu [V]     ", pModule->values.vrms[0]>>8);
    sprintf(pTexts[4] ,"      L2: %lu [V]     ", pModule->values.vrms[1]>>8);
    sprintf(pTexts[5] ,"      L3: %lu [V]     ", pModule->values.vrms[2]>>8);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}*/

/*
void sf_irms(byte* pTexts[NR_ROWS]){
    
    tMESSMODULES *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       IRMS           ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %lu [A]     ", pModule->values.irms[0]>>8);
    sprintf(pTexts[4] ,"      L2: %lu [A]     ", pModule->values.irms[1]>>8);
    sprintf(pTexts[5] ,"      L3: %lu [A]     ", pModule->values.irms[2]>>8);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}*/
/*
void sf_act(byte* pTexts[NR_ROWS]){
    
    tMESSMODULES *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       ACT            ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %ld [W]     ", pModule->values.act[0]);
    sprintf(pTexts[4] ,"      L2: %ld [W]     ", pModule->values.act[1]);
    sprintf(pTexts[5] ,"      L3: %ld [W]     ", pModule->values.act[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}

void sf_app(byte* pTexts[NR_ROWS]){
    
    tMESSMODULES *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"       APP            ");
    sprintf(pTexts[1] ,"      =========       ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"      L1: %ld [VA]     ", pModule->values.app[0]);
    sprintf(pTexts[4] ,"      L2: %ld [VA]     ", pModule->values.app[1]);
    sprintf(pTexts[5] ,"      L3: %ld [VA]     ", pModule->values.app[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
} */

/* ENERGY */
/*
void sf_eapos_eaneg(byte* pTexts[NR_ROWS]){
    
    tMESSMODULES *pMessmodul = &sMm[0];    
    
    sprintf(pTexts[0] ,"      EAPOS, EANEG    ");
    sprintf(pTexts[1] ,"      ============    ");
    sprintf(pTexts[2] ,"                      ");   
    sprintf(pTexts[3] ,"  L1: %ld , %ld       ", pModule->values.eapos[0], pModule->values.eaneg[0]);
    sprintf(pTexts[4] ,"  L2: %ld , %ld       ", pModule->values.eapos[1], pModule->values.eaneg[1]);
    sprintf(pTexts[5] ,"  L3: %ld , %ld       ", pModule->values.eapos[2], pModule->values.eaneg[2]);
    sprintf(pTexts[6] ,"                      ");
    sprintf(pTexts[7] ,"                      ");
        
}*/
