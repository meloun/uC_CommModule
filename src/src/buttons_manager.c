//**********************************************************************************************
// buttons_user.c - 
// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
//**********************************************************************************************

#include <hw_def.h>
#include <stdio.h>
#include <buttons.h>
#include <display_manager.h>
#include <display_screens.h>
#include <utils.h>
#include "buttons_manager.h"


void Test_process_buttons2(){
    static byte aux_top_first = 1, aux_bottom_first = 1;
    
    /* BUTTON TOP */
    if(GET_BUTTON_TOP_STATE == 0){
        if(aux_top_first){ //prave ted zmacknuto?            
            //uartSendBufferf(0,"\nI: Tlacitko TOP  bylo zmacknuto..");
            
            printf("\n-");
            Disp_previous_screen();   
            aux_top_first = 0;
        }        
    }
    else    //tlacitko pusteno
        aux_top_first = 1;  //vynulovani flagu pro nove zmacknuti

    /* BUTTON BOTTOM */        
    if(GET_BUTTON_BOTTOM_STATE == 0){ //prave ted zmacknuto?     
        if(aux_bottom_first){ 
            //uartSendBufferf(0,"\nI: Tlacitko BOTTOM bylo zmacknuto..");  
            
            printf("\n+");                        
            Disp_next_screen();
            aux_bottom_first = 0;
        }
    }
    else    //tlacitko pusteno
        aux_bottom_first = 1;   //vynulovani flagu pro nove zmacknuti
}

void Buttons_manager(){
    static byte aux_top_first = 1, aux_bottom_first = 1;
    static byte cnt_pressed_1=0, cnt_pressed_2=0;
    static byte flag_long_pressed = 0;
    
    /* BUTTON TOP */
    if(GET_BUTTON_TOP_STATE == 0){
        cnt_pressed_1++; 
        if( cnt_pressed_1 > CNT_LONG_PRESS){
            printf("\nI:buttons: long press"); 
            cnt_pressed_1 = 0;  //vynulovani flagu pro nove zmacknuti
            flag_long_pressed = 1; // aby se po pusteni tlacitka nevykonal "short press"
            rot_inc(&sScreen_data.nr_selected_module, 3);            
        }                      
    }
    else{    //tlacitko pusteno
        if((cnt_pressed_1>CNT_SHORT_PRESS)&&(flag_long_pressed == 0)) {
            printf("\nI:buttons: short press"); 
            Disp_previous_screen();                  
        }
        flag_long_pressed = 0;
        cnt_pressed_1 = 0;  //vynulovani flagu pro nove zmacknuti
    } 
    
    /* BUTTON BOTTOM */
    if(GET_BUTTON_BOTTOM_STATE == 0){
        cnt_pressed_2++;                       
    }
    else{    //tlacitko pusteno
        if(cnt_pressed_2>CNT_SHORT_PRESS) {             
            Disp_next_screen();                  
        }        
        cnt_pressed_2 = 0;  //vynulovani flagu pro nove zmacknuti
    }
}



/* END OF BUTTONS_USER */