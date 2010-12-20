//**********************************************************************************************
// test_process.c - 
// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
//**********************************************************************************************

#include <hw_def.h>
#include <stdio.h>
#include <digital_outputs.h>
#include <buttons.h>
#include <uart2.h>
#include <display.h>



void Test_process_leds(void){
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


void Test_process_buttons(){
    static byte aux_top_first = 1, aux_bottom_first = 1;
    
    /* BUTTON TOP */
    if(GET_BUTTON_TOP_STATE == 0){
        if(aux_top_first){ //prave ted zmacknuto?            
            //uartSendBufferf(0,"\nI: Tlacitko TOP  bylo zmacknuto..");
            
            //printf("\n-");
            //Disp_previous_screen();   
            aux_top_first = 0;
        }        
    }
    else    //tlacitko pusteno
        aux_top_first = 1;  //vynulovani flagu pro nove zmacknuti

    /* BUTTON BOTTOM */        
    if(GET_BUTTON_BOTTOM_STATE == 0){ //prave ted zmacknuto?     
        if(aux_bottom_first){ 
            //uartSendBufferf(0,"\nI: Tlacitko BOTTOM bylo zmacknuto..");  
            
            //printf("\n+");                        
            //Disp_next_screen();
            aux_bottom_first = 0;
        }
    }
    else    //tlacitko pusteno
        aux_bottom_first = 1;   //vynulovani flagu pro nove zmacknuti
}

void Test_process_uart(void){
    //char text[] = "\nI: SendBuffer()";
    //char a= 'a';

    //uartSendByte(0, a);
    uartSendBufferf(1,"\nI: SendBufferf()");
    // uartSendBuffer(0,text, 16);    
}



/* END OF TEST_PROCESS */