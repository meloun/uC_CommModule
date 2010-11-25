
;CodeVisionAVR C Compiler V2.04.8a Standard
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega324PA
;Program type             : Application
;Clock frequency          : 11,059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
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
	.DB  0x20,0x69,0x6E,0x67,0x2E,0x20,0x4C,0x2E
	.DB  0x4D,0x65,0x6C,0x69,0x63,0x68,0x61,0x72
	.DB  0x2C,0x20,0x69,0x6E,0x67,0x2E,0x20,0x50
	.DB  0x2E,0x4B,0x65,0x72,0x6E,0x64,0x6C,0x20
	.DB  0x0
_STRING_SEPARATOR:
	.DB  0xA,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0xA,0x23,0x20,0x48,0x57,0x3A,0x20,0x0
	.DB  0x43,0x6F,0x6D,0x6D,0x4D,0x6F,0x64,0x75
	.DB  0x6C,0x0,0x20,0x76,0x0,0x31,0x2E,0x30
	.DB  0x30,0x0,0xA,0x23,0x20,0x53,0x57,0x3A
	.DB  0x20,0x0,0x54,0x65,0x73,0x74,0x48,0x77
	.DB  0x0,0xA,0x49,0x3A,0x20,0x53,0x79,0x73
	.DB  0x74,0x65,0x6D,0x20,0x73,0x74,0x61,0x72
	.DB  0x74,0x2E,0x2E,0x0
_0x20005:
	.DB  0x1
_0x20006:
	.DB  0x1
_0x20000:
	.DB  0xA,0x49,0x3A,0x20,0x54,0x6C,0x61,0x63
	.DB  0x69,0x74,0x6B,0x6F,0x20,0x54,0x4F,0x50
	.DB  0x20,0x20,0x62,0x79,0x6C,0x6F,0x20,0x7A
	.DB  0x6D,0x61,0x63,0x6B,0x6E,0x75,0x74,0x6F
	.DB  0x2E,0x2E,0x0,0xA,0x49,0x3A,0x20,0x54
	.DB  0x6C,0x61,0x63,0x69,0x74,0x6B,0x6F,0x20
	.DB  0x42,0x4F,0x54,0x54,0x4F,0x4D,0x20,0x62
	.DB  0x79,0x6C,0x6F,0x20,0x7A,0x6D,0x61,0x63
	.DB  0x6B,0x6E,0x75,0x74,0x6F,0x2E,0x2E,0x0
	.DB  0xA,0x49,0x3A,0x20,0x53,0x65,0x6E,0x64
	.DB  0x42,0x75,0x66,0x66,0x65,0x72,0x66,0x28
	.DB  0x29,0x0
_0x40000:
	.DB  0xA,0x49,0x3A,0x20,0x50,0x72,0x69,0x6A
	.DB  0x6D,0x75,0x74,0x20,0x73,0x74,0x72,0x69
	.DB  0x6E,0x67,0x3A,0x20,0x0,0xA,0x45,0x3A
	.DB  0x20,0x4E,0x65,0x64,0x6F,0x73,0x74,0x61
	.DB  0x74,0x65,0x63,0x6E,0x79,0x20,0x62,0x75
	.DB  0x66,0x66,0x65,0x72,0x2C,0x20,0x73,0x74
	.DB  0x72,0x69,0x6E,0x67,0x3A,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _aux_top_first_S0010001000
	.DW  _0x20005*2

	.DW  0x01
	.DW  _aux_bottom_first_S0010001000
	.DW  _0x20006*2

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
;/*****************************************************
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
;#include <digital_outputs.h>
;#include <buttons.h>
;#include <test_process.h>
;#include <comm_terminal.h>
;
;void HW_init(void);
;
;
;void main(void){
; 0000 0017 void main(void){

	.CSEG
_main:
; 0000 0018 
; 0000 0019   /* HW Inits */
; 0000 001A   HW_init();
	RCALL _HW_init
; 0000 001B   Digital_outputs_init();
	CALL _Digital_outputs_init
; 0000 001C   Buttons_init();
	CALL _Buttons_init
; 0000 001D 
; 0000 001E   /* SW Inits */
; 0000 001F   //uart
; 0000 0020   CommTerminal_Init(); //init ports, registers, baudrate, RX handler
	CALL _CommTerminal_Init
; 0000 0021 
; 0000 0022   /* KERNEL Init */
; 0000 0023   uKnos_Init();
	CALL _uKnos_Init
; 0000 0024 
; 0000 0025   //******************************************
; 0000 0026   // PROCESSES
; 0000 0027   // - period in miliseconds, shortest period is 10ms
; 0000 0028   //******************************************
; 0000 0029   Create_Process( 100, CommTerminal_Manager);   //zpracovava buffer naplneny prijmutymi znaky
	__GETD1N 0x64
	CALL __PUTPARD1
	LDI  R30,LOW(_CommTerminal_Manager)
	LDI  R31,HIGH(_CommTerminal_Manager)
	CALL SUBOPT_0x0
; 0000 002A   Create_Process(  200, Test_process_buttons);  //vypisuje jake tlacitko bylo zmacknuto
	__GETD1N 0xC8
	CALL __PUTPARD1
	LDI  R30,LOW(_Test_process_buttons)
	LDI  R31,HIGH(_Test_process_buttons)
	CALL SUBOPT_0x0
; 0000 002B   Create_Process( 1000, Test_process_leds);     //blika led
	__GETD1N 0x3E8
	CALL __PUTPARD1
	LDI  R30,LOW(_Test_process_leds)
	LDI  R31,HIGH(_Test_process_leds)
	CALL SUBOPT_0x0
; 0000 002C 
; 0000 002D   //print messages
; 0000 002E   uartSendBufferf(0, STRING_START_MESSAGE);  //start message
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_STRING_START_MESSAGE*2)
	LDI  R31,HIGH(_STRING_START_MESSAGE*2)
	CALL SUBOPT_0x1
; 0000 002F   uartSendBufferf(0, "\n# HW: "); uartSendBufferf(0, HW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, HW_VERSION_S); //version
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,8
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,21
	CALL SUBOPT_0x1
; 0000 0030   uartSendBufferf(0, "\n# SW: "); uartSendBufferf(0, SW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, SW_VERSION_S); //version
	__POINTW1FN _0x0,26
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,21
	CALL SUBOPT_0x1
; 0000 0031   uartSendBufferf(0, STRING_SEPARATOR);
	LDI  R30,LOW(_STRING_SEPARATOR*2)
	LDI  R31,HIGH(_STRING_SEPARATOR*2)
	CALL SUBOPT_0x2
; 0000 0032 
; 0000 0033   //Start uKnos
; 0000 0034   uKnos_Start(); //enable interrupt
	CALL _uKnos_Start
; 0000 0035   uartSendBufferf(0,"\nI: System start..");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x2
; 0000 0036 
; 0000 0037   while (1){
_0x3:
; 0000 0038 
; 0000 0039     ; //nothing to do
; 0000 003A 
; 0000 003B   }
	RJMP _0x3
; 0000 003C }
_0x6:
	RJMP _0x6
