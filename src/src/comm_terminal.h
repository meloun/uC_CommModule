/*
 * comm_app.h
 *
 *  Created on: 31.8.2009
 *      Author: Tomáš Padrta
 */

#ifndef _COMM_TERMINAL_H
#define _COMM_TERMINAL_H

//USERS DEFINES
#define COMM_TERMINAL_PORT          PORTD         // UART 0 port
#define COMM_TERMINAL_DDR           DDRD          // UART 0 data direction
#define COMM_TERMINAL_PIN           PIND          // UART 0 pins
#define COMM_TERMINAL_RX_PIN_MASK   0x01          // UART 0 RX pin
#define COMM_TERMINAL_TX_PIN_MASK	0x02          // UART 0 TX pin

#define COMM_TERMINAL_UART_NR          0
#define COMM_TERMINAL_BAUDRATE         115200//9600         // transfer baudrate
//END OF USERS DEFINES

typedef enum {
	eWAIT_FOR_CHAR, eWAIT_FOR_PROCESS_OK,eWAIT_FOR_PROCESS_KO 
} eCOMM_TERMINAL_STATE;

// Public functions
void CommTerminal_Init(void);

// Private functions
void CommTerminal_Handler(byte data);
void CommTerminal_Manager(void);


#endif // _COMM_TERMINAL_H
