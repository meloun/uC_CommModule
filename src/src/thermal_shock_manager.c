//**********************************************************************************************
// outputs_manager.c - 
// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
// vsechny potrebne makra, aliasy definovany v digital_outputs_user.h
//**********************************************************************************************

#include <hw_def.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <digital_outputs.h>
#include "thermal_shock_manager.h"

/* USER DEFINES */

//#define THERMAL_SHOCK
#define THERMAL_SHOCK_TEST

#ifdef THERMAL_SHOCK_TEST          
    #define KELVIN_PER_10MINUTES   25 //!!kelvin per minute * 10!! 
    #define NR_CYCLES              7

    flash tCYCLE sCYCLES[NR_CYCLES] = {

    //      TEMP (°C)  | DURATION(sec) | POWER CYCLE | ON(sec) | OFF (sec) | 
        {     25,                 5,             0,          0,       0        }, //1    
        {     23,                 7,             0,          0,       0        }, //2
        {     24,                30,             1,          3,       3        }, //3
        {     20,                6,             1,         10,      10        }, //4
        {     20,                6,             1,         30,      30        }, //5
        {     25,                6,             0,          0,       0        }, //6
        {     25,                6,             0,          0,       0        }  //7
    }; 
#endif

#ifdef THERMAL_SHOCK
    #define KELVIN_PER_10MINUTES    25 //!!kelvin per minute * 10!!
    #define NR_CYCLES               51

    flash tCYCLE sCYCLES[NR_CYCLES] = {

    //      TEMP (°C)  | DURATION(sec) | POWER CYCLE | ON(sec) | OFF (sec) |
     
        /* 1 */
        {     25,            15 * 60,             0,          0,       0        }, //1    
        {     70,            60 * 60,             0,          0,       0        }, //2
        {     70,            15 * 60,             1,         30,      30        }, //3
        {    -20,            60 * 60,             0,          0,       0        }, //4
        {    -20,            15 * 60,             1,         30,      30        }, //5
        
        /* 2 */    
        {     25,            15 * 60,             0,          0,       0        }, //6    
        {     70,            60 * 60,             0,          0,       0        }, //7
        {     70,            15 * 60,             1,         20,      20        }, //8
        {    -20,            60 * 60,             0,          0,       0        }, //9
        {    -20,            15 * 60,             1,         20,      20        }, //10

        /* 3 */    
        {     25,            15 * 60,             0,          0,       0        }, //11    
        {     70,            60 * 60,             0,          0,       0        }, //12
        {     70,            15 * 60,             1,         15,      15        }, //13
        {    -20,            60 * 60,             0,          0,       0        }, //14
        {    -20,            15 * 60,             1,         15,      15        }, //15   
        
        /* 4 */
        {     25,            15 * 60,             0,          0,       0        }, //16    
        {     70,            60 * 60,             0,          0,       0        }, //17
        {     70,            15 * 60,             1,         10,      10        }, //18
        {    -20,            60 * 60,             0,          0,       0        }, //19
        {    -20,            15 * 60,             1,         10,      10        }, //20  

        /* 5 */    
        {     25,            15 * 60,             0,          0,       0        }, //21    
        {     70,            60 * 60,             0,          0,       0        }, //22
        {     70,            15 * 60,             1,         10,       5        }, //23
        {    -20,            60 * 60,             0,          0,       0        }, //24
        {    -20,            15 * 60,             1,         10,       5        }, //25
        
        /* 6 */
        {     25,            15 * 60,             0,          0,       0        }, //26    
        {     70,            60 * 60,             0,          0,       0        }, //27
        {     70,            15 * 60,             1,         10,       5        }, //28
        {    -20,            60 * 60,             0,          0,       0        }, //29
        {    -20,            15 * 60,             1,         10,       5        }, //30
        
        /* 7 */
        {     25,            15 * 60,             0,          0,       0        }, //31    
        {     70,            60 * 60,             0,          0,       0        }, //32
        {     70,            15 * 60,             1,          5,       3        }, //33
        {    -20,            60 * 60,             0,          0,       0        }, //34
        {    -20,            15 * 60,             1,          5,       3        }, //35
        
        /* 8 */
        {     25,            15 * 60,             0,          0,       0        }, //36    
        {     70,            60 * 60,             0,          0,       0        }, //37
        {     70,            15 * 60,             1,          5,       3        }, //38
        {    -20,            60 * 60,             0,          0,       0        }, //39
        {    -20,            15 * 60,             1,          5,       3        }, //40 
        
            
        /* 9 */
        {     25,            15 * 60,             0,          0,       0        }, //41    
        {     70,            60 * 60,             0,          0,       0        }, //42
        {     70,            15 * 60,             1,          5,       3        }, //43
        {    -20,            60 * 60,             0,          0,       0        }, //44
        {    -20,            15 * 60,             1,          5,       3        }, //45
        
            
        /* 10 */
        {     25,            15 * 60,             0,          0,       0        }, //46    
        {     70,            60 * 60,             0,          0,       0        }, //47
        {     70,            15 * 60,             1,          5,       3        }, //48
        {    -20,            60 * 60,             0,          0,       0        }, //49
        {    -20,            15 * 60,             1,          5,       3        }, //50
        
        {     25,            15 * 60,             0,          0,       0        } //51        
        
    };