;
;//**************************************************************************
;// Nastaveni MCU
;//**************************************************************************
;void HW_init(void)
; 0000 0042 {
_HW_init:
; 0000 0043     // Crystal Oscillator division factor: 1
; 0000 0044     #pragma optsize-
; 0000 0045     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0046     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0047     #ifdef _OPTIMIZE_SIZE_
; 0000 0048     #pragma optsize+
; 0000 0049     #endif
; 0000 004A 
; 0000 004B     // Input/Output Ports initialization
; 0000 004C     // Port A initialization
; 0000 004D     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004E     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 004F     PORTA=0x00;
	OUT  0x2,R30
; 0000 0050     DDRA=0x00;
	OUT  0x1,R30
; 0000 0051 
; 0000 0052     // Port B initialization
; 0000 0053     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0054     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0055     PORTB=0x00;
	OUT  0x5,R30
; 0000 0056     DDRB=0x00;
	OUT  0x4,R30
; 0000 0057 
; 0000 0058     // Port C initialization
; 0000 0059     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005A     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 005B     PORTC=0x00;
	OUT  0x8,R30
; 0000 005C     DDRC=0x00;
	OUT  0x7,R30
; 0000 005D 
; 0000 005E     // Port D initialization
; 0000 005F     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0060     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0061     PORTD=0x00;
	OUT  0xB,R30
; 0000 0062     DDRD=0x00;
	OUT  0xA,R30
; 0000 0063 
; 0000 0064     // Timer/Counter 0 initialization
; 0000 0065     // Clock source: System Clock
; 0000 0066     // Clock value: Timer 0 Stopped
; 0000 0067     // Mode: Normal top=FFh
; 0000 0068     // OC0A output: Disconnected
; 0000 0069     // OC0B output: Disconnected
; 0000 006A     TCCR0A=0x00;
	OUT  0x24,R30
; 0000 006B     TCCR0B=0x00;
	OUT  0x25,R30
; 0000 006C     TCNT0=0x00;
	OUT  0x26,R30
; 0000 006D     OCR0A=0x00;
	OUT  0x27,R30
; 0000 006E     OCR0B=0x00;
	OUT  0x28,R30
; 0000 006F 
; 0000 0070     // Timer/Counter 1 initialization
; 0000 0071     // Clock source: System Clock
; 0000 0072     // Clock value: Timer1 Stopped
; 0000 0073     // Mode: Normal top=FFFFh
; 0000 0074     // OC1A output: Discon.
; 0000 0075     // OC1B output: Discon.
; 0000 0076     // Noise Canceler: Off
; 0000 0077     // Input Capture on Falling Edge
; 0000 0078     // Timer1 Overflow Interrupt: Off
; 0000 0079     // Input Capture Interrupt: Off
; 0000 007A     // Compare A Match Interrupt: Off
; 0000 007B     // Compare B Match Interrupt: Off
; 0000 007C     TCCR1A=0x00;
	STS  128,R30
; 0000 007D     TCCR1B=0x00;
	STS  129,R30
; 0000 007E     TCNT1H=0x00;
	STS  133,R30
; 0000 007F     TCNT1L=0x00;
	STS  132,R30
; 0000 0080     ICR1H=0x00;
	STS  135,R30
; 0000 0081     ICR1L=0x00;
	STS  134,R30
; 0000 0082     OCR1AH=0x00;
	STS  137,R30
; 0000 0083     OCR1AL=0x00;
	STS  136,R30
; 0000 0084     OCR1BH=0x00;
	STS  139,R30
; 0000 0085     OCR1BL=0x00;
	STS  138,R30
; 0000 0086 
; 0000 0087     // Timer/Counter 2 initialization
; 0000 0088     // Clock source: System Clock
; 0000 0089     // Clock value: Timer2 Stopped
; 0000 008A     // Mode: Normal top=FFh
; 0000 008B     // OC2A output: Disconnected
; 0000 008C     // OC2B output: Disconnected
; 0000 008D     ASSR=0x00;
	STS  182,R30
; 0000 008E     TCCR2A=0x00;
	STS  176,R30
; 0000 008F     TCCR2B=0x00;
	STS  177,R30
; 0000 0090     TCNT2=0x00;
	STS  178,R30
; 0000 0091     OCR2A=0x00;
	STS  179,R30
; 0000 0092     OCR2B=0x00;
	STS  180,R30
; 0000 0093 
; 0000 0094     // External Interrupt(s) initialization
; 0000 0095     // INT0: Off
; 0000 0096     // INT1: Off
; 0000 0097     // INT2: Off
; 0000 0098     // Interrupt on any change on pins PCINT0-7: Off
; 0000 0099     // Interrupt on any change on pins PCINT8-15: Off
; 0000 009A     // Interrupt on any change on pins PCINT16-23: Off
; 0000 009B     // Interrupt on any change on pins PCINT24-31: Off
; 0000 009C     EICRA=0x00;
	STS  105,R30
; 0000 009D     EIMSK=0x00;
	OUT  0x1D,R30
; 0000 009E     PCICR=0x00;
	STS  104,R30
; 0000 009F 
; 0000 00A0     // Timer/Counter 0 Interrupt(s) initialization
; 0000 00A1     TIMSK0=0x00;
	STS  110,R30
; 0000 00A2     // Timer/Counter 1 Interrupt(s) initialization
; 0000 00A3     TIMSK1=0x00;
	STS  111,R30
; 0000 00A4     // Timer/Counter 2 Interrupt(s) initialization
; 0000 00A5     TIMSK2=0x00;
	STS  112,R30
; 0000 00A6 
; 0000 00A7     // USART0 initialization
; 0000 00A8     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00A9     // USART0 Receiver: Off
; 0000 00AA     // USART0 Transmitter: On
; 0000 00AB     // USART0 Mode: Asynchronous
; 0000 00AC     // USART0 Baud Rate: 9600
; 0000 00AD     UCSR0A=0x00;
	STS  192,R30
; 0000 00AE     UCSR0B=0x08;
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 00AF     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00B0     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00B1     UBRR0L=0x47;
	LDI  R30,LOW(71)
	STS  196,R30
; 0000 00B2 
; 0000 00B3     // Analog Comparator initialization
; 0000 00B4     // Analog Comparator: Off
; 0000 00B5     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00B6     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00B7     ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00B8 }
	RET
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
;#include <digital_outputs.h>
;#include <buttons.h>
;#include <uart2.h>
;
;
;void Test_process_leds(void){
; 0001 000C void Test_process_leds(void){

	.CSEG
_Test_process_leds:
; 0001 000D     static byte aux_flag = 0;
; 0001 000E 
; 0001 000F     LED_2_CHANGE;
	IN   R30,0xB
	LDI  R26,LOW(128)
	EOR  R30,R26
	OUT  0xB,R30
; 0001 0010 
; 0001 0011     if(aux_flag){
	LDS  R30,_aux_flag_S0010000000
	CPI  R30,0
	BREQ _0x20003
; 0001 0012         LED_1_CHANGE;
	IN   R30,0xB
	LDI  R26,LOW(64)
	EOR  R30,R26
	OUT  0xB,R30
; 0001 0013         aux_flag = 0;
	LDI  R30,LOW(0)
	RJMP _0x2000D
; 0001 0014     }
; 0001 0015     else
_0x20003:
; 0001 0016         aux_flag = 1;
	LDI  R30,LOW(1)
_0x2000D:
	STS  _aux_flag_S0010000000,R30
; 0001 0017 }
	RET
;
;
;void Test_process_buttons(){
; 0001 001A void Test_process_buttons(){
_Test_process_buttons:
; 0001 001B     static byte aux_top_first = 1, aux_bottom_first = 1;

	.DSEG

	.CSEG

	.DSEG

	.CSEG
; 0001 001C 
; 0001 001D     /* BUTTON TOP */
; 0001 001E     if(GET_BUTTON_TOP_STATE == 0){
	SBIC 0x6,7
	RJMP _0x20007
; 0001 001F         if(aux_top_first){ //prave ted zmacknuto?
	LDS  R30,_aux_top_first_S0010001000
	CPI  R30,0
	BREQ _0x20008
; 0001 0020             uartSendBufferf(0,"\nI: Tlacitko TOP  bylo zmacknuto..");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x20000,0
	CALL SUBOPT_0x2
; 0001 0021             aux_top_first = 0;
	LDI  R30,LOW(0)
	STS  _aux_top_first_S0010001000,R30
; 0001 0022         }
; 0001 0023     }
_0x20008:
; 0001 0024     else    //tlacitko pusteno
	RJMP _0x20009
_0x20007:
; 0001 0025         aux_top_first = 1;  //vynulovani flagu pro nove zmacknuti
	LDI  R30,LOW(1)
	STS  _aux_top_first_S0010001000,R30
; 0001 0026 
; 0001 0027     /* BUTTON BOTTOM */
; 0001 0028     if(GET_BUTTON_BOTTOM_STATE == 0){ //prave ted zmacknuto?
_0x20009:
	SBIC 0x6,6
	RJMP _0x2000A
; 0001 0029         if(aux_bottom_first){
	LDS  R30,_aux_bottom_first_S0010001000
	CPI  R30,0
	BREQ _0x2000B
; 0001 002A             uartSendBufferf(0,"\nI: Tlacitko BOTTOM bylo zmacknuto..");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x20000,35
	CALL SUBOPT_0x2
; 0001 002B             aux_bottom_first = 0;
	LDI  R30,LOW(0)
	STS  _aux_bottom_first_S0010001000,R30
; 0001 002C         }
; 0001 002D     }
_0x2000B:
; 0001 002E     else    //tlacitko pusteno
	RJMP _0x2000C
_0x2000A:
; 0001 002F         aux_bottom_first = 1;   //vynulovani flagu pro nove zmacknuti
	LDI  R30,LOW(1)
	STS  _aux_bottom_first_S0010001000,R30
; 0001 0030 }
_0x2000C:
	RET
;
;void Test_process_uart(void){
; 0001 0032 void Test_process_uart(void){
; 0001 0033     //char text[] = "\nI: SendBuffer()";
; 0001 0034     //char a= 'a';
; 0001 0035 
; 0001 0036     //uartSendByte(0, a);
; 0001 0037     uartSendBufferf(1,"\nI: SendBufferf()");
; 0001 0038     // uartSendBuffer(0,text, 16);
; 0001 0039 }
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
; 0002 001D {

	.CSEG
_CommTerminal_Init:
; 0002 001E 
; 0002 001F 	//Rx pin init
; 0002 0020 	COMM_TERMINAL_DDR &= ~COMM_TERMINAL_RX_PIN_MASK; 	//0 -> input
	CBI  0xA,0
; 0002 0021 	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> pullup
	SBI  0xB,0
; 0002 0022 	//Tx pin init
; 0002 0023 	COMM_TERMINAL_DDR |= COMM_TERMINAL_TX_PIN_MASK; 	//1 -> output
	SBI  0xA,1
; 0002 0024 	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> default output = '1'
	SBI  0xB,0
; 0002 0025 
; 0002 0026     // USART param setting
; 0002 0027 	uart0Init();            // Tx, Rx, TxIRq, RxIRq
	RCALL _uart0Init
; 0002 0028 	uartSetBaudRate(0, COMM_TERMINAL_BAUDRATE, 0);   // Commspeed
	LDI  R30,LOW(0)
	ST   -Y,R30
	__GETD1N 0x2580
	CALL __PUTPARD1
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _uartSetBaudRate
; 0002 0029 	uartSetRxHandler(0,CommTerminal_Handler);        // Rx bytes handler
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_CommTerminal_Handler)
	LDI  R31,HIGH(_CommTerminal_Handler)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _uartSetRxHandler
; 0002 002A 
; 0002 002B     // Variables init
; 0002 002C     uartRxBuffer_index = 0;
	CLR  R5
; 0002 002D }
	RET
;
;// CommApp_Handler() - routine for received char from UART.
;// Received char is processed, after last char is received,
;// control "comm_terminal_state" is switched to special state allowing
;// processing and executing of command
;void CommTerminal_Handler(byte data){
; 0002 0033 void CommTerminal_Handler(byte data){
_CommTerminal_Handler:
; 0002 0034 
; 0002 0035     if(comm_terminal_state == eWAIT_FOR_CHAR){
;	data -> Y+0
	LDS  R30,_comm_terminal_state
	CPI  R30,0
	BRNE _0x40003
; 0002 0036 
; 0002 0037         //ukoncovaci znak?
; 0002 0038         if ((data == '\n')||(data == '\r')){
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x40005
	CPI  R26,LOW(0xD)
	BRNE _0x40004
_0x40005:
; 0002 0039             comm_terminal_state = eWAIT_FOR_PROCESS_OK;
	LDI  R30,LOW(1)
	STS  _comm_terminal_state,R30
; 0002 003A             return; //-> ukoncovaci znak se do bufferu nevklada
	RJMP _0x2060004
; 0002 003B         }
; 0002 003C 
; 0002 003D         //ulozeni znaku do bufferu
; 0002 003E         uartRxBuffer[uartRxBuffer_index++] = data;
_0x40004:
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_uartRxBuffer)
	SBCI R31,HIGH(-_uartRxBuffer)
	LD   R26,Y
	STD  Z+0,R26
; 0002 003F 
; 0002 0040         //je jeste misto pro dalsi prijem?
; 0002 0041         if(uartRxBuffer_index ==  RX_BUFFER_SIZE){
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x40007
; 0002 0042            comm_terminal_state = eWAIT_FOR_PROCESS_KO;
	LDI  R30,LOW(2)
	STS  _comm_terminal_state,R30
; 0002 0043         }
; 0002 0044     }
_0x40007:
; 0002 0045 }
_0x40003:
	RJMP _0x2060004
;void CommTerminal_Manager(void){
; 0002 0046 void CommTerminal_Manager(void){
_CommTerminal_Manager:
; 0002 0047     switch(comm_terminal_state){
	LDS  R30,_comm_terminal_state
	LDI  R31,0
; 0002 0048         case eWAIT_FOR_PROCESS_OK:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4000B
; 0002 0049             uartSendBufferf(0,"\nI: Prijmut string: ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x40000,0
	RJMP _0x4000E
; 0002 004A             break;
; 0002 004B         case  eWAIT_FOR_PROCESS_KO:
_0x4000B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4000A
; 0002 004C             uartSendBufferf(0,"\nE: Nedostatecny buffer, string:");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x40000,21
_0x4000E:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _uartSendBufferf
; 0002 004D             break;
; 0002 004E     }
_0x4000A:
; 0002 004F 
; 0002 0050     if(comm_terminal_state != eWAIT_FOR_CHAR){
	LDS  R30,_comm_terminal_state
	CPI  R30,0
	BREQ _0x4000D
; 0002 0051         uartSendBuffer(0, uartRxBuffer, uartRxBuffer_index);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_uartRxBuffer)
	LDI  R31,HIGH(_uartRxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _uartSendBuffer
; 0002 0052         uartRxBuffer_index = 0;           //flush buffer
	CLR  R5
; 0002 0053         comm_terminal_state = eWAIT_FOR_CHAR;  //povoleni dalsiho prijmu
	LDI  R30,LOW(0)
	STS  _comm_terminal_state,R30
; 0002 0054     }
; 0002 0055 }
_0x4000D:
	RET
;
;
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
; 0003 002E {

	.CSEG
; 0003 002F 	// initialize uarts
; 0003 0030     if(nUart)
;	nUart -> Y+0
; 0003 0031         uart1Init();
; 0003 0032     else
; 0003 0033 	    uart0Init();
; 0003 0034 
; 0003 0035 }
;
;void uart0Init(void)
; 0003 0038 {
_uart0Init:
; 0003 0039 	// initialize the buffers
; 0003 003A 	uart0InitBuffers();
	RCALL _uart0InitBuffers
; 0003 003B 
; 0003 003C 	// initialize user receive handlers
; 0003 003D 	UartRxFunc[0] = 0;
	LDI  R30,LOW(0)
	STS  _UartRxFunc_G003,R30
	STS  _UartRxFunc_G003+1,R30
; 0003 003E 
; 0003 003F 	// enable RxD/TxD and interrupts
; 0003 0040 	UCSR0B = (1<<RXCIE) | (1<<TXCIE) | (1<<RXEN) | (1<<TXEN);
	LDI  R30,LOW(216)
	STS  193,R30
; 0003 0041 
; 0003 0042 	// set default baud rate
; 0003 0043     // uartSetBaudRate(0, UART0_DEFAULT_BAUD_RATE);
; 0003 0044 
; 0003 0045 	// initialize states
; 0003 0046 	uartReadyTx[0] = 1;
	LDI  R30,LOW(1)
	STS  _uartReadyTx,R30
; 0003 0047 	uartBufferedTx[0] = 0;
	LDI  R30,LOW(0)
	STS  _uartBufferedTx,R30
; 0003 0048 
; 0003 0049 	// clear overflow count
; 0003 004A 	uartRxOverflow[0] = 0;
	STS  _uartRxOverflow,R30
	STS  _uartRxOverflow+1,R30
; 0003 004B 
; 0003 004C 	// enable interrupts
; 0003 004D 	//#asm("sei")
; 0003 004E }
	RET
;
;void uart1Init(void)
; 0003 0051 {
; 0003 0052 	// initialize the buffers
; 0003 0053 	uart1InitBuffers();
; 0003 0054 	// initialize user receive handlers
; 0003 0055 	UartRxFunc[1] = 0;
; 0003 0056 	// enable RxD/TxD and interrupts
; 0003 0057 	UCSR1B = (1<<RXCIE) | (1<<TXCIE) | (1<<RXEN) | (1<<TXEN);
; 0003 0058 	// set default baud rate
; 0003 0059 //	uartSetBaudRate(1, UART1_DEFAULT_BAUD_RATE);
; 0003 005A 	// initialize states
; 0003 005B 	uartReadyTx[1] = 1;
; 0003 005C 	uartBufferedTx[1] = 0;
; 0003 005D 	// clear overflow count
; 0003 005E 	uartRxOverflow[1] = 0;
; 0003 005F 	// enable interrupts
; 0003 0060 	#asm("sei")
; 0003 0061 }
;
;void uart0InitBuffers(void)
; 0003 0064 {
_uart0InitBuffers:
; 0003 0065     // initialize the UART0 buffers
; 0003 0066 	bufferInit(&uartTxBuffer[0], uart0TxData, UART0_TX_BUFFER_SIZE);
	LDI  R30,LOW(_uartTxBuffer)
	LDI  R31,HIGH(_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_uart0TxData_G003)
	LDI  R31,HIGH(_uart0TxData_G003)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	CALL _bufferInit
; 0003 0067 }
	RET
;
;void uart1InitBuffers(void)
; 0003 006A {
; 0003 006B 	// initialize the UART1 buffers
; 0003 006C 	bufferInit(&uartTxBuffer[1], uart1TxData, UART1_TX_BUFFER_SIZE);
; 0003 006D }
;
;void uartSetRxHandler(byte nUart, void (*rx_func)(unsigned char c))
; 0003 0070 {
_uartSetRxHandler:
; 0003 0071 	if(nUart < 2) // make sure the uart number is within bounds
;	nUart -> Y+2
;	*rx_func -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRSH _0x60005
; 0003 0072 	{
; 0003 0073 		UartRxFunc[nUart] = rx_func; // set the receive interrupt to run the supplied user function
	LDD  R30,Y+2
	CALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0003 0074 	}
; 0003 0075 }
_0x60005:
	JMP  _0x2060001
;
;void uartSetBaudRate(byte nUart, dword baudrate, byte double_speed_mode)
; 0003 0078 {
_uartSetBaudRate:
; 0003 0079 	word bauddiv;
; 0003 007A 	byte u2x_flag;
; 0003 007B 
; 0003 007C 	if(double_speed_mode){
	CALL __SAVELOCR4
;	nUart -> Y+9
;	baudrate -> Y+5
;	double_speed_mode -> Y+4
;	bauddiv -> R16,R17
;	u2x_flag -> R19
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x60006
; 0003 007D 		bauddiv = ((F_CPU+(baudrate*4L))/(baudrate*8L)-1); // calculate division factor for requested baud rate, and set it
	CALL SUBOPT_0x4
	CALL __LSLD1
	CALL __LSLD1
	__ADDD1N 11059200
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x6
; 0003 007E 		u2x_flag = 1;
	LDI  R19,LOW(1)
; 0003 007F 	}
; 0003 0080 	else{
	RJMP _0x60007
_0x60006:
; 0003 0081 		bauddiv = ((F_CPU+(baudrate*8L))/(baudrate*16L)-1); // calculate division factor for requested baud rate, and set it
	CALL SUBOPT_0x5
	__ADDD1N 11059200
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	__GETD2N 0x10
	CALL __MULD12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x6
; 0003 0082 		u2x_flag = 0;
	LDI  R19,LOW(0)
; 0003 0083 	}
_0x60007:
; 0003 0084 
; 0003 0085 	if(nUart)
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x60008
; 0003 0086 	{
; 0003 0087 		UBRR1L = bauddiv;
	STS  204,R16
; 0003 0088 		#ifdef UBRR1H
; 0003 0089 		UBRR1H = (bauddiv>>8);
	STS  205,R17
; 0003 008A 		#endif
; 0003 008B 		UCSR0A &= ~(1 << U2X0); 			//clear
	LDS  R30,192
	ANDI R30,0xFD
	STS  192,R30
; 0003 008C 		UCSR0A |= (u2x_flag << U2X0);		//set (if u2x_flag is set)
	LDI  R26,LOW(192)
	LDI  R27,HIGH(192)
	RJMP _0x60030
; 0003 008D 	}
; 0003 008E 	else
_0x60008:
; 0003 008F 	{
; 0003 0090 		UBRR0L = bauddiv;
	STS  196,R16
; 0003 0091 		#ifdef UBRR0H
; 0003 0092 		UBRR0H = (bauddiv>>8);
	STS  197,R17
; 0003 0093 		#endif
; 0003 0094 		UCSR1A &= ~(1 << U2X0); 			//clear
	LDS  R30,200
	ANDI R30,0xFD
	STS  200,R30
; 0003 0095 		UCSR1A |= (u2x_flag << U2X0);		//set (if u2x_flag is set)
	LDI  R26,LOW(200)
	LDI  R27,HIGH(200)
_0x60030:
	MOV  R0,R26
	LD   R26,X
	MOV  R30,R19
	LSL  R30
	OR   R30,R26
	MOV  R26,R0
	ST   X,R30
; 0003 0096 	}
; 0003 0097 }
	RJMP _0x2060002
;
;cBuffer* uartGetTxBuffer(byte nUart)
; 0003 009A {
; 0003 009B 	return &uartTxBuffer[nUart]; // return tx buffer pointer
;	nUart -> Y+0
; 0003 009C }
;
;void uartSendByte(byte nUart, byte txData)
; 0003 009F {
_uartSendByte:
; 0003 00A0   // wait for the transmitter to be ready
; 0003 00A1   while(!uartReadyTx[nUart]);
;	nUart -> Y+1
;	txData -> Y+0
_0x6000A:
	LDD  R30,Y+1
	CALL SUBOPT_0x7
	LD   R30,Z
	CPI  R30,0
	BREQ _0x6000A
; 0003 00A2 
; 0003 00A3   //L.M. - vysilam v preruseni od prijmu
; 0003 00A4   // vyvola se znova preruseni od prijmu ale neprobehlo preruseni od vysilani kde se shazuje flag
; 0003 00A5   //uartReadyTx[nUart] = 0; // set ready state to 0
; 0003 00A6 
; 0003 00A7 	// send byte
; 0003 00A8 	if(nUart)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x6000D
; 0003 00A9 	{
; 0003 00AA 		while(!(UCSR1A & (1<<UDRE)));
_0x6000E:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x6000E
; 0003 00AB 			UDR1 = txData;
	LD   R30,Y
	STS  206,R30
; 0003 00AC 	}
; 0003 00AD 	else
	RJMP _0x60011
_0x6000D:
; 0003 00AE 	{
; 0003 00AF 		while(!(UCSR0A & (1<<UDRE)));
_0x60012:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x60012
; 0003 00B0 			UDR0 = txData;
	LD   R30,Y
	STS  198,R30
; 0003 00B1 	}
_0x60011:
; 0003 00B2 }
	RJMP _0x2060003
;
;void uart0SendByte(u08 data)
; 0003 00B5 {
; 0003 00B6 	// send byte on UART0
; 0003 00B7 	uartSendByte(0, data);
;	data -> Y+0
; 0003 00B8 }
;
;void uart1SendByte(u08 data)
; 0003 00BB {
; 0003 00BC 	// send byte on UART1
; 0003 00BD 	uartSendByte(1, data);
;	data -> Y+0
; 0003 00BE }
;
;void uartAddToTxBuffer(byte nUart, byte data)
; 0003 00C1 {
; 0003 00C2 	// add data byte to the end of the tx buffer
; 0003 00C3 	bufferAddToEnd(&uartTxBuffer[nUart], data);
;	nUart -> Y+1
;	data -> Y+0
; 0003 00C4 }
;
;void uartSendTxBuffer(byte nUart)
; 0003 00C7 {
; 0003 00C8 	// turn on buffered transmit
; 0003 00C9 	uartBufferedTx[nUart] = 1;
;	nUart -> Y+0
; 0003 00CA 	// send the first byte to get things going by interrupts
; 0003 00CB 	uartSendByte(nUart, bufferGetFromFront(&uartTxBuffer[nUart]));
; 0003 00CC }
;
;byte uartSendBuffer(byte nUart, char *buffer, word nBytes)
; 0003 00CF {
_uartSendBuffer:
; 0003 00D0 	register byte first;
; 0003 00D1 	register word i;
; 0003 00D2 
; 0003 00D3 	// check if there's space (and that we have any bytes to send at all)
; 0003 00D4 	if((uartTxBuffer[nUart].datalength + nBytes < uartTxBuffer[nUart].size) && nBytes)
	CALL __SAVELOCR4
;	nUart -> Y+8
;	*buffer -> Y+6
;	nBytes -> Y+4
;	first -> R17
;	i -> R18,R19
	CALL SUBOPT_0x8
	MOVW R22,R30
	__ADDW1MN _uartTxBuffer,4
	MOVW R26,R30
	CALL __GETW1P
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	__ADDW1MN _uartTxBuffer,2
	MOVW R26,R30
	CALL SUBOPT_0x9
	BRSH _0x60016
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x60017
_0x60016:
	RJMP _0x60015
_0x60017:
; 0003 00D5 	{
; 0003 00D6 		first = *buffer++; // grab first character
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R17,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
; 0003 00D7 		// copy user buffer to uart transmit buffer
; 0003 00D8 		for(i = 0; i < nBytes-1; i++)
	__GETWRN 18,19,0
_0x60019:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x6001A
; 0003 00D9 		{
; 0003 00DA 			bufferAddToEnd(&uartTxBuffer[nUart], *buffer++); // put data bytes at end of buffer
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_uartTxBuffer)
	SBCI R31,HIGH(-_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X+
	STD  Y+8,R26
	STD  Y+8+1,R27
	ST   -Y,R30
	CALL _bufferAddToEnd
; 0003 00DB 		}
	__ADDWRN 18,19,1
	RJMP _0x60019
_0x6001A:
; 0003 00DC 
; 0003 00DD 		// send the first byte to get things going by interrupts
; 0003 00DE 		uartBufferedTx[nUart] = 1;
	LDD  R30,Y+8
	CALL SUBOPT_0xA
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0003 00DF 		uartSendByte(nUart, first);
	LDD  R30,Y+8
	ST   -Y,R30
	ST   -Y,R17
	RCALL _uartSendByte
; 0003 00E0 		return 1; // return success
	LDI  R30,LOW(1)
	RJMP _0x2060005
; 0003 00E1 	}
; 0003 00E2 	else
_0x60015:
; 0003 00E3 	{
; 0003 00E4 		return 0; // return failure
	LDI  R30,LOW(0)
; 0003 00E5 	}
; 0003 00E6 }
_0x2060005:
	CALL __LOADLOCR4
	ADIW R28,9
	RET
;void uartSendBufferf(byte nUart, char flash *text){
; 0003 00E7 void uartSendBufferf(byte nUart, char flash *text){
_uartSendBufferf:
; 0003 00E8   while(*text)
;	nUart -> Y+2
;	*text -> Y+0
_0x6001C:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x6001E
; 0003 00E9   {
; 0003 00EA   	if(nUart){
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x6001F
; 0003 00EB     	while (!( UCSR1A & 0x20));
_0x60020:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x60020
; 0003 00EC     	UDR1 = *text++;
	CALL SUBOPT_0xB
	STS  206,R30
; 0003 00ED   	}
; 0003 00EE   	else{
	RJMP _0x60023
_0x6001F:
; 0003 00EF     	while (!( UCSR0A & 0x20));
_0x60024:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x60024
; 0003 00F0     	UDR0 = *text++;
	CALL SUBOPT_0xB
	STS  198,R30
; 0003 00F1   	}
_0x60023:
; 0003 00F2   }
	RJMP _0x6001C
_0x6001E:
; 0003 00F3 }
	JMP  _0x2060001
;
;// UART Transmit Complete Interrupt Function
;void uartTransmitService(byte nUart)
; 0003 00F7 {
_uartTransmitService:
; 0003 00F8 	// check if buffered tx is enabled
; 0003 00F9 	if(uartBufferedTx[nUart])
;	nUart -> Y+0
	LD   R30,Y
	CALL SUBOPT_0xA
	LD   R30,Z
	CPI  R30,0
	BREQ _0x60027
; 0003 00FA 	{
; 0003 00FB 		// check if there's data left in the buffer
; 0003 00FC 		if(uartTxBuffer[nUart].datalength)
	LD   R30,Y
	LDI  R31,0
	CALL __LSLW3
	__ADDW1MN _uartTxBuffer,4
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x60028
; 0003 00FD 		{
; 0003 00FE 			// send byte from top of buffer
; 0003 00FF 			if(nUart)
	LD   R30,Y
	CPI  R30,0
	BREQ _0x60029
; 0003 0100 				UDR1 =  bufferGetFromFront(&uartTxBuffer[1]);
	__POINTW1MN _uartTxBuffer,8
	ST   -Y,R31
	ST   -Y,R30
	CALL _bufferGetFromFront
	STS  206,R30
; 0003 0101 			else
	RJMP _0x6002A
_0x60029:
; 0003 0102 				UDR0 =  bufferGetFromFront(&uartTxBuffer[0]);
	LDI  R30,LOW(_uartTxBuffer)
	LDI  R31,HIGH(_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _bufferGetFromFront
	STS  198,R30
; 0003 0103 		}
_0x6002A:
; 0003 0104 		else
	RJMP _0x6002B
_0x60028:
; 0003 0105 		{
; 0003 0106 			uartBufferedTx[nUart] = 0; // no data left
	LD   R30,Y
	CALL SUBOPT_0xA
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0003 0107 			uartReadyTx[nUart] = 1; // return to ready state
	LD   R30,Y
	CALL SUBOPT_0x7
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0003 0108 
; 0003 0109       // Comm LED off
; 0003 010A       LED_COMM_OFF;
	SBI  0xB,6
; 0003 010B 		}
_0x6002B:
; 0003 010C 	}
; 0003 010D 	else
	RJMP _0x6002C
_0x60027:
; 0003 010E 	{
; 0003 010F 		// we're using single-byte tx mode
; 0003 0110 		// indicate transmit complete, back to ready
; 0003 0111 		uartReadyTx[nUart] = 1;
	LD   R30,Y
	CALL SUBOPT_0x7
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0003 0112 
; 0003 0113     // Comm LED off
; 0003 0114     LED_COMM_OFF;
	SBI  0xB,6
; 0003 0115 	}
_0x6002C:
; 0003 0116 }
_0x2060004:
	ADIW R28,1
	RET
;
;// UART Receive Complete Interrupt Function
;void uartReceiveService(byte nUart)
; 0003 011A {
_uartReceiveService:
; 0003 011B 	byte c;
; 0003 011C 
; 0003 011D 	// get received char
; 0003 011E 	if(nUart)
	ST   -Y,R17
;	nUart -> Y+1
;	c -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x6002D
; 0003 011F 		c = UDR1;
	LDS  R17,206
; 0003 0120 	else
	RJMP _0x6002E
_0x6002D:
; 0003 0121 		c = UDR0;
	LDS  R17,198
; 0003 0122 
; 0003 0123 	// if there's a user function to handle this receive event
; 0003 0124 	if(UartRxFunc[nUart])
_0x6002E:
	LDD  R30,Y+1
	CALL SUBOPT_0x3
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x6002F
; 0003 0125 	{
; 0003 0126 		// call it and pass the received data
; 0003 0127 		UartRxFunc[nUart](c);
	LDD  R30,Y+1
	CALL SUBOPT_0x3
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	PUSH R31
	PUSH R30
	ST   -Y,R17
	POP  R30
	POP  R31
	ICALL
; 0003 0128 	}
; 0003 0129 
; 0003 012A }
_0x6002F:
	LDD  R17,Y+0
_0x2060003:
	ADIW R28,2
	RET
;
;
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0003 012E {
_usart0_tx_isr:
	CALL SUBOPT_0xC
; 0003 012F 	// service UART0 transmit interrupt
; 0003 0130 	uartTransmitService(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _uartTransmitService
; 0003 0131 }
	RJMP _0x60032
;
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0003 0134 {
_usart1_tx_isr:
	CALL SUBOPT_0xC
; 0003 0135 	// service UART1 transmit interrupt
; 0003 0136 	uartTransmitService(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _uartTransmitService
; 0003 0137 }
	RJMP _0x60032
;
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0003 013A {
_usart0_rx_isr:
	CALL SUBOPT_0xC
; 0003 013B 	// service UART0 receive interrupt
; 0003 013C 	uartReceiveService(0);
	LDI  R30,LOW(0)
	RJMP _0x60031
; 0003 013D }
;
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0003 0140 {
_usart1_rx_isr:
	CALL SUBOPT_0xC
; 0003 0141 	// service UART1 receive interrupt
; 0003 0142 	uartReceiveService(1);
	LDI  R30,LOW(1)
_0x60031:
	ST   -Y,R30
	RCALL _uartReceiveService
; 0003 0143 }
_0x60032:
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
; 0004 0025 void uKnos_Init(){

	.CSEG
_uKnos_Init:
; 0004 0026     // Timer/Counter 0 initialization
; 0004 0027     // Clock source: System Clock
; 0004 0028     // Clock value: 10,800 kHz
; 0004 0029     // Mode: CTC top=OCR0A
; 0004 002A     TCCR0A = 0x02;
	LDI  R30,LOW(2)
	OUT  0x24,R30
; 0004 002B     TCCR0B = 0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0004 002C     TCNT0  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0004 002D     OCR0A  = 0x6C - 1;   // 0x6C=108; //prescaler timeru je 1024!
	LDI  R30,LOW(107)
	OUT  0x27,R30
; 0004 002E     OCR0B  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0004 002F 
; 0004 0030     // Timer/Counter 0 Interrupt(s) initialization
; 0004 0031     TIMSK0=0x02;  //compare match
	LDI  R30,LOW(2)
	STS  110,R30
; 0004 0032 }
	RET
;
;void uKnos_Start(){
; 0004 0034 void uKnos_Start(){
_uKnos_Start:
; 0004 0035     #asm("sei")
	sei
; 0004 0036 }
	RET
;
;//*****************************************************************************
;// Funkce pro vytvoreni periodicky volane funkce -> procesu
;// dword period - perioda volani funkce v ms
;// flash dword *function - adresa funkce, ktera ma byt volana
;//*****************************************************************************
;void Create_Process(dword period,  void (*function)(void)){
; 0004 003D void Create_Process(dword period,  void (*function)(void)){
_Create_Process:
; 0004 003E   byte i;
; 0004 003F   tProcess *p_aux_process;
; 0004 0040 
; 0004 0041   for (i = 0; i < PROCESS_MAX; i++) {
	CALL __SAVELOCR4
;	period -> Y+6
;	*function -> Y+4
;	i -> R17
;	*p_aux_process -> R18,R19
	LDI  R17,LOW(0)
_0x80004:
	CPI  R17,10
	BRSH _0x80005
; 0004 0042     p_aux_process = &sProcess[i];
	CALL SUBOPT_0xD
; 0004 0043     if (p_aux_process->state == PROCESS_FREE) {   // pokud je proces volny
	LD   R30,X
	CPI  R30,0
	BRNE _0x80006
; 0004 0044       p_aux_process->state = PROCESS_STANDBY;
	MOVW R26,R18
	LDI  R30,LOW(1)
	ST   X,R30
; 0004 0045       p_aux_process->function = function;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTW1RNS 18,1
; 0004 0046       if (period < 10)
	CALL SUBOPT_0xE
	BRSH _0x80007
; 0004 0047         period = 10;
	CALL SUBOPT_0xF
	__PUTD1S 6
; 0004 0048       p_aux_process->period = ((period<10)? 1 : period/10);
_0x80007:
	CALL SUBOPT_0xE
	BRSH _0x80008
	__GETD1N 0x1
	RJMP _0x80009
_0x80008:
	CALL SUBOPT_0x10
_0x80009:
	__PUTD1RNS 18,3
; 0004 0049       p_aux_process->counter =((period<10)? 1 : period/10);
	CALL SUBOPT_0xE
	BRSH _0x8000B
	__GETD1N 0x1
	RJMP _0x8000C
_0x8000B:
	CALL SUBOPT_0x10
_0x8000C:
	__PUTD1RNS 18,7
; 0004 004A       return;
	RJMP _0x2060002
; 0004 004B     }
; 0004 004C   }
_0x80006:
	SUBI R17,-1
	RJMP _0x80004
_0x80005:
; 0004 004D   // tady udelat dbg vypis nebo signalizaci chyby
; 0004 004E }
_0x2060002:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;
;//*****************************************************************************
;// 10 MILISECOND INTERRUPT, kde se periodicky vyvolavaji procesy
;//*****************************************************************************
;// Timer 0 output compare A interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void){
; 0004 0054 interrupt [17] void timer0_compa_isr(void){
_timer0_compa_isr:
	CALL SUBOPT_0xC
; 0004 0055   byte i;
; 0004 0056   tProcess *p_aux_process;
; 0004 0057   void (*called_funcion)(void);
; 0004 0058 
; 0004 0059   // povolit vnorena preruseni
; 0004 005A   #ifdef ENABLE_RECURSIVE_INTERRUPT
; 0004 005B     ENABLE_INTERRUPT
	CALL __SAVELOCR6
;	i -> R17
;	*p_aux_process -> R18,R19
;	*called_funcion -> R20,R21
	sei
; 0004 005C   #endif
; 0004 005D 
; 0004 005E   // spusteni procesu
; 0004 005F   for (i = 0; i < PROCESS_MAX; i++) {   //pres vsechny procesy
	LDI  R17,LOW(0)
_0x8000F:
	CPI  R17,10
	BRSH _0x80010
; 0004 0060     p_aux_process = &sProcess[i];
	CALL SUBOPT_0xD
; 0004 0061     if (p_aux_process->state == PROCESS_STANDBY) {
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x80011
; 0004 0062 
; 0004 0063       if (--(p_aux_process->counter) == 0) {    // proces ma byt vyvolan
	MOVW R26,R18
	ADIW R26,7
	CALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTDP1_DEC
	CALL __CPD10
	BRNE _0x80012
; 0004 0064 
; 0004 0065         p_aux_process->state = PROCESS_BUSSY;
	MOVW R26,R18
	LDI  R30,LOW(2)
	ST   X,R30
; 0004 0066 
; 0004 0067         // zavola se odpovidajici funkce
; 0004 0068         //toDo: vyzkouset a zahodit pomocnou promennou, volat primo
; 0004 0069         called_funcion = ( void (*)(void))p_aux_process->function;
	ADIW R26,1
	LD   R20,X+
	LD   R21,X
; 0004 006A         called_funcion();
	MOVW R30,R20
	ICALL
; 0004 006B 
; 0004 006C         // nastaveni periody u procesu
; 0004 006D         p_aux_process->counter = p_aux_process->period;
	MOVW R26,R18
	ADIW R26,3
	CALL __GETD1P
	__PUTD1RNS 18,7
; 0004 006E 
; 0004 006F         //uvolneni procesu pro dalsi volani
; 0004 0070         p_aux_process->state = PROCESS_STANDBY;
	MOVW R26,R18
	LDI  R30,LOW(1)
	ST   X,R30
; 0004 0071       } // if (counter == 0) end
; 0004 0072     } // if (process == PROCESS_STANDBY) end
_0x80012:
; 0004 0073   } // for cyklus end
_0x80011:
	SUBI R17,-1
	RJMP _0x8000F
_0x80010:
; 0004 0074 
; 0004 0075 }
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
; 0005 001F {

	.CSEG
_bufferInit:
; 0005 0020 	// begin critical section
; 0005 0021 	CRITICAL_SECTION_START;
;	*buffer -> Y+4
;	*start -> Y+2
;	size -> Y+0
	cli
; 0005 0022 	// set start pointer of the buffer
; 0005 0023 	buffer->dataptr = start;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X+,R30
	ST   X,R31
; 0005 0024 	buffer->size = size;
	LD   R30,Y
	LDD  R31,Y+1
	__PUTW1SNS 4,2
; 0005 0025 	// initialize index and length
; 0005 0026 	buffer->dataindex = 0;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0005 0027 	buffer->datalength = 0;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	ST   X+,R30
	ST   X,R31
; 0005 0028 	// end critical section
; 0005 0029 	CRITICAL_SECTION_END;
	sei
; 0005 002A }
	ADIW R28,6
	RET
;
;// access routines
;unsigned char  bufferGetFromFront(cBuffer* buffer)
; 0005 002E {
_bufferGetFromFront:
; 0005 002F 	unsigned char data = 0;
; 0005 0030 	// begin critical section
; 0005 0031 	CRITICAL_SECTION_START;
	ST   -Y,R17
;	*buffer -> Y+1
;	data -> R17
	LDI  R17,0
	cli
; 0005 0032 	// check to see if there's data in the buffer
; 0005 0033 	if(buffer->datalength)
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	SBIW R30,0
	BREQ _0xA0003
; 0005 0034 	{
; 0005 0035 		// get the first character from buffer
; 0005 0036 		data = buffer->dataptr[buffer->dataindex];
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
; 0005 0037 		// move index down and decrement length
; 0005 0038 		buffer->dataindex++;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,6
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0005 0039 		if(buffer->dataindex >= buffer->size)
	CALL SUBOPT_0x11
	ADIW R26,2
	CALL SUBOPT_0x9
	BRLO _0xA0004
; 0005 003A 		{
; 0005 003B 			buffer->dataindex -= buffer->size;
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
; 0005 003C 		}
; 0005 003D 		buffer->datalength--;
_0xA0004:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0005 003E 	}
; 0005 003F 	// end critical section
; 0005 0040 	CRITICAL_SECTION_END;
_0xA0003:
	sei
; 0005 0041 	// return
; 0005 0042 	return data;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2060001
; 0005 0043 }
;
;void bufferDumpFromFront(cBuffer* buffer, unsigned short numbytes)
; 0005 0046 {
; 0005 0047 	// begin critical section
; 0005 0048 	CRITICAL_SECTION_START;
;	*buffer -> Y+2
;	numbytes -> Y+0
; 0005 0049 	// dump numbytes from the front of the buffer
; 0005 004A 	// are we dumping less than the entire buffer?
; 0005 004B 	if(numbytes < buffer->datalength)
; 0005 004C 	{
; 0005 004D 		// move index down by numbytes and decrement length by numbytes
; 0005 004E 		buffer->dataindex += numbytes;
; 0005 004F 		if(buffer->dataindex >= buffer->size)
; 0005 0050 		{
; 0005 0051 			buffer->dataindex -= buffer->size;
; 0005 0052 		}
; 0005 0053 		buffer->datalength -= numbytes;
; 0005 0054 	}
; 0005 0055 	else
; 0005 0056 	{
; 0005 0057 		// flush the whole buffer
; 0005 0058 		buffer->datalength = 0;
; 0005 0059 	}
; 0005 005A 	// end critical section
; 0005 005B 	CRITICAL_SECTION_END;
; 0005 005C }
;
;unsigned char bufferGetAtIndex(cBuffer* buffer, unsigned short index)
; 0005 005F {
; 0005 0060   unsigned char data;
; 0005 0061 
; 0005 0062 	// begin critical section
; 0005 0063 	CRITICAL_SECTION_START;
;	*buffer -> Y+3
;	index -> Y+1
;	data -> R17
; 0005 0064 	// return character at index in buffer
; 0005 0065 	data = buffer->dataptr[(buffer->dataindex+index)%(buffer->size)];
; 0005 0066 	// end critical section
; 0005 0067 	CRITICAL_SECTION_END;
; 0005 0068 	return data;
; 0005 0069 }
;
;unsigned char bufferAddToEnd(cBuffer* buffer, unsigned char data)
; 0005 006C {
_bufferAddToEnd:
; 0005 006D 	// begin critical section
; 0005 006E 	CRITICAL_SECTION_START;
;	*buffer -> Y+1
;	data -> Y+0
	cli
; 0005 006F 	// make sure the buffer has room
; 0005 0070 	if(buffer->datalength < buffer->size)
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__GETWRZ 0,1,4
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	CALL SUBOPT_0x9
	BRSH _0xA0008
; 0005 0071 	{
; 0005 0072 		// save data byte at end of buffer
; 0005 0073 		buffer->dataptr[(buffer->dataindex + buffer->datalength) % buffer->size] = data;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x11
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
; 0005 0074 		// increment the length
; 0005 0075 		buffer->datalength++;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0005 0076 		// end critical section
; 0005 0077 		CRITICAL_SECTION_END;
	sei
; 0005 0078 		// return success
; 0005 0079 		return -1;
	LDI  R30,LOW(255)
	RJMP _0x2060001
; 0005 007A 	}
; 0005 007B 	// end critical section
; 0005 007C 	CRITICAL_SECTION_END;
_0xA0008:
	sei
; 0005 007D 	// return failure
; 0005 007E 	return 0;
	LDI  R30,LOW(0)
_0x2060001:
	ADIW R28,3
	RET
; 0005 007F }
;
;unsigned short bufferIsNotFull(cBuffer* buffer)
; 0005 0082 {
; 0005 0083   unsigned short bytesleft;
; 0005 0084 
; 0005 0085 	// begin critical section
; 0005 0086 	CRITICAL_SECTION_START;
;	*buffer -> Y+2
;	bytesleft -> R16,R17
; 0005 0087 	// check to see if the buffer has room
; 0005 0088 	// return true if there is room
; 0005 0089 	bytesleft = (buffer->size - buffer->datalength);
; 0005 008A 	// end critical section
; 0005 008B 	CRITICAL_SECTION_END;
; 0005 008C 	return bytesleft;
; 0005 008D }
;
;void bufferFlush(cBuffer* buffer)
; 0005 0090 {
; 0005 0091 	// begin critical section
; 0005 0092 	CRITICAL_SECTION_START;
;	*buffer -> Y+0
; 0005 0093 	// flush contents of the buffer
; 0005 0094 	buffer->datalength = 0;
; 0005 0095 	// end critical section
; 0005 0096 	CRITICAL_SECTION_END;
; 0005 0097 }
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
; 0006 0012 void Buttons_init(void){

	.CSEG
_Buttons_init:
; 0006 0013     BUTTONS_INIT;
	CBI  0x7,6
	SBI  0x8,6
	CBI  0x7,7
	SBI  0x8,7
; 0006 0014 }
	RET
;
;
;//*****************************************************************
;// Buttons_get_x - vrati stav X-teho tlacitka
;//*****************************************************************
;byte Buttons_get_x(byte button_position){
; 0006 001A byte Buttons_get_x(byte button_position){
; 0006 001B     char aux_button = -1;
; 0006 001C 
; 0006 001D     switch (button_position) {
;	button_position -> Y+1
;	aux_button -> R17
; 0006 001E         case 1 : aux_button = GET_BUTTON_1_STATE; break;
; 0006 001F         case 2 : aux_button = GET_BUTTON_2_STATE; break;
; 0006 0020         case 3 : aux_button = GET_BUTTON_3_STATE; break;
; 0006 0021         case 4 : aux_button = GET_BUTTON_4_STATE; break;
; 0006 0022         case 5 : aux_button = GET_BUTTON_5_STATE; break;
; 0006 0023         case 6 : aux_button = GET_BUTTON_6_STATE; break;
; 0006 0024         case 7 : aux_button = GET_BUTTON_7_STATE; break;
; 0006 0025         case 8 : aux_button = GET_BUTTON_8_STATE; break;
; 0006 0026         case 9 : aux_button = GET_BUTTON_9_STATE; break;
; 0006 0027         case 10 : aux_button = GET_BUTTON_10_STATE; break;
; 0006 0028         default: aux_button = -1; break;
; 0006 0029   }
; 0006 002A   return aux_button;
; 0006 002B }
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
; 0007 0011 void Digital_outputs_init(void){

	.CSEG
_Digital_outputs_init:
; 0007 0012 	DIG_OUTS_INIT;
	SBI  0xA,6
	SBI  0xB,6
	SBI  0xA,7
	SBI  0xB,7
	SBI  0x1,2
	CBI  0x2,2
	SBI  0x1,3
	CBI  0x2,3
; 0007 0013 }
	RET
;
;
;//*****************************************************************
;// Leds_x_on - rozsviti urcenou LED diodu
;//*****************************************************************
;void Digital_outputs_x_on(byte output_position)
; 0007 001A {
; 0007 001B     switch (output_position) {
;	output_position -> Y+0
; 0007 001C         case 1 : DIG_OUT_1_ON; break;
; 0007 001D         case 2 : DIG_OUT_2_ON; break;
; 0007 001E         case 3 : DIG_OUT_3_ON; break;
; 0007 001F         case 4 : DIG_OUT_4_ON; break;
; 0007 0020         case 5 : DIG_OUT_5_ON; break;
; 0007 0021         case 6 : DIG_OUT_6_ON; break;
; 0007 0022         case 7 : DIG_OUT_7_ON; break;
; 0007 0023         case 8 : DIG_OUT_8_ON; break;
; 0007 0024         case 9 : DIG_OUT_9_ON; break;
; 0007 0025         case 10 : DIG_OUT_10_ON; break;
; 0007 0026         default: break;
; 0007 0027   }
; 0007 0028 }
;
;
;//*****************************************************************
;// Leds_X_Off - zhasne urcenou LED diodu
;//*****************************************************************
;void Digital_outputs_x_off(byte output_position)
; 0007 002F {
; 0007 0030 	switch (output_position) {
;	output_position -> Y+0
; 0007 0031         case 1 : DIG_OUT_1_OFF; break;
; 0007 0032         case 2 : DIG_OUT_2_OFF; break;
; 0007 0033         case 3 : DIG_OUT_3_OFF; break;
; 0007 0034         case 4 : DIG_OUT_4_OFF; break;
; 0007 0035         case 5 : DIG_OUT_5_OFF; break;
; 0007 0036         case 6 : DIG_OUT_6_OFF; break;
; 0007 0037         case 7 : DIG_OUT_7_OFF; break;
; 0007 0038         case 8 : DIG_OUT_8_OFF; break;
; 0007 0039         case 9 : DIG_OUT_9_OFF; break;
; 0007 003A         case 10 : DIG_OUT_10_OFF; break;
; 0007 003B         default: break;
; 0007 003C   }
; 0007 003D }
;
;
;//*****************************************************************
;// Leds_set - rozsviti/zhasne ledky podle zadane masky
;//*****************************************************************
;void Digital_outputs_set(word mask){
; 0007 0043 void Digital_outputs_set(word mask){
; 0007 0044 	byte i;
; 0007 0045 	for(i=0;i<16;i++){
;	mask -> Y+1
;	i -> R17
; 0007 0046 		if((mask >> i) & 0x01)
; 0007 0047 			Digital_outputs_x_on(i+1);
; 0007 0048 		else
; 0007 0049 			Digital_outputs_x_off(i+1);
; 0007 004A 	}
; 0007 004B }
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
;
;/* STRINGS */
;flash char STRING_START_MESSAGE[]=  "\n#########################################"
;                                    "\n# Knuerr AG"
;                                    "\n# RM II - ing. L.Melichar, ing. P.Kerndl ";
;
;flash char STRING_SEPARATOR[]=      "\n#########################################";
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

	.CSEG

	.CSEG

	.DSEG
_aux_flag_S0010000000:
	.BYTE 0x1
_aux_top_first_S0010001000:
	.BYTE 0x1
_aux_bottom_first_S0010001000:
	.BYTE 0x1
_uartRxBuffer:
	.BYTE 0xA
_comm_terminal_state:
	.BYTE 0x1
_uartReadyTx:
	.BYTE 0x2
_uartBufferedTx:
	.BYTE 0x2
_uartTxBuffer:
	.BYTE 0x10
_uartRxOverflow:
	.BYTE 0x4
_uart0TxData_G003:
	.BYTE 0x30
_uart1TxData_G003:
	.BYTE 0x30
_UartRxFunc_G003:
	.BYTE 0x4
_sProcess:
	.BYTE 0x6E

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _uartSendBufferf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_UartRxFunc_G003)
	LDI  R27,HIGH(_UartRxFunc_G003)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	RCALL SUBOPT_0x4
	__GETD2N 0x8
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CALL __DIVD21U
	__SUBD1N 1
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R31,0
	SUBI R30,LOW(-_uartReadyTx)
	SBCI R31,HIGH(-_uartReadyTx)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDD  R30,Y+8
	LDI  R31,0
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R31,0
	SUBI R30,LOW(-_uartBufferedTx)
	SBCI R31,HIGH(-_uartBufferedTx)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xC:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(11)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sProcess)
	SBCI R31,HIGH(-_sProcess)
	MOVW R18,R30
	MOVW R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE:
	__GETD2S 6
	__CPD2N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	__GETD2S 6
	RCALL SUBOPT_0xF
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__GETWRZ 0,1,6
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET


	.CSEG
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

;END OF CODE MARKER
__END_OF_CODE:
