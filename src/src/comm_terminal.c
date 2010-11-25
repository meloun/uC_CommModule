//**********************************************************************************************
// comm_terminal.c 
// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
//**********************************************************************************************
// - 
// - 
// - 
//**********************************************************************************************

#include <hw_def.h>
#include <types.h>
#include <stdio.h>
#include <string.h>
#include <uart2.h>
#include <digital_outputs.h>
#include "comm_terminal.h"

//LOCAL VARIABLES
#define RX_BUFFER_SIZE  10

//prijimaci buffer
byte uartRxBuffer[RX_BUFFER_SIZE];
byte uartRxBuffer_index;
//stav protokolu
volatile byte comm_terminal_state;

// CommApp_Init - Init IO pins, UART params, protocol variables
void CommTerminal_Init(void)
{

	//Rx pin init
	COMM_TERMINAL_DDR &= ~COMM_TERMINAL_RX_PIN_MASK; 	//0 -> input
	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> pullup
	//Tx pin init
	COMM_TERMINAL_DDR |= COMM_TERMINAL_TX_PIN_MASK; 	//1 -> output
	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> default output = '1'

    // USART param setting	 
    uartInit(COMM_TERMINAL_UART_NR);            // Tx, Rx, TxIRq, RxIRq
	uartSetBaudRate(COMM_TERMINAL_UART_NR, COMM_TERMINAL_BAUDRATE, 0);   // Commspeed
	uartSetRxHandler(COMM_TERMINAL_UART_NR, CommTerminal_Handler);        // Rx bytes handler

    // Variables init
    uartRxBuffer_index = 0;	
}

// CommApp_Handler() - routine for received char from UART.
// Received char is processed, after last char is received,
// control "comm_terminal_state" is switched to special state allowing
// processing and executing of command
void CommTerminal_Handler(byte data){ 
    
    if(comm_terminal_state == eWAIT_FOR_CHAR){

        //ukoncovaci znak?        
        if ((data == '\n')||(data == '\r')){
            comm_terminal_state = eWAIT_FOR_PROCESS_OK;            
            return; //-> ukoncovaci znak se do bufferu nevklada 
        }
        
        //ulozeni znaku do bufferu    
        uartRxBuffer[uartRxBuffer_index++] = data;

        //je jeste misto pro dalsi prijem?        
        if(uartRxBuffer_index ==  RX_BUFFER_SIZE){        
           comm_terminal_state = eWAIT_FOR_PROCESS_KO;          
        }
    }    
}
void CommTerminal_Manager(void){
    switch(comm_terminal_state){
        case eWAIT_FOR_PROCESS_OK: 
            uartSendBufferf(COMM_TERMINAL_UART_NR,"\nI: Prijmut string: ");
            break;
        case  eWAIT_FOR_PROCESS_KO:
            uartSendBufferf(COMM_TERMINAL_UART_NR,"\nE: Nedostatecny buffer, string:");
            break;          
    }
    
    if(comm_terminal_state != eWAIT_FOR_CHAR){
        uartSendBuffer(COMM_TERMINAL_UART_NR, uartRxBuffer, uartRxBuffer_index);                  
        uartRxBuffer_index = 0;           //flush buffer                           
        comm_terminal_state = eWAIT_FOR_CHAR;  //povoleni dalsiho prijmu
    }
}
