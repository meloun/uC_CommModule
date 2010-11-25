//**********************************************************************************************
// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
/* *******************************************************************
 *  modul               :    COMM_XPORT.C
 * *******************************************************************
 * desc: UART protocol for communication with terminal, webserver, etc.
 * this mcu counts as MASTER, terminal counts as SLAVE
 * communication session can be initiated only by MASTER for now
 * MASTER starts by sending command
 * ------------------------------------------------------------
 * | STARTBYTE | SEQ | COMMAND | DATALENGTH | DATA | .. | XOR |
 * ------------------------------------------------------------
 * STARTBYTE = 0x53 (byte), constant for start of frame
 * SEQ = 0-255(byte), control id of command in case of retransmit
 * COMMAND = 0-0x7F(byte), application command
 *         = 0-0x7F+0x80(byte), terminal acknowledge for good received command
 * DATALENGTH = 0-255(byte), length of transmitted data
 * DATA = payload, contains useful info
 * XOR = 0-0xFF(byte), logic xor of STARTBYTE, SEQ, COMMAND, DATALENGTH and DATA (if any)
 *
 * SLAVE executes command and responds with the equal structured frame,
 * but the COMMAND MSb is set to 1
 * ********************************************************************
 */

#include <hw_def.h>
#include <types.h>
#include <stdio.h>
#include <string.h>
#include <uart2.h>
#include <digital_outputs.h>
#include <buttons.h>
#include <messmodules.h>
#include "comm_xport.h"
#include "comm_xport_frames.h"


//LOCAL VARIABLES
#define RX_BUFFER_SIZE  10

tFRAME sFrame_Rx;       // receiving frame
tPROTOCOL sProtocol;    // protocol states 
tXPORT sXport;          // values received from xport


// CommApp_Init - Init IO pins, UART params, protocol variables
void CommXport_Init(void){
    byte i;

	//Rx pin init
	COMM_XPORT_DDR &= ~COMM_XPORT_RX_PIN_MASK; 	//0 -> input
	COMM_XPORT_PORT |= COMM_XPORT_RX_PIN_MASK; 	//1 -> pullup
	//Tx pin init
	COMM_XPORT_DDR |= COMM_XPORT_TX_PIN_MASK; 	//1 -> output
	COMM_XPORT_PORT |= COMM_XPORT_RX_PIN_MASK; 	//1 -> default output = '1'

    // USART param setting    
	uartInit(COMM_XPORT_UART_NR);            // Tx, Rx, TxIRq, RxIRq
	uartSetBaudRate(COMM_XPORT_UART_NR, COMM_XPORT_BAUDRATE, 0);   // Commspeed
	uartSetRxHandler(COMM_XPORT_UART_NR, CommXport_Handler);        // Rx bytes handler

    /* VARIABLES */
     
    //ip address
    for(i=0; i<4; i++) 
        sXport.ip_address[i] = i;

    //mac address        
    for(i=0; i<6; i++)
        sXport.mac_address[i] = i;                    
    
    sProtocol.seq = 0;
}

