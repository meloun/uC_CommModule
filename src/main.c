 
  
  /*****************************************************
Chip type               : ATmega324PA
Program type            : Application
AVR Core Clock frequency: 11,0592 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <hw_def.h>
#include <stdio.h>
#include <delay.h>
#include <uknos.h>    //110B
#include <uart2.h>    //124B
#include <my_spi.h>
#include <messmodules.h>
#include <digital_outputs.h>
#include <buttons.h>
#include <NT7534.h>
#include "display.h"
#include "test_process.h"
#include "comm_terminal.h"
#include "comm_xport.h"

void HW_init(void);

void main(void){

  /* HW Inits */
  HW_init();
  Digital_outputs_init();
  Buttons_init();
      
  /* SW Inits */
  //uart                                                         
  //CommTerminal_Init(); //init ports, registers, baudrate, RX handler  
  CommXport_Init(); //init ports, registers, baudrate, RX handler
  
  //spi
  Messmodul_Init();
  Display_Init();        
        
  DISABLE_INTERRUPT //some Inits can enable interrupt
  
  delay_ms(100);
  
  /* KERNEL Init */
  uKnos_Init();            
  
  
  
  //****************************************** 
  // PROCESSES 
  // - period in miliseconds, shortest period is 10ms
  //******************************************
  
  //Create_Process( 3000, CommXport_Manager);   //zpracovava buffer naplneny v preruseni
  Create_Process( 3000,  Messmodul_Manager);    //read and save data from MAXIM     
  Create_Process(  200, Test_process_buttons);//vypisuje jake tlacitko bylo zmacknuto 
  Create_Process( 1000, Test_process_leds);     //blika led   
  Create_Process( 500, Display_Manager);       //obsluha dipleje
  
  //Create_Process( 100, CommTerminal_Manager); //zpracovava buffer naplneny prijmutymi znaky
  
  //delay before uart output  
  delay_ms(2000);   
  
  //print messages
  uartSendBufferf(0, STRING_START_MESSAGE);  //start message
  uartSendBufferf(0, "\n# HW: "); uartSendBufferf(0, HW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, HW_VERSION_S); //version  
  uartSendBufferf(0, "\n# SW: "); uartSendBufferf(0, SW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, SW_VERSION_S); //version
  uartSendBufferf(0, STRING_SEPARATOR);
  
  //Start uKnos  
  uKnos_Start(); //enable interrupt
  uartSendBufferf(0,"\nI: System start..");             
        
while (1){
 
    //printf(".");     
    Messmodul_Rest();  //vypisy
     
} //end of while
} //end of main

void getR(){
    byte aux_data;
    aux_data = SPI_MasterTransmit(0x38);    
    if(aux_data == 0xc1){
        delay_ms(10);
        aux_data = SPI_MasterTransmit(0x31);         
        if(aux_data == 0xc2){
            delay_ms(50);
            aux_data = SPI_MasterTransmit(0x00);
            delay_ms(10);
            aux_data = SPI_MasterTransmit(0x00);
            if(aux_data == 0x41){
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:1.byte %x", aux_data);
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:2.byte %x", aux_data);
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:3.byte %x", aux_data);                
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:4.byte %x", aux_data);
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:5.byte %x", aux_data);
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:6.byte %x", aux_data);
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:7.byte %x", aux_data);
                delay_ms(10);
                aux_data = SPI_MasterTransmit(0x00);
                printf("\nI:8.byte %x", aux_data);
                printf("\n=============================================");                  
            }
            else
                printf("\nEE: nejsem ready %x",aux_data);
            
        }
        else
            printf("\nEE: spatna adresa");
    }
    else
        printf("\nEE: spatnej zacatek");     
}

//**************************************************************************
// Nastaveni MCU
//**************************************************************************
void HW_init(void)
{
    // Crystal Oscillator division factor: 1
    #pragma optsize-
    CLKPR=0x80;
    CLKPR=0x00;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    // Input/Output Ports initialization
    // Port A initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTA=0x00;
    DDRA=0x00;

    // Port B initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTB=0x00;
    DDRB=0x00;

    // Port C initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTC=0x00;
    DDRC=0x00;

    // Port D initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTD=0x00;
    DDRD=0x00;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=FFh
    // OC0A output: Disconnected
    // OC0B output: Disconnected
    TCCR0A=0x00;
    TCCR0B=0x00;
    TCNT0=0x00;
    OCR0A=0x00;
    OCR0B=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: Timer1 Stopped
    // Mode: Normal top=FFFFh
    // OC1A output: Discon.
    // OC1B output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=0x00;
    TCCR1B=0x00;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer2 Stopped
    // Mode: Normal top=FFh
    // OC2A output: Disconnected
    // OC2B output: Disconnected
    ASSR=0x00;
    TCCR2A=0x00;
    TCCR2B=0x00;
    TCNT2=0x00;
    OCR2A=0x00;
    OCR2B=0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    // Interrupt on any change on pins PCINT0-7: Off
    // Interrupt on any change on pins PCINT8-15: Off
    // Interrupt on any change on pins PCINT16-23: Off
    // Interrupt on any change on pins PCINT24-31: Off
    EICRA=0x00;
    EIMSK=0x00;
    PCICR=0x00;

    // Timer/Counter 0 Interrupt(s) initialization
    TIMSK0=0x00;
    // Timer/Counter 1 Interrupt(s) initialization
    TIMSK1=0x00;
    // Timer/Counter 2 Interrupt(s) initialization
    TIMSK2=0x00;
    
    // USART0 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART0 Receiver: Off
    // USART0 Transmitter: On
    // USART0 Mode: Asynchronous
    // USART0 Baud Rate: 9600
    UCSR0A=0x00;
    UCSR0B=0x08;
    UCSR0C=0x06;
    UBRR0H=0x00;
    UBRR0L=0x05; //0x47;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    ADCSRB=0x00;
} 