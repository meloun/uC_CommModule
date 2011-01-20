
;CodeVisionAVR C Compiler V2.04.8a Standard
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega324PA
;Program type             : Application
;Clock frequency          : 11,059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : long, width
;(s)scanf features        : long, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega324PA
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _uartRxBuffer_index=R5

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr

_STRING_START_MESSAGE:
	.DB  0xA,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0xA,0x23,0x20,0x4B,0x6E,0x75
	.DB  0x65,0x72,0x72,0x20,0x41,0x47,0xA,0x23
	.DB  0x20,0x52,0x4D,0x20,0x49,0x49,0x20,0x2D
	.DB  0x20,0x49,0x6E,0x67,0x2E,0x20,0x4C,0x2E
	.DB  0x4D,0x65,0x6C,0x69,0x63,0x68,0x61,0x72
	.DB  0x2C,0x20,0x49,0x6E,0x67,0x2E,0x20,0x50
	.DB  0x2E,0x4B,0x65,0x72,0x6E,0x64,0x6C,0x20
	.DB  0x0
_STRING_SEPARATOR:
	.DB  0xA,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x0
_sSCREEN_GROUP:
	.DB  0x42,0x4F,0x41,0x52,0x44,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,LOW(_sf_board)
	.DB  HIGH(_sf_board),0x4D,0x4F,0x44,0x55,0x4C,0x45,0x53
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  LOW(_sf_modules),HIGH(_sf_modules),0x52,0x45,0x53,0x55,0x4D,0x45
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,LOW(_sf_resume),HIGH(_sf_resume),0x56,0x4F,0x4C,0x54,0x41
	.DB  0x47,0x45,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,LOW(_sf_voltages),HIGH(_sf_voltages),0x43,0x55,0x52,0x52
	.DB  0x45,0x4E,0x54,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,LOW(_sf_currents),HIGH(_sf_currents),0x50,0x4F,0x57
	.DB  0x45,0x52,0x46,0x41,0x43,0x54,0x4F,0x52
	.DB  0x0,0x0,0x0,0x0,LOW(_sf_powerfactors),HIGH(_sf_powerfactors),0x50,0x4F
	.DB  0x57,0x45,0x52,0x20,0x41,0x43,0x54,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,LOW(_sf_powers_act),HIGH(_sf_powers_act),0x50
	.DB  0x4F,0x57,0x45,0x52,0x20,0x41,0x50,0x50
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,LOW(_sf_powers_app),HIGH(_sf_powers_app)
	.DB  0x45,0x4E,0x45,0x52,0x47,0x59,0x20,0x41
	.DB  0x43,0x54,0x0,0x0,0x0,0x0,0x0,LOW(_sf_energies_act)
	.DB  HIGH(_sf_energies_act),0x45,0x4E,0x45,0x52,0x47,0x59,0x20
	.DB  0x41,0x50,0x50,0x0,0x0,0x0,0x0,0x0
	.DB  LOW(_sf_energies_app),HIGH(_sf_energies_app)
_LOGO_KNUERR_G007:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x80,0x80,0xC0,0x60,0x60,0x30,0x18,0x1C
	.DB  0x18,0x30,0x60,0x60,0xC0,0x80,0x80,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0xE0,0x70,0x38,0x3C,0x1E,0x1F
	.DB  0x1F,0x9F,0xC,0xC,0xE,0xE,0xFE,0xFE
	.DB  0xFE,0xE,0xE,0xC,0xC,0x9F,0x1F,0x1F
	.DB  0x1E,0x3C,0x38,0x70,0xE0,0x80,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0xF0,0xFE
	.DB  0xFF,0x7,0x0,0x0,0x0,0xF8,0xFE,0xFF
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0xFF,0xFF
	.DB  0xFF,0x0,0x0,0x0,0x0,0x0,0x1,0xFF
	.DB  0xFE,0xF8,0x0,0x0,0x0,0x7,0xFF,0xFE
	.DB  0xF0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x3
	.DB  0xF,0x3E,0x78,0xF0,0xE0,0xE0,0xC7,0x8F
	.DB  0x8E,0x90,0x0,0x0,0x0,0x0,0xFF,0xFF
	.DB  0xFF,0x0,0x0,0x0,0x0,0x90,0x8E,0x8F
	.DB  0xC7,0xE0,0xE0,0xF0,0x78,0x3E,0xF,0x3
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x7,0x7F,0xFF,0xF1
	.DB  0x1,0x3,0x3,0x3,0x3,0x3,0x3,0x7
	.DB  0x3,0x3,0x3,0x3,0x3,0x3,0x1,0xF1
	.DB  0xFF,0x7F,0x7,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xF0,0xF8,0xFC,0x3E,0xE,0xF
	.DB  0x7,0x7,0x7,0x7,0xE,0x3E,0xFC,0xF8
	.DB  0xE0,0xC0,0xE0,0xE0,0xE0,0x70,0x7F,0x7F
	.DB  0x70,0x60,0xE0,0xC0,0xC0,0xC0,0xC0,0xC0
	.DB  0xC0,0xC0,0xC0,0xC0,0xE0,0x60,0x70,0x7F
	.DB  0x7F,0x70,0xE0,0xE0,0xE0,0xC0,0xE0,0xF8
	.DB  0xFC,0x3E,0xE,0x7,0x7,0x7,0x7,0xF
	.DB  0xE,0x3E,0xFC,0xF8,0xF0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1F,0x1F
	.DB  0x3F,0x39,0x70,0x70,0xE0,0xE0,0xE0,0xC0
	.DB  0xC0,0x80,0x80,0x0,0x0,0x1,0x1,0x1
	.DB  0x1,0x1,0x0,0x0,0x80,0x80,0xC0,0xC0
	.DB  0xE0,0xE0,0xE0,0x70,0x70,0x39,0x3F,0x1F
	.DB  0x1F,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x3,0x3,0x7,0x7,0x7,0xE,0xC,0x1C
	.DB  0xC,0xE,0x7,0x7,0x7,0x3,0x3,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_FontLookup_Extended_G007:
	.DB  0x0,0x7,0x5,0x7,0x0
_FontLookup_G007:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x2F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0xC4,0xC8,0x10,0x26,0x46,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x0,0x50,0x30
	.DB  0x0,0x10,0x10,0x10,0x10,0x10,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x59,0x51,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x7A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x55,0x2A,0x55,0x2A
	.DB  0x55,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44

_0x0:
	.DB  0xA,0x23,0x20,0x48,0x57,0x3A,0x20,0x0
	.DB  0x43,0x6F,0x6D,0x6D,0x4D,0x6F,0x64,0x75
	.DB  0x6C,0x0,0x20,0x76,0x0,0x31,0x2E,0x31
	.DB  0x30,0x0,0xA,0x23,0x20,0x53,0x57,0x3A
	.DB  0x20,0x0,0x54,0x65,0x73,0x74,0x48,0x77
	.DB  0x0,0x31,0x2E,0x30,0x30,0x0,0xA,0x49
	.DB  0x3A,0x20,0x53,0x79,0x73,0x74,0x65,0x6D
	.DB  0x20,0x73,0x74,0x61,0x72,0x74,0x2E,0x2E
	.DB  0x0,0xA,0x49,0x3A,0x31,0x2E,0x62,0x79
	.DB  0x74,0x65,0x20,0x25,0x78,0x0,0xA,0x49
	.DB  0x3A,0x32,0x2E,0x62,0x79,0x74,0x65,0x20
	.DB  0x25,0x78,0x0,0xA,0x49,0x3A,0x33,0x2E
	.DB  0x62,0x79,0x74,0x65,0x20,0x25,0x78,0x0
	.DB  0xA,0x49,0x3A,0x34,0x2E,0x62,0x79,0x74
	.DB  0x65,0x20,0x25,0x78,0x0,0xA,0x49,0x3A
	.DB  0x35,0x2E,0x62,0x79,0x74,0x65,0x20,0x25
	.DB  0x78,0x0,0xA,0x49,0x3A,0x36,0x2E,0x62
	.DB  0x79,0x74,0x65,0x20,0x25,0x78,0x0,0xA
	.DB  0x49,0x3A,0x37,0x2E,0x62,0x79,0x74,0x65
	.DB  0x20,0x25,0x78,0x0,0xA,0x49,0x3A,0x38
	.DB  0x2E,0x62,0x79,0x74,0x65,0x20,0x25,0x78
	.DB  0x0,0xA,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x0
	.DB  0xA,0x45,0x45,0x3A,0x20,0x6E,0x65,0x6A
	.DB  0x73,0x65,0x6D,0x20,0x72,0x65,0x61,0x64
	.DB  0x79,0x20,0x25,0x78,0x0,0xA,0x45,0x45
	.DB  0x3A,0x20,0x73,0x70,0x61,0x74,0x6E,0x61
	.DB  0x20,0x61,0x64,0x72,0x65,0x73,0x61,0x0
	.DB  0xA,0x45,0x45,0x3A,0x20,0x73,0x70,0x61
	.DB  0x74,0x6E,0x65,0x6A,0x20,0x7A,0x61,0x63
	.DB  0x61,0x74,0x65,0x6B,0x0
_0x20000:
	.DB  0xA,0x63,0x72,0x65,0x61,0x74,0x65,0x20
	.DB  0x70,0x72,0x6F,0x63,0x65,0x73,0x73,0x20
	.DB  0x6E,0x72,0x2E,0x25,0x64,0x20,0x2E,0x2E
	.DB  0x0
_0xE0000:
	.DB  0x49,0x6E,0x69,0x63,0x69,0x61,0x6C,0x69
	.DB  0x7A,0x61,0x63,0x65,0x20,0x4F,0x4B,0x0
	.DB  0x66,0x72,0x65,0x6B,0x76,0x65,0x6E,0x63
	.DB  0x65,0x3A,0x20,0x20,0x25,0x64,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x4E,0x65,0x6A
	.DB  0x73,0x65,0x6D,0x20,0x70,0x6F,0x76,0x69
	.DB  0x6E,0x65,0x6E,0x20,0x62,0xFD,0x74,0x20
	.DB  0x74,0x61,0x6B,0x6F,0x76,0xFD,0x2C,0x20
	.DB  0x6A,0x61,0x6B,0xFD,0x20,0x62,0x79,0x63
	.DB  0x68,0x20,0x70,0x6F,0x64,0x6C,0x65,0x20
	.DB  0x6F,0x73,0x74,0x61,0x74,0x6E,0xED,0x63
	.DB  0x68,0x20,0x6C,0x69,0x64,0xED,0x20,0x6D
	.DB  0xEC,0x6C,0x20,0x62,0xFD,0x74,0x2E,0x20
	.DB  0x4A,0x65,0x20,0x74,0x6F,0x20,0x6A,0x65
	.DB  0x6A,0x69,0x63,0x68,0x20,0x6F,0x6D,0x79
	.DB  0x6C,0x2C,0x20,0x61,0x20,0x6E,0x65,0x20
	.DB  0x6D,0x6F,0x6A,0x65,0x20,0x73,0x65,0x6C
	.DB  0x68,0xE1,0x6E,0xED,0x20,0x2D,0x20,0x52
	.DB  0x69,0x63,0x68,0x61,0x72,0x64,0x20,0x46
	.DB  0x65,0x79,0x6E,0x6D,0x61,0x6E,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x25,0x75,0x2F,0x25,0x75,0x0
_0x120000:
	.DB  0xA,0x45,0x3A,0x20,0x77,0x72,0x69,0x74
	.DB  0x65,0x20,0x77,0x61,0x73,0x6E,0x74,0x20
	.DB  0x73,0x75,0x63,0x63,0x65,0x73,0x66,0x75
	.DB  0x6C,0x6C,0x0,0xA,0x45,0x3A,0x20,0x77
	.DB  0x72,0x6F,0x6E,0x67,0x20,0x6F,0x70,0x65
	.DB  0x72,0x61,0x74,0x69,0x6F,0x6E,0x20,0x28
	.DB  0x72,0x65,0x61,0x64,0x2F,0x77,0x72,0x69
	.DB  0x74,0x65,0x29,0x0,0xA,0x45,0x3A,0x67
	.DB  0x6F,0x6F,0x64,0x2C,0x20,0x6E,0x65,0x78
	.DB  0x74,0x20,0x73,0x74,0x65,0x70,0x20,0x30
	.DB  0x78,0x25,0x78,0x0,0xA,0x45,0x3A,0x77
	.DB  0x72,0x6F,0x6E,0x67,0x2C,0x20,0x6F,0x6E
	.DB  0x63,0x65,0x20,0x61,0x67,0x61,0x69,0x6E
	.DB  0x0,0xA,0x45,0x3A,0x20,0x77,0x72,0x69
	.DB  0x74,0x65,0x20,0x66,0x61,0x69,0x6C,0x65
	.DB  0x64,0x21,0x0,0xA,0x45,0x3A,0x20,0x53
	.DB  0x59,0x4E,0x43,0x28,0x33,0x2E,0x62,0x79
	.DB  0x74,0x65,0x29,0x20,0x3A,0x20,0x25,0x78
	.DB  0x0,0xA,0x45,0x3A,0x20,0x41,0x44,0x44
	.DB  0x52,0x45,0x53,0x53,0x20,0x28,0x32,0x2E
	.DB  0x62,0x79,0x74,0x65,0x29,0x0
_0x140000:
	.DB  0xA,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x0,0xA,0x6D
	.DB  0x65,0x73,0x73,0x6D,0x6F,0x64,0x75,0x6C
	.DB  0x20,0x6E,0x72,0x2E,0x25,0x75,0x0,0xA
	.DB  0x74,0x65,0x6D,0x70,0x65,0x72,0x61,0x74
	.DB  0x75,0x72,0x65,0x3A,0x20,0x25,0x64,0x2E
	.DB  0x25,0x64,0xB0,0x43,0x0,0xA,0x70,0x66
	.DB  0x3A,0x20,0x25,0x6C,0x64,0x20,0x7C,0x20
	.DB  0x25,0x6C,0x64,0x20,0x7C,0x20,0x25,0x6C
	.DB  0x64,0x0
_0x160004:
	.DB  LOW(_0x160003),HIGH(_0x160003),LOW(_0x160003+23),HIGH(_0x160003+23),LOW(_0x160003+46),HIGH(_0x160003+46),LOW(_0x160003+69),HIGH(_0x160003+69)
	.DB  LOW(_0x160003+92),HIGH(_0x160003+92),LOW(_0x160003+115),HIGH(_0x160003+115),LOW(_0x160003+138),HIGH(_0x160003+138),LOW(_0x160003+161),HIGH(_0x160003+161)
_0x160000:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0
_0x180000:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x25,0x75
	.DB  0x2F,0x25,0x75,0x0,0x20,0x48,0x57,0x20
	.DB  0x76,0x65,0x72,0x2E,0x3A,0x20,0x0,0x31
	.DB  0x2E,0x31,0x30,0x0,0x20,0x53,0x57,0x20
	.DB  0x76,0x65,0x72,0x2E,0x3A,0x20,0x0,0x31
	.DB  0x2E,0x30,0x30,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x41,0x76
	.DB  0x61,0x69,0x6C,0x61,0x62,0x6C,0x65,0x3A
	.DB  0x20,0x25,0x75,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x53,0x65
	.DB  0x6C,0x65,0x63,0x74,0x65,0x64,0x3A,0x20
	.DB  0x4D,0x25,0x75,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x55,0x20,0x6C,0x69,0x6E
	.DB  0x65,0x73,0x3A,0x20,0x25,0x75,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x49,0x20,0x6C,0x69,0x6E,0x65,0x73
	.DB  0x3A,0x20,0x25,0x75,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x46,0x72,0x65,0x71,0x75,0x65
	.DB  0x6E,0x63,0x65,0x3A,0x20,0x25,0x75,0x2E
	.DB  0x25,0x75,0x20,0x48,0x7A,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x54,0x65,0x6D
	.DB  0x70,0x65,0x72,0x61,0x74,0x75,0x72,0x65
	.DB  0x3A,0x20,0x25,0x75,0x2E,0x25,0x75,0xB0
	.DB  0x43,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x25,0x36,0x6C,0x75,0x2C,0x20,0x25
	.DB  0x75,0x2E,0x25,0x75,0x20,0x5B,0x56,0x5D
	.DB  0x20,0x20,0x20,0x4D,0x25,0x75,0x20,0x20
	.DB  0x0,0x20,0x25,0x36,0x6C,0x75,0x2C,0x20
	.DB  0x25,0x75,0x2E,0x25,0x30,0x32,0x75,0x20
	.DB  0x5B,0x41,0x5D,0x20,0x4D,0x25,0x75,0x20
	.DB  0x20,0x0,0x20,0x4C,0x25,0x75,0x3A,0x20
	.DB  0x25,0x6C,0x64,0x2E,0x25,0x64,0x20,0x5B
	.DB  0x57,0x5D,0x20,0x7C,0x20,0x25,0x6C,0x64
	.DB  0x2E,0x25,0x64,0x20,0x5B,0x56,0x41,0x5D
	.DB  0x0,0x20,0x25,0x36,0x6C,0x64,0x2C,0x20
	.DB  0x25,0x6C,0x64,0x2E,0x25,0x64,0x20,0x5B
	.DB  0x57,0x5D,0x20,0x4D,0x25,0x75,0x20,0x20
	.DB  0x0,0x20,0x25,0x36,0x6C,0x64,0x2C,0x20
	.DB  0x25,0x33,0x6C,0x64,0x20,0x5B,0x57,0x68
	.DB  0x5D,0x20,0x4D,0x25,0x75,0x20,0x0,0x20
	.DB  0x25,0x36,0x6C,0x64,0x2C,0x20,0x25,0x36
	.DB  0x6C,0x64,0x20,0x4D,0x25,0x75,0x20,0x20
	.DB  0x0
_0x1A0003:
	.DB  0x1
_0x1A0004:
	.DB  0x1
_0x1A000B:
	.DB  0x1
_0x1A000C:
	.DB  0x1
_0x1A0000:
	.DB  0xA,0x2D,0x0,0xA,0x2B,0x0,0xA,0x49
	.DB  0x3A,0x62,0x75,0x74,0x74,0x6F,0x6E,0x73
	.DB  0x3A,0x20,0x6C,0x6F,0x6E,0x67,0x20,0x70
	.DB  0x72,0x65,0x73,0x73,0x0,0xA,0x49,0x3A
	.DB  0x62,0x75,0x74,0x74,0x6F,0x6E,0x73,0x3A
	.DB  0x20,0x73,0x68,0x6F,0x72,0x74,0x20,0x70
	.DB  0x72,0x65,0x73,0x73,0x0
_0x1E0000:
	.DB  0xA,0x49,0x3A,0x20,0x50,0x72,0x69,0x6A
	.DB  0x6D,0x75,0x74,0x20,0x73,0x74,0x72,0x69
	.DB  0x6E,0x67,0x3A,0x20,0x0,0xA,0x45,0x3A
	.DB  0x20,0x4E,0x65,0x64,0x6F,0x73,0x74,0x61
	.DB  0x74,0x65,0x63,0x6E,0x79,0x20,0x62,0x75
	.DB  0x66,0x66,0x65,0x72,0x2C,0x20,0x73,0x74
	.DB  0x72,0x69,0x6E,0x67,0x3A,0x0
_0x240005:
	.DB  0x1
_0x240006:
	.DB  0x1
_0x240000:
	.DB  0xA,0x49,0x3A,0x20,0x53,0x65,0x6E,0x64
	.DB  0x42,0x75,0x66,0x66,0x65,0x72,0x66,0x28
	.DB  0x29,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x17
	.DW  _0x160003
	.DW  _0x160000*2

	.DW  0x17
	.DW  _0x160003+23
	.DW  _0x160000*2

	.DW  0x17
	.DW  _0x160003+46
	.DW  _0x160000*2

	.DW  0x17
	.DW  _0x160003+69
	.DW  _0x160000*2

	.DW  0x17
	.DW  _0x160003+92
	.DW  _0x160000*2

	.DW  0x17
	.DW  _0x160003+115
	.DW  _0x160000*2

	.DW  0x17
	.DW  _0x160003+138
	.DW  _0x160000*2

	.DW  0x17
	.DW  _0x160003+161
	.DW  _0x160000*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;
;
;  /*****************************************************
;Chip type               : ATmega324PA
;Program type            : Application
;AVR Core Clock frequency: 11,0592 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <delay.h>
;#include <uknos.h>    //110B
;#include <uart2.h>    //124B
;#include <my_spi.h>
;
;
;#include <messmodules.h>     //read and save all usefulldata from MAXIM to the structure
;#include <display_manager.h> //users screeen in display_screens.c
;#include "leds_manager.h"
;#include "buttons_manager.h"
;#include "comm_terminal.h"
;#include "comm_xport.h"
;
;void HW_init(void);
;
;void main(void){
; 0000 001D void main(void){

	.CSEG
_main:
; 0000 001E 
; 0000 001F   /* HW Inits */
; 0000 0020   HW_init();
	RCALL _HW_init
; 0000 0021   Leds_Init();
	CALL _Leds_Init
; 0000 0022   Buttons_init();
	CALL _Buttons_init
; 0000 0023 
; 0000 0024   /* SW Inits */
; 0000 0025   //uart
; 0000 0026   //CommTerminal_Init(); //init ports, registers, baudrate, RX handler
; 0000 0027   CommXport_Init(); //init ports, registers, baudrate, RX handler
	CALL _CommXport_Init
; 0000 0028 
; 0000 0029   //spi
; 0000 002A   Messmodul_Init();
	CALL _Messmodul_Init
; 0000 002B   Display_Init();
	CALL _Display_Init
; 0000 002C 
; 0000 002D   DISABLE_INTERRUPT //some Inits can enable interrupt
	cli
; 0000 002E 
; 0000 002F   delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0030 
; 0000 0031   /* KERNEL Init */
; 0000 0032   uKnos_Init();
	RCALL _uKnos_Init
; 0000 0033 
; 0000 0034 
; 0000 0035 
; 0000 0036   //******************************************
; 0000 0037   // PROCESSES
; 0000 0038   // - period in miliseconds, shortest period is 10ms
; 0000 0039   //******************************************
; 0000 003A 
; 0000 003B   Create_Process( 3000, CommXport_Manager);  // zpracovava buffer naplneny v preruseni
	__GETD1N 0xBB8
	CALL __PUTPARD1
	LDI  R30,LOW(_CommXport_Manager)
	LDI  R31,HIGH(_CommXport_Manager)
	CALL SUBOPT_0x0
; 0000 003C   Create_Process( 250,  Messmodul_Manager);  // read and save data from MAXIM
	__GETD1N 0xFA
	CALL __PUTPARD1
	LDI  R30,LOW(_Messmodul_Manager)
	LDI  R31,HIGH(_Messmodul_Manager)
	CALL SUBOPT_0x0
; 0000 003D   Create_Process(  30,  Buttons_manager);    // obsluha tlacitek
	__GETD1N 0x1E
	CALL __PUTPARD1
	LDI  R30,LOW(_Buttons_manager)
	LDI  R31,HIGH(_Buttons_manager)
	CALL SUBOPT_0x0
; 0000 003E   Create_Process( 500,  Display_Manager);    // obsluha dipleje
	__GETD1N 0x1F4
	CALL __PUTPARD1
	LDI  R30,LOW(_Display_Manager)
	LDI  R31,HIGH(_Display_Manager)
	CALL SUBOPT_0x0
; 0000 003F   Create_Process( 1000, Leds_Manager);       // obsluha led
	__GETD1N 0x3E8
	CALL __PUTPARD1
	LDI  R30,LOW(_Leds_Manager)
	LDI  R31,HIGH(_Leds_Manager)
	CALL SUBOPT_0x0
; 0000 0040   //Create_Process( 100, CommTerminal_Manager); //zpracovava buffer naplneny prijmutymi znaky
; 0000 0041 
; 0000 0042   //delay before uart output
; 0000 0043   delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0044 
; 0000 0045   //print messages
; 0000 0046   uartSendBufferf(0, STRING_START_MESSAGE);  //start message
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_STRING_START_MESSAGE*2)
	LDI  R31,HIGH(_STRING_START_MESSAGE*2)
	CALL SUBOPT_0x1
; 0000 0047   uartSendBufferf(0, "\n# HW: "); uartSendBufferf(0, HW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, HW_VERSION_S); //version
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,8
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,21
	CALL SUBOPT_0x1
; 0000 0048   uartSendBufferf(0, "\n# SW: "); uartSendBufferf(0, SW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, SW_VERSION_S); //version
	__POINTW1FN _0x0,26
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x1
; 0000 0049   uartSendBufferf(0, STRING_SEPARATOR);
	LDI  R30,LOW(_STRING_SEPARATOR*2)
	LDI  R31,HIGH(_STRING_SEPARATOR*2)
	CALL SUBOPT_0x2
; 0000 004A 
; 0000 004B   //Start uKnos
; 0000 004C   uKnos_Start(); //enable interrupt
	RCALL _uKnos_Start
; 0000 004D   uartSendBufferf(0,"\nI: System start..");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x0,46
	CALL SUBOPT_0x2
; 0000 004E 
; 0000 004F while (1){
_0x3:
; 0000 0050 
; 0000 0051     //printf(".");
; 0000 0052     //Messmodul_Rest();  //vypisy
; 0000 0053 
; 0000 0054 } //end of while
	RJMP _0x3
; 0000 0055 } //end of main
_0x6:
	RJMP _0x6