// CommApp_Handler() - routine for received char from UART.
// Received char is processed, after last char is received,
// control "sProtocol.comm_state" is switched to special state allowing
// processing and executing of command
void CommXport_Handler(byte data){ 
    
	switch(sProtocol.comm_state){
    
	    case eWAIT_FOR_STARTBYTE:                // waiting for startbyte
			if (data == COMM_XPORT_STARTBYTE) {    // start of frame
				sFrame_Rx.data_cnt = 0;          // init databytes counter                
				sProtocol.comm_state = eWAIT_FOR_SEQ;  // switch to next state
// 				LED_7_CHANGE;
// 				uartSendBufferf(0,"LED_7_CHANGE");
			}
			break;

        case eWAIT_FOR_SEQ:                  // awaiting sequence byte
            sFrame_Rx.seq = data;            // seq
            sProtocol.comm_state = eWAIT_FOR_CMD;  // switch to nex state
            break;

		case eWAIT_FOR_CMD:                         // awaiting command byte                                   
		    sFrame_Rx.command = data;   // command                                   
			sProtocol.comm_state = eWAIT_FOR_DATALENGTH;  // switch to next state
			break;

		case eWAIT_FOR_DATALENGTH:  // awaiting datalength byte
			if(data > COMM_XPORT_DATALENGTH_MAX)        // datalength above data buffer (ERROR)
				sProtocol.comm_state = eWAIT_FOR_STARTBYTE; // switch to starting state
			else {      // ok
				sFrame_Rx.datalength = data;
                if (data)     // frame contains data
  				    sProtocol.comm_state = eWAIT_FOR_DATA;        // switch to next state
                else          // no data, xor is expected
  				    sProtocol.comm_state = eWAIT_FOR_XOR;			// switch to xor state
			}
			break;

		case eWAIT_FOR_DATA:              // awaiting data byte
			sFrame_Rx.data[sFrame_Rx.data_cnt] = data;  // data byte
			sFrame_Rx.data_cnt++;                       // saved data cntr increases
			if (sFrame_Rx.data_cnt >= sFrame_Rx.datalength){ // last data
				sProtocol.comm_state = eWAIT_FOR_XOR;       // switch to next (xor) state
			}
// 			uartSendByte(0,sFrame_Rx.data_cnt);
// 			LED_2_CHANGE;
			break;

		case eWAIT_FOR_XOR: // awaiting xor
            sFrame_Rx.xor = data;               // xor
            sProtocol.comm_state = eWAIT_FOR_PROCESS; // switch to final state - awating processing
			break;
    } // switch end
}


// CommApp_ProcessCommand - command executing and filling
// Tx Frame with valid data and datalength. Return 1 when
// gets unknown command, else return 0 (OK).
byte CommXport_ProcessCommand(void){

	switch(sFrame_Rx.command){
    
        // system commands
        case CMD_SYNC_END:                // Set seq to value 0, any rx frame is new
            sFrame_Rx.seq = 0;
            break;
        
        // unknown command
	    default:
            return RSP_UNKNOWN_COMMAND;
		    break;
	}
  return RSP_OK;
}

 /* ------------------------------------------------------------
 * | STARTBYTE | SEQ | COMMAND | DATALENGTH | DATA | .. | XOR |
 * ------------------------------------------------------------*/
void CommXport_SendFrame(byte command, byte* pData, byte datalength){
    byte i, xor = COMM_XPORT_STARTBYTE;       

    /* CREATING FRAME */
    
    //start byte
    uartAddToTxBuffer(COMM_XPORT_UART_NR, COMM_XPORT_STARTBYTE);      // startbyte added to buffer
    
    //sequence
    uartAddToTxBuffer(COMM_XPORT_UART_NR, ++sProtocol.seq);           // sequence added to buffer
    xor ^= sProtocol.seq;                                 // seq added to xor
    
    //command    
    uartAddToTxBuffer(COMM_XPORT_UART_NR, command | 0x80); // command added to buffer
    xor ^= command;                                        // command added to xor           
    
    //datalength
    uartAddToTxBuffer(COMM_XPORT_UART_NR, datalength);           // datalength added to buffer
    xor ^= datalength;                          // datalength added to xor
    
    //data
    for (i=0; i<datalength; i++) {                  // all databytes
        uartAddToTxBuffer(COMM_XPORT_UART_NR, *(pData+i));    // data byte added to buffer
        xor ^= *(pData+i);                             // data byte added to xor
    }
    
    //xor
    uartAddToTxBuffer(COMM_XPORT_UART_NR, xor);         // xor added to buffer

    // sending frame
    uartSendTxBuffer(COMM_XPORT_UART_NR);
    
}

