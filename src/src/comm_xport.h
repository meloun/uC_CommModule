/*
 * comm_app.h
 *
 *  Created on: 31.8.2009
 *      Author: Luboš Melichar
 */

#ifndef _COMM_XPORT_H
#define _COMM_XPORT_H

/* USERS DEFINES */
#define COMM_XPORT_PORT          PORTD         // UART 0 port
#define COMM_XPORT_DDR           DDRD          // UART 0 data direction
#define COMM_XPORT_PIN           PIND          // UART 0 pins
#define COMM_XPORT_RX_PIN_MASK   0x03          // UART 0 RX pin
#define COMM_XPORT_TX_PIN_MASK	 0x04          // UART 0 TX pin


#define COMM_XPORT_UART_NR       1
#define COMM_XPORT_BAUDRATE      9600         // transfer baudrate
//END OF USERS DEFINES


// protocol specification
#define COMM_XPORT_EMPTYFRAME_LENGTH      3         // empty frame length (datalength = 0)
#define COMM_XPORT_DATALENGTH_MAX		  30		  // maximal datalength, restricted by UART buffer max length
#define COMM_XPORT_STARTBYTE			  0x53      // Startbyte
#define COMM_XPORT_ACK_OFFSET             0x80      // Offset added to command tag = ACK

/* COMMANDS */
// 0x00+ - spec command

#define CMD_SYNC_START         0x01      // Comm synchronization command
// synchtonization, posila se na konci jedne davky prenosu
// xport ma cas do dalsi davky -> muze si procistit buffery, resp. odpojit a pripojit seriovy port
#define CMD_SYNC_END           0x02      


// 0x10+ - executive commands (set)
#define CMD_SET_OUTPUTS		0x10      // Set 16xoutputs

// 0x20+ - state commands (get)
#define CMD_GET_INPUTS  	0x20      // Get 16xiputs

//0x30+ - MESSMODUL state commands(get)
#define CMD_MM_GET_FREQUENCY  	0x30      //
#define CMD_MM_GET_TEMPERATURE 	0x31      //


#define CMD_MM_GET_VOLTAGE_1  	0x40      //
#define CMD_MM_GET_VOLTAGE_2  	0x41      //
#define CMD_MM_GET_VOLTAGE_3  	0x42      //
#define CMD_MM_GET_CURRENT_1  	0x43      //
#define CMD_MM_GET_CURRENT_2  	0x44      //
#define CMD_MM_GET_CURRENT_3  	0x45      //
#define CMD_MM_GET_POWER_1  	0x46      //
#define CMD_MM_GET_POWER_2  	0x47      //
#define CMD_MM_GET_POWER_3  	0x48      //
#define CMD_MM_GET_ENERGY_1  	0x49      //
#define CMD_MM_GET_ENERGY_2  	0x4A      //
#define CMD_MM_GET_ENERGY_3  	0x4B      //
#define CMD_MM_GET_PF_1  	    0x4C      //
#define CMD_MM_GET_PF_2  	    0x4D      //
#define CMD_MM_GET_PF_3  	    0x4E      //







// Errors
#define RSP_OK                  0x00        // No errors
#define RSP_UNKNOWN_COMMAND     0x01        // Unknown command
//END OF COMMANDS

// protocol states
typedef enum {
	eWAIT_FOR_STARTBYTE, eWAIT_FOR_SEQ, eWAIT_FOR_CMD,  eWAIT_FOR_DATALENGTH, eWAIT_FOR_DATA, eWAIT_FOR_XOR, eWAIT_FOR_PROCESS
} eCOMM_XPORT_STATE;

typedef enum {
	eIO, e1F, eVOLTAGES, eCURRENTS,  ePOWERS, eENERGIES, ePFS
} eCOMM_XPORT_SENDGROUPS;

// protocol frame structure
typedef struct{
    volatile byte comm_state; // current protocol state
    byte seq;            // current sequence number	
} tPROTOCOL;             // Protocol variables


typedef struct{
    byte seq;           // sequence number
    byte command;       // commnad id
    byte* pData;
	byte datalength;    // length of data
	byte data[COMM_XPORT_DATALENGTH_MAX];   // max data length  
    byte xor;           // control xor
    byte data_cnt;      // received bytes counter	
} tFRAME;             // communication frame

//values from xport
typedef struct{
    byte ip_address[4];
    byte mac_address[6]; 	
} tXPORT;



extern tXPORT sXport;

// Public functions
void CommXport_Init(void);

// Private functions
void CommXport_Handler(byte data);
byte CommXport_ProcessCommand(void);
void CommXport_Manager(void);



#endif // _COMM_XPORT_H