;
;void getR(){
; 0000 0057 void getR(){
; 0000 0058     byte aux_data;
; 0000 0059     aux_data = SPI_MasterTransmit(0x38);
;	aux_data -> R17
; 0000 005A     if(aux_data == 0xc1){
; 0000 005B         delay_ms(10);
; 0000 005C         aux_data = SPI_MasterTransmit(0x31);
; 0000 005D         if(aux_data == 0xc2){
; 0000 005E             delay_ms(50);
; 0000 005F             aux_data = SPI_MasterTransmit(0x00);
; 0000 0060             delay_ms(10);
; 0000 0061             aux_data = SPI_MasterTransmit(0x00);
; 0000 0062             if(aux_data == 0x41){
; 0000 0063                 delay_ms(10);
; 0000 0064                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0065                 printf("\nI:1.byte %x", aux_data);
; 0000 0066                 delay_ms(10);
; 0000 0067                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0068                 printf("\nI:2.byte %x", aux_data);
; 0000 0069                 delay_ms(10);
; 0000 006A                 aux_data = SPI_MasterTransmit(0x00);
; 0000 006B                 printf("\nI:3.byte %x", aux_data);
; 0000 006C                 delay_ms(10);
; 0000 006D                 aux_data = SPI_MasterTransmit(0x00);
; 0000 006E                 printf("\nI:4.byte %x", aux_data);
; 0000 006F                 delay_ms(10);
; 0000 0070                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0071                 printf("\nI:5.byte %x", aux_data);
; 0000 0072                 delay_ms(10);
; 0000 0073                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0074                 printf("\nI:6.byte %x", aux_data);
; 0000 0075                 delay_ms(10);
; 0000 0076                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0077                 printf("\nI:7.byte %x", aux_data);
; 0000 0078                 delay_ms(10);
; 0000 0079                 aux_data = SPI_MasterTransmit(0x00);
; 0000 007A                 printf("\nI:8.byte %x", aux_data);
; 0000 007B                 printf("\n=============================================");
; 0000 007C             }
; 0000 007D             else
; 0000 007E                 printf("\nEE: nejsem ready %x",aux_data);
; 0000 007F 
; 0000 0080         }
; 0000 0081         else
; 0000 0082             printf("\nEE: spatna adresa");
; 0000 0083     }
; 0000 0084     else
; 0000 0085         printf("\nEE: spatnej zacatek");
; 0000 0086 }
;
;//**************************************************************************
;// Nastaveni MCU
;//**************************************************************************
;void HW_init(void)
; 0000 008C {
_HW_init:
; 0000 008D     // Crystal Oscillator division factor: 1
; 0000 008E     #pragma optsize-
; 0000 008F     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0090     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0091     #ifdef _OPTIMIZE_SIZE_
; 0000 0092     #pragma optsize+
; 0000 0093     #endif
; 0000 0094 
; 0000 0095     // Input/Output Ports initialization
; 0000 0096     // Port A initialization
; 0000 0097     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0098     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0099     PORTA=0x00;
	OUT  0x2,R30
; 0000 009A     DDRA=0x00;
	OUT  0x1,R30
; 0000 009B 
; 0000 009C     // Port B initialization
; 0000 009D     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009E     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009F     PORTB=0x00;
	OUT  0x5,R30
; 0000 00A0     DDRB=0x00;
	OUT  0x4,R30
; 0000 00A1 
; 0000 00A2     // Port C initialization
; 0000 00A3     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A4     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A5     PORTC=0x00;
	OUT  0x8,R30
; 0000 00A6     DDRC=0x00;
	OUT  0x7,R30
; 0000 00A7 
; 0000 00A8     // Port D initialization
; 0000 00A9     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AA     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AB     PORTD=0x00;
	OUT  0xB,R30
; 0000 00AC     DDRD=0x00;
	OUT  0xA,R30
; 0000 00AD 
; 0000 00AE     // Timer/Counter 0 initialization
; 0000 00AF     // Clock source: System Clock
; 0000 00B0     // Clock value: Timer 0 Stopped
; 0000 00B1     // Mode: Normal top=FFh
; 0000 00B2     // OC0A output: Disconnected
; 0000 00B3     // OC0B output: Disconnected
; 0000 00B4     TCCR0A=0x00;
	OUT  0x24,R30
; 0000 00B5     TCCR0B=0x00;
	OUT  0x25,R30
; 0000 00B6     TCNT0=0x00;
	OUT  0x26,R30
; 0000 00B7     OCR0A=0x00;
	OUT  0x27,R30
; 0000 00B8     OCR0B=0x00;
	OUT  0x28,R30
; 0000 00B9 
; 0000 00BA     // Timer/Counter 1 initialization
; 0000 00BB     // Clock source: System Clock
; 0000 00BC     // Clock value: Timer1 Stopped
; 0000 00BD     // Mode: Normal top=FFFFh
; 0000 00BE     // OC1A output: Discon.
; 0000 00BF     // OC1B output: Discon.
; 0000 00C0     // Noise Canceler: Off
; 0000 00C1     // Input Capture on Falling Edge
; 0000 00C2     // Timer1 Overflow Interrupt: Off
; 0000 00C3     // Input Capture Interrupt: Off
; 0000 00C4     // Compare A Match Interrupt: Off
; 0000 00C5     // Compare B Match Interrupt: Off
; 0000 00C6     TCCR1A=0x00;
	STS  128,R30
; 0000 00C7     TCCR1B=0x00;
	STS  129,R30
; 0000 00C8     TCNT1H=0x00;
	STS  133,R30
; 0000 00C9     TCNT1L=0x00;
	STS  132,R30
; 0000 00CA     ICR1H=0x00;
	STS  135,R30
; 0000 00CB     ICR1L=0x00;
	STS  134,R30
; 0000 00CC     OCR1AH=0x00;
	STS  137,R30
; 0000 00CD     OCR1AL=0x00;
	STS  136,R30
; 0000 00CE     OCR1BH=0x00;
	STS  139,R30
; 0000 00CF     OCR1BL=0x00;
	STS  138,R30
; 0000 00D0 
; 0000 00D1     // Timer/Counter 2 initialization
; 0000 00D2     // Clock source: System Clock
; 0000 00D3     // Clock value: Timer2 Stopped
; 0000 00D4     // Mode: Normal top=FFh
; 0000 00D5     // OC2A output: Disconnected
; 0000 00D6     // OC2B output: Disconnected
; 0000 00D7     ASSR=0x00;
	STS  182,R30
; 0000 00D8     TCCR2A=0x00;
	STS  176,R30
; 0000 00D9     TCCR2B=0x00;
	STS  177,R30
; 0000 00DA     TCNT2=0x00;
	STS  178,R30
; 0000 00DB     OCR2A=0x00;
	STS  179,R30
; 0000 00DC     OCR2B=0x00;
	STS  180,R30
; 0000 00DD 
; 0000 00DE     // External Interrupt(s) initialization
; 0000 00DF     // INT0: Off
; 0000 00E0     // INT1: Off
; 0000 00E1     // INT2: Off
; 0000 00E2     // Interrupt on any change on pins PCINT0-7: Off
; 0000 00E3     // Interrupt on any change on pins PCINT8-15: Off
; 0000 00E4     // Interrupt on any change on pins PCINT16-23: Off
; 0000 00E5     // Interrupt on any change on pins PCINT24-31: Off
; 0000 00E6     EICRA=0x00;
	STS  105,R30
; 0000 00E7     EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00E8     PCICR=0x00;
	STS  104,R30
; 0000 00E9 
; 0000 00EA     // Timer/Counter 0 Interrupt(s) initialization
; 0000 00EB     TIMSK0=0x00;
	STS  110,R30
; 0000 00EC     // Timer/Counter 1 Interrupt(s) initialization
; 0000 00ED     TIMSK1=0x00;
	STS  111,R30
; 0000 00EE     // Timer/Counter 2 Interrupt(s) initialization
; 0000 00EF     TIMSK2=0x00;
	STS  112,R30
; 0000 00F0 
; 0000 00F1     // USART0 initialization
; 0000 00F2     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00F3     // USART0 Receiver: Off
; 0000 00F4     // USART0 Transmitter: On
; 0000 00F5     // USART0 Mode: Asynchronous
; 0000 00F6     // USART0 Baud Rate: 9600
; 0000 00F7     UCSR0A=0x00;
	STS  192,R30
; 0000 00F8     UCSR0B=0x08;
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 00F9     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00FA     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00FB     UBRR0L=0x05; //0x47;
	LDI  R30,LOW(5)
	STS  196,R30
; 0000 00FC 
; 0000 00FD     // Analog Comparator initialization
; 0000 00FE     // Analog Comparator: Off
; 0000 00FF     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0100     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0101     ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0102 }
	RET
;//**********************************************************************************************
;// uKNOS - micro Knuerr operating system
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// Version     :   1.0
;//*****************************************************************
;// Description :
;//    uKnos slouzi k periodickemu volani uzivatelskych funci -> procesu.
;//    Zakladni casova zakladna je 1 mS.
;//    Preruseni uvnitr procesu jsou zejmena kvuli komunikacim povolene.(default)
;//*****************************************************************
;// Memory Management  :
;//    RAM    :   110 Bytes
;//    FLASH  :     X Bytes
;//*****************************************************************
;
;#include <types.h>
;#include <stdio.h>
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <uknos.h>
;
;
;//GLOBAL VARIABLES
;tKernel sKernel;
;tProcess sProcess[PROCESS_MAX];    // tabulka procesu
;
;//LOCAL VARIABLES
;typedef enum{
;  PROCESS_FREE,     //prazdny proces bez prirazene funkce
;  PROCESS_STANDBY,  //proces ceka na zavolani
;  PROCESS_BUSSY     //proces se prave vykonava
;}ePROCESS_STATE;
;
;
;//*****************************************************************************
;// INIT 10 MILISECOND INTERRUPT, CTC MODE
;//*****************************************************************************
;// 11,0592MHZ
;void uKnos_Init(){
; 0001 0027 void uKnos_Init(){

	.CSEG
_uKnos_Init:
; 0001 0028     byte i;
; 0001 0029     // Timer/Counter 0 initialization
; 0001 002A     // Clock source: System Clock
; 0001 002B     // Clock value: 10,800 kHz
; 0001 002C     // Mode: CTC top=OCR0A
; 0001 002D     TCCR0A = 0x02;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(2)
	OUT  0x24,R30
; 0001 002E     TCCR0B = 0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0001 002F     TCNT0  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0001 0030     OCR0A  = 0x6C - 1;   // 0x6C=108; //prescaler timeru je 1024!
	LDI  R30,LOW(107)
	OUT  0x27,R30
; 0001 0031     OCR0B  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0001 0032 
; 0001 0033     // Timer/Counter 0 Interrupt(s) initialization
; 0001 0034     TIMSK0=0x02;  //compare match
	LDI  R30,LOW(2)
	STS  110,R30
; 0001 0035 
; 0001 0036     sKernel.delay_after_start = DELAY_AFTER_START / 10;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _sKernel,R30
	STS  _sKernel+1,R31
; 0001 0037 
; 0001 0038     for (i = 0; i < PROCESS_MAX; i++) {
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,10
	BRSH _0x20005
; 0001 0039         sProcess[i].state = PROCESS_FREE;   //proces volny
	CALL SUBOPT_0x3
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0001 003A     }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 003B }
	LD   R17,Y+
	RET
;
;void uKnos_Start(){
; 0001 003D void uKnos_Start(){
_uKnos_Start:
; 0001 003E     #asm("sei")
	sei
; 0001 003F }
	RET
;
;//*****************************************************************************
;// Funkce pro vytvoreni periodicky volane funkce -> procesu
;// dword period - perioda volani funkce v ms
;// flash dword *function - adresa funkce, ktera ma byt volana
;//*****************************************************************************
;void Create_Process(dword period,  void (*function)(void)){
; 0001 0046 void Create_Process(dword period,  void (*function)(void)){
_Create_Process:
; 0001 0047   byte i;
; 0001 0048   tProcess *p_aux_process;
; 0001 0049 
; 0001 004A   for (i = 0; i < PROCESS_MAX; i++) {
	CALL __SAVELOCR4
;	period -> Y+6
;	*function -> Y+4
;	i -> R17
;	*p_aux_process -> R18,R19
	LDI  R17,LOW(0)
_0x20007:
	CPI  R17,10
	BRSH _0x20008
; 0001 004B     p_aux_process = &sProcess[i];
	CALL SUBOPT_0x3
	MOVW R18,R30
; 0001 004C     if (p_aux_process->state == PROCESS_FREE) {   // pokud je proces volny
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	BRNE _0x20009
; 0001 004D       p_aux_process->state = PROCESS_STANDBY;
	LDI  R30,LOW(1)
	ST   X,R30
; 0001 004E       p_aux_process->function = function;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTW1RNS 18,1
; 0001 004F       if (period < 10)
	CALL SUBOPT_0x4
	BRSH _0x2000A
; 0001 0050         period = 10;
	CALL SUBOPT_0x5
	__PUTD1S 6
; 0001 0051       p_aux_process->period = ((period<10)? 1 : period/10);
_0x2000A:
	CALL SUBOPT_0x4
	BRSH _0x2000B
	__GETD1N 0x1
	RJMP _0x2000C
_0x2000B:
	CALL SUBOPT_0x6
_0x2000C:
	__PUTD1RNS 18,3
; 0001 0052       p_aux_process->counter =((period<10)? 1 : period/10);
	CALL SUBOPT_0x4
	BRSH _0x2000E
	__GETD1N 0x1
	RJMP _0x2000F
_0x2000E:
	CALL SUBOPT_0x6
_0x2000F:
	__PUTD1RNS 18,7
; 0001 0053       printf("\ncreate process nr.%d ..",i);
	__POINTW1FN _0x20000,0
	CALL SUBOPT_0x7
; 0001 0054       return;
	RJMP _0x20A0011
; 0001 0055     }
; 0001 0056   }
_0x20009:
	SUBI R17,-1
	RJMP _0x20007
_0x20008:
; 0001 0057   // tady udelat dbg vypis nebo signalizaci chyby
; 0001 0058 }
	RJMP _0x20A0011
;
;//*****************************************************************************
;// 10 MILISECOND INTERRUPT, kde se periodicky vyvolavaji procesy
;//*****************************************************************************
;// Timer 0 output compare A interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void){
; 0001 005E interrupt [17] void timer0_compa_isr(void){
_timer0_compa_isr:
	CALL SUBOPT_0x8
; 0001 005F   byte i;
; 0001 0060   tProcess *p_aux_process;
; 0001 0061   void (*called_funcion)(void);
; 0001 0062 
; 0001 0063   // povolit vnorena preruseni
; 0001 0064   /*#ifdef ENABLE_RECURSIVE_INTERRUPT
; 0001 0065     ENABLE_INTERRUPT
; 0001 0066   #endif*/
; 0001 0067 
; 0001 0068 
; 0001 0069 
; 0001 006A   //delay after kernel start
; 0001 006B   if(sKernel.delay_after_start != 0){
	CALL __SAVELOCR6
;	i -> R17
;	*p_aux_process -> R18,R19
;	*called_funcion -> R20,R21
	LDS  R30,_sKernel
	LDS  R31,_sKernel+1
	SBIW R30,0
	BREQ _0x20011
; 0001 006C     sKernel.delay_after_start--;
	LDI  R26,LOW(_sKernel)
	LDI  R27,HIGH(_sKernel)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 006D     return;
	RJMP _0x20017
; 0001 006E   }
; 0001 006F 
; 0001 0070   TIMSK0=0x00;
_0x20011:
	LDI  R30,LOW(0)
	STS  110,R30
; 0001 0071 
; 0001 0072   // spusteni procesu
; 0001 0073   for (i = 0; i < PROCESS_MAX; i++) {   //pres vsechny procesy
	LDI  R17,LOW(0)
_0x20013:
	CPI  R17,10
	BRSH _0x20014
; 0001 0074     p_aux_process = &sProcess[i];
	CALL SUBOPT_0x3
	MOVW R18,R30
; 0001 0075     if (p_aux_process->state == PROCESS_STANDBY) {
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x20015
; 0001 0076 
; 0001 0077       if (--(p_aux_process->counter) == 0) {    // proces ma byt vyvolan
	MOVW R26,R18
	ADIW R26,7
	CALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTDP1_DEC
	CALL __CPD10
	BRNE _0x20016
; 0001 0078 
; 0001 0079         p_aux_process->state = PROCESS_BUSSY;
	MOVW R26,R18
	LDI  R30,LOW(2)
	ST   X,R30
; 0001 007A 
; 0001 007B         // zavola se odpovidajici funkce
; 0001 007C         //toDo: vyzkouset a zahodit pomocnou promennou, volat primo
; 0001 007D         //printf("\n%d s",i);
; 0001 007E         called_funcion = ( void (*)(void))p_aux_process->function;
	ADIW R26,1
	LD   R20,X+
	LD   R21,X
; 0001 007F         called_funcion();
	MOVW R30,R20
	ICALL
; 0001 0080         //printf("\n%d e",i);
; 0001 0081 
; 0001 0082 
; 0001 0083         // nastaveni periody u procesu
; 0001 0084         p_aux_process->counter = p_aux_process->period;
	MOVW R26,R18
	ADIW R26,3
	CALL __GETD1P
	__PUTD1RNS 18,7
; 0001 0085 
; 0001 0086         //uvolneni procesu pro dalsi volani
; 0001 0087         p_aux_process->state = PROCESS_STANDBY;
	MOVW R26,R18
	LDI  R30,LOW(1)
	ST   X,R30
; 0001 0088       } // if (counter == 0) end
; 0001 0089     } // if (process == PROCESS_STANDBY) end
_0x20016:
; 0001 008A   } // for cyklus end
_0x20015:
	SUBI R17,-1
	RJMP _0x20013
_0x20014:
; 0001 008B   TIMSK0=0x02;
	LDI  R30,LOW(2)
	STS  110,R30
; 0001 008C }
_0x20017:
	CALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;/*! \file uart2.c \brief Dual UART driver with buffer support. */
;//*****************************************************************************
;//
;// File Name	: 'uart2.c'
;// Title		: Dual UART driver with buffer support
;// Author		: Pascal Stang - Copyright (C) 2000-2004
;// Created		: 11/20/2000
;// Revised		: 07/04/2004
;// Version		: 1.0
;// Target MCU	: ATMEL AVR Series
;// Editor Tabs	: 4
;//
;// Description	: This is a UART driver for AVR-series processors with two
;//		hardware UARTs such as the mega161 and mega128
;//
;// This code is distributed under the GNU Public License
;//		which can be found at http://www.gnu.org/licenses/gpl.txt
;//
;//*****************************************************************************
;
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <buffer.h>
;#include <uart2.h>
;#include <digital_outputs.h>
;
;
;// UART global variables
;// flag variables
;volatile byte uartReadyTx[2];
;volatile byte uartBufferedTx[2];
;//transmit buffers
;cBuffer uartTxBuffer[2];
;unsigned short uartRxOverflow[2];
;
;// automatically allocate space in ram for each buffer
;
;static char uart0TxData[UART0_TX_BUFFER_SIZE];
;static char uart1TxData[UART1_TX_BUFFER_SIZE];
;
;
;typedef void (*voidFuncPtrbyte)(unsigned char);
;volatile static voidFuncPtrbyte UartRxFunc[2];
;
;void uartInit(byte nUart)
; 0002 002E {

	.CSEG
_uartInit:
; 0002 002F 	// initialize uarts
; 0002 0030     if(nUart)
;	nUart -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x40003
; 0002 0031         uart1Init();
	RCALL _uart1Init
; 0002 0032     else
	RJMP _0x40004
_0x40003:
; 0002 0033 	    uart0Init();
	RCALL _uart0Init
; 0002 0034 
; 0002 0035 }
_0x40004:
	JMP  _0x20A000F
;
;void uart0Init(void)
; 0002 0038 {
_uart0Init:
; 0002 0039 	// initialize the buffers
; 0002 003A 	uart0InitBuffers();
	RCALL _uart0InitBuffers
; 0002 003B 
; 0002 003C 	// initialize user receive handlers
; 0002 003D 	UartRxFunc[0] = 0;
	LDI  R30,LOW(0)
	STS  _UartRxFunc_G002,R30
	STS  _UartRxFunc_G002+1,R30
; 0002 003E 
; 0002 003F 	// enable RxD/TxD and interrupts
; 0002 0040 	UCSR0B = (1<<RXCIE) | (1<<TXCIE) | (1<<RXEN) | (1<<TXEN);
	LDI  R30,LOW(216)
	STS  193,R30
; 0002 0041 
; 0002 0042 	// set default baud rate
; 0002 0043     // uartSetBaudRate(0, UART0_DEFAULT_BAUD_RATE);
; 0002 0044 
; 0002 0045 	// initialize states
; 0002 0046 	uartReadyTx[0] = 1;
	LDI  R30,LOW(1)
	STS  _uartReadyTx,R30
; 0002 0047 	uartBufferedTx[0] = 0;
	LDI  R30,LOW(0)
	STS  _uartBufferedTx,R30
; 0002 0048 
; 0002 0049 	// clear overflow count
; 0002 004A 	uartRxOverflow[0] = 0;
	STS  _uartRxOverflow,R30
	STS  _uartRxOverflow+1,R30
; 0002 004B 
; 0002 004C 	// enable interrupts
; 0002 004D 	//#asm("sei")
; 0002 004E }
	RET
;
;void uart1Init(void)
; 0002 0051 {
_uart1Init:
; 0002 0052 	// initialize the buffers
; 0002 0053 	uart1InitBuffers();
	RCALL _uart1InitBuffers
; 0002 0054 	// initialize user receive handlers
; 0002 0055 	UartRxFunc[1] = 0;
	__POINTW1MN _UartRxFunc_G002,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0002 0056 	// enable RxD/TxD and interrupts
; 0002 0057 	UCSR1B = (1<<RXCIE) | (1<<TXCIE) | (1<<RXEN) | (1<<TXEN);
	LDI  R30,LOW(216)
	STS  201,R30
; 0002 0058 	// set default baud rate
; 0002 0059 //	uartSetBaudRate(1, UART1_DEFAULT_BAUD_RATE);
; 0002 005A 	// initialize states
; 0002 005B 	uartReadyTx[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _uartReadyTx,1
; 0002 005C 	uartBufferedTx[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _uartBufferedTx,1
; 0002 005D 	// clear overflow count
; 0002 005E 	uartRxOverflow[1] = 0;
	__POINTW1MN _uartRxOverflow,2
	STD  Z+0,R26
	STD  Z+1,R27
; 0002 005F 	// enable interrupts
; 0002 0060 	//#asm("sei")
; 0002 0061 }
	RET
;
;void uart0InitBuffers(void)
; 0002 0064 {
_uart0InitBuffers:
; 0002 0065     // initialize the UART0 buffers
; 0002 0066 	bufferInit(&uartTxBuffer[0], uart0TxData, UART0_TX_BUFFER_SIZE);
	LDI  R30,LOW(_uartTxBuffer)
	LDI  R31,HIGH(_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_uart0TxData_G002)
	LDI  R31,HIGH(_uart0TxData_G002)
	RJMP _0x20A0012
; 0002 0067 }
;
;void uart1InitBuffers(void)
; 0002 006A {
_uart1InitBuffers:
; 0002 006B 	// initialize the UART1 buffers
; 0002 006C 	bufferInit(&uartTxBuffer[1], uart1TxData, UART1_TX_BUFFER_SIZE);
	__POINTW1MN _uartTxBuffer,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_uart1TxData_G002)
	LDI  R31,HIGH(_uart1TxData_G002)
_0x20A0012:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _bufferInit
; 0002 006D }
	RET
;
;void uartSetRxHandler(byte nUart, void (*rx_func)(unsigned char c))
; 0002 0070 {
_uartSetRxHandler:
; 0002 0071 	if(nUart < 2) // make sure the uart number is within bounds
;	nUart -> Y+2
;	*rx_func -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRSH _0x40005
; 0002 0072 	{
; 0002 0073 		UartRxFunc[nUart] = rx_func; // set the receive interrupt to run the supplied user function
	LDD  R30,Y+2
	CALL SUBOPT_0x9
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0002 0074 	}
; 0002 0075 }
_0x40005:
	JMP  _0x20A000D
;
;void uartSetBaudRate(byte nUart, dword baudrate, byte double_speed_mode)
; 0002 0078 {
_uartSetBaudRate:
; 0002 0079 	word bauddiv;
; 0002 007A 	byte u2x_flag;
; 0002 007B 
; 0002 007C 	if(double_speed_mode){
	CALL __SAVELOCR4
;	nUart -> Y+9
;	baudrate -> Y+5
;	double_speed_mode -> Y+4
;	bauddiv -> R16,R17
;	u2x_flag -> R19
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x40006
; 0002 007D 		bauddiv = ((F_CPU+(baudrate*4L))/(baudrate*8L)-1); // calculate division factor for requested baud rate, and set it
	CALL SUBOPT_0xA
	CALL __LSLD1
	CALL __LSLD1
	__ADDD1N 11059200
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xC
; 0002 007E 		u2x_flag = 1;
	LDI  R19,LOW(1)
; 0002 007F 	}
; 0002 0080 	else{
	RJMP _0x40007
_0x40006:
; 0002 0081 		bauddiv = ((F_CPU+(baudrate*8L))/(baudrate*16L)-1); // calculate division factor for requested baud rate, and set it
	CALL SUBOPT_0xB
	__ADDD1N 11059200
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	__GETD2N 0x10
	CALL __MULD12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xC
; 0002 0082 		u2x_flag = 0;
	LDI  R19,LOW(0)
; 0002 0083 	}
_0x40007:
; 0002 0084 
; 0002 0085 	if(nUart)
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x40008
; 0002 0086 	{
; 0002 0087 		UBRR1L = bauddiv;
	STS  204,R16
; 0002 0088 		#ifdef UBRR1H
; 0002 0089 		UBRR1H = (bauddiv>>8);
	STS  205,R17
; 0002 008A 		#endif
; 0002 008B 		UCSR0A &= ~(1 << U2X0); 			//clear
	LDS  R30,192
	ANDI R30,0xFD
	STS  192,R30
; 0002 008C 		UCSR0A |= (u2x_flag << U2X0);		//set (if u2x_flag is set)
	LDI  R26,LOW(192)
	LDI  R27,HIGH(192)
	RJMP _0x40030
; 0002 008D 	}
; 0002 008E 	else
_0x40008:
; 0002 008F 	{
; 0002 0090 		UBRR0L = bauddiv;
	STS  196,R16
; 0002 0091 		#ifdef UBRR0H
; 0002 0092 		UBRR0H = (bauddiv>>8);
	STS  197,R17
; 0002 0093 		#endif
; 0002 0094 		UCSR1A &= ~(1 << U2X0); 			//clear
	LDS  R30,200
	ANDI R30,0xFD
	STS  200,R30
; 0002 0095 		UCSR1A |= (u2x_flag << U2X0);		//set (if u2x_flag is set)
	LDI  R26,LOW(200)
	LDI  R27,HIGH(200)
_0x40030:
	MOV  R0,R26
	LD   R26,X
	MOV  R30,R19
	LSL  R30
	OR   R30,R26
	MOV  R26,R0
	ST   X,R30
; 0002 0096 	}
; 0002 0097 }
_0x20A0011:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;
;cBuffer* uartGetTxBuffer(byte nUart)
; 0002 009A {
; 0002 009B 	return &uartTxBuffer[nUart]; // return tx buffer pointer
;	nUart -> Y+0
; 0002 009C }
;
;void uartSendByte(byte nUart, byte txData)
; 0002 009F {
_uartSendByte:
; 0002 00A0   // wait for the transmitter to be ready
; 0002 00A1   while(!uartReadyTx[nUart]);
;	nUart -> Y+1
;	txData -> Y+0
_0x4000A:
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_uartReadyTx)
	SBCI R31,HIGH(-_uartReadyTx)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x4000A
; 0002 00A2 
; 0002 00A3   //L.M. - vysilam v preruseni od prijmu
; 0002 00A4   // vyvola se znova preruseni od prijmu ale neprobehlo preruseni od vysilani kde se shazuje flag
; 0002 00A5   //uartReadyTx[nUart] = 0; // set ready state to 0
; 0002 00A6 
; 0002 00A7 	// send byte
; 0002 00A8 	if(nUart)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x4000D
; 0002 00A9 	{
; 0002 00AA 		while(!(UCSR1A & (1<<UDRE)));
_0x4000E:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x4000E
; 0002 00AB 			UDR1 = txData;
	LD   R30,Y
	STS  206,R30
; 0002 00AC 	}
; 0002 00AD 	else
	RJMP _0x40011
_0x4000D:
; 0002 00AE 	{
; 0002 00AF 		while(!(UCSR0A & (1<<UDRE)));
_0x40012:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x40012
; 0002 00B0 			UDR0 = txData;
	LD   R30,Y
	STS  198,R30
; 0002 00B1 	}
_0x40011:
; 0002 00B2 }
	JMP  _0x20A0010
;
;void uart0SendByte(u08 data)
; 0002 00B5 {
; 0002 00B6 	// send byte on UART0
; 0002 00B7 	uartSendByte(0, data);
;	data -> Y+0
; 0002 00B8 }
;
;void uart1SendByte(u08 data)
; 0002 00BB {
; 0002 00BC 	// send byte on UART1
; 0002 00BD 	uartSendByte(1, data);
;	data -> Y+0
; 0002 00BE }
;
;void uartAddToTxBuffer(byte nUart, byte data)
; 0002 00C1 {
_uartAddToTxBuffer:
; 0002 00C2 	// add data byte to the end of the tx buffer
; 0002 00C3 	bufferAddToEnd(&uartTxBuffer[nUart], data);
;	nUart -> Y+1
;	data -> Y+0
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _bufferAddToEnd
; 0002 00C4 }
	JMP  _0x20A0010
;
;void uartSendTxBuffer(byte nUart)
; 0002 00C7 {
_uartSendTxBuffer:
; 0002 00C8 	// turn on buffered transmit
; 0002 00C9 	uartBufferedTx[nUart] = 1;
;	nUart -> Y+0
	CALL SUBOPT_0xF
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0002 00CA 	// send the first byte to get things going by interrupts
; 0002 00CB 	uartSendByte(nUart, bufferGetFromFront(&uartTxBuffer[nUart]));
	LD   R30,Y
	ST   -Y,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	RCALL _bufferGetFromFront
	ST   -Y,R30
	RCALL _uartSendByte
; 0002 00CC }
	JMP  _0x20A000F
;
;byte uartSendBuffer(byte nUart, char *buffer, word nBytes)
; 0002 00CF {
; 0002 00D0 	register byte first;
; 0002 00D1 	register word i;
; 0002 00D2 
; 0002 00D3 	// check if there's space (and that we have any bytes to send at all)
; 0002 00D4 	if((uartTxBuffer[nUart].datalength + nBytes < uartTxBuffer[nUart].size) && nBytes)
;	nUart -> Y+8
;	*buffer -> Y+6
;	nBytes -> Y+4
;	first -> R17
;	i -> R18,R19
; 0002 00D5 	{
; 0002 00D6 		first = *buffer++; // grab first character
; 0002 00D7 		// copy user buffer to uart transmit buffer
; 0002 00D8 		for(i = 0; i < nBytes-1; i++)
; 0002 00D9 		{
; 0002 00DA 			bufferAddToEnd(&uartTxBuffer[nUart], *buffer++); // put data bytes at end of buffer
; 0002 00DB 		}
; 0002 00DC 
; 0002 00DD 		// send the first byte to get things going by interrupts
; 0002 00DE 		uartBufferedTx[nUart] = 1;
; 0002 00DF 		uartSendByte(nUart, first);
; 0002 00E0 		return 1; // return success
; 0002 00E1 	}
; 0002 00E2 	else
; 0002 00E3 	{
; 0002 00E4 		return 0; // return failure
; 0002 00E5 	}
; 0002 00E6 }
;void uartSendBufferf(byte nUart, char flash *text){
; 0002 00E7 void uartSendBufferf(byte nUart, char flash *text){
_uartSendBufferf:
; 0002 00E8   while(*text)
;	nUart -> Y+2
;	*text -> Y+0
_0x4001C:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x4001E
; 0002 00E9   {
; 0002 00EA   	if(nUart){
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x4001F
; 0002 00EB     	while (!( UCSR1A & 0x20));
_0x40020:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x40020
; 0002 00EC     	UDR1 = *text++;
	CALL SUBOPT_0x10
	STS  206,R30
; 0002 00ED   	}
; 0002 00EE   	else{
	RJMP _0x40023
_0x4001F:
; 0002 00EF     	while (!( UCSR0A & 0x20));
_0x40024:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x40024
; 0002 00F0     	UDR0 = *text++;
	CALL SUBOPT_0x10
	STS  198,R30
; 0002 00F1   	}
_0x40023:
; 0002 00F2   }
	RJMP _0x4001C
_0x4001E:
; 0002 00F3 }
	JMP  _0x20A000D
;
;// UART Transmit Complete Interrupt Function
;void uartTransmitService(byte nUart)
; 0002 00F7 {
_uartTransmitService:
; 0002 00F8 	// check if buffered tx is enabled
; 0002 00F9 	if(uartBufferedTx[nUart])
;	nUart -> Y+0
	CALL SUBOPT_0xF
	LD   R30,Z
	CPI  R30,0
	BREQ _0x40027
; 0002 00FA 	{
; 0002 00FB 		// check if there's data left in the buffer
; 0002 00FC 		if(uartTxBuffer[nUart].datalength)
	CALL SUBOPT_0x11
	CALL __LSLW3
	__ADDW1MN _uartTxBuffer,4
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x40028
; 0002 00FD 		{
; 0002 00FE 			// send byte from top of buffer
; 0002 00FF 			if(nUart)
	LD   R30,Y
	CPI  R30,0
	BREQ _0x40029
; 0002 0100 				UDR1 =  bufferGetFromFront(&uartTxBuffer[1]);
	__POINTW1MN _uartTxBuffer,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL _bufferGetFromFront
	STS  206,R30
; 0002 0101 			else
	RJMP _0x4002A
_0x40029:
; 0002 0102 				UDR0 =  bufferGetFromFront(&uartTxBuffer[0]);
	LDI  R30,LOW(_uartTxBuffer)
	LDI  R31,HIGH(_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _bufferGetFromFront
	STS  198,R30
; 0002 0103 		}
_0x4002A:
; 0002 0104 		else
	RJMP _0x4002B
_0x40028:
; 0002 0105 		{
; 0002 0106 			uartBufferedTx[nUart] = 0; // no data left
	CALL SUBOPT_0xF
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0002 0107 			uartReadyTx[nUart] = 1; // return to ready state
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_uartReadyTx)
	SBCI R31,HIGH(-_uartReadyTx)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0002 0108 
; 0002 0109       // Comm LED off
; 0002 010A       LED_COMM_OFF;
; 0002 010B 		}
_0x4002B:
; 0002 010C 	}
; 0002 010D 	else
	RJMP _0x4002C
_0x40027:
; 0002 010E 	{
; 0002 010F 		// we're using single-byte tx mode
; 0002 0110 		// indicate transmit complete, back to ready
; 0002 0111 		uartReadyTx[nUart] = 1;
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_uartReadyTx)
	SBCI R31,HIGH(-_uartReadyTx)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0002 0112 
; 0002 0113     // Comm LED off
; 0002 0114     LED_COMM_OFF;
; 0002 0115 	}
_0x4002C:
; 0002 0116 }
	JMP  _0x20A000F
;
;// UART Receive Complete Interrupt Function
;void uartReceiveService(byte nUart)
; 0002 011A {
_uartReceiveService:
; 0002 011B 	byte c;
; 0002 011C 
; 0002 011D 	// get received char
; 0002 011E 	if(nUart)
	ST   -Y,R17
;	nUart -> Y+1
;	c -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x4002D
; 0002 011F 		c = UDR1;
	LDS  R17,206
; 0002 0120 	else
	RJMP _0x4002E
_0x4002D:
; 0002 0121 		c = UDR0;
	LDS  R17,198
; 0002 0122 
; 0002 0123 	// if there's a user function to handle this receive event
; 0002 0124 	if(UartRxFunc[nUart])
_0x4002E:
	LDD  R30,Y+1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x12
	SBIW R30,0
	BREQ _0x4002F
; 0002 0125 	{
; 0002 0126 		// call it and pass the received data
; 0002 0127 		UartRxFunc[nUart](c);
	LDD  R30,Y+1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x12
	PUSH R31
	PUSH R30
	ST   -Y,R17
	POP  R30
	POP  R31
	ICALL
; 0002 0128 	}
; 0002 0129 
; 0002 012A }
_0x4002F:
	LDD  R17,Y+0
	JMP  _0x20A0010
;
;
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0002 012E {
_usart0_tx_isr:
	CALL SUBOPT_0x8
; 0002 012F 	// service UART0 transmit interrupt
; 0002 0130 	uartTransmitService(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _uartTransmitService
; 0002 0131 }
	RJMP _0x40032
;
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0002 0134 {
_usart1_tx_isr:
	CALL SUBOPT_0x8
; 0002 0135 	// service UART1 transmit interrupt
; 0002 0136 	uartTransmitService(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _uartTransmitService
; 0002 0137 }
	RJMP _0x40032
;
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0002 013A {
_usart0_rx_isr:
	CALL SUBOPT_0x8
; 0002 013B 	// service UART0 receive interrupt
; 0002 013C 	uartReceiveService(0);
	LDI  R30,LOW(0)
	RJMP _0x40031
; 0002 013D }
;
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0002 0140 {
_usart1_rx_isr:
	CALL SUBOPT_0x8
; 0002 0141 	// service UART1 receive interrupt
; 0002 0142 	uartReceiveService(1);
	LDI  R30,LOW(1)
_0x40031:
	ST   -Y,R30
	RCALL _uartReceiveService
; 0002 0143 }
_0x40032:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;/*! \file buffer.c \brief Multipurpose byte buffer structure and methods. */
;//*****************************************************************************
;//
;// File Name	: 'buffer.c'
;// Title		: Multipurpose byte buffer structure and methods
;// Author		: Pascal Stang - Copyright (C) 2001-2002
;// Created		: 9/23/2001
;// Revised		: 9/23/2001
;// Version		: 1.0
;// Target MCU	: any
;// Editor Tabs	: 4
;//
;// This code is distributed under the GNU Public License
;//		which can be found at http://www.gnu.org/licenses/gpl.txt
;//
;//*****************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <buffer.h>
;
;#ifndef CRITICAL_SECTION_START
;#define CRITICAL_SECTION_START	unsigned char _sreg = SREG; cli()
;#define CRITICAL_SECTION_END	SREG = _sreg
;#endif
;
;// global variables
;
;// initialization
;
;void bufferInit(cBuffer* buffer, unsigned char *start, unsigned short size)
; 0003 001F {

	.CSEG
_bufferInit:
; 0003 0020 	// begin critical section
; 0003 0021 	CRITICAL_SECTION_START;
;	*buffer -> Y+4
;	*start -> Y+2
;	size -> Y+0
	cli
; 0003 0022 	// set start pointer of the buffer
; 0003 0023 	buffer->dataptr = start;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X+,R30
	ST   X,R31
; 0003 0024 	buffer->size = size;
	LD   R30,Y
	LDD  R31,Y+1
	__PUTW1SNS 4,2
; 0003 0025 	// initialize index and length
; 0003 0026 	buffer->dataindex = 0;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,6
	CALL SUBOPT_0x13
; 0003 0027 	buffer->datalength = 0;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL SUBOPT_0x13
; 0003 0028 	// end critical section
; 0003 0029 	CRITICAL_SECTION_END;
	sei
; 0003 002A }
	ADIW R28,6
	RET
;
;// access routines
;unsigned char  bufferGetFromFront(cBuffer* buffer)
; 0003 002E {
_bufferGetFromFront:
; 0003 002F 	unsigned char data = 0;
; 0003 0030 	// begin critical section
; 0003 0031 	CRITICAL_SECTION_START;
	ST   -Y,R17
;	*buffer -> Y+1
;	data -> R17
	LDI  R17,0
	cli
; 0003 0032 	// check to see if there's data in the buffer
; 0003 0033 	if(buffer->datalength)
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x60003
; 0003 0034 	{
; 0003 0035 		// get the first character from buffer
; 0003 0036 		data = buffer->dataptr[buffer->dataindex];
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R0,X+
	LD   R1,X
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,6
	CALL __GETW1P
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	LD   R17,X
; 0003 0037 		// move index down and decrement length
; 0003 0038 		buffer->dataindex++;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,6
	CALL SUBOPT_0x14
; 0003 0039 		if(buffer->dataindex >= buffer->size)
	CALL SUBOPT_0x15
	ADIW R26,2
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	BRLO _0x60004
; 0003 003A 		{
; 0003 003B 			buffer->dataindex -= buffer->size;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,6
	MOVW R22,R30
	LD   R0,Z
	LDD  R1,Z+1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0003 003C 		}
; 0003 003D 		buffer->datalength--;
_0x60004:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0003 003E 	}
; 0003 003F 	// end critical section
; 0003 0040 	CRITICAL_SECTION_END;
_0x60003:
	sei
; 0003 0041 	// return
; 0003 0042 	return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20A000D
; 0003 0043 }
;
;void bufferDumpFromFront(cBuffer* buffer, unsigned short numbytes)
; 0003 0046 {
; 0003 0047 	// begin critical section
; 0003 0048 	CRITICAL_SECTION_START;
;	*buffer -> Y+2
;	numbytes -> Y+0
; 0003 0049 	// dump numbytes from the front of the buffer
; 0003 004A 	// are we dumping less than the entire buffer?
; 0003 004B 	if(numbytes < buffer->datalength)
; 0003 004C 	{
; 0003 004D 		// move index down by numbytes and decrement length by numbytes
; 0003 004E 		buffer->dataindex += numbytes;
; 0003 004F 		if(buffer->dataindex >= buffer->size)
; 0003 0050 		{
; 0003 0051 			buffer->dataindex -= buffer->size;
; 0003 0052 		}
; 0003 0053 		buffer->datalength -= numbytes;
; 0003 0054 	}
; 0003 0055 	else
; 0003 0056 	{
; 0003 0057 		// flush the whole buffer
; 0003 0058 		buffer->datalength = 0;
; 0003 0059 	}
; 0003 005A 	// end critical section
; 0003 005B 	CRITICAL_SECTION_END;
; 0003 005C }
;
;unsigned char bufferGetAtIndex(cBuffer* buffer, unsigned short index)
; 0003 005F {
; 0003 0060   unsigned char data;
; 0003 0061 
; 0003 0062 	// begin critical section
; 0003 0063 	CRITICAL_SECTION_START;
;	*buffer -> Y+3
;	index -> Y+1
;	data -> R17
; 0003 0064 	// return character at index in buffer
; 0003 0065 	data = buffer->dataptr[(buffer->dataindex+index)%(buffer->size)];
; 0003 0066 	// end critical section
; 0003 0067 	CRITICAL_SECTION_END;
; 0003 0068 	return data;
; 0003 0069 }
;
;unsigned char bufferAddToEnd(cBuffer* buffer, unsigned char data)
; 0003 006C {
_bufferAddToEnd:
; 0003 006D 	// begin critical section
; 0003 006E 	CRITICAL_SECTION_START;
;	*buffer -> Y+1
;	data -> Y+0
	cli
; 0003 006F 	// make sure the buffer has room
; 0003 0070 	if(buffer->datalength < buffer->size)
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__GETWRZ 0,1,4
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x60008
; 0003 0071 	{
; 0003 0072 		// save data byte at end of buffer
; 0003 0073 		buffer->dataptr[(buffer->dataindex + buffer->datalength) % buffer->size] = data;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x15
	ADIW R26,4
	CALL __GETW1P
	__ADDWRR 0,1,30,31
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	CALL __GETW1P
	MOVW R26,R0
	CALL __MODW21U
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	STD  Z+0,R26
; 0003 0074 		// increment the length
; 0003 0075 		buffer->datalength++;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL SUBOPT_0x14
; 0003 0076 		// end critical section
; 0003 0077 		CRITICAL_SECTION_END;
	sei
; 0003 0078 		// return success
; 0003 0079 		return -1;
	LDI  R30,LOW(255)
	JMP  _0x20A000D
; 0003 007A 	}
; 0003 007B 	// end critical section
; 0003 007C 	CRITICAL_SECTION_END;
_0x60008:
	sei
; 0003 007D 	// return failure
; 0003 007E 	return 0;
	LDI  R30,LOW(0)
	JMP  _0x20A000D
; 0003 007F }
;
;unsigned short bufferIsNotFull(cBuffer* buffer)
; 0003 0082 {
; 0003 0083   unsigned short bytesleft;
; 0003 0084 
; 0003 0085 	// begin critical section
; 0003 0086 	CRITICAL_SECTION_START;
;	*buffer -> Y+2
;	bytesleft -> R16,R17
; 0003 0087 	// check to see if the buffer has room
; 0003 0088 	// return true if there is room
; 0003 0089 	bytesleft = (buffer->size - buffer->datalength);
; 0003 008A 	// end critical section
; 0003 008B 	CRITICAL_SECTION_END;
; 0003 008C 	return bytesleft;
; 0003 008D }
;
;void bufferFlush(cBuffer* buffer)
; 0003 0090 {
; 0003 0091 	// begin critical section
; 0003 0092 	CRITICAL_SECTION_START;
;	*buffer -> Y+0
; 0003 0093 	// flush contents of the buffer
; 0003 0094 	buffer->datalength = 0;
; 0003 0095 	// end critical section
; 0003 0096 	CRITICAL_SECTION_END;
; 0003 0097 }
;
;//**********************************************************************************************
;// buttons.c
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// - funkce a makra pro praci az s 10 vstupy
;// - porty se nastavuji jako vstupni s pullupy
;// - kazdy vstup muze mit rozdilny DDR, PORT a zejmena MASK(=>LED existuje)
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <types.h>
;#include <buttons.h>
;
;
;//*****************************************************************
;// Buttons_init - init portu
;//*****************************************************************
;void Buttons_init(void){
; 0004 0012 void Buttons_init(void){

	.CSEG
_Buttons_init:
; 0004 0013     BUTTONS_INIT;
	CBI  0x7,6
	SBI  0x8,6
	CBI  0x7,7
	SBI  0x8,7
; 0004 0014 }
	RET
;
;
;//*****************************************************************
;// Buttons_get_x - vrati stav X-teho tlacitka
;//*****************************************************************
;signed char Buttons_get_x(byte button_position){
; 0004 001A signed char Buttons_get_x(byte button_position){
; 0004 001B     signed char aux_button = -1;
; 0004 001C 
; 0004 001D     switch (button_position) {
;	button_position -> Y+1
;	aux_button -> R17
; 0004 001E         case 1 : aux_button = GET_BUTTON_1_STATE; break;
; 0004 001F         case 2 : aux_button = GET_BUTTON_2_STATE; break;
; 0004 0020         case 3 : aux_button = GET_BUTTON_3_STATE; break;
; 0004 0021         case 4 : aux_button = GET_BUTTON_4_STATE; break;
; 0004 0022         case 5 : aux_button = GET_BUTTON_5_STATE; break;
; 0004 0023         case 6 : aux_button = GET_BUTTON_6_STATE; break;
; 0004 0024         case 7 : aux_button = GET_BUTTON_7_STATE; break;
; 0004 0025         case 8 : aux_button = GET_BUTTON_8_STATE; break;
; 0004 0026         case 9 : aux_button = GET_BUTTON_9_STATE; break;
; 0004 0027         case 10 : aux_button = GET_BUTTON_10_STATE; break;
; 0004 0028         default: aux_button = -1; break;
; 0004 0029   }
; 0004 002A   return aux_button;
; 0004 002B }
;
;/* END OF SPI FUNCTIONS */
;//**********************************************************************************************
;// digital_outputs.c
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// - funkce a makra pro praci az s 10 vystupy
;// - porty se nastavuji jako vystupni s definovanou defaultni hodnotou
;// - kazdy vystupu muze mit rozdilny DDR, PORT a zejmena MASK(=>OUTPUT existuje)
;//**********************************************************************************************
;
;#include <types.h>
;#include <digital_outputs.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;
;
;//*****************************************************************
;// Leds_init - init portu
;//*****************************************************************
;void Digital_outputs_init(void){
; 0005 0011 void Digital_outputs_init(void){

	.CSEG
_Digital_outputs_init:
; 0005 0012 	DIG_OUTS_INIT;
	SBI  0xA,6
	SBI  0xB,6
	SBI  0xA,7
	SBI  0xB,7
	SBI  0x1,2
	CBI  0x2,2
	SBI  0x1,3
	CBI  0x2,3
; 0005 0013 }
	RET
;
;
;//*****************************************************************
;// Leds_x_on - rozsviti urcenou LED diodu
;//*****************************************************************
;void Digital_outputs_x_on(byte output_position)
; 0005 001A {
; 0005 001B     switch (output_position) {
;	output_position -> Y+0
; 0005 001C         case 1 : DIG_OUT_1_ON; break;
; 0005 001D         case 2 : DIG_OUT_2_ON; break;
; 0005 001E         case 3 : DIG_OUT_3_ON; break;
; 0005 001F         case 4 : DIG_OUT_4_ON; break;
; 0005 0020         case 5 : DIG_OUT_5_ON; break;
; 0005 0021         case 6 : DIG_OUT_6_ON; break;
; 0005 0022         case 7 : DIG_OUT_7_ON; break;
; 0005 0023         case 8 : DIG_OUT_8_ON; break;
; 0005 0024         case 9 : DIG_OUT_9_ON; break;
; 0005 0025         case 10 : DIG_OUT_10_ON; break;
; 0005 0026         default: break;
; 0005 0027   }
; 0005 0028 }
;
;
;//*****************************************************************
;// Leds_X_Off - zhasne urcenou LED diodu
;//*****************************************************************
;void Digital_outputs_x_off(byte output_position)
; 0005 002F {
; 0005 0030 	switch (output_position) {
;	output_position -> Y+0
; 0005 0031         case 1 : DIG_OUT_1_OFF; break;
; 0005 0032         case 2 : DIG_OUT_2_OFF; break;
; 0005 0033         case 3 : DIG_OUT_3_OFF; break;
; 0005 0034         case 4 : DIG_OUT_4_OFF; break;
; 0005 0035         case 5 : DIG_OUT_5_OFF; break;
; 0005 0036         case 6 : DIG_OUT_6_OFF; break;
; 0005 0037         case 7 : DIG_OUT_7_OFF; break;
; 0005 0038         case 8 : DIG_OUT_8_OFF; break;
; 0005 0039         case 9 : DIG_OUT_9_OFF; break;
; 0005 003A         case 10 : DIG_OUT_10_OFF; break;
; 0005 003B         default: break;
; 0005 003C   }
; 0005 003D }
;
;
;//*****************************************************************
;// Leds_set - rozsviti/zhasne ledky podle zadane masky
;//*****************************************************************
;void Digital_outputs_set(word mask){
; 0005 0043 void Digital_outputs_set(word mask){
; 0005 0044 	byte i;
; 0005 0045 	for(i=0;i<16;i++){
;	mask -> Y+1
;	i -> R17
; 0005 0046 		if((mask >> i) & 0x01)
; 0005 0047 			Digital_outputs_x_on(i+1);
; 0005 0048 		else
; 0005 0049 			Digital_outputs_x_off(i+1);
; 0005 004A 	}
; 0005 004B }
;
;//**********************************************************************************************
;// SPI communication driver
;// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
;//**********************************************************************************************
;  #include <mega324a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;  #include <types.h>
;  #include <my_spi.h>
;
;
;#include <stdio.h>
;//**********************************************************************************************
;
;void SPI_MasterInit(void)
; 0006 000E {

	.CSEG
_SPI_MasterInit:
; 0006 000F 
; 0006 0010     /* Set MOSI and SCK output, all others input */
; 0006 0011     //DDRB = 0xB0;
; 0006 0012 
; 0006 0013     DDRB.4 = 1; //ss output
	SBI  0x4,4
; 0006 0014     DDRB.5 = 1; //mosi output
	SBI  0x4,5
; 0006 0015     DDRB.6 = 0; //miso input
	CBI  0x4,6
; 0006 0016     DDRB.7 = 1; //SCK output
	SBI  0x4,7
; 0006 0017     //printf("\nDDR_SPI: %x, %x \n", DDRB, (1<<DD_MOSI)|(1<<DD_SCK));
; 0006 0018 
; 0006 0019     /* Enable SPI, Master, set clock rate fck/16 */
; 0006 001A     SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0);
	LDI  R30,LOW(83)
	OUT  0x2C,R30
; 0006 001B 
; 0006 001C }
	RET
;
;//**********************************************************************************************
;byte SPI_MasterTransmit(byte tx_data)
; 0006 0020 {
_SPI_MasterTransmit:
; 0006 0021   //byte auxb;
; 0006 0022 
; 0006 0023   //auxb = SPDR;        // vycteni bufferu (shozeni pripadneho flagu SPIF)
; 0006 0024 
; 0006 0025   /* Start transmission */
; 0006 0026   SPDR = tx_data;
;	tx_data -> Y+0
	LD   R30,Y
	OUT  0x2E,R30
; 0006 0027 
; 0006 0028   /* Wait for transmission complete */
; 0006 0029   while(!(SPSR & (1<<SPIF)));
_0xC000B:
	IN   R30,0x2D
	ANDI R30,LOW(0x80)
	BREQ _0xC000B
; 0006 002A 
; 0006 002B   //read
; 0006 002C   return(SPDR);
	IN   R30,0x2E
	RJMP _0x20A000F
; 0006 002D }
;
;unsigned char SPI_MasterTransmit2(unsigned char data)
; 0006 0030 {
; 0006 0031 SPDR=data;
;	data -> Y+0
; 0006 0032 while ((SPSR & (1<<SPIF))==0);
; 0006 0033 return SPDR;
; 0006 0034 }
;//**********************************************************************************************
;// nt7534.c
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// - základní funkce pro práci s radicem/displejem
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <types.h>
;#include <my_spi.h>
;#include <delay.h>
;#include <stdio.h>
;#include <NT7534.h>
;
;//****************GRAFIKA*************************
;static flash const char LOGO_KNUERR[1024] = {
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x80,0xC0,0x60,0x60,0x30,0x18,0x1C,0x18,0x30,0x60,0x60,0xC0,0x80,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0xE0,0x70,0x38,0x3C,0x1E,0x1F,0x1F,0x9F,0x0C,0x0C,0x0E,0x0E,0xFE,0xFE,0xFE,0x0E,0x0E,0x0C,0x0C,0x9F,0x1F,0x1F,0x1E,0x3C,0x38,0x70,0xE0,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0xFE,0xFF,0x07,0x00,0x00,0x00,0xF8,0xFE,0xFF,0x01,0x00,0x00,0x00,0x00,0x00,0xFF,0xFF,0xFF,0x00,0x00,0x00,0x00,0x00,0x01,0xFF,0xFE,0xF8,0x00,0x00,0x00,0x07,0xFF,0xFE,0xF0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x03,0x0F,0x3E,0x78,0xF0,0xE0,0xE0,0xC7,0x8F,0x8E,0x90,0x00,0x00,0x00,0x00,0xFF,0xFF,0xFF,0x00,0x00,0x00,0x00,0x90,0x8E,0x8F,0xC7,0xE0,0xE0,0xF0,0x78,0x3E,0x0F,0x03,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x07,0x7F,0xFF,0xF1,0x01,0x03,0x03,0x03,0x03,0x03,0x03,0x07,0x03,0x03,0x03,0x03,0x03,0x03,0x01,0xF1,0xFF,0x7F,0x07,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0xF8,0xFC,0x3E,0x0E,0x0F,0x07,0x07,0x07,0x07,0x0E,0x3E,0xFC,0xF8,0xE0,0xC0,0xE0,0xE0,0xE0,0x70,0x7F,0x7F,0x70,0x60,0xE0,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,0xE0,0x60,0x70,0x7F,0x7F,0x70,0xE0,0xE0,0xE0,0xC0,0xE0,0xF8,0xFC,0x3E,0x0E,0x07,0x07,0x07,0x07,0x0F,0x0E,0x3E,0xFC,0xF8,0xF0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1F,0x1F,0x3F,0x39,0x70,0x70,0xE0,0xE0,0xE0,0xC0,0xC0,0x80,0x80,0x00,0x00,0x01,0x01,0x01,0x01,0x01,0x00,0x00,0x80,0x80,0xC0,0xC0,0xE0,0xE0,0xE0,0x70,0x70,0x39,0x3F,0x1F,0x1F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x01,0x03,0x03,0x07,0x07,0x07,0x0E,0x0C,0x1C,0x0C,0x0E,0x07,0x07,0x07,0x03,0x03,0x01,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
;};
;static flash const char FontLookup_Extended [1][5] = {
;    { 0x00, 0x07, 0x05, 0x07, 0x00 }      //°
;};
;
;static flash const char FontLookup [91][5] = {
;    { 0x00, 0x00, 0x00, 0x00, 0x00 },   // sp
;    { 0x00, 0x00, 0x2f, 0x00, 0x00 },   // !
;    { 0x00, 0x07, 0x00, 0x07, 0x00 },   // "
;    { 0x14, 0x7f, 0x14, 0x7f, 0x14 },   // #
;    { 0x24, 0x2a, 0x7f, 0x2a, 0x12 },   // $
;    { 0xc4, 0xc8, 0x10, 0x26, 0x46 },   // %
;    { 0x36, 0x49, 0x55, 0x22, 0x50 },   // &
;    { 0x00, 0x05, 0x03, 0x00, 0x00 },   // '
;    { 0x00, 0x1c, 0x22, 0x41, 0x00 },   // (
;    { 0x00, 0x41, 0x22, 0x1c, 0x00 },   // )
;
;    { 0x14, 0x08, 0x3E, 0x08, 0x14 },   // *
;    { 0x08, 0x08, 0x3E, 0x08, 0x08 },   // +
;    { 0x00, 0x00, 0x50, 0x30, 0x00 },   // ,
;    { 0x10, 0x10, 0x10, 0x10, 0x10 },   // -
;    { 0x00, 0x60, 0x60, 0x00, 0x00 },   // .
;    { 0x20, 0x10, 0x08, 0x04, 0x02 },   // /
;    { 0x3E, 0x51, 0x49, 0x45, 0x3E },   // 0
;    { 0x00, 0x42, 0x7F, 0x40, 0x00 },   // 1
;    { 0x42, 0x61, 0x51, 0x49, 0x46 },   // 2
;    { 0x21, 0x41, 0x45, 0x4B, 0x31 },   // 3
;
;    { 0x18, 0x14, 0x12, 0x7F, 0x10 },   // 4
;    { 0x27, 0x45, 0x45, 0x45, 0x39 },   // 5
;    { 0x3C, 0x4A, 0x49, 0x49, 0x30 },   // 6
;    { 0x01, 0x71, 0x09, 0x05, 0x03 },   // 7
;    { 0x36, 0x49, 0x49, 0x49, 0x36 },   // 8
;    { 0x06, 0x49, 0x49, 0x29, 0x1E },   // 9
;    { 0x00, 0x36, 0x36, 0x00, 0x00 },   // :
;    { 0x00, 0x56, 0x36, 0x00, 0x00 },   // ;
;    { 0x08, 0x14, 0x22, 0x41, 0x00 },   // <
;    { 0x14, 0x14, 0x14, 0x14, 0x14 },   // =
;
;    { 0x00, 0x41, 0x22, 0x14, 0x08 },   // >
;    { 0x02, 0x01, 0x51, 0x09, 0x06 },   // ?
;    { 0x32, 0x49, 0x59, 0x51, 0x3E },   // @
;    { 0x7E, 0x11, 0x11, 0x11, 0x7E },   // A
;    { 0x7F, 0x49, 0x49, 0x49, 0x36 },   // B
;    { 0x3E, 0x41, 0x41, 0x41, 0x22 },   // C
;    { 0x7F, 0x41, 0x41, 0x22, 0x1C },   // D
;    { 0x7F, 0x49, 0x49, 0x49, 0x41 },   // E
;    { 0x7F, 0x09, 0x09, 0x09, 0x01 },   // F
;    { 0x3E, 0x41, 0x49, 0x49, 0x7A },   // G
;
;    { 0x7F, 0x08, 0x08, 0x08, 0x7F },   // H
;    { 0x00, 0x41, 0x7F, 0x41, 0x00 },   // I
;    { 0x20, 0x40, 0x41, 0x3F, 0x01 },   // J
;    { 0x7F, 0x08, 0x14, 0x22, 0x41 },   // K
;    { 0x7F, 0x40, 0x40, 0x40, 0x40 },   // L
;    { 0x7F, 0x02, 0x0C, 0x02, 0x7F },   // M
;    { 0x7F, 0x04, 0x08, 0x10, 0x7F },   // N
;    { 0x3E, 0x41, 0x41, 0x41, 0x3E },   // O
;    { 0x7F, 0x09, 0x09, 0x09, 0x06 },   // P
;    { 0x3E, 0x41, 0x51, 0x21, 0x5E },   // Q
;
;    { 0x7F, 0x09, 0x19, 0x29, 0x46 },   // R
;    { 0x46, 0x49, 0x49, 0x49, 0x31 },   // S
;    { 0x01, 0x01, 0x7F, 0x01, 0x01 },   // T
;    { 0x3F, 0x40, 0x40, 0x40, 0x3F },   // U
;    { 0x1F, 0x20, 0x40, 0x20, 0x1F },   // V
;    { 0x3F, 0x40, 0x38, 0x40, 0x3F },   // W
;    { 0x63, 0x14, 0x08, 0x14, 0x63 },   // X
;    { 0x07, 0x08, 0x70, 0x08, 0x07 },   // Y
;    { 0x61, 0x51, 0x49, 0x45, 0x43 },   // Z
;    { 0x00, 0x7F, 0x41, 0x41, 0x00 },   // [
;
;    { 0x55, 0x2A, 0x55, 0x2A, 0x55 },   // 55
;    { 0x00, 0x41, 0x41, 0x7F, 0x00 },   // ]
;    { 0x04, 0x02, 0x01, 0x02, 0x04 },   // ^
;    { 0x40, 0x40, 0x40, 0x40, 0x40 },   // _
;    { 0x00, 0x01, 0x02, 0x04, 0x00 },   // '
;    { 0x20, 0x54, 0x54, 0x54, 0x78 },   // a
;    { 0x7F, 0x48, 0x44, 0x44, 0x38 },   // b
;    { 0x38, 0x44, 0x44, 0x44, 0x20 },   // c
;    { 0x38, 0x44, 0x44, 0x48, 0x7F },   // d
;    { 0x38, 0x54, 0x54, 0x54, 0x18 },   // e
;
;    { 0x08, 0x7E, 0x09, 0x01, 0x02 },   // f
;    { 0x0C, 0x52, 0x52, 0x52, 0x3E },   // g
;    { 0x7F, 0x08, 0x04, 0x04, 0x78 },   // h
;    { 0x00, 0x44, 0x7D, 0x40, 0x00 },   // i
;    { 0x20, 0x40, 0x44, 0x3D, 0x00 },   // j
;    { 0x7F, 0x10, 0x28, 0x44, 0x00 },   // k
;    { 0x00, 0x41, 0x7F, 0x40, 0x00 },   // l
;    { 0x7C, 0x04, 0x18, 0x04, 0x78 },   // m
;    { 0x7C, 0x08, 0x04, 0x04, 0x78 },   // n
;    { 0x38, 0x44, 0x44, 0x44, 0x38 },   // o
;
;    { 0x7C, 0x14, 0x14, 0x14, 0x08 },   // p
;    { 0x08, 0x14, 0x14, 0x18, 0x7C },   // q
;    { 0x7C, 0x08, 0x04, 0x04, 0x08 },   // r
;    { 0x48, 0x54, 0x54, 0x54, 0x20 },   // s
;    { 0x04, 0x3F, 0x44, 0x40, 0x20 },   // t
;    { 0x3C, 0x40, 0x40, 0x20, 0x7C },   // u
;    { 0x1C, 0x20, 0x40, 0x20, 0x1C },   // v
;    { 0x3C, 0x40, 0x30, 0x40, 0x3C },   // w
;    { 0x44, 0x28, 0x10, 0x28, 0x44 },   // x
;    { 0x0C, 0x50, 0x50, 0x50, 0x3C },   // y
;
;    { 0x44, 0x64, 0x54, 0x4C, 0x44 }    // z
;};
;
;
;void NT7534_clear_screen(void);
;void NT7534_set_position(unsigned char x_high, unsigned char x_low, unsigned char y);
;void w_command(unsigned char data);
;void w_data(unsigned char data);
;void NT7534_printf(unsigned char flash *cp);
;void NT7534_print(unsigned char *cp);
;void NT7534_Display_Init();
;void knuerr_logo(void);
;
;void NT7534_Init(){
; 0007 008F void NT7534_Init(){

	.CSEG
_NT7534_Init:
; 0007 0090 
; 0007 0091     //nastaveni portu
; 0007 0092     PIN_A0_DDR = 1;     //data
	SBI  0x1,2
; 0007 0093     PIN_RES_DDR = 1;    //reset
	SBI  0x1,1
; 0007 0094     NT7534_CS_DDR = 1;  //cs
	SBI  0x4,4
; 0007 0095 
; 0007 0096     //init values
; 0007 0097 
; 0007 0098     //reset
; 0007 0099     RES = 0;
	CBI  0x2,1
; 0007 009A     delay_us(50);
	__DELAY_USB 184
; 0007 009B     RES = 1;
	SBI  0x2,1
; 0007 009C 
; 0007 009D     //CS deactive
; 0007 009E     NT7534_CLEAR_CS;
	SBI  0x5,4
; 0007 009F 
; 0007 00A0     //init SPI
; 0007 00A1     SPI_MasterInit();
	RCALL _SPI_MasterInit
; 0007 00A2 
; 0007 00A3     delay_us(50);
	__DELAY_USB 184
; 0007 00A4 
; 0007 00A5     //init display
; 0007 00A6     NT7534_Display_Init();
	RCALL _NT7534_Display_Init
; 0007 00A7 
; 0007 00A8     delay_us(50);
	__DELAY_USB 184
; 0007 00A9     NT7534_clear_screen();
	RCALL _NT7534_clear_screen
; 0007 00AA     delay_us(50);
	__DELAY_USB 184
; 0007 00AB     knuerr_logo();
	RCALL _knuerr_logo
; 0007 00AC }
	RET
;
;//init display
;void NT7534_Display_Init(){
; 0007 00AF void NT7534_Display_Init(){
_NT7534_Display_Init:
; 0007 00B0 
; 0007 00B1     //NT7534_SET_CS;
; 0007 00B2     w_command( 0xA3 );   //LCD bias setting (11)
	LDI  R30,LOW(163)
	ST   -Y,R30
	RCALL _w_command
; 0007 00B3     w_command( 0xA1 );   //ADC selection (8)
	LDI  R30,LOW(161)
	ST   -Y,R30
	RCALL _w_command
; 0007 00B4     w_command( 0xC0 );   //Select COM output scan direction (15)
	LDI  R30,LOW(192)
	ST   -Y,R30
	RCALL _w_command
; 0007 00B5     w_command( 0x24 );   //Setting the built-in resistance ratio for regulation of the V0 voltage (17)
	LDI  R30,LOW(36)
	ST   -Y,R30
	RCALL _w_command
; 0007 00B6 
; 0007 00B7     w_command( 0x81 );   //Electric volume Mode Set (18)
	LDI  R30,LOW(129)
	ST   -Y,R30
	RCALL _w_command
; 0007 00B8     w_command( 0x2F );   //Electric volume Register Set (18)
	LDI  R30,LOW(47)
	ST   -Y,R30
	RCALL _w_command
; 0007 00B9 
; 0007 00BA     w_command( 0x2F );   //Power control seting (16)
	LDI  R30,LOW(47)
	ST   -Y,R30
	RCALL _w_command
; 0007 00BB     w_command( 0xA7 );   // LCD in normal mode (9)
	LDI  R30,LOW(167)
	ST   -Y,R30
	RCALL _w_command
; 0007 00BC 
; 0007 00BD     NT7534_clear_screen();
	RCALL _NT7534_clear_screen
; 0007 00BE 
; 0007 00BF     w_command( 0x7F );   //Display start line set (2)
	CALL SUBOPT_0x16
; 0007 00C0     w_command( 0xB0 );   //Page address set (3)
	LDI  R30,LOW(176)
	CALL SUBOPT_0x17
; 0007 00C1     w_command( 0x10 );   //Column Address set (4) High nibble (10h to 18h)
; 0007 00C2     w_command( 0x05 );   //Column address set (4) Low nibble (00h to 0Fh)
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _w_command
; 0007 00C3 
; 0007 00C4     NT7534_printf("Inicializace OK");
	__POINTW1FN _0xE0000,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _NT7534_printf
; 0007 00C5 
; 0007 00C6     w_command( 0xAF );   //LCD on (1)
	LDI  R30,LOW(175)
	ST   -Y,R30
	RCALL _w_command
; 0007 00C7 
; 0007 00C8     //NT7534_CLEAR_CS;
; 0007 00C9 
; 0007 00CA }
	RET
;
;
;void NT7534_manager(){
; 0007 00CD void NT7534_manager(){
; 0007 00CE     static byte aux_cnt = 0;
; 0007 00CF     byte my_string[20];
; 0007 00D0     //byte* pRows[4] = {"ahoj","cau","nazdar","pic"};
; 0007 00D1 
; 0007 00D2     //NT7534_set_screen(pRows);
; 0007 00D3 
; 0007 00D4     //NT7534_clear_screen();
; 0007 00D5     NT7534_set_position(0,1,0);
;	my_string -> Y+0
; 0007 00D6     aux_cnt++;
; 0007 00D7 
; 0007 00D8     if(aux_cnt<10){
; 0007 00D9         sprintf(my_string, "frekvence:  %d      ", 70 - aux_cnt);
; 0007 00DA         NT7534_print(my_string);
; 0007 00DB         //disp_str("Consider it solved!!!");
; 0007 00DC     }
; 0007 00DD     else if (aux_cnt<11){
; 0007 00DE         NT7534_set_position(0,1,1);
; 0007 00DF         NT7534_printf("Nejsem povinen být takový, jaký bych podle ostatních lidí mìl být. Je to jejich omyl, a ne moje selhání - Richard Feynman");
; 0007 00E0     }
; 0007 00E1     else
; 0007 00E2         aux_cnt = 0;
; 0007 00E3 
; 0007 00E4 
; 0007 00E5 }
;
;//zobrazi X stringu na X radcich displeje
;void NT7534_set_screen(byte *pRows[NR_ROWS]){
; 0007 00E8 void NT7534_set_screen(byte *pRows[8]){
_NT7534_set_screen:
; 0007 00E9     byte i;
; 0007 00EA 
; 0007 00EB     for(i=0; i<NR_ROWS; i++){
	ST   -Y,R17
;	pRows -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0xE0014:
	CPI  R17,8
	BRSH _0xE0015
; 0007 00EC          NT7534_set_position(0,1,i);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R17
	RCALL _NT7534_set_position
; 0007 00ED          NT7534_print(pRows[i]);
	MOV  R30,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x18
	ST   -Y,R31
	ST   -Y,R30
	RCALL _NT7534_print
; 0007 00EE     }
	SUBI R17,-1
	RJMP _0xE0014
_0xE0015:
; 0007 00EF 
; 0007 00F0 }
	LDD  R17,Y+0
	RJMP _0x20A000D
;void NT7534_set_paging(byte current, byte max){
; 0007 00F1 void NT7534_set_paging(byte current, byte max){
; 0007 00F2     char aus_string[21];
; 0007 00F3     sprintf(aus_string, "                  %u/%u", current, max);
;	current -> Y+22
;	max -> Y+21
;	aus_string -> Y+0
; 0007 00F4     NT7534_set_position(0,1,7);
; 0007 00F5     NT7534_print(aus_string);
; 0007 00F6 }
;
;
;//clear display
;void NT7534_clear_screen(void){
; 0007 00FA void NT7534_clear_screen(void){
_NT7534_clear_screen:
; 0007 00FB     unsigned char i,j;
; 0007 00FC      w_command(0x7F);      //Set Display Start Line = com0
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	CALL SUBOPT_0x16
; 0007 00FD      for(i=0;i<8;i++){
	LDI  R17,LOW(0)
_0xE0017:
	CPI  R17,8
	BRSH _0xE0018
; 0007 00FE          w_command(0xB0|i);    //Set Page Address
	MOV  R30,R17
	ORI  R30,LOW(0xB0)
	CALL SUBOPT_0x17
; 0007 00FF          w_command(0x10);      //Set Column Address = 0
; 0007 0100          w_command(0x01);      //Colum from 1 -> 129 auto add
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _w_command
; 0007 0101          for(j=0;j<132;j++)
	LDI  R16,LOW(0)
_0xE001A:
	CPI  R16,132
	BRSH _0xE001B
; 0007 0102             w_data( 0x00 );   //Display data write (6)
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _w_data
	SUBI R16,-1
	RJMP _0xE001A
_0xE001B:
; 0007 0103 }
	SUBI R17,-1
	RJMP _0xE0017
_0xE0018:
; 0007 0104 
; 0007 0105  }
	JMP  _0x20A000A
;
;//set cursor to position
;void NT7534_set_position(unsigned char x_high, unsigned char x_low, unsigned char y){
; 0007 0108 void NT7534_set_position(unsigned char x_high, unsigned char x_low, unsigned char y){
_NT7534_set_position:
; 0007 0109 
; 0007 010A 
; 0007 010B     w_command( 0x7F );   //Display start line set (2)
;	x_high -> Y+2
;	x_low -> Y+1
;	y -> Y+0
	CALL SUBOPT_0x16
; 0007 010C 
; 0007 010D     x_high|=0x10;
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
; 0007 010E     w_command(x_high);
	ST   -Y,R30
	RCALL _w_command
; 0007 010F 
; 0007 0110     if(x_high==0x10){
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BRNE _0xE001C
; 0007 0111         x_low|=0x04;
	LDD  R30,Y+1
	ORI  R30,4
	RJMP _0xE0049
; 0007 0112     }
; 0007 0113     else{
_0xE001C:
; 0007 0114         x_low|=0x00;
	LDD  R30,Y+1
_0xE0049:
	STD  Y+1,R30
; 0007 0115     }
; 0007 0116     w_command(x_low);
	ST   -Y,R30
	RCALL _w_command
; 0007 0117 
; 0007 0118     y|=0xB0;
	LD   R30,Y
	ORI  R30,LOW(0xB0)
	ST   Y,R30
; 0007 0119     w_command(y);
	ST   -Y,R30
	RCALL _w_command
; 0007 011A }
	RJMP _0x20A000D
;
;
;/* PRINT CHAR
;   - 2 tabulky znaku FontLookup a FontLookup_Extended
;   - "FontLookup" kopiruje ascii tabulku s offsetem -32, ve "FontLookup_Extended" jsou specielni znaky
;   - specielni znak -> nahradi se 0-31, tiskne se znak s timto indexem z tabulky FontLookup_Extended
;   - normalni znak  -> vezme se jeho ascii hodnota odecte se 32 a tiskne se znak s timto indexem z tabulky FontLookup
;*/
;void NT7534_print_char(unsigned char chr){
; 0007 0123 void NT7534_print_char(unsigned char chr){
_NT7534_print_char:
; 0007 0124 
; 0007 0125     unsigned char i=0;
; 0007 0126 
; 0007 0127 
; 0007 0128     //nahradit specielni znaky (0-31)
; 0007 0129     if(chr == '°')
	ST   -Y,R17
;	chr -> Y+1
;	i -> R17
	LDI  R17,0
	LDD  R26,Y+1
	CPI  R26,LOW(0xB0)
	BRNE _0xE001E
; 0007 012A         chr = 0;
	LDI  R30,LOW(0)
	RJMP _0xE004A
; 0007 012B 
; 0007 012C     //escape unprintable chars with space
; 0007 012D     else if ( (chr < 0x20) || (chr > 0x7b) ) // resim pouze tisknutelne znaky - tj. 32(sp) az 123(z) viz. ASCII
_0xE001E:
	LDD  R26,Y+1
	CPI  R26,LOW(0x20)
	BRLO _0xE0021
	CPI  R26,LOW(0x7C)
	BRLO _0xE0020
_0xE0021:
; 0007 012E         chr = 64; // pokud bude zadan netisknutelny znak, napise se misto nej mezera
	LDI  R30,LOW(64)
_0xE004A:
	STD  Y+1,R30
; 0007 012F 
; 0007 0130 
; 0007 0131     for(i=0; i<5; i++){
_0xE0020:
	LDI  R17,LOW(0)
_0xE0024:
	CPI  R17,5
	BRSH _0xE0025
; 0007 0132 
; 0007 0133         //specielni znaky -> FontLookup_Extended
; 0007 0134         if(chr<32)
	LDD  R26,Y+1
	CPI  R26,LOW(0x20)
	BRSH _0xE0026
; 0007 0135             w_data(FontLookup_Extended[chr][i]);
	LDD  R30,Y+1
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_FontLookup_Extended_G007*2)
	SBCI R31,HIGH(-_FontLookup_Extended_G007*2)
	RJMP _0xE004B
; 0007 0136 
; 0007 0137         //normalni znak -> FontLookup
; 0007 0138         else
_0xE0026:
; 0007 0139             w_data(FontLookup[chr-32][i]); //odecitam 32 pro dosazeni pozadovane radky v Look up tabulce
	LDD  R30,Y+1
	SUBI R30,LOW(32)
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_FontLookup_G007*2)
	SBCI R31,HIGH(-_FontLookup_G007*2)
_0xE004B:
	MOVW R26,R30
	CALL SUBOPT_0x19
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	ST   -Y,R30
	RCALL _w_data
; 0007 013A     }
	SUBI R17,-1
	RJMP _0xE0024
_0xE0025:
; 0007 013B 
; 0007 013C     w_data(0); // odsazeni za pismenkem
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _w_data
; 0007 013D 
; 0007 013E }
	LDD  R17,Y+0
	RJMP _0x20A0010
;
;//print string
;void NT7534_print(unsigned char *cp){
; 0007 0141 void NT7534_print(unsigned char *cp){
_NT7534_print:
; 0007 0142 
; 0007 0143     for (; *cp; cp++)
;	*cp -> Y+0
_0xE0029:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xE002A
; 0007 0144         NT7534_print_char(*cp);
	ST   -Y,R30
	RCALL _NT7534_print_char
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0xE0029
_0xE002A:
; 0007 0145 }
	RJMP _0x20A0010
;
;//print flash string
;void NT7534_printf(unsigned char flash *cp){
; 0007 0148 void NT7534_printf(unsigned char flash *cp){
_NT7534_printf:
; 0007 0149 
; 0007 014A     for (; *cp; cp++)
;	*cp -> Y+0
_0xE002C:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xE002D
; 0007 014B         NT7534_print_char(*cp);
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _NT7534_print_char
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0xE002C
_0xE002D:
; 0007 014C }
	RJMP _0x20A0010
;
;//send command or data, basic function for w_command() and w_data()
;void w_command_data(byte command_data, byte data){
; 0007 014F void w_command_data(byte command_data, byte data){
_w_command_data:
; 0007 0150 
; 0007 0151     //active CS
; 0007 0152     NT7534_SET_CS;
;	command_data -> Y+1
;	data -> Y+0
	CBI  0x5,4
; 0007 0153 
; 0007 0154     if(command_data)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xE0030
; 0007 0155         PIN_A0 = 0;
	CBI  0x2,2
; 0007 0156     else
	RJMP _0xE0033
_0xE0030:
; 0007 0157         PIN_A0 = 1;
	SBI  0x2,2
; 0007 0158 
; 0007 0159     delay_us(10);
_0xE0033:
	__DELAY_USB 37
; 0007 015A 
; 0007 015B     SPI_MasterTransmit(data);
	LD   R30,Y
	ST   -Y,R30
	RCALL _SPI_MasterTransmit
; 0007 015C 
; 0007 015D     delay_us(10);
	__DELAY_USB 37
; 0007 015E 
; 0007 015F     //deactive CS
; 0007 0160     NT7534_CLEAR_CS;
	SBI  0x5,4
; 0007 0161 }
_0x20A0010:
	ADIW R28,2
	RET
;
;void w_command(unsigned char data){
; 0007 0163 void w_command(unsigned char data){
_w_command:
; 0007 0164     w_command_data(1, data);
;	data -> Y+0
	LDI  R30,LOW(1)
	RJMP _0x20A000E
; 0007 0165 }
;
;void w_data(unsigned char data){
; 0007 0167 void w_data(unsigned char data){
_w_data:
; 0007 0168     w_command_data(0, data);
;	data -> Y+0
	LDI  R30,LOW(0)
_0x20A000E:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _w_command_data
; 0007 0169 }
_0x20A000F:
	ADIW R28,1
	RET
;
;
;
;
;/* TEST FUNCTIONs */
;
;
;void knuerr_logo(void){
; 0007 0171 void knuerr_logo(void){
_knuerr_logo:
; 0007 0172     byte i;
; 0007 0173     word row;
; 0007 0174 
; 0007 0175     for(row=0; row<8; row++){
	CALL __SAVELOCR4
;	i -> R17
;	row -> R18,R19
	__GETWRN 18,19,0
_0xE0039:
	__CPWRN 18,19,8
	BRSH _0xE003A
; 0007 0176         NT7534_set_position(0,1,(byte)row);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R18
	RCALL _NT7534_set_position
; 0007 0177         for(i=0;i<128;i++)
	LDI  R17,LOW(0)
_0xE003C:
	CPI  R17,128
	BRSH _0xE003D
; 0007 0178             w_data(LOGO_KNUERR[i + 128*row]);
	__MULBNWRU 18,19,128
	MOV  R26,R17
	LDI  R27,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_LOGO_KNUERR_G007*2)
	SBCI R31,HIGH(-_LOGO_KNUERR_G007*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _w_data
	SUBI R17,-1
	RJMP _0xE003C
_0xE003D:
; 0007 0179 }
	__ADDWRN 18,19,1
	RJMP _0xE0039
_0xE003A:
; 0007 017A }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;//chessboard
;void chessboard(void){
; 0007 017C void chessboard(void){
; 0007 017D     unsigned char i,j;
; 0007 017E 
; 0007 017F      w_command(0x40);      //Set Display Start Line = com0
;	i -> R17
;	j -> R16
; 0007 0180      for(i=0;i<8;i++)
; 0007 0181      {
; 0007 0182              w_command(0xB0|i);    //Set Page Address
; 0007 0183              w_command(0x10);      //Set Column Address = 0
; 0007 0184              w_command(0x04);      //Colum from 1 -> 129 auto add
; 0007 0185 
; 0007 0186         if(i%2)
; 0007 0187           {
; 0007 0188              for(j=0;j<8;j++)
; 0007 0189              {
; 0007 018A                      //disp_write(0x10|j,0);      //Set Column Address = 0
; 0007 018B 
; 0007 018C                      w_data( 0xFF );   //Display data write (6)
; 0007 018D                      w_data( 0x00 );   //Display data write (6)
; 0007 018E                      w_data( 0x00 );   //Display data write (6)
; 0007 018F                      w_data( 0x00 );   //Display data write (6)
; 0007 0190                      w_data( 0x00 );   //Display data write (6)
; 0007 0191                      w_data( 0x00 );   //Display data write (6)
; 0007 0192                      w_data( 0x00 );   //Display data write (6)
; 0007 0193                      w_data( 0x00 );   //Display data write (6)
; 0007 0194                      w_data( 0xFF );   //Display data write (6)
; 0007 0195                      w_data( 0xFF );   //Display data write (6)
; 0007 0196                      w_data( 0xFF );   //Display data write (6)
; 0007 0197                      w_data( 0xFF );   //Display data write (6)
; 0007 0198                      w_data( 0xFF );   //Display data write (6)
; 0007 0199                      w_data( 0xFF );   //Display data write (6)
; 0007 019A                      w_data( 0xFF );   //Display data write (6)
; 0007 019B                      w_data( 0xFF );   //Display data write (6)
; 0007 019C              }
; 0007 019D           }
; 0007 019E 
; 0007 019F         else
; 0007 01A0           {
; 0007 01A1             for(j=0;j<8;j++)
; 0007 01A2              {
; 0007 01A3                      w_data( 0xFF );   //Display data write (6)
; 0007 01A4                      w_data( 0xFF );   //Display data write (6)
; 0007 01A5                      w_data( 0xFF );   //Display data write (6)
; 0007 01A6                      w_data( 0xFF );   //Display data write (6)
; 0007 01A7                      w_data( 0xFF );   //Display data write (6)
; 0007 01A8                      w_data( 0xFF );   //Display data write (6)
; 0007 01A9                      w_data( 0xFF );   //Display data write (6)
; 0007 01AA                      w_data( 0xFF );   //Display data write (6)
; 0007 01AB                      w_data( 0x00 );   //Display data write (6)
; 0007 01AC                      w_data( 0x00 );   //Display data write (6)
; 0007 01AD                      w_data( 0x00 );   //Display data write (6)
; 0007 01AE                      w_data( 0x00 );   //Display data write (6)
; 0007 01AF                      w_data( 0x00 );   //Display data write (6)
; 0007 01B0                      w_data( 0x00 );   //Display data write (6)
; 0007 01B1                      w_data( 0x00 );   //Display data write (6)
; 0007 01B2                      w_data( 0x00 );   //Display data write (6)
; 0007 01B3              }
; 0007 01B4           }
; 0007 01B5 
; 0007 01B6 
; 0007 01B7 
; 0007 01B8 
; 0007 01B9      }
; 0007 01BA  }
;
;//**********************************************************************************************
;//
;//*****************************************************************
;
;#include <types.h>
;#include <stdio.h>
;#include <utils.h>
;
;//rotacni incrementace, mozna udelat jako makro
;void rot_inc(byte *var, byte max){
; 0008 000A void rot_inc(byte *var, byte max){

	.CSEG
_rot_inc:
; 0008 000B 	if(*var < max)
;	*var -> Y+1
;	max -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R26,X
	LD   R30,Y
	CP   R26,R30
	BRSH _0x100003
; 0008 000C 		(*var)++;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	SUBI R30,-LOW(1)
	RJMP _0x100007
; 0008 000D 	else
_0x100003:
; 0008 000E 		*var = 0;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
_0x100007:
	ST   X,R30
; 0008 000F }
	RJMP _0x20A000D
;
;//rotacni incrementace, mozna udelat jako makro
;void rot_dec(byte *var, byte max){
; 0008 0012 void rot_dec(byte *var, byte max){
_rot_dec:
; 0008 0013 	if(*var == 0)
;	*var -> Y+1
;	max -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x100005
; 0008 0014         *var = max;
	LD   R30,Y
	RJMP _0x100008
; 0008 0015 	else
_0x100005:
; 0008 0016         (*var)--;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	SUBI R30,LOW(1)
_0x100008:
	ST   X,R30
; 0008 0017 }
_0x20A000D:
	ADIW R28,3
	RET
;//**********************************************************************************************
;// MAXQ318X.c
;// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
;//**********************************************************************************************
;// 1.BYTE  7:6 - command mode: 0x00 -> read; 0x10 -> write
;//         5:4 - datalength: 0x00 -> 1bytes; 0x01 -> 2bytes; 0x10 -> 4bytes; 0x11 -> 8 bytes
;//         3:0 - MSB portion of data address
;// 2.BYTE  - LSB portion of data address
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <my_spi.h>
;#include <delay.h>
;#include <uart2.h>
;#include <maxq318x.h>
;
;
;//GLOBAL VARIABLES
;//tMM_FRAME sFrame;
;
;//DEFINES
;#define MAXQ_FIRST_BYTE_ACK  0xC1
;#define MAXQ_SECOND_BYTE_ACK 0xC2
;
;#define MAXQ_DELAY           50
;#define MAXQ_DELAY_2         100
;
;/* SPI FUNCTIONS */
;
;
;void maxq_Init(){
; 0009 0020 void maxq_Init(){

	.CSEG
_maxq_Init:
; 0009 0021 
; 0009 0022     SPI_MasterInit();
	CALL _SPI_MasterInit
; 0009 0023 }
	RET
;
;/*******************************************/
;// MAXQ_READ_WRITE()
;/*******************************************/
;// - read/write data from/to maxim
;// - see page 23 in MAXIM datasheet
;// - expect CS active already
;/*******************************************/
;signed char maxq_read_write(byte read_write, word address, char* pData, byte datalength){
; 0009 002C signed char maxq_read_write(byte read_write, word address, char* pData, byte datalength){
_maxq_read_write:
; 0009 002D     byte aux_data = 0x00;
; 0009 002E     byte aux_datalength = 0;
; 0009 002F     byte i, address1, address2;
; 0009 0030 
; 0009 0031     //MSB and LSB portion of address
; 0009 0032     address1 = (byte)(address>>8) & 0x0F;
	CALL __SAVELOCR6
;	read_write -> Y+11
;	address -> Y+9
;	*pData -> Y+7
;	datalength -> Y+6
;	aux_data -> R17
;	aux_datalength -> R16
;	i -> R19
;	address1 -> R18
;	address2 -> R21
	LDI  R17,0
	LDI  R16,0
	LDD  R30,Y+10
	LDI  R31,0
	ANDI R30,LOW(0xF)
	MOV  R18,R30
; 0009 0033     address2 = (byte) (address & 0xFF);
	LDD  R30,Y+9
	MOV  R21,R30
; 0009 0034 
; 0009 0035     //1.BYTE
; 0009 0036     aux_data = SPI_MasterTransmit(read_write<<7 | datalength<<4 | address1); //0x1 ->read&datalength=2, 0x1 - MSB address -> A line
	LDD  R30,Y+11
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R26,R30
	LDD  R30,Y+6
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OR   R30,R18
	CALL SUBOPT_0x1A
; 0009 0037     delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 0009 0038 
; 0009 0039 
; 0009 003A     if(aux_data == MAXQ_FIRST_BYTE_ACK){
	CPI  R17,193
	BREQ PC+3
	JMP _0x120003
; 0009 003B 
; 0009 003C         //2.BYTE
; 0009 003D         aux_data = SPI_MasterTransmit(address2); //LSB address
	ST   -Y,R21
	CALL _SPI_MasterTransmit
	MOV  R17,R30
; 0009 003E 
; 0009 003F         if(aux_data == MAXQ_SECOND_BYTE_ACK){
	CPI  R17,194
	BREQ PC+3
	JMP _0x120004
; 0009 0040 
; 0009 0041             if(read_write ==  eREAD){
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x120005
; 0009 0042 
; 0009 0043                 //maxim ready?
; 0009 0044                 for(i=0; i<30; i++){
	LDI  R19,LOW(0)
_0x120007:
	CPI  R19,30
	BRSH _0x120008
; 0009 0045                     delay_us(MAXQ_DELAY_2);
	__DELAY_USW 276
; 0009 0046                     aux_data = SPI_MasterTransmit(0x00); //
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0009 0047                     if(aux_data == 0x41)
	CPI  R17,65
	BREQ _0x120008
; 0009 0048                         break;
; 0009 0049                     //printf("\nE: Maxim is not ready, once again..");
; 0009 004A                 }
	SUBI R19,-1
	RJMP _0x120007
_0x120008:
; 0009 004B             }
; 0009 004C             else
	RJMP _0x12000A
_0x120005:
; 0009 004D                 aux_data = 0x41;
	LDI  R17,LOW(65)
; 0009 004E 
; 0009 004F             // READ / WRITE DATA
; 0009 0050             if(aux_data == 0x41){
_0x12000A:
	CPI  R17,65
	BREQ PC+3
	JMP _0x12000B
; 0009 0051 
; 0009 0052                 for(i=0; i<(1<<datalength); i++){
	LDI  R19,LOW(0)
_0x12000D:
	LDD  R30,Y+6
	LDI  R26,LOW(1)
	CALL __LSLB12
	CP   R19,R30
	BRSH _0x12000E
; 0009 0053 
; 0009 0054                     delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 0009 0055 
; 0009 0056                     //read
; 0009 0057                     if(read_write ==  eREAD){
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x12000F
; 0009 0058                         aux_data = SPI_MasterTransmit(0x00); //
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0009 0059                         *(byte *)(pData+aux_datalength) = aux_data;
	MOV  R30,R16
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0009 005A                         aux_datalength++;
	SUBI R16,-1
; 0009 005B                         //printf("\nI: read succesfull: 0x%x", aux_data);
; 0009 005C                     }
; 0009 005D 
; 0009 005E                     //write
; 0009 005F                     else if(read_write == eWRITE){
	RJMP _0x120010
_0x12000F:
	LDD  R26,Y+11
	CPI  R26,LOW(0x1)
	BRNE _0x120011
; 0009 0060                         byte aux_answer;
; 0009 0061                         aux_data = *(byte *)(pData+aux_datalength);
	SBIW R28,1
;	read_write -> Y+12
;	address -> Y+10
;	*pData -> Y+8
;	datalength -> Y+7
;	aux_answer -> Y+0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R17,X
; 0009 0062                         aux_answer = SPI_MasterTransmit(aux_data); //
	ST   -Y,R17
	CALL _SPI_MasterTransmit
	ST   Y,R30
; 0009 0063                         aux_datalength++;
	SUBI R16,-1
; 0009 0064                         if(aux_answer != 0x41){
	LD   R26,Y
	CPI  R26,LOW(0x41)
	BREQ _0x120012
; 0009 0065                             printf("\nE: write wasnt succesfull");
	__POINTW1FN _0x120000,0
	CALL SUBOPT_0x1B
; 0009 0066                             return -1;
	LDI  R30,LOW(255)
	ADIW R28,1
	RJMP _0x20A000C
; 0009 0067                         }
; 0009 0068                         //else
; 0009 0069                             //printf("\nI: write succesfull: 0x%x", aux_data);
; 0009 006A 
; 0009 006B 
; 0009 006C                     }
_0x120012:
	ADIW R28,1
; 0009 006D                     else
	RJMP _0x120013
_0x120011:
; 0009 006E                         printf("\nE: wrong operation (read/write)");
	__POINTW1FN _0x120000,27
	CALL SUBOPT_0x1B
; 0009 006F 
; 0009 0070                 }
_0x120013:
_0x120010:
	SUBI R19,-1
	RJMP _0x12000D
_0x12000E:
; 0009 0071 
; 0009 0072                 // check write operation
; 0009 0073                 if(read_write == eWRITE){
	LDD  R26,Y+11
	CPI  R26,LOW(0x1)
	BRNE _0x120014
; 0009 0074                     for(i=0; i<30; i++){
	LDI  R19,LOW(0)
_0x120016:
	CPI  R19,30
	BRSH _0x120017
; 0009 0075                         delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 0009 0076                         aux_data = SPI_MasterTransmit(0x00);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0009 0077                         if(aux_data != 0x4E){
	CPI  R17,78
	BREQ _0x120018
; 0009 0078                             printf("\nE:good, next step 0x%x", aux_data);
	__POINTW1FN _0x120000,60
	CALL SUBOPT_0x7
; 0009 0079                             break;
	RJMP _0x120017
; 0009 007A                         }
; 0009 007B                         else
_0x120018:
; 0009 007C                             printf("\nE:wrong, once again");
	__POINTW1FN _0x120000,84
	CALL SUBOPT_0x1B
; 0009 007D                     }
	SUBI R19,-1
	RJMP _0x120016
_0x120017:
; 0009 007E                     if(aux_data != 0x41){
	CPI  R17,65
	BREQ _0x12001A
; 0009 007F                         printf("\nE: write failed!");
	__POINTW1FN _0x120000,105
	CALL SUBOPT_0x1B
; 0009 0080                         return -1;
	LDI  R30,LOW(255)
	RJMP _0x20A000C
; 0009 0081                     }
; 0009 0082                     //else
; 0009 0083                         //printf("\nWRITE COPLETE!!\n\n");
; 0009 0084                  }
_0x12001A:
; 0009 0085 
; 0009 0086             }
_0x120014:
; 0009 0087             else
	RJMP _0x12001B
_0x12000B:
; 0009 0088                 printf("\nE: SYNC(3.byte) : %x", aux_data);
	__POINTW1FN _0x120000,123
	CALL SUBOPT_0x7
; 0009 0089                 //uartSendBufferf(0,"\nE: SYNC (3.byte)");
; 0009 008A         }
_0x12001B:
; 0009 008B         else{
	RJMP _0x12001C
_0x120004:
; 0009 008C             uartSendBufferf(0,"\nE: ADDRESS (2.byte)");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x120000,145
	CALL SUBOPT_0x2
; 0009 008D             return -1;
	LDI  R30,LOW(255)
	RJMP _0x20A000C
; 0009 008E         }
_0x12001C:
; 0009 008F     }
; 0009 0090     else{
	RJMP _0x12001D
_0x120003:
; 0009 0091         //printf("\nE: CMD 1.B: %x", aux_data);
; 0009 0092         return -1;
	LDI  R30,LOW(255)
	RJMP _0x20A000C
; 0009 0093     }
_0x12001D:
; 0009 0094 
; 0009 0095 
; 0009 0096     delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 0009 0097     return 0;
	LDI  R30,LOW(0)
_0x20A000C:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; 0009 0098 
; 0009 0099 }
;
;signed char maxq_read(word address, char* pData, byte datalength){
; 0009 009B signed char maxq_read(word address, char* pData, byte datalength){
_maxq_read:
; 0009 009C     return maxq_read_write(eREAD, address, pData, datalength);
;	address -> Y+3
;	*pData -> Y+1
;	datalength -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _maxq_read_write
	JMP  _0x20A0009
; 0009 009D }
;
;signed char maxq_write(word address, char* pData, byte datalength){
; 0009 009F signed char maxq_write(word address, char* pData, byte datalength){
; 0009 00A0     return maxq_read_write(eWRITE, address, pData, datalength);
;	address -> Y+3
;	*pData -> Y+1
;	datalength -> Y+0
; 0009 00A1 }
;
;/* END OF SPI FUNCTIONS */
;//**********************************************************************************************
;// messmodules.c -
;// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <delay.h>
;#include <math.h>
;#include <maxq318x.h>
;#include <maxq318x_commands.h>
;#include <messmodules.h>
;#include <spi_manager_user.h>
;#include <spi_manager.h>
;#include <uart2.h>    //124B
;
;
;signed long buffer2signed(byte *pBuffer, byte length);
;byte Messmodul_countAvailable();
;
;//MESSMODULES structure
;tMESSMODULES  sMm;
;
;void Messmodul_Init(){
; 000A 001A void Messmodul_Init(){

	.CSEG
_Messmodul_Init:
; 000A 001B 
; 000A 001C     //init max, spi etc.
; 000A 001D     maxq_Init();
	RCALL _maxq_Init
; 000A 001E 
; 000A 001F     //reset all values of all messmodules
; 000A 0020     memset(&sMm, 0, sizeof(sMm));
	LDI  R30,LOW(_sMm)
	LDI  R31,HIGH(_sMm)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(855)
	LDI  R31,HIGH(855)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 000A 0021 
; 000A 0022     //CS AS OUTPUT
; 000A 0023     SPI_INIT_ALL_CS
	SBI  0x4,4
	SBI  0x4,3
	SBI  0x4,2
	SBI  0x4,1
	SBI  0x4,0
; 000A 0024     MESSMODULE_DESELECT
	SBI  0x5,4
	SBI  0x5,3
	SBI  0x5,2
	SBI  0x5,1
	SBI  0x5,0
	nop
	nop
; 000A 0025 
; 000A 0026 }
	RET
;
;/*******************************************/
;// MESSMODUL_SPI()
;/*******************************************/
;// receive values of registers to temporarily structure
;// calibrate to electrical quantity, restrict
;// and save to permanent structure
;/*******************************************/
;void Messmodule_spi(byte nr_module){
; 000A 002F void Messmodule_spi(byte nr_module){
_Messmodule_spi:
; 000A 0030     byte i;
; 000A 0031 
; 000A 0032     //REGISTER Sturcture, temporarily
; 000A 0033     tMAXQ_REGISTERS sMaxq_registers;
; 000A 0034     tMAXQ_REGISTERS *pMaxq_registers = &sMaxq_registers;
; 000A 0035 
; 000A 0036     //ELECTRICAL QUANTITY, pointer to global structure
; 000A 0037     tMESSMODULE *pModule = &sMm.sModule[nr_module];
; 000A 0038 
; 000A 0039     //reset register structure
; 000A 003A     memset(&sMaxq_registers, 0, sizeof(tMAXQ_REGISTERS));
	SBIW R28,63
	SBIW R28,63
	SBIW R28,63
	SBIW R28,15
	CALL __SAVELOCR6
;	nr_module -> Y+210
;	i -> R17
;	sMaxq_registers -> Y+6
;	*pMaxq_registers -> R18,R19
;	*pModule -> R20,R21
	MOVW R30,R28
	ADIW R30,6
	MOVW R18,R30
	__GETB1SX 210
	CALL SUBOPT_0x1C
	MOVW R20,R30
	CALL SUBOPT_0x1D
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
; 000A 003B 
; 000A 003C     /*******************************************/
; 000A 003D     // GET VALUES FROM MAXIM
; 000A 003E     /*******************************************/
; 000A 003F 
; 000A 0040     //1F values
; 000A 0041     //read first values and get availibility(status)
; 000A 0042     pModule->status = maxq_read( AFE_LINEFR,      (byte *)&pMaxq_registers->linefr,  eTWO_BYTES);
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x1E
	MOVW R26,R20
	ST   X,R30
; 000A 0043 
; 000A 0044     //module not availible -> exit
; 000A 0045     if(pModule->status == -1){
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BRNE _0x140003
; 000A 0046         sMm.rest_flag = 1;
	RJMP _0x20A000B
; 000A 0047         return;
; 000A 0048     }
; 000A 0049 
; 000A 004A     //RAWTEMP
; 000A 004B     maxq_read( AFE_RAWTEMP,     (byte *)&(pMaxq_registers->rawtemp), eTWO_BYTES);
_0x140003:
	LDI  R30,LOW(3073)
	LDI  R31,HIGH(3073)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,2
	CALL SUBOPT_0x1F
; 000A 004C 
; 000A 004D     //V.X
; 000A 004E     maxq_read( AFE_V_A, pMaxq_registers->v_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2097)
	LDI  R31,HIGH(2097)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,12
	CALL SUBOPT_0x20
; 000A 004F     maxq_read( AFE_V_B, pMaxq_registers->v_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2098)
	LDI  R31,HIGH(2098)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,20
	CALL SUBOPT_0x20
; 000A 0050     maxq_read( AFE_V_C, pMaxq_registers->v_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2100)
	LDI  R31,HIGH(2100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,28
	CALL SUBOPT_0x20
; 000A 0051 
; 000A 0052     //I.X
; 000A 0053     maxq_read( AFE_I_A, pMaxq_registers->i_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2113)
	LDI  R31,HIGH(2113)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,44
	CALL SUBOPT_0x20
; 000A 0054     maxq_read( AFE_I_B, pMaxq_registers->i_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2114)
	LDI  R31,HIGH(2114)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,52
	CALL SUBOPT_0x20
; 000A 0055     maxq_read( AFE_I_C, pMaxq_registers->i_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2116)
	LDI  R31,HIGH(2116)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,60
	CALL SUBOPT_0x20
; 000A 0056     //maxq_read( AFE_I_N, pMaxq_registers->i_x[3], eEIGHT_BYTES);
; 000A 0057 
; 000A 0058     //POWER FACTOR
; 000A 0059     maxq_read( AFE_A_PF,        (byte *)&pMaxq_registers->pf[0],      eTWO_BYTES);
	LDI  R30,LOW(454)
	LDI  R31,HIGH(454)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,4
	CALL SUBOPT_0x1F
; 000A 005A     maxq_read( AFE_B_PF,        (byte *)&pMaxq_registers->pf[1],      eTWO_BYTES);
	LDI  R30,LOW(690)
	LDI  R31,HIGH(690)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,6
	CALL SUBOPT_0x1F
; 000A 005B     maxq_read( AFE_C_PF,        (byte *)&pMaxq_registers->pf[2],      eTWO_BYTES);
	LDI  R30,LOW(926)
	LDI  R31,HIGH(926)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,8
	CALL SUBOPT_0x1F
; 000A 005C 
; 000A 005D     //POWER
; 000A 005E     //real power
; 000A 005F     maxq_read( AFE_PWRP_A, pMaxq_registers->pwrp_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2049)
	LDI  R31,HIGH(2049)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-76)
	SBCI R31,HIGH(-76)
	CALL SUBOPT_0x20
; 000A 0060     maxq_read( AFE_PWRP_B, pMaxq_registers->pwrp_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2050)
	LDI  R31,HIGH(2050)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x20
; 000A 0061     maxq_read( AFE_PWRP_C, pMaxq_registers->pwrp_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2052)
	LDI  R31,HIGH(2052)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x20
; 000A 0062     //maxq_read( AFE_PWRP_T, pMaxq_registers->pwrp_x[3], eEIGHT_BYTES);
; 000A 0063     //apparent power
; 000A 0064     maxq_read( AFE_PWRS_A, pMaxq_registers->pwrs_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2081)
	LDI  R31,HIGH(2081)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-108)
	SBCI R31,HIGH(-108)
	CALL SUBOPT_0x20
; 000A 0065     maxq_read( AFE_PWRS_B, pMaxq_registers->pwrs_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2082)
	LDI  R31,HIGH(2082)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-116)
	SBCI R31,HIGH(-116)
	CALL SUBOPT_0x20
; 000A 0066     maxq_read( AFE_PWRS_C, pMaxq_registers->pwrs_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2084)
	LDI  R31,HIGH(2084)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-124)
	SBCI R31,HIGH(-124)
	CALL SUBOPT_0x20
; 000A 0067     //maxq_read( AFE_PWRS_T, pMaxq_registers->pwrs_x[3], eEIGHT_BYTES);
; 000A 0068 
; 000A 0069     //ENERGY
; 000A 006A     //activ energy
; 000A 006B     maxq_read( AFE_ENRP_A,     (byte *)&pMaxq_registers->enrp_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2161)
	LDI  R31,HIGH(2161)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-140)
	SBCI R31,HIGH(-140)
	CALL SUBOPT_0x20
; 000A 006C     maxq_read( AFE_ENRP_B,     (byte *)&pMaxq_registers->enrp_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2162)
	LDI  R31,HIGH(2162)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-148)
	SBCI R31,HIGH(-148)
	CALL SUBOPT_0x20
; 000A 006D     maxq_read( AFE_ENRP_C,     (byte *)&pMaxq_registers->enrp_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2164)
	LDI  R31,HIGH(2164)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-156)
	SBCI R31,HIGH(-156)
	CALL SUBOPT_0x20
; 000A 006E     //maxq_read( AFE_ENRP_T,     (byte *)&pMaxq_registers->enrp_x[3], eEIGHT_BYTES);
; 000A 006F     //apparent energy
; 000A 0070     maxq_read( AFE_ENRS_A,     (byte *)&pMaxq_registers->enrs_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2161)
	LDI  R31,HIGH(2161)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-172)
	SBCI R31,HIGH(-172)
	CALL SUBOPT_0x20
; 000A 0071     maxq_read( AFE_ENRS_B,     (byte *)&pMaxq_registers->enrs_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2162)
	LDI  R31,HIGH(2162)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-180)
	SBCI R31,HIGH(-180)
	CALL SUBOPT_0x20
; 000A 0072     maxq_read( AFE_ENRS_C,     (byte *)&pMaxq_registers->enrs_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2164)
	LDI  R31,HIGH(2164)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	SUBI R30,LOW(-188)
	SBCI R31,HIGH(-188)
	CALL SUBOPT_0x20
; 000A 0073     //maxq_read( AFE_ENRS_T,     (byte *)&pMaxq_registers->enrs_x[3], eEIGHT_BYTES);
; 000A 0074 
; 000A 0075 
; 000A 0076     //POWER - real registers
; 000A 0077     //active power
; 000A 0078     //maxq_read( AFE_A_ACT,     (byte *)&pMaxq_registers->act[0],   eFOUR_BYTES);
; 000A 0079     //maxq_read( AFE_B_ACT,     (byte *)&pMaxq_registers->act[1],   eFOUR_BYTES);
; 000A 007A     //maxq_read( AFE_C_ACT,     (byte *)&pMaxq_registers->act[2],   eFOUR_BYTES);
; 000A 007B     //apparent power
; 000A 007C     //maxq_read( AFE_A_APP,     (byte *)&pMaxq_registers->app[0],   eFOUR_BYTES);
; 000A 007D     //maxq_read( AFE_B_APP,     (byte *)&pMaxq_registers->app[1],   eFOUR_BYTES);
; 000A 007E     //maxq_read( AFE_C_APP,     (byte *)&pMaxq_registers->app[2],   eFOUR_BYTES);
; 000A 007F 
; 000A 0080     //ENERGY - real registers
; 000A 0081     //real positive energy
; 000A 0082     //maxq_read( AFE_A_EAPOS,     (byte *)&pMaxq_registers->eapos[0],   eFOUR_BYTES);
; 000A 0083     //maxq_read( AFE_B_EAPOS,     (byte *)&pMaxq_registers->eapos[1],   eFOUR_BYTES);
; 000A 0084     //maxq_read( AFE_C_EAPOS,     (byte *)&pMaxq_registers->eapos[2],   eFOUR_BYTES);
; 000A 0085     //real negative energy
; 000A 0086     //maxq_read( AFE_A_EANEG,     (byte *)&pMaxq_registers->eaneg[0], eFOUR_BYTES);
; 000A 0087     //maxq_read( AFE_B_EANEG,     (byte *)&pMaxq_registers->eaneg[1], eFOUR_BYTES);
; 000A 0088     //maxq_read( AFE_C_EANEG,     (byte *)&pMaxq_registers->eaneg[2], eFOUR_BYTES);
; 000A 0089 
; 000A 008A 
; 000A 008B     /*******************************************/
; 000A 008C     // CONVERT & RESTRICT & STORE THE VALUES
; 000A 008D     /*******************************************/
; 000A 008E     pModule->values.frequence =  pMaxq_registers->linefr;
	MOVW R26,R18
	CALL __GETW1P
	__PUTW1RNS 20,3
; 000A 008F     pModule->values.temperature =  pMaxq_registers->rawtemp / 76;
	MOVW R30,R18
	LDD  R26,Z+2
	LDD  R27,Z+3
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL __DIVW21U
	__PUTW1RNS 20,1
; 000A 0090 
; 000A 0091     //pres vsechny 3faze a nulak/total
; 000A 0092     for(i=0; i<4; i++){
	LDI  R17,LOW(0)
_0x140005:
	CPI  R17,4
	BRLO PC+3
	JMP _0x140006
; 000A 0093         dword unsigned_value;
; 000A 0094         signed long signed_value;
; 000A 0095 
; 000A 0096 
; 000A 0097         #ifdef MM_CALIBRATION_MODE
; 000A 0098             //these register have to be saved only for calibration
; 000A 0099             pModule->registers.v_x[i] =  (* (dword *) pMaxq_registers->v_x[i]) >> 8;
	SBIW R28,8
;	nr_module -> Y+218
;	sMaxq_registers -> Y+14
;	unsigned_value -> Y+4
;	signed_value -> Y+0
	MOVW R26,R20
	SUBI R26,LOW(-101)
	SBCI R27,HIGH(-101)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,12
	CALL SUBOPT_0x19
	CALL SUBOPT_0x22
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 009A             pModule->registers.i_x[i] =  (* (dword *) pMaxq_registers->i_x[i]) >> 8;
	MOVW R26,R20
	SUBI R26,LOW(-117)
	SBCI R27,HIGH(-117)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,44
	CALL SUBOPT_0x19
	CALL SUBOPT_0x22
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 009B             pModule->registers.pwrp_x[i] =  buffer2signed(pMaxq_registers->pwrp_x[i], 8);
	MOVW R26,R20
	SUBI R26,LOW(-133)
	SBCI R27,HIGH(-133)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	MOVW R26,R18
	SUBI R26,LOW(-76)
	SBCI R27,HIGH(-76)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x23
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 009C             pModule->registers.pwrs_x[i] =  buffer2signed(pMaxq_registers->pwrs_x[i], 8);
	MOVW R26,R20
	SUBI R26,LOW(-149)
	SBCI R27,HIGH(-149)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	MOVW R26,R18
	SUBI R26,LOW(-108)
	SBCI R27,HIGH(-108)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x23
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 009D             pModule->registers.enrp_x[i] =  buffer2signed(pMaxq_registers->enrp_x[i], 8)>>8;
	MOVW R26,R20
	SUBI R26,LOW(-165)
	SBCI R27,HIGH(-165)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	MOVW R26,R18
	SUBI R26,LOW(-140)
	SBCI R27,HIGH(-140)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __ASRD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 009E             pModule->registers.enrs_x[i] =  buffer2signed(pMaxq_registers->enrs_x[i], 8)>>8;
	MOVW R26,R20
	SUBI R26,LOW(-181)
	SBCI R27,HIGH(-181)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	MOVW R26,R18
	SUBI R26,LOW(-172)
	SBCI R27,HIGH(-172)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __ASRD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 009F             pModule->registers.pf_x[i] = pMaxq_registers->pf[i];
	MOVW R26,R20
	SUBI R26,LOW(-197)
	SBCI R27,HIGH(-197)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
; 000A 00A0         #endif
; 000A 00A1 
; 000A 00A2         //******************************************
; 000A 00A3         // CONVERT
; 000A 00A4         //*******************************************
; 000A 00A5 
; 000A 00A6         //VOLTAGE
; 000A 00A7         unsigned_value = (*(dword *)pMaxq_registers->v_x[i]) >> 8;
	ADIW R26,12
	CALL SUBOPT_0x19
	CALL SUBOPT_0x22
	__PUTD1S 4
; 000A 00A8         pModule->values.voltage[i] = (unsigned_value * VOLTAGE_CONVERSION) / 10000;
	MOVW R26,R20
	ADIW R26,5
	CALL SUBOPT_0x19
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0x311
	CALL SUBOPT_0x26
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 000A 00A9 
; 000A 00AA         //CURRENT
; 000A 00AB         unsigned_value = (*(dword *)pMaxq_registers->i_x[i]) >> 8;
	MOVW R26,R18
	ADIW R26,44
	CALL SUBOPT_0x19
	CALL SUBOPT_0x22
	__PUTD1S 4
; 000A 00AC         pModule->values.current[i] =  (unsigned_value * CURRENT_CONVERSION) / 10000;
	MOVW R26,R20
	ADIW R26,13
	CALL SUBOPT_0x19
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0x319
	CALL SUBOPT_0x26
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 000A 00AD 
; 000A 00AE         //POWER
; 000A 00AF         //activ power
; 000A 00B0         signed_value = buffer2signed(pMaxq_registers->pwrp_x[i], 8);
	MOVW R26,R18
	SUBI R26,LOW(-76)
	SBCI R27,HIGH(-76)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x23
	CALL __PUTD1S0
; 000A 00B1         pModule->values.power_act[i] = (signed_value * POWER_ACT_CONVERSION) / 100000;
	CALL SUBOPT_0x27
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 00B2 
; 000A 00B3         //apparent power
; 000A 00B4         //signed_value = buffer2signed(pModule->values.pwrs_x[i], 8)
; 000A 00B5         //pModule->values.energy[i]  = (signed_value * POWER_APP_CONVERSION) / 100000;
; 000A 00B6 
; 000A 00B7         //POWER FACTOR
; 000A 00B8         pModule->values.power_factor[i] = pMaxq_registers->pf[i];
	MOVW R30,R20
	ADIW R30,1
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	MOVW R26,R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
; 000A 00B9 
; 000A 00BA         //ENERGY
; 000A 00BB         //activ energy
; 000A 00BC         signed_value = buffer2signed(pMaxq_registers->enrp_x[i], 8);
	SUBI R26,LOW(-140)
	SBCI R27,HIGH(-140)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x23
	CALL __PUTD1S0
; 000A 00BD         pModule->values.energy_act[i]  = (signed_value * ENERGY_ACT_CONVERSION) / 100000;
	CALL SUBOPT_0x29
	CALL SUBOPT_0x21
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000A 00BE 
; 000A 00BF         //apparent energy
; 000A 00C0         //signed_value = buffer2signed(pModule->values.enrs_x[i], 8)
; 000A 00C1         //pModule->values.energy_app[i]  = (signed_value * ENERGY_APP_CONVERSION) / 100000;
; 000A 00C2 
; 000A 00C3         //******************************************
; 000A 00C4         // RESTRICTIONS
; 000A 00C5         //*******************************************
; 000A 00C6 
; 000A 00C7         //VOLTAGE
; 000A 00C8         if(pModule->values.voltage[i] < VOLTAGE_MIN)
	MOVW R26,R20
	ADIW R26,5
	MOV  R30,R17
	CALL SUBOPT_0x18
	SBIW R30,20
	BRSH _0x140007
; 000A 00C9             pModule->values.voltage[i] = 0;
	MOVW R26,R20
	ADIW R26,5
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2A
; 000A 00CA 
; 000A 00CB         //CURRENT
; 000A 00CC         if(pModule->values.current[i] < CURRENT_MIN)
_0x140007:
	MOVW R26,R20
	ADIW R26,13
	MOV  R30,R17
	CALL SUBOPT_0x18
	SBIW R30,5
	BRSH _0x140008
; 000A 00CD             pModule->values.current[i] = 0;
	MOVW R26,R20
	ADIW R26,13
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2A
; 000A 00CE 
; 000A 00CF         //POWER
; 000A 00D0         if(pModule->values.power_act[i] < POWER_ACT_MIN)
_0x140008:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BRGE _0x140009
; 000A 00D1             pModule->values.power_act[i] = 0;
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
; 000A 00D2         if(pModule->values.power_app[i] < POWER_APP_MIN)
_0x140009:
	MOVW R26,R20
	ADIW R26,37
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BRGE _0x14000A
; 000A 00D3             pModule->values.power_app[i] = 0;
	MOVW R26,R20
	ADIW R26,37
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
; 000A 00D4 
; 000A 00D5         //ENERGY
; 000A 00D6         if(pModule->values.energy_act[i] < ENERGY_ACT_MIN)
_0x14000A:
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BRGE _0x14000B
; 000A 00D7             pModule->values.energy_act[i] = 0;
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
; 000A 00D8         if(pModule->values.energy_app[i] < ENERGY_APP_MIN)
_0x14000B:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BRGE _0x14000C
; 000A 00D9             pModule->values.energy_app[i] = 0;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
; 000A 00DA     }
_0x14000C:
	ADIW R28,8
	SUBI R17,-1
	RJMP _0x140005
_0x140006:
; 000A 00DB 
; 000A 00DC     sMm.rest_flag = 1;
_0x20A000B:
	LDI  R30,LOW(1)
	__PUTB1MN _sMm,854
; 000A 00DD }
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,63
	ADIW R28,63
	ADIW R28,22
	RET
;
;/*******************************************/
;// MESSMODUL_MANAGER()
;/*******************************************/
;// process function
;/*******************************************/
;void Messmodul_Manager(){
; 000A 00E4 void Messmodul_Manager(){
_Messmodul_Manager:
; 000A 00E5 
; 000A 00E6     //next module
; 000A 00E7     sMm.nr_current_module++;
	__GETB1MN _sMm,853
	SUBI R30,-LOW(1)
	__PUTB1MN _sMm,853
	SUBI R30,LOW(1)
; 000A 00E8 
; 000A 00E9     //NEW ROUND, set first messmodule
; 000A 00EA     if(sMm.nr_current_module == NR_MESSMODULES){
	__GETB2MN _sMm,853
	CPI  R26,LOW(0x4)
	BRNE _0x14000D
; 000A 00EB 
; 000A 00EC         //set first module
; 000A 00ED         sMm.nr_current_module = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _sMm,853
; 000A 00EE 
; 000A 00EF         //nr of available modules
; 000A 00F0         sMm.nr_available_modules = Messmodul_countAvailable();
	RCALL _Messmodul_countAvailable
	__PUTB1MN _sMm,852
; 000A 00F1 
; 000A 00F2     }
; 000A 00F3 
; 000A 00F4     //set CS
; 000A 00F5     MESSMODULE_SELECT(sMm.nr_current_module)
_0x14000D:
	__GETB1MN _sMm,853
	CPI  R30,0
	BRNE _0x140011
	CBI  0x5,3
	RJMP _0x140010
_0x140011:
	CPI  R30,LOW(0x1)
	BRNE _0x140012
	CBI  0x5,2
	RJMP _0x140010
_0x140012:
	CPI  R30,LOW(0x2)
	BRNE _0x140013
	CBI  0x5,1
	RJMP _0x140010
_0x140013:
	CPI  R30,LOW(0x3)
	BRNE _0x140015
	CBI  0x5,0
_0x140015:
_0x140010:
; 000A 00F6 
; 000A 00F7     //receive, convert and store data from module
; 000A 00F8     Messmodule_spi(sMm.nr_current_module);
	__GETB1MN _sMm,853
	ST   -Y,R30
	RCALL _Messmodule_spi
; 000A 00F9 
; 000A 00FA     //clear CS
; 000A 00FB     MESSMODULE_DESELECT
	SBI  0x5,4
	SBI  0x5,3
	SBI  0x5,2
	SBI  0x5,1
	SBI  0x5,0
	nop
	nop
; 000A 00FC 
; 000A 00FD }
	RET
;
;
;/*******************************************/
;// MESSMODUL_REST()
;/*******************************************/
;// "while fuction", print debug messages
;/*******************************************/
;void Messmodul_Rest(){
; 000A 0105 void Messmodul_Rest(){
; 000A 0106 
; 000A 0107     if(sMm.rest_flag){
; 000A 0108         tMESSMODULE *pModule = &sMm.sModule[sMm.nr_current_module];
; 000A 0109         //print values
; 000A 010A         printf("\n============");
;	*pModule -> Y+0
; 000A 010B         printf("\nmessmodul nr.%u", sMm.nr_current_module+1);
; 000A 010C         printf("\n============");
; 000A 010D         //printf("\nfrequence: %u.%u Hz", pModule->values.frequence/1000, pModule->values.frequence%1000);
; 000A 010E         printf("\ntemperature: %d.%d°C", pModule->values.temperature / 10, abs(pModule->values.temperature % 10));
; 000A 010F 
; 000A 0110         //printf("\ncurrent: %ld | %ld | %ld",  pModule->values.current[0], pModule->values.current[1], pModule->values.current[2]);
; 000A 0111         //printf("\nvoltage: %ld | %ld | %ld",  pModule->values.voltage[0], pModule->values.voltage[1], pModule->values.voltage[2]);
; 000A 0112         printf("\npf: %ld | %ld | %ld",  pModule->values.power_factor[0], pModule->values.power_factor[1], pModule->values.power_factor[2]);
; 000A 0113 
; 000A 0114         //printf("\nCC: volt:%d, amp:%d", pModule->values.volt_cc, pModule->values.amp_cc);
; 000A 0115         //printf("\nPF: %d, %d, %d", pModule->values.pf[0], pModule->values.pf[1], pModule->values.pf[2]);
; 000A 0116         //printf("\nPF: %ld, %ld, %ld", pModule->values.pf[0], pModule->values.pf[1], pModule->values.pf[2]);
; 000A 0117         //printf("\nVRMS: 0x%lx, 0x%lx, 0x%lx", pModule->values.vrms[0], pModule->values.vrms[1], pModule->values.vrms[2]);
; 000A 0118         //printf("\nIRMS: 0x%lx, 0x%lx, 0x%lx", pModule->values.irms[0], pModule->values.irms[1], pModule->values.irms[2]);
; 000A 0119         //printf("\nACT: %ld, %ld, %ld", pModule->values.act[0], pModule->values.act[1], pModule->values.act[2]);
; 000A 011A         //printf("\nACT: %x, %x, %x", pModule->values.act[0], pModule->values.act[1], pModule->values.act[2]);
; 000A 011B         //printf("\nACT: %lx, %lx, %lx", pModule->values.act[0], pModule->values.act[1], pModule->values.act[2]);
; 000A 011C         //printf("\nACT: %ld, %ld, %ld", pModule->values.act[0], pModule->values.act[1], pModule->values.act[2]);
; 000A 011D         //printf("\nEAPOS: %lx, %lx, %lx", pModule->values.eapos[0], pModule->values.eapos[1], pModule->values.eapos[2]);
; 000A 011E         //printf("\nEANEG: %lx, %lx, %lx", pModule->values.eaneg[0], pModule->values.eaneg[1], pModule->values.eaneg[2]);
; 000A 011F         //printf("\nvoltage: %u, %u, %u", pModule->values.voltage[0], pModule->values.voltage[1], pModule->values.voltage[2]);
; 000A 0120         //printf("\npwrp: 0x%ld, 0x%ld | 0x%ld,  0x%ld | 0x%ld,  0x%ld",  *(dword *)pModule->values.pwrp_x[0], *((dword *)pModule->values.pwrp_x[0]+1), *(dword *)pModule->values.pwrp_x[1], *((dword *)pModule->values.pwrp_x[1]+1), *(dword *)pModule->values.pwrp_x[2], *((dword *)pModule->values.pwrp_x[2]+1));
; 000A 0121         //printf("\nvrms: %ld | %ld | %ld",  pModule->values.vrms[0],  pModule->values.vrms[1], pModule->values.vrms[2]);
; 000A 0122         //printf("\nirms: %ld | %ld | %ld",  pModule->values.irms[0],  pModule->values.irms[1], pModule->values.irms[2]);
; 000A 0123         //printf("\nvrms: %ld",  pModule->values.vrms[0]);
; 000A 0124         //printf("\nv_x: %ld | %ld",  *(dword *)&(pModule->values.v_x[0][0]), *(dword *)&(pModule->values.v_x[0][4]));
; 000A 0125         //printf("\nv_x: %x,%x,%x,%x,%x,%x,%x,%x", pModule->values.v_x[0][0], pModule->values.v_x[0][1], pModule->values.v_x[0][2], pModule->values.v_x[0][3], pModule->values.v_x[0][4], pModule->values.v_x[0][5], pModule->values.v_x[0][6], pModule->values.v_x[0][7]);
; 000A 0126         //printf("\nv_x: %ld", buffer2signed(pModule->values.v_x[0],8));
; 000A 0127         //printf("\ncurrent A: 0x%ld, 0x%ld | 0x%ld,  0x%lx | 0x%lx,  0x%lx", *(dword *)pModule->values.current[0], *((dword *)pModule->values.current[0]+1),*(dword *)pModule->values.current[1], *((dword *)pModule->values.current[1]+1),*(dword *)pModule->values.current[2], *((dword *)pModule->values.current[2]+1));
; 000A 0128 
; 000A 0129         sMm.rest_flag = 0;
; 000A 012A     }
; 000A 012B }
;
;//GET COUNT OF AVAILABLE MODULES
;byte Messmodul_countAvailable(){
; 000A 012E byte Messmodul_countAvailable(){
_Messmodul_countAvailable:
; 000A 012F     byte i, aux_nr = 0;
; 000A 0130 
; 000A 0131     //check available modules
; 000A 0132     for(i=0; i<NR_MESSMODULES;i++)      //over all modules
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	aux_nr -> R16
	LDI  R16,0
	LDI  R17,LOW(0)
_0x140018:
	CPI  R17,4
	BRSH _0x140019
; 000A 0133         if(sMm.sModule[i].status != -1) //available? (variable status is managed in Messmodul_spi())
	LDI  R26,LOW(213)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sMm)
	SBCI R31,HIGH(-_sMm)
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BREQ _0x14001A
; 000A 0134             aux_nr++;
	SUBI R16,-1
; 000A 0135 
; 000A 0136     return aux_nr;
_0x14001A:
	SUBI R17,-1
	RJMP _0x140018
_0x140019:
	MOV  R30,R16
_0x20A000A:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 000A 0137 }
;
;//GET COUNT OF AVAILABLE VOLTAGES FOR MESSMODUL
;byte Messmodul_getCountVoltage(byte nr_messmodul){
; 000A 013A byte Messmodul_getCountVoltage(byte nr_messmodul){
_Messmodul_getCountVoltage:
; 000A 013B     byte i,aux_count = 0;
; 000A 013C     tMESSMODULE *pModule = &sMm.sModule[nr_messmodul];
; 000A 013D 
; 000A 013E     for(i=0; i<3; i++)
	CALL SUBOPT_0x2F
;	nr_messmodul -> Y+4
;	i -> R17
;	aux_count -> R16
;	*pModule -> R18,R19
	MOVW R18,R30
	LDI  R17,LOW(0)
_0x14001C:
	CPI  R17,3
	BRSH _0x14001D
; 000A 013F         if(pModule->values.voltage[i])
	MOVW R26,R18
	ADIW R26,5
	MOV  R30,R17
	CALL SUBOPT_0x18
	SBIW R30,0
	BREQ _0x14001E
; 000A 0140             aux_count++;
	SUBI R16,-1
; 000A 0141 
; 000A 0142     return aux_count;
_0x14001E:
	SUBI R17,-1
	RJMP _0x14001C
_0x14001D:
	RJMP _0x20A0008
; 000A 0143 }
;
;//GET COUNT OF AVAILABLE CURRENTS FOR MESSMODUL
;byte Messmodul_getCountCurrent(byte nr_messmodul){
; 000A 0146 byte Messmodul_getCountCurrent(byte nr_messmodul){
_Messmodul_getCountCurrent:
; 000A 0147     byte i,aux_count = 0;
; 000A 0148     tMESSMODULE *pModule = &sMm.sModule[nr_messmodul];
; 000A 0149 
; 000A 014A     for(i=0; i<3; i++)
	CALL SUBOPT_0x2F
;	nr_messmodul -> Y+4
;	i -> R17
;	aux_count -> R16
;	*pModule -> R18,R19
	MOVW R18,R30
	LDI  R17,LOW(0)
_0x140020:
	CPI  R17,3
	BRSH _0x140021
; 000A 014B         if(pModule->values.current[i])
	MOVW R26,R18
	ADIW R26,13
	MOV  R30,R17
	CALL SUBOPT_0x18
	SBIW R30,0
	BREQ _0x140022
; 000A 014C             aux_count++;
	SUBI R16,-1
; 000A 014D 
; 000A 014E     return aux_count;
_0x140022:
	SUBI R17,-1
	RJMP _0x140020
_0x140021:
_0x20A0008:
	MOV  R30,R16
	CALL __LOADLOCR4
_0x20A0009:
	ADIW R28,5
	RET
; 000A 014F }
;
;//bit 63 is the sign
;//otherwise 4 most significat bytes are zero
;signed long buffer2signed(byte *pBuffer, byte length){
; 000A 0153 signed long buffer2signed(byte *pBuffer, byte length){
_buffer2signed:
; 000A 0154 
; 000A 0155      //most significant bit is the sign
; 000A 0156      byte my_sign = *(pBuffer + (length-1)) & 0x80 ? 1 : 0;
; 000A 0157      return  (signed long)(my_sign ? -*(unsigned long *)pBuffer : *(unsigned long *)pBuffer);
	ST   -Y,R17
;	*pBuffer -> Y+2
;	length -> Y+1
;	my_sign -> R17
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ANDI R30,LOW(0x80)
	BREQ _0x140023
	LDI  R30,LOW(1)
	RJMP _0x140024
_0x140023:
	LDI  R30,LOW(0)
_0x140024:
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x140026
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETD1P
	CALL __ANEGD1
	RJMP _0x140027
_0x140026:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETD1P
_0x140027:
	LDD  R17,Y+0
	JMP  _0x20A0004
; 000A 0158 }
;//**********************************************************************************************
;// display.c
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// Display_Manager()
;// - bere obrazovky z display_screens.c a zobrazuje je na display
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <types.h>
;#include <stdio.h>
;#include <utils.h>
;
;#include <NT7534.h>
;#include <display_manager.h>
;#include "display_screens.h"
;
;tDISPLAY sDisplay;
;
;void rot_inc(byte *var, byte max);
;void rot_dec(byte *var, byte max);
;void Disp_next_screen();
;void Disp_previous_screen();
;
;void Display_Init(){
; 000B 0019 void Display_Init(){

	.CSEG
_Display_Init:
; 000B 001A 
; 000B 001B //    for(i=0; i<NR_ROWS; i++)
; 000B 001C //        sDisplay.pRows[i] = sDisplay.rows_text[i];
; 000B 001D 
; 000B 001E     sDisplay.screen_index = 0;
	LDI  R30,LOW(0)
	STS  _sDisplay,R30
; 000B 001F     //sDisplay.current_screen_function = sSCREEN_GROUP[0].function;
; 000B 0020 
; 000B 0021 
; 000B 0022     //init display
; 000B 0023     NT7534_Init();
	CALL _NT7534_Init
; 000B 0024 
; 000B 0025 
; 000B 0026 }
	RET
;
;void Display_Manager(){
; 000B 0028 void Display_Manager(){
_Display_Manager:
; 000B 0029     byte* pRows[NR_ROWS] = {    "                      ", //21
; 000B 002A                                 "                      ",
; 000B 002B                                 "                      ",
; 000B 002C                                 "                      ",
; 000B 002D                                 "                      ",
; 000B 002E                                 "                      ",
; 000B 002F                                 "                      ",
; 000B 0030                                 "                      "};
; 000B 0031 
; 000B 0032 //    sprintf(sDisplay.rows_text[0], "nulovy");
; 000B 0033 //    sprintf(sDisplay.rows_text[1], "prvy");
; 000B 0034 //    sprintf(sDisplay.rows_text[2], "treti");
; 000B 0035 //    sprintf(sDisplay.rows_text[3], "ctvrty");
; 000B 0036 
; 000B 0037     //sDisplay.current_screen_function(sDisplay.pRows);
; 000B 0038 
; 000B 0039     //sSCREEN_GROUP[sDisplay.screen_index].function(pRows);
; 000B 003A 
; 000B 003B     //funkce z indexu naplni stringy
; 000B 003C     Display_screens_setStrings(sDisplay.screen_index, pRows);
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x160004*2)
	LDI  R31,HIGH(_0x160004*2)
	CALL __INITLOCB
;	pRows -> Y+0
	LDS  R30,_sDisplay
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Display_screens_setStrings
; 000B 003D 
; 000B 003E     //incrementy screen
; 000B 003F     //Disp_next_screen();
; 000B 0040     //rot_inc(&sDisplay.screen_index, NR_SCREEN-1);
; 000B 0041 
; 000B 0042     //set screen
; 000B 0043     NT7534_set_screen(pRows);
	CALL SUBOPT_0x30
	CALL _NT7534_set_screen
; 000B 0044     //NT7534_set_paging(sDisplay.screen_index+1, NR_SCREEN);
; 000B 0045 
; 000B 0046 //    printf("\n screen");
; 000B 0047 //    for(i=0; i<NR_ROWS; i++){
; 000B 0048 //        printf("%s", sDisplay.rows_text[i]);
; 000B 0049 //    }
; 000B 004A 
; 000B 004B }
	ADIW R28,16
	RET

	.DSEG
_0x160003:
	.BYTE 0xB8
;
;
;void Disp_next_screen(){
; 000B 004E void Disp_next_screen(){

	.CSEG
_Disp_next_screen:
; 000B 004F     rot_inc(&sDisplay.screen_index, NR_SCREEN-1);
	CALL SUBOPT_0x31
	CALL _rot_inc
; 000B 0050 }
	RET
;
;void Disp_previous_screen(){
; 000B 0052 void Disp_previous_screen(){
_Disp_previous_screen:
; 000B 0053     rot_dec(&sDisplay.screen_index, NR_SCREEN-1);
	CALL SUBOPT_0x31
	CALL _rot_dec
; 000B 0054 }
	RET
;
;
;
;//**********************************************************************************************
;// display_screen.c
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// - uzivatelske screeny
;// - sf (screen function) naplni X stringu daty
;//      - STRNCPY() proti preteceni
;//      - vraci dalsi volny radek (vstup pro getFooter())
;// - SCREEN_GROUP potom definuje jake obrazovky a v jakem poradi se zobrazuji
;//**********************************************************************************************
;
;#include <stdlib.h>
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <types.h>
;#include <stdio.h>
;#include <string.h>
;#include <math.h>
;
;#include <NT7534.h>
;#include <display_manager.h>
;#include <display_screens.h>
;#include <messmodules.h>
;//#include "comm_xport.h"
;
;byte sf_board(byte* pTexts[NR_ROWS]);
;byte sf_modules(byte* pTexts[NR_ROWS]);
;byte sf_resume(byte* pTexts[NR_ROWS]);
;
;//SCREEN FUNCTIONs
;byte sf_voltages(byte* pTexts[NR_ROWS]);
;byte sf_currents(byte* pTexts[NR_ROWS]);
;byte sf_powers(byte* pTexts[NR_ROWS]);
;byte sf_powers_act(byte* pTexts[NR_ROWS]);
;byte sf_powers_app(byte* pTexts[NR_ROWS]);
;byte sf_energies_act(byte* pTexts[NR_ROWS]);
;byte sf_energies_app(byte* pTexts[NR_ROWS]);
;byte sf_powerfactors(byte* pTexts[NR_ROWS]);
;
;
;flash tSCREEN sSCREEN_GROUP[NR_SCREEN] = {
;    {"BOARD", sf_board},
;    {"MODULES", sf_modules},
;    {"RESUME", sf_resume},
;    {"VOLTAGE", sf_voltages},
;    {"CURRENT", sf_currents},
;    {"POWERFACTOR", sf_powerfactors},
;    {"POWER ACT", sf_powers_act},
;    {"POWER APP", sf_powers_app},
;    {"ENERGY ACT", sf_energies_act},
;    {"ENERGY APP", sf_energies_app}
;};
;
;
;tSCREEN_DATA sScreen_data;
;
;#define AUX_STRING_SIZE     40
;
;// GET_HEADER
;// title, underline
;void getHeader(byte screen_index, byte* pTexts[NR_ROWS]){
; 000C 003C void getHeader(byte screen_index, byte* pTexts[8]){

	.CSEG
_getHeader:
; 000C 003D     byte aux_string[AUX_STRING_SIZE];
; 000C 003E 
; 000C 003F     //check string length
; 000C 0040     if(strlenf(sSCREEN_GROUP[screen_index].title)>TITLE_SIZE)
	SBIW R28,40
;	screen_index -> Y+42
;	pTexts -> Y+40
;	aux_string -> Y+0
	LDD  R30,Y+42
	CALL SUBOPT_0x32
	CALL _strlenf
	SBIW R30,16
	BRSH _0x20A0007
; 000C 0041         return;
; 000C 0042 
; 000C 0043     //title
; 000C 0044     strcpyf(aux_string , "        "); strcatf(aux_string, sSCREEN_GROUP[screen_index].title); strcatf(aux_string, "     ");
	CALL SUBOPT_0x30
	__POINTW1FN _0x180000,0
	CALL SUBOPT_0x33
	LDD  R30,Y+44
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	__POINTW1FN _0x180000,3
	CALL SUBOPT_0x35
; 000C 0045     strncpy(pTexts[0], aux_string, NR_COLUMNS);
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
; 000C 0046 
; 000C 0047     //underline
; 000C 0048     strncpyf(pTexts[1] ,"      ============    ", NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	__POINTW1FN _0x180000,9
	CALL SUBOPT_0x38
; 000C 0049 
; 000C 004A }
_0x20A0007:
	ADIW R28,43
	RET
;
;// GET_FOOTER
;// clear unused rows, pagging
;void getFooter(byte first_unused_row, byte screen_index, byte* pTexts[NR_ROWS]){
; 000C 004E void getFooter(byte first_unused_row, byte screen_index, byte* pTexts[8]){
_getFooter:
; 000C 004F     byte i;
; 000C 0050     byte aux_string[AUX_STRING_SIZE];
; 000C 0051 
; 000C 0052     //clear unused rows
; 000C 0053     for(i=first_unused_row; i<(NR_ROWS-1); i++)
	SBIW R28,40
	ST   -Y,R17
;	first_unused_row -> Y+44
;	screen_index -> Y+43
;	pTexts -> Y+41
;	i -> R17
;	aux_string -> Y+1
	LDD  R17,Y+44
_0x180005:
	CPI  R17,7
	BRSH _0x180006
; 000C 0054         strncpyf(pTexts[i] , "                    ", NR_COLUMNS);
	MOV  R30,R17
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	CALL SUBOPT_0x18
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x180000,32
	CALL SUBOPT_0x38
	SUBI R17,-1
	RJMP _0x180005
_0x180006:
; 000C 0057 sprintf(aux_string, "                 %u/%u", screen_index+1, 10);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x180000,53
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+47
	CALL SUBOPT_0x39
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3A
; 000C 0058     strncpy(pTexts[NR_ROWS-1], aux_string, NR_COLUMNS);
	LDD  R30,Y+41
	LDD  R31,Y+41+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	MOVW R30,R28
	ADIW R30,3
	CALL SUBOPT_0x3B
; 000C 0059 
; 000C 005A }
	LDD  R17,Y+0
	ADIW R28,45
	RET
;
;//SET_STRINGS
;//global function, set all strings
;void Display_screens_setStrings(byte screen_index, byte* pTexts[NR_ROWS]){
; 000C 005E void Display_screens_setStrings(byte screen_index, byte* pTexts[8]){
_Display_screens_setStrings:
; 000C 005F     byte nr_row;
; 000C 0060 
; 000C 0061     //title, underline (row 0,1)
; 000C 0062     getHeader(screen_index, pTexts);
	ST   -Y,R17
;	screen_index -> Y+3
;	pTexts -> Y+1
;	nr_row -> R17
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _getHeader
; 000C 0063 
; 000C 0064     nr_row = sSCREEN_GROUP[screen_index].function(pTexts);
	LDD  R30,Y+3
	LDI  R26,LOW(17)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sSCREEN_GROUP*2)
	SBCI R31,HIGH(-_sSCREEN_GROUP*2)
	ADIW R30,15
	CALL __GETW1PF
	PUSH R31
	PUSH R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	POP  R30
	POP  R31
	ICALL
	MOV  R17,R30
; 000C 0065 
; 000C 0066     //clear unused rows, pagging
; 000C 0067     getFooter(nr_row, screen_index, pTexts);
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _getFooter
; 000C 0068 }
	LDD  R17,Y+0
	JMP  _0x20A0004
;
;
;//******************************************
;// SCREEN FUNCTIONS
;//*******************************************
;
;// BOARD
;byte sf_board(byte* pTexts[NR_ROWS]){
; 000C 0070 byte sf_board(byte* pTexts[8]){
_sf_board:
; 000C 0071     byte aux_string[AUX_STRING_SIZE];
; 000C 0072 
; 000C 0073     strcpyf(aux_string , " HW ver.: "); strcatf(aux_string, HW_VERSION_S); strcatf(aux_string, "      ");
	SBIW R28,40
;	pTexts -> Y+40
;	aux_string -> Y+0
	CALL SUBOPT_0x30
	__POINTW1FN _0x180000,76
	CALL SUBOPT_0x33
	__POINTW1FN _0x180000,87
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x34
	__POINTW1FN _0x180000,2
	CALL SUBOPT_0x35
; 000C 0074     strncpy(pTexts[2], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x37
; 000C 0075 
; 000C 0076     strcpyf(aux_string , " SW ver.: "); strcatf(aux_string, SW_VERSION_S); strcatf(aux_string, "      ");
	CALL SUBOPT_0x30
	__POINTW1FN _0x180000,92
	CALL SUBOPT_0x33
	__POINTW1FN _0x180000,103
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x34
	__POINTW1FN _0x180000,2
	CALL SUBOPT_0x35
; 000C 0077     strncpy(pTexts[3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x3D
; 000C 0078 
; 000C 0079     strncpyf(pTexts[4], "                     ", NR_COLUMNS);
	CALL SUBOPT_0x3E
; 000C 007A 
; 000C 007B     //sprintf(aux_string ," IP: %3u.%3u.%3u.%3u        ", sXport.ip_address[0], sXport.ip_address[1], sXport.ip_address[2], sXport.ip_address[3]);
; 000C 007C     strncpy(pTexts[5], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x3F
; 000C 007D 
; 000C 007E     //sprintf(aux_string ," MAC: %02X%02X%02X%02X%02X%02X   ", sXport.mac_address[0], sXport.mac_address[1], sXport.mac_address[2], sXport.mac_address[3], sXport.mac_address[4], sXport.mac_address[5]);
; 000C 007F     strncpy(pTexts[6], aux_string, NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x37
; 000C 0080 
; 000C 0081     return NR_ROWS-1;
	LDI  R30,LOW(7)
	RJMP _0x20A0006
; 000C 0082 }
;
;// MODULES
;byte sf_modules(byte* pTexts[NR_ROWS]){
; 000C 0085 byte sf_modules(byte* pTexts[8]){
_sf_modules:
; 000C 0086     byte aux_string[AUX_STRING_SIZE];
; 000C 0087 
; 000C 0088     strncpyf(pTexts[2] ,"                     ", NR_COLUMNS);
	SBIW R28,40
;	pTexts -> Y+40
;	aux_string -> Y+0
	CALL SUBOPT_0x3C
	__POINTW1FN _0x180000,108
	CALL SUBOPT_0x38
; 000C 0089 
; 000C 008A     sprintf(aux_string ,"    Available: %u      ", sMm.nr_available_modules);
	CALL SUBOPT_0x30
	__POINTW1FN _0x180000,130
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _sMm,852
	CALL SUBOPT_0x40
; 000C 008B     strncpy(pTexts[3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x3D
; 000C 008C 
; 000C 008D     strncpyf(pTexts[4] ,"                     ", NR_COLUMNS);
	CALL SUBOPT_0x3E
; 000C 008E 
; 000C 008F     //selected module
; 000C 0090     sprintf(aux_string ,"    Selected: M%u      ", sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x30
	__POINTW1FN _0x180000,154
	CALL SUBOPT_0x41
	CALL SUBOPT_0x39
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 000C 0091     strncpy(pTexts[5], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x3F
; 000C 0092 
; 000C 0093     return NR_ROWS-2;
	LDI  R30,LOW(6)
_0x20A0006:
	ADIW R28,42
	RET
; 000C 0094 }
;
;// RESUME
;byte sf_resume(byte* pTexts[NR_ROWS]){
; 000C 0097 byte sf_resume(byte* pTexts[8]){
_sf_resume:
; 000C 0098 
; 000C 0099     byte aux_string[AUX_STRING_SIZE];
; 000C 009A     tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 009B 
; 000C 009C     sprintf(aux_string ," U lines: %u         ", Messmodul_getCountVoltage(sScreen_data.nr_selected_module));
	SBIW R28,40
	ST   -Y,R17
	ST   -Y,R16
;	pTexts -> Y+42
;	aux_string -> Y+2
;	*pModule -> R16,R17
	CALL SUBOPT_0x42
	MOVW R16,R30
	CALL SUBOPT_0x43
	__POINTW1FN _0x180000,178
	CALL SUBOPT_0x41
	ST   -Y,R30
	CALL _Messmodul_getCountVoltage
	CALL SUBOPT_0x40
; 000C 009D     strncpy(pTexts[2], aux_string, NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
; 000C 009E 
; 000C 009F     sprintf(aux_string ," I lines: %u         ", Messmodul_getCountCurrent(sScreen_data.nr_selected_module));
	CALL SUBOPT_0x43
	__POINTW1FN _0x180000,200
	CALL SUBOPT_0x41
	ST   -Y,R30
	CALL _Messmodul_getCountCurrent
	CALL SUBOPT_0x40
; 000C 00A0     strncpy(pTexts[3], aux_string, NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	CALL SUBOPT_0x46
; 000C 00A1 
; 000C 00A2     strncpyf(pTexts[4] ,"                          ", NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	LDD  R26,Z+8
	LDD  R27,Z+9
	ST   -Y,R27
	ST   -Y,R26
	__POINTW1FN _0x180000,222
	CALL SUBOPT_0x38
; 000C 00A3 
; 000C 00A4     sprintf(aux_string ," Frequence: %u.%u Hz      ", pModule->values.frequence/1000, pModule->values.frequence%1000);
	CALL SUBOPT_0x43
	__POINTW1FN _0x180000,249
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	LDD  R26,Z+3
	LDD  R27,Z+4
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x47
	LDD  R26,Z+3
	LDD  R27,Z+4
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x48
; 000C 00A5     strncpy(pTexts[5], aux_string, NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	LDD  R26,Z+10
	LDD  R27,Z+11
	CALL SUBOPT_0x46
; 000C 00A6 
; 000C 00A7     sprintf(aux_string ," Temperature: %u.%u°C      ", pModule->values.temperature/10,pModule->values.temperature%10);
	CALL SUBOPT_0x43
	__POINTW1FN _0x180000,276
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	LDD  R26,Z+1
	LDD  R27,Z+2
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x47
	LDD  R26,Z+1
	LDD  R27,Z+2
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x48
; 000C 00A8     strncpy(pTexts[6], aux_string, NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	CALL SUBOPT_0x46
; 000C 00A9 
; 000C 00AA     return NR_ROWS-1;
	LDI  R30,LOW(7)
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,44
	RET
; 000C 00AB 
; 000C 00AC }
;
;/*******************************************/
;// VOLTAGES
;/*******************************************/
;#ifndef MM_CALIBRATION_MODE
;    //NORMAL FUNCTION
;    byte sf_voltages(byte* pTexts[NR_ROWS]){
;        byte aux_string[AUX_STRING_SIZE];
;        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
;        word i;
;
;        strncpyf(pTexts[2] ,"                     ", NR_COLUMNS);
;
;        for(i=0; i<3;i++){
;            sprintf(aux_string ,"    L%u: %u.%u [V]   M%u  ", i+1, pModule->values.voltage[i]/10, pModule->values.voltage[i]%10, sScreen_data.nr_selected_module+1);
;            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
;        }
;
;        return NR_ROWS-2;
;    }
;#else
;    //CALIBRATION FUNCTION
;    byte sf_voltages(byte* pTexts[NR_ROWS]){
; 000C 00C3 byte sf_voltages(byte* pTexts[8]){
_sf_voltages:
; 000C 00C4         byte aux_string[AUX_STRING_SIZE];
; 000C 00C5         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 00C6         word i;
; 000C 00C7 
; 000C 00C8         strncpyf(pTexts[2] ,"                     ", NR_COLUMNS);
	CALL SUBOPT_0x49
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x4A
	__POINTW1FN _0x180000,108
	CALL SUBOPT_0x38
; 000C 00C9 
; 000C 00CA 
; 000C 00CB         for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x180008:
	__CPWRN 18,19,3
	BRSH _0x180009
; 000C 00CC             sprintf(aux_string ," %6lu, %u.%u [V]   M%u  ", pModule->registers.v_x[i], pModule->values.voltage[i]/10, pModule->values.voltage[i]%10, sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x4B
	__POINTW1FN _0x180000,304
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-101)
	SBCI R27,HIGH(-101)
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4D
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
; 000C 00CD             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 000C 00CE         }
	__ADDWRN 18,19,1
	RJMP _0x180008
_0x180009:
; 000C 00CF 
; 000C 00D0 
; 000C 00D1         return NR_ROWS-2;
	RJMP _0x20A0005
; 000C 00D2     }
;#endif
;
;/*******************************************/
;// CURRENTS
;/*******************************************/
;#ifndef MM_CALIBRATION_MODE
;    //NORMAL FUNCTION
;    byte sf_currents(byte* pTexts[NR_ROWS]){
;        byte aux_string[AUX_STRING_SIZE];
;        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
;        word i;
;
;
;        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
;
;        for(i=0; i<3;i++){
;            sprintf(aux_string ,"    L%u: %u.%02u [A] M%u  ", i+1, pModule->values.current[i]/100, pModule->values.current[i]%100, sScreen_data.nr_selected_module+1);
;            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
;        }
;
;        return NR_ROWS-2;
;
;    }
;#else
;    //CALIBRATION FUNCTION
;    byte sf_currents(byte* pTexts[NR_ROWS]){
; 000C 00EC byte sf_currents(byte* pTexts[8]){
_sf_currents:
; 000C 00ED         byte aux_string[AUX_STRING_SIZE];
; 000C 00EE         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 00EF         word i;
; 000C 00F0 
; 000C 00F1 
; 000C 00F2         strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x49
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x53
; 000C 00F3 
; 000C 00F4         for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x18000B:
	__CPWRN 18,19,3
	BRSH _0x18000C
; 000C 00F5             sprintf(aux_string ," %6lu, %u.%02u [A] M%u  ",  pModule->registers.i_x[i], pModule->values.current[i]/100, pModule->values.current[i]%100, sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x4B
	__POINTW1FN _0x180000,329
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-117)
	SBCI R27,HIGH(-117)
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x54
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x54
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
; 000C 00F6             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 000C 00F7         }
	__ADDWRN 18,19,1
	RJMP _0x18000B
_0x18000C:
; 000C 00F8 
; 000C 00F9         return NR_ROWS-2;
	RJMP _0x20A0005
; 000C 00FA 
; 000C 00FB     }
;#endif
;
;
;/*******************************************/
;// ALL POWERS
;/*******************************************/
;    //active & apparent power
;    byte sf_powers(byte* pTexts[NR_ROWS]){
; 000C 0103 byte sf_powers(byte* pTexts[8]){
; 000C 0104         byte aux_string[AUX_STRING_SIZE];
; 000C 0105         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 0106         word i;
; 000C 0107 
; 000C 0108         strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
; 000C 0109 
; 000C 010A         for(i=0; i<3;i++){
; 000C 010B             sprintf(aux_string ," L%u: %ld.%d [W] | %ld.%d [VA]", i+1, pModule->values.power_act[i]/10, abs(pModule->values.power_act[i]%10), pModule->values.power_app[i]/10, abs(pModule->values.power_app[i]%10));
; 000C 010C             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
; 000C 010D         }
; 000C 010E 
; 000C 010F         return NR_ROWS-2;
; 000C 0110     }
;
;
;/*******************************************/
;// ACTIVE POWERS
;/*******************************************/
;#ifndef MM_CALIBRATION_MODE
;    byte sf_powers_act(byte* pTexts[NR_ROWS]){
;        byte aux_string[AUX_STRING_SIZE];
;        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
;        word i;
;
;        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
;
;        for(i=0; i<3;i++){
;            sprintf(aux_string ,"    L%u: %ld.%d [W] M%u  ", i+1, pModule->values.power_act[i]/10, abs(pModule->values.power_act[i]%10), sScreen_data.nr_selected_module+1);
;            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
;        }
;
;        return NR_ROWS-2;
;
;    }
;#else
;    //CALIBRATION FUNCTION
;    byte sf_powers_act(byte* pTexts[NR_ROWS]){
; 000C 0128 byte sf_powers_act(byte* pTexts[8]){
_sf_powers_act:
; 000C 0129         byte aux_string[AUX_STRING_SIZE];
; 000C 012A         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 012B         word i;
; 000C 012C 
; 000C 012D         strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x49
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x53
; 000C 012E 
; 000C 012F         for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x180011:
	__CPWRN 18,19,3
	BRSH _0x180012
; 000C 0130             sprintf(aux_string ," %6ld, %ld.%d [W] M%u  ",  pModule->registers.pwrp_x[i], pModule->values.power_act[i]/10, abs(pModule->values.power_act[i]%10), sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x4B
	__POINTW1FN _0x180000,385
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-133)
	SBCI R27,HIGH(-133)
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x4C
	ADIW R26,21
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x55
	CALL __DIVD21
	CALL __PUTPARD1
	MOVW R26,R16
	ADIW R26,21
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	CALL SUBOPT_0x50
; 000C 0131             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 000C 0132         }
	__ADDWRN 18,19,1
	RJMP _0x180011
_0x180012:
; 000C 0133 
; 000C 0134         return NR_ROWS-2;
	RJMP _0x20A0005
; 000C 0135 
; 000C 0136     }
;#endif
;/*******************************************/
;// APPARENT POWERS
;/*******************************************/
;#ifndef MM_CALIBRATION_MODE
;    byte sf_powers_app(byte* pTexts[NR_ROWS]){
;        byte aux_string[AUX_STRING_SIZE];
;        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
;        word i;
;
;        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
;
;        for(i=0; i<3;i++){
;            sprintf(aux_string ,"    L%u: %ld.%d [W] M%u  ", i+1, pModule->values.power_app[i]/10, abs(pModule->values.power_app[i]%10), sScreen_data.nr_selected_module+1);
;            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
;        }
;
;        return NR_ROWS-2;
;
;    }
;#else
;    //CALIBRATION FUNCTION
;    byte sf_powers_app(byte* pTexts[NR_ROWS]){
; 000C 014D byte sf_powers_app(byte* pTexts[8]){
_sf_powers_app:
; 000C 014E         byte aux_string[AUX_STRING_SIZE];
; 000C 014F         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 0150         word i;
; 000C 0151 
; 000C 0152         strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x49
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x53
; 000C 0153 
; 000C 0154         for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x180014:
	__CPWRN 18,19,3
	BRSH _0x180015
; 000C 0155             sprintf(aux_string ," %6ld, %ld.%d [W] M%u  ",  pModule->registers.pwrs_x[i], pModule->values.power_app[i]/10, abs(pModule->values.power_app[i]%10), sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x4B
	__POINTW1FN _0x180000,385
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-149)
	SBCI R27,HIGH(-149)
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x4C
	ADIW R26,37
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x55
	CALL __DIVD21
	CALL __PUTPARD1
	MOVW R26,R16
	ADIW R26,37
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	CALL SUBOPT_0x50
; 000C 0156             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 000C 0157         }
	__ADDWRN 18,19,1
	RJMP _0x180014
_0x180015:
; 000C 0158 
; 000C 0159         return NR_ROWS-2;
	RJMP _0x20A0005
; 000C 015A 
; 000C 015B     }
;#endif
;
;
;/*******************************************/
;// ACTIVE ENERGIES
;/*******************************************/
;#ifndef MM_CALIBRATION_MODE
;    // NORMAL FUNCTION
;    byte sf_energies_act(byte* pTexts[NR_ROWS]){
;        byte aux_string[AUX_STRING_SIZE];
;        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
;        word i;
;
;        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
;
;        for(i=0; i<3;i++){
;            sprintf(aux_string ,"   L%u: %3ld [Wh]   M%u ", i+1, pModule->values.energy_act[i], sScreen_data.nr_selected_module+1);
;            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
;        }
;
;        return NR_ROWS-2;
;
;    }
;#else
;    //CALIBRATION FUNCTION
;    byte sf_energies_act(byte* pTexts[NR_ROWS]){
; 000C 0175 byte sf_energies_act(byte* pTexts[8]){
_sf_energies_act:
; 000C 0176         byte aux_string[AUX_STRING_SIZE];
; 000C 0177         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 0178         word i;
; 000C 0179 
; 000C 017A         strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x49
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x53
; 000C 017B 
; 000C 017C         for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x180017:
	__CPWRN 18,19,3
	BRSH _0x180018
; 000C 017D             sprintf(aux_string ," %6ld, %3ld [Wh] M%u ", pModule->registers.enrp_x[i], pModule->values.energy_act[i], sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x4B
	__POINTW1FN _0x180000,409
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-165)
	SBCI R27,HIGH(-165)
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x4C
	ADIW R26,53
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
; 000C 017E             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 000C 017F         }
	__ADDWRN 18,19,1
	RJMP _0x180017
_0x180018:
; 000C 0180 
; 000C 0181         return NR_ROWS-2;
	RJMP _0x20A0005
; 000C 0182 
; 000C 0183     }
;#endif
;
;/*******************************************/
;// ACTIVE ENERGIES
;/*******************************************/
;#ifndef MM_CALIBRATION_MODE
;    // NORMAL FUNCTION
;    byte sf_energies_app(byte* pTexts[NR_ROWS]){
;        byte aux_string[AUX_STRING_SIZE];
;        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
;        word i;
;
;        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
;
;        for(i=0; i<3;i++){
;            sprintf(aux_string ,"   L%u: %3ld [Wh]   M%u ", i+1, pModule->values.energy_app[i], sScreen_data.nr_selected_module+1);
;            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
;        }
;
;        return NR_ROWS-2;
;
;    }
;#else
;    //CALIBRATION FUNCTION
;    byte sf_energies_app(byte* pTexts[NR_ROWS]){
; 000C 019C byte sf_energies_app(byte* pTexts[8]){
_sf_energies_app:
; 000C 019D         byte aux_string[AUX_STRING_SIZE];
; 000C 019E         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 019F         word i;
; 000C 01A0 
; 000C 01A1         strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x49
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x53
; 000C 01A2 
; 000C 01A3         for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x18001A:
	__CPWRN 18,19,3
	BRSH _0x18001B
; 000C 01A4             sprintf(aux_string ," %6ld, %3ld [Wh] M%u ", pModule->registers.enrs_x[i], pModule->values.energy_app[i], sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x4B
	__POINTW1FN _0x180000,409
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-181)
	SBCI R27,HIGH(-181)
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x57
	MOVW R30,R16
	ADIW R30,1
	SUBI R30,LOW(-68)
	SBCI R31,HIGH(-68)
	MOVW R26,R30
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
; 000C 01A5             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 000C 01A6         }
	__ADDWRN 18,19,1
	RJMP _0x18001A
_0x18001B:
; 000C 01A7 
; 000C 01A8         return NR_ROWS-2;
	RJMP _0x20A0005
; 000C 01A9 
; 000C 01AA     }
;#endif
;
;/*******************************************/
;// POWER FACTOR
;/*******************************************/
;#ifndef MM_CALIBRATION_MODE
;    // NORMAL FUNCTION
;    byte sf_powerfactors(byte* pTexts[NR_ROWS]){
;        byte aux_string[AUX_STRING_SIZE];
;        tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
;        word i;
;
;        strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
;
;        for(i=0; i<3;i++){
;            sprintf(aux_string ,"    L%u: %6ld    M%u  ", i+1, pModule->values.power_factor[i], sScreen_data.nr_selected_module+1);
;            strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
;        }
;
;        return NR_ROWS-2;
;
;    }
;#else
;    //CALIBRATION FUNCTION
;    byte sf_powerfactors(byte* pTexts[NR_ROWS]){
; 000C 01C3 byte sf_powerfactors(byte* pTexts[8]){
_sf_powerfactors:
; 000C 01C4         byte aux_string[AUX_STRING_SIZE];
; 000C 01C5         tMESSMODULE *pModule = &sMm.sModule[sScreen_data.nr_selected_module];
; 000C 01C6         word i;
; 000C 01C7 
; 000C 01C8         strncpyf(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x49
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pModule -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x53
; 000C 01C9 
; 000C 01CA         for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x18001D:
	__CPWRN 18,19,3
	BRSH _0x18001E
; 000C 01CB             sprintf(aux_string ," %6ld, %6ld M%u  ",  pModule->registers.pf_x[i], pModule->values.power_factor[i], sScreen_data.nr_selected_module+1);
	CALL SUBOPT_0x4B
	__POINTW1FN _0x180000,431
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-197)
	SBCI R27,HIGH(-197)
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x57
	MOVW R30,R16
	ADIW R30,1
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	MOVW R26,R30
	MOVW R30,R18
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
; 000C 01CC             strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
; 000C 01CD         }
	__ADDWRN 18,19,1
	RJMP _0x18001D
_0x18001E:
; 000C 01CE 
; 000C 01CF         return NR_ROWS-2;
_0x20A0005:
	LDI  R30,LOW(6)
	CALL __LOADLOCR4
	ADIW R28,46
	RET
; 000C 01D0 
; 000C 01D1     }
;#endif
;
;
;
;/*************/
;/* REGISTERS */
;/*************/
;/*
;void sf_vrms(byte* pTexts[NR_ROWS]){
;
;    tMESSMODULES *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       VRMS           ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %lu [V]     ", pModule->values.vrms[0]>>8);
;    sprintf(pTexts[4] ,"      L2: %lu [V]     ", pModule->values.vrms[1]>>8);
;    sprintf(pTexts[5] ,"      L3: %lu [V]     ", pModule->values.vrms[2]>>8);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}*/
;
;/*
;void sf_irms(byte* pTexts[NR_ROWS]){
;
;    tMESSMODULES *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       IRMS           ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %lu [A]     ", pModule->values.irms[0]>>8);
;    sprintf(pTexts[4] ,"      L2: %lu [A]     ", pModule->values.irms[1]>>8);
;    sprintf(pTexts[5] ,"      L3: %lu [A]     ", pModule->values.irms[2]>>8);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}*/
;/*
;void sf_act(byte* pTexts[NR_ROWS]){
;
;    tMESSMODULES *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       ACT            ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %ld [W]     ", pModule->values.act[0]);
;    sprintf(pTexts[4] ,"      L2: %ld [W]     ", pModule->values.act[1]);
;    sprintf(pTexts[5] ,"      L3: %ld [W]     ", pModule->values.act[2]);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}
;
;void sf_app(byte* pTexts[NR_ROWS]){
;
;    tMESSMODULES *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       APP            ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %ld [VA]     ", pModule->values.app[0]);
;    sprintf(pTexts[4] ,"      L2: %ld [VA]     ", pModule->values.app[1]);
;    sprintf(pTexts[5] ,"      L3: %ld [VA]     ", pModule->values.app[2]);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;} */
;
;/* ENERGY */
;/*
;void sf_eapos_eaneg(byte* pTexts[NR_ROWS]){
;
;    tMESSMODULES *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"      EAPOS, EANEG    ");
;    sprintf(pTexts[1] ,"      ============    ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"  L1: %ld , %ld       ", pModule->values.eapos[0], pModule->values.eaneg[0]);
;    sprintf(pTexts[4] ,"  L2: %ld , %ld       ", pModule->values.eapos[1], pModule->values.eaneg[1]);
;    sprintf(pTexts[5] ,"  L3: %ld , %ld       ", pModule->values.eapos[2], pModule->values.eaneg[2]);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}*/
;//**********************************************************************************************
;// buttons_user.c -
;// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <buttons.h>
;#include <display_manager.h>
;#include <display_screens.h>
;#include <utils.h>
;#include "buttons_manager.h"
;
;
;void Test_process_buttons2(){
; 000D 000F void Test_process_buttons2(){

	.CSEG
; 000D 0010     static byte aux_top_first = 1, aux_bottom_first = 1;

	.DSEG

	.CSEG

	.DSEG

	.CSEG
; 000D 0011 
; 000D 0012     /* BUTTON TOP */
; 000D 0013     if(GET_BUTTON_TOP_STATE == 0){
; 000D 0014         if(aux_top_first){ //prave ted zmacknuto?
; 000D 0015             //uartSendBufferf(0,"\nI: Tlacitko TOP  bylo zmacknuto..");
; 000D 0016 
; 000D 0017             printf("\n-");
; 000D 0018             Disp_previous_screen();
; 000D 0019             aux_top_first = 0;
; 000D 001A         }
; 000D 001B     }
; 000D 001C     else    //tlacitko pusteno
; 000D 001D         aux_top_first = 1;  //vynulovani flagu pro nove zmacknuti
; 000D 001E 
; 000D 001F     /* BUTTON BOTTOM */
; 000D 0020     if(GET_BUTTON_BOTTOM_STATE == 0){ //prave ted zmacknuto?
; 000D 0021         if(aux_bottom_first){
; 000D 0022             //uartSendBufferf(0,"\nI: Tlacitko BOTTOM bylo zmacknuto..");
; 000D 0023 
; 000D 0024             printf("\n+");
; 000D 0025             Disp_next_screen();
; 000D 0026             aux_bottom_first = 0;
; 000D 0027         }
; 000D 0028     }
; 000D 0029     else    //tlacitko pusteno
; 000D 002A         aux_bottom_first = 1;   //vynulovani flagu pro nove zmacknuti
; 000D 002B }
;
;void Buttons_manager(){
; 000D 002D void Buttons_manager(){
_Buttons_manager:
; 000D 002E     static byte aux_top_first = 1, aux_bottom_first = 1;

	.DSEG

	.CSEG

	.DSEG

	.CSEG
; 000D 002F     static byte cnt_pressed_1=0, cnt_pressed_2=0;
; 000D 0030     static byte flag_long_pressed = 0;
; 000D 0031 
; 000D 0032     /* BUTTON TOP */
; 000D 0033     if(GET_BUTTON_TOP_STATE == 0){
	SBIC 0x6,7
	RJMP _0x1A000D
; 000D 0034         cnt_pressed_1++;
	LDS  R30,_cnt_pressed_1_S00D0001000
	SUBI R30,-LOW(1)
	STS  _cnt_pressed_1_S00D0001000,R30
; 000D 0035         if( cnt_pressed_1 > CNT_LONG_PRESS){
	LDS  R26,_cnt_pressed_1_S00D0001000
	CPI  R26,LOW(0x1F)
	BRLO _0x1A000E
; 000D 0036             printf("\nI:buttons: long press");
	__POINTW1FN _0x1A0000,6
	CALL SUBOPT_0x1B
; 000D 0037             cnt_pressed_1 = 0;  //vynulovani flagu pro nove zmacknuti
	LDI  R30,LOW(0)
	STS  _cnt_pressed_1_S00D0001000,R30
; 000D 0038             flag_long_pressed = 1; // aby se po pusteni tlacitka nevykonal "short press"
	LDI  R30,LOW(1)
	STS  _flag_long_pressed_S00D0001000,R30
; 000D 0039             rot_inc(&sScreen_data.nr_selected_module, 3);
	LDI  R30,LOW(_sScreen_data)
	LDI  R31,HIGH(_sScreen_data)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _rot_inc
; 000D 003A         }
; 000D 003B     }
_0x1A000E:
; 000D 003C     else{    //tlacitko pusteno
	RJMP _0x1A000F
_0x1A000D:
; 000D 003D         if((cnt_pressed_1>CNT_SHORT_PRESS)&&(flag_long_pressed == 0)) {
	LDS  R26,_cnt_pressed_1_S00D0001000
	CPI  R26,LOW(0x3)
	BRLO _0x1A0011
	LDS  R26,_flag_long_pressed_S00D0001000
	CPI  R26,LOW(0x0)
	BREQ _0x1A0012
_0x1A0011:
	RJMP _0x1A0010
_0x1A0012:
; 000D 003E             printf("\nI:buttons: short press");
	__POINTW1FN _0x1A0000,29
	CALL SUBOPT_0x1B
; 000D 003F             Disp_previous_screen();
	CALL _Disp_previous_screen
; 000D 0040         }
; 000D 0041         flag_long_pressed = 0;
_0x1A0010:
	LDI  R30,LOW(0)
	STS  _flag_long_pressed_S00D0001000,R30
; 000D 0042         cnt_pressed_1 = 0;  //vynulovani flagu pro nove zmacknuti
	STS  _cnt_pressed_1_S00D0001000,R30
; 000D 0043     }
_0x1A000F:
; 000D 0044 
; 000D 0045     /* BUTTON BOTTOM */
; 000D 0046     if(GET_BUTTON_BOTTOM_STATE == 0){
	SBIC 0x6,6
	RJMP _0x1A0013
; 000D 0047         cnt_pressed_2++;
	LDS  R30,_cnt_pressed_2_S00D0001000
	SUBI R30,-LOW(1)
	RJMP _0x1A0016
; 000D 0048     }
; 000D 0049     else{    //tlacitko pusteno
_0x1A0013:
; 000D 004A         if(cnt_pressed_2>CNT_SHORT_PRESS) {
	LDS  R26,_cnt_pressed_2_S00D0001000
	CPI  R26,LOW(0x3)
	BRLO _0x1A0015
; 000D 004B             Disp_next_screen();
	CALL _Disp_next_screen
; 000D 004C         }
; 000D 004D         cnt_pressed_2 = 0;  //vynulovani flagu pro nove zmacknuti
_0x1A0015:
	LDI  R30,LOW(0)
_0x1A0016:
	STS  _cnt_pressed_2_S00D0001000,R30
; 000D 004E     }
; 000D 004F }
	RET
;
;
;
;/* END OF BUTTONS_USER */
;//**********************************************************************************************
;// leds_manager.c -
;// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
;// vsechny potrebne makra, aliasy definovany v digital_outputs_user.h
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <digital_outputs.h>
;#include "leds_manager.h"
;
;
;void Leds_Init(void){
; 000E 000D void Leds_Init(void){

	.CSEG
_Leds_Init:
; 000E 000E   Digital_outputs_init();
	CALL _Digital_outputs_init
; 000E 000F }
	RET
;
;void Leds_Manager(void){
; 000E 0011 void Leds_Manager(void){
_Leds_Manager:
; 000E 0012     static byte aux_flag = 0;
; 000E 0013 
; 000E 0014     //printf("\nLED CHANGED");
; 000E 0015 
; 000E 0016     LED_2_CHANGE;
	IN   R30,0xB
	LDI  R26,LOW(128)
	EOR  R30,R26
	OUT  0xB,R30
; 000E 0017 
; 000E 0018     if(aux_flag){
	LDS  R30,_aux_flag_S00E0001000
	CPI  R30,0
	BREQ _0x1C0003
; 000E 0019         LED_1_CHANGE;
	IN   R30,0xB
	LDI  R26,LOW(64)
	EOR  R30,R26
	OUT  0xB,R30
; 000E 001A         aux_flag = 0;
	LDI  R30,LOW(0)
	RJMP _0x1C0005
; 000E 001B     }
; 000E 001C     else
_0x1C0003:
; 000E 001D         aux_flag = 1;
	LDI  R30,LOW(1)
_0x1C0005:
	STS  _aux_flag_S00E0001000,R30
; 000E 001E }
	RET
;
;
;
;
;/* END OF TEST_PROCESS */
;//**********************************************************************************************
;// comm_terminal.c
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// -
;// -
;// -
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <types.h>
;#include <stdio.h>
;#include <string.h>
;#include <uart2.h>
;#include <digital_outputs.h>
;#include "comm_terminal.h"
;
;//LOCAL VARIABLES
;#define RX_BUFFER_SIZE  10
;
;//prijimaci buffer
;byte uartRxBuffer[RX_BUFFER_SIZE];
;byte uartRxBuffer_index;
;//stav protokolu
;volatile byte comm_terminal_state;
;
;// CommApp_Init - Init IO pins, UART params, protocol variables
;void CommTerminal_Init(void)
; 000F 001D {

	.CSEG
; 000F 001E 
; 000F 001F 	//Rx pin init
; 000F 0020 	COMM_TERMINAL_DDR &= ~COMM_TERMINAL_RX_PIN_MASK; 	//0 -> input
; 000F 0021 	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> pullup
; 000F 0022 	//Tx pin init
; 000F 0023 	COMM_TERMINAL_DDR |= COMM_TERMINAL_TX_PIN_MASK; 	//1 -> output
; 000F 0024 	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> default output = '1'
; 000F 0025 
; 000F 0026     // USART param setting
; 000F 0027     uartInit(COMM_TERMINAL_UART_NR);            // Tx, Rx, TxIRq, RxIRq
; 000F 0028 	uartSetBaudRate(COMM_TERMINAL_UART_NR, COMM_TERMINAL_BAUDRATE, 0);   // Commspeed
; 000F 0029 	uartSetRxHandler(COMM_TERMINAL_UART_NR, CommTerminal_Handler);        // Rx bytes handler
; 000F 002A 
; 000F 002B     // Variables init
; 000F 002C     uartRxBuffer_index = 0;
; 000F 002D }
;
;// CommApp_Handler() - routine for received char from UART.
;// Received char is processed, after last char is received,
;// control "comm_terminal_state" is switched to special state allowing
;// processing and executing of command
;void CommTerminal_Handler(byte data){
; 000F 0033 void CommTerminal_Handler(byte data){
; 000F 0034 
; 000F 0035     if(comm_terminal_state == eWAIT_FOR_CHAR){
;	data -> Y+0
; 000F 0036 
; 000F 0037         //ukoncovaci znak?
; 000F 0038         if ((data == '\n')||(data == '\r')){
; 000F 0039             comm_terminal_state = eWAIT_FOR_PROCESS_OK;
; 000F 003A             return; //-> ukoncovaci znak se do bufferu nevklada
; 000F 003B         }
; 000F 003C 
; 000F 003D         //ulozeni znaku do bufferu
; 000F 003E         uartRxBuffer[uartRxBuffer_index++] = data;
; 000F 003F 
; 000F 0040         //je jeste misto pro dalsi prijem?
; 000F 0041         if(uartRxBuffer_index ==  RX_BUFFER_SIZE){
; 000F 0042            comm_terminal_state = eWAIT_FOR_PROCESS_KO;
; 000F 0043         }
; 000F 0044     }
; 000F 0045 }
;void CommTerminal_Manager(void){
; 000F 0046 void CommTerminal_Manager(void){
; 000F 0047     switch(comm_terminal_state){
; 000F 0048         case eWAIT_FOR_PROCESS_OK:
; 000F 0049             uartSendBufferf(COMM_TERMINAL_UART_NR,"\nI: Prijmut string: ");
; 000F 004A             break;
; 000F 004B         case  eWAIT_FOR_PROCESS_KO:
; 000F 004C             uartSendBufferf(COMM_TERMINAL_UART_NR,"\nE: Nedostatecny buffer, string:");
; 000F 004D             break;
; 000F 004E     }
; 000F 004F 
; 000F 0050     if(comm_terminal_state != eWAIT_FOR_CHAR){
; 000F 0051         uartSendBuffer(COMM_TERMINAL_UART_NR, uartRxBuffer, uartRxBuffer_index);
; 000F 0052         uartRxBuffer_index = 0;           //flush buffer
; 000F 0053         comm_terminal_state = eWAIT_FOR_CHAR;  //povoleni dalsiho prijmu
; 000F 0054     }
; 000F 0055 }
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;
;/* STRINGS */
;flash char STRING_START_MESSAGE[]=  "\n#########################################"
;                                    "\n# Knuerr AG"
;                                    "\n# RM II - Ing. L.Melichar, Ing. P.Kerndl ";
;
;flash char STRING_SEPARATOR[]=      "\n#########################################";
;//**********************************************************************************************
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;/* *******************************************************************
; *  modul               :    COMM_XPORT.C
; * *******************************************************************
; * desc: UART protocol for communication with terminal, webserver, etc.
; * this mcu counts as MASTER, terminal counts as SLAVE
; * communication session can be initiated only by MASTER for now
; * MASTER starts by sending command
; * ------------------------------------------------------------
; * | STARTBYTE | SEQ | COMMAND | DATALENGTH | DATA | .. | XOR |
; * ------------------------------------------------------------
; * STARTBYTE = 0x53 (byte), constant for start of frame
; * SEQ = 0-255(byte), control id of command in case of retransmit
; * COMMAND = 0-0x7F(byte), application command
; *         = 0-0x7F+0x80(byte), terminal acknowledge for good received command
; * DATALENGTH = 0-255(byte), length of transmitted data
; * DATA = payload, contains useful info
; * XOR = 0-0xFF(byte), logic xor of STARTBYTE, SEQ, COMMAND, DATALENGTH and DATA (if any)
; *
; * SLAVE executes command and responds with the equal structured frame,
; * but the COMMAND MSb is set to 1
; * ********************************************************************
; */
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <types.h>
;#include <stdio.h>
;#include <string.h>
;#include <uart2.h>
;#include <digital_outputs.h>
;#include <buttons.h>
;#include <messmodules.h>
;#include "comm_xport.h"
;#include "comm_xport_frames.h"
;
;void CommXport_SendFrames(void);
;void CommXport_SendFrame(byte command, byte* pData, byte datalength);
;
;
;//LOCAL VARIABLES
;#define RX_BUFFER_SIZE  10
;
;tFRAME sFrame_Rx;       // receiving frame
;tPROTOCOL sProtocol;    // protocol states
;tXPORT sXport;          // values received from xport
;
;/*******************************************/
;// COMMXPORT_INIT()
;/*******************************************/
;// - Init IO pins, UART params, protocol variables
;/*******************************************/
;void CommXport_Init(void){
; 0011 0035 void CommXport_Init(void){

	.CSEG
_CommXport_Init:
; 0011 0036     byte i;
; 0011 0037 
; 0011 0038 	//Rx pin init
; 0011 0039 	COMM_XPORT_DDR &= ~COMM_XPORT_RX_PIN_MASK; 	//0 -> input
	ST   -Y,R17
;	i -> R17
	IN   R30,0xA
	ANDI R30,LOW(0xFC)
	OUT  0xA,R30
; 0011 003A 	COMM_XPORT_PORT |= COMM_XPORT_RX_PIN_MASK; 	//1 -> pullup
	IN   R30,0xB
	ORI  R30,LOW(0x3)
	OUT  0xB,R30
; 0011 003B 	//Tx pin init
; 0011 003C 	COMM_XPORT_DDR |= COMM_XPORT_TX_PIN_MASK; 	//1 -> output
	SBI  0xA,2
; 0011 003D 	COMM_XPORT_PORT |= COMM_XPORT_RX_PIN_MASK; 	//1 -> default output = '1'
	IN   R30,0xB
	ORI  R30,LOW(0x3)
	OUT  0xB,R30
; 0011 003E 
; 0011 003F     // USART param setting
; 0011 0040 	uartInit(COMM_XPORT_UART_NR);            // Tx, Rx, TxIRq, RxIRq
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _uartInit
; 0011 0041 	uartSetBaudRate(COMM_XPORT_UART_NR, COMM_XPORT_BAUDRATE, 0);   // Commspeed
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETD1N 0x2580
	CALL __PUTPARD1
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _uartSetBaudRate
; 0011 0042 	uartSetRxHandler(COMM_XPORT_UART_NR, CommXport_Handler);        // Rx bytes handler
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_CommXport_Handler)
	LDI  R31,HIGH(_CommXport_Handler)
	ST   -Y,R31
	ST   -Y,R30
	CALL _uartSetRxHandler
; 0011 0043 
; 0011 0044     /* VARIABLES */
; 0011 0045 
; 0011 0046     //ip address
; 0011 0047     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x220004:
	CPI  R17,4
	BRSH _0x220005
; 0011 0048         sXport.ip_address[i] = i;
	CALL SUBOPT_0x19
	SUBI R30,LOW(-_sXport)
	SBCI R31,HIGH(-_sXport)
	ST   Z,R17
	SUBI R17,-1
	RJMP _0x220004
_0x220005:
; 0011 004B for(i=0; i<6; i++)
	LDI  R17,LOW(0)
_0x220007:
	CPI  R17,6
	BRSH _0x220008
; 0011 004C         sXport.mac_address[i] = i;
	__POINTW2MN _sXport,4
	CALL SUBOPT_0x19
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
	SUBI R17,-1
	RJMP _0x220007
_0x220008:
; 0011 004E sProtocol.seq = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _sProtocol,1
; 0011 004F }
	LD   R17,Y+
	RET
;
;/*******************************************/
;// COMMXPORT_MANAGER()
;/*******************************************/
;// - periodicly send frames to xport
;// - periodicaly checking receiving buffer for
;//   new frame, if found execute command and send acknowlenge.
;/*******************************************/
;void CommXport_Manager(void){
; 0011 0058 void CommXport_Manager(void){
_CommXport_Manager:
; 0011 0059 
; 0011 005A     if (sProtocol.comm_state == eWAIT_FOR_PROCESS) {     // new frame
	LDS  R26,_sProtocol
	CPI  R26,LOW(0x6)
	BRNE _0x220009
; 0011 005B 
; 0011 005C         // Executing received command and new frame creation
; 0011 005D         CommXport_ProcessCommand();   // command executed ok
	RCALL _CommXport_ProcessCommand
; 0011 005E     }
; 0011 005F 
; 0011 0060     //sending
; 0011 0061     CommXport_SendFrames();
_0x220009:
	RCALL _CommXport_SendFrames
; 0011 0062 }
	RET
;
;
;/*******************************************/
;// COMMXPORT_SENDFRAMES()
;/*******************************************/
;// - periodicly send frames to xport
;/*******************************************/
;void CommXport_SendFrames(void){
; 0011 006A void CommXport_SendFrames(void){
_CommXport_SendFrames:
; 0011 006B     static byte send_group = 0;
; 0011 006C     tMESSMODULE *pMessmodule = &sMm.sModule[0];
; 0011 006D     byte aux_data;
; 0011 006E 
; 0011 006F 
; 0011 0070     switch(send_group++){
	CALL __SAVELOCR4
;	*pMessmodule -> R16,R17
;	aux_data -> R19
	__POINTWRM 16,17,_sMm
	LDS  R30,_send_group_S0110002000
	SUBI R30,-LOW(1)
	STS  _send_group_S0110002000,R30
	SUBI R30,LOW(1)
; 0011 0071         case eIO:
	CPI  R30,0
	BRNE _0x22000D
; 0011 0072             //INPUTS
; 0011 0073             aux_data = (GET_BUTTON_TOP_STATE<<1) | GET_BUTTON_BOTTOM_STATE;
	LDI  R26,0
	SBIC 0x6,7
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R30
	LDI  R30,0
	SBIC 0x6,6
	LDI  R30,1
	OR   R30,R26
	MOV  R19,R30
; 0011 0074             CommXport_SendFrame( CMD_GET_INPUTS, &aux_data, 1);
	LDI  R30,LOW(32)
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _CommXport_SendFrame
	POP  R19
; 0011 0075             //OUTPUTS
; 0011 0076             aux_data = 0xAA;
	LDI  R19,LOW(170)
; 0011 0077             CommXport_SendFrame( CMD_SET_OUTPUTS , &aux_data, 1 );
	LDI  R30,LOW(16)
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _CommXport_SendFrame
	POP  R19
; 0011 0078             break;
	RJMP _0x22000C
; 0011 0079         case e1F:
_0x22000D:
	CPI  R30,LOW(0x1)
	BRNE _0x22000E
; 0011 007A             //1F values
; 0011 007B             CommXport_SendFrame( CMD_MM_GET_FREQUENCY,   (byte*)&pMessmodule->values.frequence,   2);  //FREQUENCE
	LDI  R30,LOW(48)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,3
	CALL SUBOPT_0x5A
; 0011 007C             CommXport_SendFrame( CMD_MM_GET_TEMPERATURE, (byte*)&pMessmodule->values.temperature, 2);  //RAWTEMP
	LDI  R30,LOW(49)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,1
	CALL SUBOPT_0x5A
; 0011 007D             break;
	RJMP _0x22000C
; 0011 007E         case eVOLTAGES:
_0x22000E:
	CPI  R30,LOW(0x2)
	BRNE _0x22000F
; 0011 007F             //VOLTAGEs
; 0011 0080             CommXport_SendFrame( CMD_MM_GET_VOLTAGE_1,  (byte*)&pMessmodule->values.voltage[0],  2);  //VOLTAGE 1
	LDI  R30,LOW(64)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,5
	CALL SUBOPT_0x5A
; 0011 0081             CommXport_SendFrame( CMD_MM_GET_VOLTAGE_2,  (byte*)&pMessmodule->values.voltage[1],  2);  //VOLTAGE 2
	LDI  R30,LOW(65)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,7
	CALL SUBOPT_0x5A
; 0011 0082             CommXport_SendFrame( CMD_MM_GET_VOLTAGE_3,  (byte*)&pMessmodule->values.voltage[2],  2);  //VOLTAGE 3
	LDI  R30,LOW(66)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,9
	CALL SUBOPT_0x5A
; 0011 0083             break;
	RJMP _0x22000C
; 0011 0084         case eCURRENTS:
_0x22000F:
	CPI  R30,LOW(0x3)
	BRNE _0x220010
; 0011 0085             //CURRENTs
; 0011 0086             CommXport_SendFrame( CMD_MM_GET_CURRENT_1,  (byte*)&pMessmodule->values.current[0],  2);  //CURRENT 1
	LDI  R30,LOW(67)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,13
	CALL SUBOPT_0x5A
; 0011 0087             CommXport_SendFrame( CMD_MM_GET_CURRENT_2,  (byte*)&pMessmodule->values.current[1],  2);  //CURRENT 2
	LDI  R30,LOW(68)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,15
	CALL SUBOPT_0x5A
; 0011 0088             CommXport_SendFrame( CMD_MM_GET_CURRENT_3,  (byte*)&pMessmodule->values.current[2],  2);  //CURRENT 3
	LDI  R30,LOW(69)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,17
	CALL SUBOPT_0x5A
; 0011 0089             break;
	RJMP _0x22000C
; 0011 008A         case ePOWERS:
_0x220010:
	CPI  R30,LOW(0x4)
	BRNE _0x220011
; 0011 008B             //POWERs
; 0011 008C             CommXport_SendFrame( CMD_MM_GET_POWER_1,  (byte*)&pMessmodule->values.power_act[0],  2);  //POWER 1
	LDI  R30,LOW(70)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,21
	CALL SUBOPT_0x5A
; 0011 008D             CommXport_SendFrame( CMD_MM_GET_POWER_2,  (byte*)&pMessmodule->values.power_act[1],  2);  //POWER 2
	LDI  R30,LOW(71)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,25
	CALL SUBOPT_0x5A
; 0011 008E             CommXport_SendFrame( CMD_MM_GET_POWER_3,  (byte*)&pMessmodule->values.power_act[2],  2);  //POWER 3
	LDI  R30,LOW(72)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,29
	CALL SUBOPT_0x5A
; 0011 008F             break;
	RJMP _0x22000C
; 0011 0090         case eENERGIES:
_0x220011:
	CPI  R30,LOW(0x5)
	BRNE _0x220012
; 0011 0091             //ENERGIES
; 0011 0092             CommXport_SendFrame( CMD_MM_GET_ENERGY_1,  (byte*)&pMessmodule->values.energy_act[0],  2);  //ENERGY 1
	LDI  R30,LOW(73)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,53
	CALL SUBOPT_0x5A
; 0011 0093             CommXport_SendFrame( CMD_MM_GET_ENERGY_2,  (byte*)&pMessmodule->values.energy_act[1],  2);  //ENERGY 2
	LDI  R30,LOW(74)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,57
	CALL SUBOPT_0x5A
; 0011 0094             CommXport_SendFrame( CMD_MM_GET_ENERGY_3,  (byte*)&pMessmodule->values.energy_act[2],  2);  //ENERGY 3
	LDI  R30,LOW(75)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,61
	CALL SUBOPT_0x5A
; 0011 0095             break;
	RJMP _0x22000C
; 0011 0096         case ePFS:
_0x220012:
	CPI  R30,LOW(0x6)
	BRNE _0x22000C
; 0011 0097             //POWER FACTOR
; 0011 0098             CommXport_SendFrame( CMD_MM_GET_PF_1,  (byte*)&pMessmodule->values.power_factor[0],  2);  //PF 1
	LDI  R30,LOW(76)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,1
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x5A
; 0011 0099             CommXport_SendFrame( CMD_MM_GET_PF_2,  (byte*)&pMessmodule->values.power_factor[1],  2);  //PF 2
	LDI  R30,LOW(77)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,1
	SUBI R30,LOW(-88)
	SBCI R31,HIGH(-88)
	CALL SUBOPT_0x5A
; 0011 009A             CommXport_SendFrame( CMD_MM_GET_PF_3,  (byte*)&pMessmodule->values.power_factor[2],  2);  //PF 3
	LDI  R30,LOW(78)
	ST   -Y,R30
	MOVW R30,R16
	ADIW R30,1
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x5A
; 0011 009B             send_group = eIO;
	LDI  R30,LOW(0)
	STS  _send_group_S0110002000,R30
; 0011 009C             break;
; 0011 009D     }
_0x22000C:
; 0011 009E 
; 0011 009F     //SYNCHRONIZATION END
; 0011 00A0     CommXport_SendFrame( CMD_SYNC_END,     (byte*)&aux_data,                       0);  //SYNCHRONIZATION END
	LDI  R30,LOW(2)
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	PUSH R19
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _CommXport_SendFrame
	POP  R19
	POP  R20
; 0011 00A1 
; 0011 00A2 }
	CALL __LOADLOCR4
_0x20A0004:
	ADIW R28,4
	RET
;
;/*******************************************/
;// COMMXPORT_SENDFRAME()
;/*******************************************/
;// - send frame to xport
;/* ------------------------------------------------------------
; * | STARTBYTE | SEQ | COMMAND | DATALENGTH | DATA | .. | XOR |
; * ------------------------------------------------------------*/
;void CommXport_SendFrame(byte command, byte* pData, byte datalength){
; 0011 00AB void CommXport_SendFrame(byte command, byte* pData, byte datalength){
_CommXport_SendFrame:
; 0011 00AC     byte i, xor = COMM_XPORT_STARTBYTE;
; 0011 00AD 
; 0011 00AE     /* CREATING FRAME */
; 0011 00AF 
; 0011 00B0     //start byte
; 0011 00B1     uartAddToTxBuffer(COMM_XPORT_UART_NR, COMM_XPORT_STARTBYTE);      // startbyte added to buffer
	ST   -Y,R17
	ST   -Y,R16
;	command -> Y+5
;	*pData -> Y+3
;	datalength -> Y+2
;	i -> R17
;	xor -> R16
	LDI  R16,83
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(83)
	ST   -Y,R30
	CALL _uartAddToTxBuffer
; 0011 00B2 
; 0011 00B3     //sequence
; 0011 00B4     uartAddToTxBuffer(COMM_XPORT_UART_NR, ++sProtocol.seq);           // sequence added to buffer
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB1MN _sProtocol,1
	SUBI R30,-LOW(1)
	__PUTB1MN _sProtocol,1
	ST   -Y,R30
	CALL _uartAddToTxBuffer
; 0011 00B5     xor ^= sProtocol.seq;                                 // seq added to xor
	__GETB1MN _sProtocol,1
	EOR  R16,R30
; 0011 00B6 
; 0011 00B7     //command
; 0011 00B8     uartAddToTxBuffer(COMM_XPORT_UART_NR, command | 0x80); // command added to buffer
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+6
	ORI  R30,0x80
	ST   -Y,R30
	CALL _uartAddToTxBuffer
; 0011 00B9     xor ^= command;                                        // command added to xor
	LDD  R30,Y+5
	EOR  R16,R30
; 0011 00BA 
; 0011 00BB     //datalength
; 0011 00BC     uartAddToTxBuffer(COMM_XPORT_UART_NR, datalength);           // datalength added to buffer
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _uartAddToTxBuffer
; 0011 00BD     xor ^= datalength;                          // datalength added to xor
	LDD  R30,Y+2
	EOR  R16,R30
; 0011 00BE 
; 0011 00BF     //data
; 0011 00C0     for (i=0; i<datalength; i++) {                  // all databytes
	LDI  R17,LOW(0)
_0x220015:
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0x220016
; 0011 00C1         uartAddToTxBuffer(COMM_XPORT_UART_NR, *(pData+i));    // data byte added to buffer
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	CALL _uartAddToTxBuffer
; 0011 00C2         xor ^= *(pData+i);                             // data byte added to xor
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	EOR  R16,R30
; 0011 00C3     }
	SUBI R17,-1
	RJMP _0x220015
_0x220016:
; 0011 00C4 
; 0011 00C5     //xor
; 0011 00C6     uartAddToTxBuffer(COMM_XPORT_UART_NR, xor);         // xor added to buffer
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R16
	CALL _uartAddToTxBuffer
; 0011 00C7 
; 0011 00C8     // sending frame
; 0011 00C9     uartSendTxBuffer(COMM_XPORT_UART_NR);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _uartSendTxBuffer
; 0011 00CA 
; 0011 00CB }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;
;
;/*******************************************/
;// COMMXPORT_HANDLER()
;/*******************************************/
;// - routine for received char from UART.
;// - received frame is processed, after last char is received,
;// - "sProtocol.comm_state" is switched to special state allowing
;//   processing and executing of command
;/*******************************************/
;void CommXport_Handler(byte data){
; 0011 00D6 void CommXport_Handler(byte data){
_CommXport_Handler:
; 0011 00D7 
; 0011 00D8 	switch(sProtocol.comm_state){
;	data -> Y+0
	LDS  R30,_sProtocol
; 0011 00D9 
; 0011 00DA 	    case eWAIT_FOR_STARTBYTE:                // waiting for startbyte
	CPI  R30,0
	BRNE _0x22001A
; 0011 00DB 			if (data == COMM_XPORT_STARTBYTE) {    // start of frame
	LD   R26,Y
	CPI  R26,LOW(0x53)
	BRNE _0x22001B
; 0011 00DC 				sFrame_Rx.data_cnt = 0;          // init databytes counter
	LDI  R30,LOW(0)
	__PUTB1MN _sFrame_Rx,36
; 0011 00DD 				sProtocol.comm_state = eWAIT_FOR_SEQ;  // switch to next state
	LDI  R30,LOW(1)
	STS  _sProtocol,R30
; 0011 00DE // 				LED_7_CHANGE;
; 0011 00DF // 				uartSendBufferf(0,"LED_7_CHANGE");
; 0011 00E0 			}
; 0011 00E1 			break;
_0x22001B:
	RJMP _0x220019
; 0011 00E2 
; 0011 00E3         case eWAIT_FOR_SEQ:                  // awaiting sequence byte
_0x22001A:
	CPI  R30,LOW(0x1)
	BRNE _0x22001C
; 0011 00E4             sFrame_Rx.seq = data;            // seq
	LD   R30,Y
	STS  _sFrame_Rx,R30
; 0011 00E5             sProtocol.comm_state = eWAIT_FOR_CMD;  // switch to nex state
	LDI  R30,LOW(2)
	RJMP _0x22002B
; 0011 00E6             break;
; 0011 00E7 
; 0011 00E8 		case eWAIT_FOR_CMD:                         // awaiting command byte
_0x22001C:
	CPI  R30,LOW(0x2)
	BRNE _0x22001D
; 0011 00E9 		    sFrame_Rx.command = data;   // command
	LD   R30,Y
	__PUTB1MN _sFrame_Rx,1
; 0011 00EA 			sProtocol.comm_state = eWAIT_FOR_DATALENGTH;  // switch to next state
	LDI  R30,LOW(3)
	RJMP _0x22002B
; 0011 00EB 			break;
; 0011 00EC 
; 0011 00ED 		case eWAIT_FOR_DATALENGTH:  // awaiting datalength byte
_0x22001D:
	CPI  R30,LOW(0x3)
	BRNE _0x22001E
; 0011 00EE 			if(data > COMM_XPORT_DATALENGTH_MAX)        // datalength above data buffer (ERROR)
	LD   R26,Y
	CPI  R26,LOW(0x1F)
	BRLO _0x22001F
; 0011 00EF 				sProtocol.comm_state = eWAIT_FOR_STARTBYTE; // switch to starting state
	LDI  R30,LOW(0)
	RJMP _0x22002C
; 0011 00F0 			else {      // ok
_0x22001F:
; 0011 00F1 				sFrame_Rx.datalength = data;
	LD   R30,Y
	__PUTB1MN _sFrame_Rx,4
; 0011 00F2                 if (data)     // frame contains data
	CPI  R30,0
	BREQ _0x220021
; 0011 00F3   				    sProtocol.comm_state = eWAIT_FOR_DATA;        // switch to next state
	LDI  R30,LOW(4)
	RJMP _0x22002C
; 0011 00F4                 else          // no data, xor is expected
_0x220021:
; 0011 00F5   				    sProtocol.comm_state = eWAIT_FOR_XOR;			// switch to xor state
	LDI  R30,LOW(5)
_0x22002C:
	STS  _sProtocol,R30
; 0011 00F6 			}
; 0011 00F7 			break;
	RJMP _0x220019
; 0011 00F8 
; 0011 00F9 		case eWAIT_FOR_DATA:              // awaiting data byte
_0x22001E:
	CPI  R30,LOW(0x4)
	BRNE _0x220023
; 0011 00FA 			sFrame_Rx.data[sFrame_Rx.data_cnt] = data;  // data byte
	__POINTW2MN _sFrame_Rx,5
	__GETB1MN _sFrame_Rx,36
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	STD  Z+0,R26
; 0011 00FB 			sFrame_Rx.data_cnt++;                       // saved data cntr increases
	__GETB1MN _sFrame_Rx,36
	SUBI R30,-LOW(1)
	__PUTB1MN _sFrame_Rx,36
	SUBI R30,LOW(1)
; 0011 00FC 			if (sFrame_Rx.data_cnt >= sFrame_Rx.datalength){ // last data
	__GETB2MN _sFrame_Rx,36
	__GETB1MN _sFrame_Rx,4
	CP   R26,R30
	BRLO _0x220024
; 0011 00FD 				sProtocol.comm_state = eWAIT_FOR_XOR;       // switch to next (xor) state
	LDI  R30,LOW(5)
	STS  _sProtocol,R30
; 0011 00FE 			}
; 0011 00FF // 			uartSendByte(0,sFrame_Rx.data_cnt);
; 0011 0100 // 			LED_2_CHANGE;
; 0011 0101 			break;
_0x220024:
	RJMP _0x220019
; 0011 0102 
; 0011 0103 		case eWAIT_FOR_XOR: // awaiting xor
_0x220023:
	CPI  R30,LOW(0x5)
	BRNE _0x220019
; 0011 0104             sFrame_Rx.xor = data;               // xor
	LD   R30,Y
	__PUTB1MN _sFrame_Rx,35
; 0011 0105             sProtocol.comm_state = eWAIT_FOR_PROCESS; // switch to final state - awating processing
	LDI  R30,LOW(6)
_0x22002B:
	STS  _sProtocol,R30
; 0011 0106 			break;
; 0011 0107     } // switch end
_0x220019:
; 0011 0108 }
	JMP  _0x20A0003
;
;
;
;
;/*******************************************/
;// COMMXPORT_PROCESSCOMMAND()
;/*******************************************/
;// - command executing and filling
;// - Tx Frame with valid data and datalength. Return 1 when
;//   gets unknown command, else return 0 (OK).
;byte CommXport_ProcessCommand(void){
; 0011 0113 byte CommXport_ProcessCommand(void){
_CommXport_ProcessCommand:
; 0011 0114 
; 0011 0115 	switch(sFrame_Rx.command){
	__GETB1MN _sFrame_Rx,1
; 0011 0116 
; 0011 0117         // system commands
; 0011 0118         case CMD_SYNC_END:                // Set seq to value 0, any rx frame is new
	CPI  R30,LOW(0x2)
	BRNE _0x22002A
; 0011 0119             sFrame_Rx.seq = 0;
	LDI  R30,LOW(0)
	STS  _sFrame_Rx,R30
; 0011 011A             break;
	RJMP _0x220028
; 0011 011B 
; 0011 011C         // unknown command
; 0011 011D 	    default:
_0x22002A:
; 0011 011E             return RSP_UNKNOWN_COMMAND;
	LDI  R30,LOW(1)
	RET
; 0011 011F 		    break;
; 0011 0120 	}
_0x220028:
; 0011 0121   return RSP_OK;
	LDI  R30,LOW(0)
	RET
; 0011 0122 }
;
;
;
;
;//**********************************************************************************************
;// test_process.c -
;// (C)2010 Knuerr s.r.o., Ing. Lubos Melichar
;//**********************************************************************************************
;
;#include <hw_def.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <digital_outputs.h>
;#include <buttons.h>
;#include <uart2.h>
;//#include <display.h>
;
;
;
;void Test_process_leds(void){
; 0012 000F void Test_process_leds(void){

	.CSEG
; 0012 0010     static byte aux_flag = 0;
; 0012 0011 
; 0012 0012     //printf("\nLED CHANGED");
; 0012 0013 
; 0012 0014 
; 0012 0015     LED_2_CHANGE;
; 0012 0016 
; 0012 0017     if(aux_flag){
; 0012 0018         LED_1_CHANGE;
; 0012 0019         aux_flag = 0;
; 0012 001A     }
; 0012 001B     else
; 0012 001C         aux_flag = 1;
; 0012 001D }
;
;
;void Test_process_buttons(){
; 0012 0020 void Test_process_buttons(){
; 0012 0021     static byte aux_top_first = 1, aux_bottom_first = 1;

	.DSEG

	.CSEG

	.DSEG

	.CSEG
; 0012 0022 
; 0012 0023     /* BUTTON TOP */
; 0012 0024     if(GET_BUTTON_TOP_STATE == 0){
; 0012 0025         if(aux_top_first){ //prave ted zmacknuto?
; 0012 0026             //uartSendBufferf(0,"\nI: Tlacitko TOP  bylo zmacknuto..");
; 0012 0027 
; 0012 0028             //printf("\n-");
; 0012 0029             //Disp_previous_screen();
; 0012 002A             aux_top_first = 0;
; 0012 002B         }
; 0012 002C     }
; 0012 002D     else    //tlacitko pusteno
; 0012 002E         aux_top_first = 1;  //vynulovani flagu pro nove zmacknuti
; 0012 002F 
; 0012 0030     /* BUTTON BOTTOM */
; 0012 0031     if(GET_BUTTON_BOTTOM_STATE == 0){ //prave ted zmacknuto?
; 0012 0032         if(aux_bottom_first){
; 0012 0033             //uartSendBufferf(0,"\nI: Tlacitko BOTTOM bylo zmacknuto..");
; 0012 0034 
; 0012 0035             //printf("\n+");
; 0012 0036             //Disp_next_screen();
; 0012 0037             aux_bottom_first = 0;
; 0012 0038         }
; 0012 0039     }
; 0012 003A     else    //tlacitko pusteno
; 0012 003B         aux_bottom_first = 1;   //vynulovani flagu pro nove zmacknuti
; 0012 003C }
;
;void Test_process_uart(void){
; 0012 003E void Test_process_uart(void){
; 0012 003F     //char text[] = "\nI: SendBuffer()";
; 0012 0040     //char a= 'a';
; 0012 0041 
; 0012 0042     //uartSendByte(0, a);
; 0012 0043     uartSendBufferf(1,"\nI: SendBufferf()");
; 0012 0044     // uartSendBuffer(0,text, 16);
; 0012 0045 }
;
;
;
;/* END OF TEST_PROCESS */
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
_0x20A0003:
	ADIW R28,1
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x14
	ADIW R28,3
	RET
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000018
	__CPWRN 16,17,2
	BRLO _0x2000019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x14
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x200001A
	CALL SUBOPT_0x14
_0x200001A:
_0x2000019:
	RJMP _0x200001B
_0x2000016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x200001B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0001
__print_G100:
	SBIW R28,11
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x13
_0x200001C:
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ADIW R30,1
	STD  Y+23,R30
	STD  Y+23+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x200001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000022
	CPI  R18,37
	BRNE _0x2000023
	LDI  R17,LOW(1)
	RJMP _0x2000024
_0x2000023:
	CALL SUBOPT_0x5B
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	CALL SUBOPT_0x5B
	RJMP _0x20000D8
_0x2000026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000027
	LDI  R16,LOW(1)
	RJMP _0x2000021
_0x2000027:
	CPI  R18,43
	BRNE _0x2000028
	LDI  R20,LOW(43)
	RJMP _0x2000021
_0x2000028:
	CPI  R18,32
	BRNE _0x2000029
	LDI  R20,LOW(32)
	RJMP _0x2000021
_0x2000029:
	RJMP _0x200002A
_0x2000025:
	CPI  R30,LOW(0x2)
	BRNE _0x200002B
_0x200002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x200002C
	ORI  R16,LOW(128)
	RJMP _0x2000021
_0x200002C:
	RJMP _0x200002D
_0x200002B:
	CPI  R30,LOW(0x3)
	BRNE _0x200002E
_0x200002D:
	CPI  R18,48
	BRLO _0x2000030
	CPI  R18,58
	BRLO _0x2000031
_0x2000030:
	RJMP _0x200002F
_0x2000031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000021
_0x200002F:
	CPI  R18,108
	BRNE _0x2000032
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000021
_0x2000032:
	RJMP _0x2000033
_0x200002E:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000021
_0x2000033:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000038
	CALL SUBOPT_0x5C
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x5D
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x73)
	BRNE _0x200003B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5E
	CALL _strlen
	MOV  R17,R30
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x70)
	BRNE _0x200003E
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5E
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200003C:
	ANDI R16,LOW(127)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x200003F
_0x200003E:
	CPI  R30,LOW(0x64)
	BREQ _0x2000042
	CPI  R30,LOW(0x69)
	BRNE _0x2000043
_0x2000042:
	ORI  R16,LOW(4)
	RJMP _0x2000044
_0x2000043:
	CPI  R30,LOW(0x75)
	BRNE _0x2000045
_0x2000044:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000046
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x5F
	LDI  R17,LOW(10)
	RJMP _0x2000047
_0x2000046:
	__GETD1N 0x2710
	CALL SUBOPT_0x5F
	LDI  R17,LOW(5)
	RJMP _0x2000047
_0x2000045:
	CPI  R30,LOW(0x58)
	BRNE _0x2000049
	ORI  R16,LOW(8)
	RJMP _0x200004A
_0x2000049:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x200007D
_0x200004A:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x200004C
	__GETD1N 0x10000000
	CALL SUBOPT_0x5F
	LDI  R17,LOW(8)
	RJMP _0x2000047
_0x200004C:
	__GETD1N 0x1000
	CALL SUBOPT_0x5F
	LDI  R17,LOW(4)
_0x2000047:
	SBRS R16,1
	RJMP _0x200004D
	CALL SUBOPT_0x5C
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x20000D9
_0x200004D:
	SBRS R16,2
	RJMP _0x200004F
	CALL SUBOPT_0x5C
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x20000D9
_0x200004F:
	CALL SUBOPT_0x5C
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x20000D9:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x2000051
	LDD  R26,Y+15
	TST  R26
	BRPL _0x2000052
	__GETD1S 12
	CALL __ANEGD1
	__PUTD1S 12
	LDI  R20,LOW(45)
_0x2000052:
	CPI  R20,0
	BREQ _0x2000053
	SUBI R17,-LOW(1)
	RJMP _0x2000054
_0x2000053:
	ANDI R16,LOW(251)
_0x2000054:
_0x2000051:
_0x200003F:
	SBRC R16,0
	RJMP _0x2000055
_0x2000056:
	CP   R17,R21
	BRSH _0x2000058
	SBRS R16,7
	RJMP _0x2000059
	SBRS R16,2
	RJMP _0x200005A
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200005B
_0x200005A:
	LDI  R18,LOW(48)
_0x200005B:
	RJMP _0x200005C
_0x2000059:
	LDI  R18,LOW(32)
_0x200005C:
	CALL SUBOPT_0x5B
	SUBI R21,LOW(1)
	RJMP _0x2000056
_0x2000058:
_0x2000055:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x200005D
_0x200005E:
	CPI  R19,0
	BREQ _0x2000060
	SBRS R16,3
	RJMP _0x2000061
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000062
_0x2000061:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000062:
	CALL SUBOPT_0x5B
	CPI  R21,0
	BREQ _0x2000063
	SUBI R21,LOW(1)
_0x2000063:
	SUBI R19,LOW(1)
	RJMP _0x200005E
_0x2000060:
	RJMP _0x2000064
_0x200005D:
_0x2000066:
	CALL SUBOPT_0x60
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000068
	SBRS R16,3
	RJMP _0x2000069
	SUBI R18,-LOW(55)
	RJMP _0x200006A
_0x2000069:
	SUBI R18,-LOW(87)
_0x200006A:
	RJMP _0x200006B
_0x2000068:
	SUBI R18,-LOW(48)
_0x200006B:
	SBRC R16,4
	RJMP _0x200006D
	CPI  R18,49
	BRSH _0x200006F
	__GETD2S 8
	__CPD2N 0x1
	BRNE _0x200006E
_0x200006F:
	RJMP _0x2000071
_0x200006E:
	CP   R21,R19
	BRLO _0x2000073
	SBRS R16,0
	RJMP _0x2000074
_0x2000073:
	RJMP _0x2000072
_0x2000074:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000075
	LDI  R18,LOW(48)
_0x2000071:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000076
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x5D
	CPI  R21,0
	BREQ _0x2000077
	SUBI R21,LOW(1)
_0x2000077:
_0x2000076:
_0x2000075:
_0x200006D:
	CALL SUBOPT_0x5B
	CPI  R21,0
	BREQ _0x2000078
	SUBI R21,LOW(1)
_0x2000078:
_0x2000072:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x60
	CALL __MODD21U
	__PUTD1S 12
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x5F
	__GETD1S 8
	CALL __CPD10
	BREQ _0x2000067
	RJMP _0x2000066
_0x2000067:
_0x2000064:
	SBRS R16,0
	RJMP _0x2000079
_0x200007A:
	CPI  R21,0
	BREQ _0x200007C
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x5D
	RJMP _0x200007A
_0x200007C:
_0x2000079:
_0x200007D:
_0x2000039:
_0x20000D8:
	LDI  R17,LOW(0)
_0x2000021:
	RJMP _0x200001C
_0x200001E:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,25
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x61
	SBIW R30,0
	BRNE _0x200007E
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x200007E:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x61
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL SUBOPT_0x36
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL SUBOPT_0x36
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG
_abs:
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret

	.DSEG

	.CSEG

	.CSEG
_memset:
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x20A0001:
	ADIW R28,5
	RET
_strcatf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcatf0:
    ld   r22,x+
    tst  r22
    brne strcatf0
    sbiw r26,1
strcatf1:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcatf1
    movw r30,r24
    ret
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
_strncpy:
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpy0:
    tst  r23
    breq strncpy1
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncpy0
strncpy2:
    tst  r23
    breq strncpy1
    dec  r23
    st   x+,r22
    rjmp strncpy2
strncpy1:
    movw r30,r24
    ret
_strncpyf:
    ld   r22,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncpyf0:
    tst  r22
    breq strncpyf1
    dec  r22
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strncpyf0
strncpyf2:
    tst  r22
    breq strncpyf1
    dec  r22
    st   x+,r0
    rjmp strncpyf2
strncpyf1:
    movw r30,r24
    ret

	.CSEG

	.CSEG

	.DSEG
_sMm:
	.BYTE 0x357
_sScreen_data:
	.BYTE 0x1
_sXport:
	.BYTE 0xA
_sKernel:
	.BYTE 0x2
_sProcess:
	.BYTE 0x6E
_uartReadyTx:
	.BYTE 0x2
_uartBufferedTx:
	.BYTE 0x2
_uartTxBuffer:
	.BYTE 0x10
_uartRxOverflow:
	.BYTE 0x4
_uart0TxData_G002:
	.BYTE 0x30
_uart1TxData_G002:
	.BYTE 0x30
_UartRxFunc_G002:
	.BYTE 0x4
_sDisplay:
	.BYTE 0x4
_cnt_pressed_1_S00D0001000:
	.BYTE 0x1
_cnt_pressed_2_S00D0001000:
	.BYTE 0x1
_flag_long_pressed_S00D0001000:
	.BYTE 0x1
_aux_flag_S00E0001000:
	.BYTE 0x1
_uartRxBuffer:
	.BYTE 0xA
_comm_terminal_state:
	.BYTE 0x1
_sFrame_Rx:
	.BYTE 0x25
_sProtocol:
	.BYTE 0x2
_send_group_S0110002000:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Create_Process

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	CALL _uartSendBufferf
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _uartSendBufferf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(11)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sProcess)
	SBCI R31,HIGH(-_sProcess)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	__GETD2S 6
	__CPD2N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5:
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	__GETD2S 6
	RCALL SUBOPT_0x5
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x8:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_UartRxFunc_G002)
	LDI  R27,HIGH(_UartRxFunc_G002)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0xA
	__GETD2N 0x8
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	CALL __DIVD21U
	__SUBD1N 1
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDD  R30,Y+1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	CALL __LSLW3
	SUBI R30,LOW(-_uartTxBuffer)
	SBCI R31,HIGH(-_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_uartBufferedTx)
	SBCI R31,HIGH(-_uartBufferedTx)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x12:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__GETWRZ 0,1,6
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(127)
	ST   -Y,R30
	JMP  _w_command

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	CALL _w_command
	LDI  R30,LOW(16)
	ST   -Y,R30
	JMP  _w_command

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x18:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x19:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	CALL _SPI_MasterTransmit
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(213)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sMm)
	SBCI R31,HIGH(-_sMm)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1D:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _maxq_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x20:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _maxq_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x21:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x22:
	CALL __LSLW3
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSRD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x23:
	CALL __LSLW3
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	JMP  _buffer2signed

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R0,R30
	MOVW R26,R18
	ADIW R26,4
	MOV  R30,R17
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	MOVW R26,R0
	CALL __CWD1
	CALL __PUTDP1
	MOVW R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x2710
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOVW R26,R20
	ADIW R26,21
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x28:
	CALL __GETD1S0
	__GETD2N 0x19C
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x186A0
	CALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	MOVW R26,R20
	ADIW R26,53
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2B:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2C:
	CALL __GETD1P
	__CPD1N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	__GETD1N 0x0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	MOVW R30,R20
	ADIW R30,1
	SUBI R30,LOW(-68)
	SBCI R31,HIGH(-68)
	MOVW R26,R30
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	CALL __SAVELOCR4
	LDI  R16,0
	LDD  R30,Y+4
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x30:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(_sDisplay)
	LDI  R31,HIGH(_sDisplay)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(17)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sSCREEN_GROUP*2)
	SBCI R31,HIGH(-_sSCREEN_GROUP*2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	CALL _strcatf
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcatf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x37:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	JMP  _strncpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x38:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	JMP  _strncpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x39:
	SUBI R30,-LOW(1)
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	JMP  _strncpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+4
	LDD  R27,Z+5
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	ST   -Y,R27
	ST   -Y,R26
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+8
	LDD  R27,Z+9
	ST   -Y,R27
	ST   -Y,R26
	__POINTW1FN _0x180000,108
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+10
	LDD  R27,Z+11
	ST   -Y,R27
	ST   -Y,R26
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x40:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_sScreen_data
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x42:
	LDS  R30,_sScreen_data
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x44:
	LDD  R26,Z+4
	LDD  R27,Z+5
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	MOVW R30,R28
	ADIW R30,4
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	ST   -Y,R27
	ST   -Y,R26
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	CALL __MODW21U
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x49:
	SBIW R28,40
	CALL __SAVELOCR4
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4A:
	MOVW R16,R30
	LDD  R30,Y+44
	LDD  R31,Y+44+1
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4B:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4C:
	CALL __GETD1P
	CALL __PUTPARD1
	MOVW R26,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	ADIW R26,5
	MOVW R30,R18
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4E:
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R26,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	CALL __MODW21U
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_sScreen_data
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x50:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	MOVW R30,R18
	ADIW R30,3
	LDD  R26,Y+44
	LDD  R27,Y+44+1
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x51:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x52:
	LDI  R30,LOW(21)
	ST   -Y,R30
	JMP  _strncpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	__POINTW1FN _0x180000,226
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	ADIW R26,13
	MOVW R30,R18
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x55:
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	CALL __MODD21
	ST   -Y,R31
	ST   -Y,R30
	CALL _abs
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_sScreen_data
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
	CALL __GETD1P
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	LDS  R30,_sScreen_data
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x59:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	MOVW R30,R18
	ADIW R30,3
	LDD  R26,Y+44
	LDD  R27,Y+44+1
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x5A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _CommXport_SendFrame

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5B:
	ST   -Y,R18
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5C:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5D:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5E:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	__GETD1S 8
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__MODD21:
	CLT
	SBRS R25,7
	RJMP __MODD211
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	SUBI R26,-1
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	SET
__MODD211:
	SBRC R23,7
	RCALL __ANEGD1
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	BRTC __MODD212
	RCALL __ANEGD1
__MODD212:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