void CommXport_SendFrames(void){
    static byte send_group = 0;        
    tMESSMODUL *pMessmodul = &sMm[0];
    byte aux_data;                                      
        
    
    switch(send_group++){
        case eIO:
            //INPUTS
            aux_data = (GET_BUTTON_TOP_STATE<<1) | GET_BUTTON_BOTTOM_STATE; 
            CommXport_SendFrame( CMD_GET_INPUTS, &aux_data, 1); 
            //OUTPUTS      
            aux_data = 0xAA;                                    
            CommXport_SendFrame( CMD_SET_OUTPUTS , &aux_data, 1 );         
            break;
        case e1F:
            //1F values    
            CommXport_SendFrame( CMD_MM_GET_FREQUENCY,   (byte*)&pMessmodul->values.frequence,   2);  //FREQUENCE                
            CommXport_SendFrame( CMD_MM_GET_TEMPERATURE, (byte*)&pMessmodul->values.temperature, 2);  //RAWTEMP
            break;
        case eVOLTAGES:
            //VOLTAGEs
            CommXport_SendFrame( CMD_MM_GET_VOLTAGE_1,  (byte*)&pMessmodul->values.voltage[0],  2);  //VOLTAGE 1
            CommXport_SendFrame( CMD_MM_GET_VOLTAGE_2,  (byte*)&pMessmodul->values.voltage[1],  2);  //VOLTAGE 2
            CommXport_SendFrame( CMD_MM_GET_VOLTAGE_3,  (byte*)&pMessmodul->values.voltage[2],  2);  //VOLTAGE 3
            break;
        case eCURRENTS:
            //CURRENTs    
            CommXport_SendFrame( CMD_MM_GET_CURRENT_1,  (byte*)&pMessmodul->values.current[0],  2);  //CURRENT 1
            CommXport_SendFrame( CMD_MM_GET_CURRENT_2,  (byte*)&pMessmodul->values.current[1],  2);  //CURRENT 2
            CommXport_SendFrame( CMD_MM_GET_CURRENT_3,  (byte*)&pMessmodul->values.current[2],  2);  //CURRENT 3
            break;
        case ePOWERS:
            //POWERs    
            CommXport_SendFrame( CMD_MM_GET_POWER_1,  (byte*)&pMessmodul->values.power[0],  2);  //POWER 1
            CommXport_SendFrame( CMD_MM_GET_POWER_2,  (byte*)&pMessmodul->values.power[1],  2);  //POWER 2
            CommXport_SendFrame( CMD_MM_GET_POWER_3,  (byte*)&pMessmodul->values.power[2],  2);  //POWER 3
            break; 
        case eENERGIES:
            //ENERGIES    
            CommXport_SendFrame( CMD_MM_GET_ENERGY_1,  (byte*)&pMessmodul->values.energy[0],  2);  //ENERGY 1
            CommXport_SendFrame( CMD_MM_GET_ENERGY_2,  (byte*)&pMessmodul->values.energy[1],  2);  //ENERGY 2
            CommXport_SendFrame( CMD_MM_GET_ENERGY_3,  (byte*)&pMessmodul->values.energy[2],  2);  //ENERGY 3
            break;
        case ePFS:
            //POWER FACTOR    
            CommXport_SendFrame( CMD_MM_GET_PF_1,  (byte*)&pMessmodul->values.pf[0],  2);  //PF 1
            CommXport_SendFrame( CMD_MM_GET_PF_2,  (byte*)&pMessmodul->values.pf[1],  2);  //PF 2
            CommXport_SendFrame( CMD_MM_GET_PF_3,  (byte*)&pMessmodul->values.pf[2],  2);  //PF 3
            send_group = eIO;  
            break;
    }                            
    
    //SYNCHRONIZATION END 
    CommXport_SendFrame( CMD_SYNC_END,     (byte*)&aux_data,                       0);  //SYNCHRONIZATION END
    
}

// CommApp_Manager - periodicaly checking receiving buffer for
// new frame, execute command if found and send acknowlenge.
void CommXport_Manager(void){            
        
    if (sProtocol.comm_state == eWAIT_FOR_PROCESS) {     // new frame
        
        // Executing received command and new frame creation
        CommXport_ProcessCommand();   // command executed ok        
    }
    
    //sending
    CommXport_SendFrames();          
}


