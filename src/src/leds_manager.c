//**********************************************************************************************
// leds_manager.c - 
// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
// vsechny potrebne makra, aliasy definovany v digital_outputs_user.h
//**********************************************************************************************

#include <hw_def.h>
#include <stdio.h>
#include <digital_outputs.h>
#include "leds_manager.h"


void Leds_Init(void){
  Digital_outputs_init();
}

void Leds_Manager(void){
    static byte aux_flag = 0;
    
    //printf("\nLED CHANGED");        
    
    LED_2_CHANGE;      
        
    if(aux_flag){
        LED_1_CHANGE;        
        aux_flag = 0;
    }
    else
        aux_flag = 1;    
}




/* END OF TEST_PROCESS */