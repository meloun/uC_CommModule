//*******************************************************************
// outputs_manager.h
// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
//*******************************************************************
// 
//*******************************************************************
#ifndef OUTPUTS_MANAGER_H_
#define OUTPUTS_MANAGER_H_

#include <types.h>

   
typedef struct{
    signed char temperature;    
    word duration;
    byte power_cycle;
    byte power_on;
    byte power_off;
}tCYCLE;

typedef struct{
    byte current_index; //index do flash tabulky
    byte current_state; //aktualni stav vystupu
    word cycle_switching;
    byte end_test;        
    tCYCLE sCycle;      //ram obraz 1radku z flash tabulky             
}tTS_PROCESS;


void ThermalShock_Manager_Init(void);
void ThermalShock_Manager(void);


#endif /* OUTPUTS_MANAGER_H_ */