#endif

/* END OF USER DEFINES */

tTS_PROCESS sTS;

void ThermalShock_Manager_Init(void){

  //set pins as outputs
  Digital_outputs_init();
  
  //init data             
  sTS.current_index = 0;    //first cycle
  sTS.current_state = 0;      
  memcpyf(&sTS.sCycle, &sCYCLES[sTS.current_index], sizeof(sTS.sCycle));
  
  printf("\ncycle->duration: %d", sTS.sCycle.duration);
    
}

//1s
void ThermalShock_Manager(void){ 
    static byte aux_flag = 0; 
    
    if(sTS.end_test){
        printf("\nTS: konec testu! (step %d.)", sTS.current_index+1);
        return;
    }
        
    /* SECOND CYCLE */
    
    //CYCLE SWITCHING?
    if(sTS.cycle_switching){
        printf("\ncycle switching: step %d -> %d - %d:%02d", sTS.current_index, sTS.current_index+1, sTS.cycle_switching/60,sTS.cycle_switching%60); 
        sTS.cycle_switching--;        
        return;           
    }
   
    //NEW STEP? 
    if(sTS.sCycle.duration == sCYCLES[sTS.current_index].duration){
        printf("\n============================================================================");
        printf("\nSTEP %d - temp:%d, duration: %d:%02d, power cycle: %d, power on: %d, power off: %d", sTS.current_index+1, sTS.sCycle.temperature, sTS.sCycle.duration/60, sTS.sCycle.duration%60, sTS.sCycle.power_cycle, sTS.sCycle.power_on, sTS.sCycle.power_off);
        printf("\n============================================================================");
    }
    
    //STEP    
    printf("\nstep %d - %d:%02d, %d, %d", sTS.current_index+1, sTS.sCycle.duration/60,sTS.sCycle.duration%60,  sTS.sCycle.power_on,  sTS.sCycle.power_off);     
    
    //NEXT CYCLE?
    if(--sTS.sCycle.duration == 0){
    
        //end of test?
        if(sTS.current_index == NR_CYCLES-1){
            sTS.end_test = 1; 
            DIG_OUT_5_OFF; 
            DIG_OUT_6_OFF; 
            return;
        }             
        
        //next cycle
        sTS.current_index++;
        sTS.cycle_switching = (abs(sCYCLES[sTS.current_index].temperature - sCYCLES[sTS.current_index-1].temperature)*10*60) / KELVIN_PER_10MINUTES;                 
        memcpyf(&sTS.sCycle, &sCYCLES[sTS.current_index], sizeof(sTS.sCycle));
        
        //pin off
        sTS.current_state = 0;
        DIG_OUT_5_OFF; 
        DIG_OUT_6_OFF;       
               
        return;          
    }
    
        
    /* TOGGLE PINS */
    //toggle pins?
    if(sTS.sCycle.power_cycle){       
    
        //output in  '0'?
        if(sTS.current_state == 0){
            
            //change to '1'?
            if(--sTS.sCycle.power_off == 0){                                
                sTS.sCycle.power_off = sCYCLES[sTS.current_index].power_off;
                sTS.current_state = 1; 
                DIG_OUT_5_ON;;
                DIG_OUT_6_ON;        
                aux_flag = 0;
                printf("\nSWITCH ON");
            }
        }               
        
        //output in '1'?
        else if(sTS.current_state == 1){
            
            //change to '0'?
            if(--sTS.sCycle.power_on == 0){                
                sTS.sCycle.power_on = sCYCLES[sTS.current_index].power_on;
                sTS.current_state = 0;
                DIG_OUT_5_OFF;;
                DIG_OUT_6_OFF;
                aux_flag = 1;
                printf("\nSWITCH OFF");
            }
        }
    }                                            
                              
}




