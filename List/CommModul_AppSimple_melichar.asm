
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
_COMMAND_DEF:
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x1,0x0
	.DB  0x2,0x0,0x1,0x0,0x3,0x0,0x1,0x0
	.DB  0x4,0x0,0x2,0x0,0x6,0x0,0x2,0x0
	.DB  0x62,0x0,0x2,0x0,0xC6,0x1,0x2,0x0
	.DB  0xC8,0x1,0x4,0x0,0xCC,0x1,0x4,0x0
	.DB  0xB2,0x2,0x2,0x0,0xB4,0x2,0x4,0x0
	.DB  0xB8,0x2,0x4,0x0,0x9E,0x3,0x2,0x0
	.DB  0xA0,0x3,0x4,0x0,0xA4,0x3,0x4,0x0
	.DB  0x1,0xC,0x2,0x0
_sSCREEN_GROUP:
	.DB  0x42,0x4F,0x41,0x52,0x44,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,LOW(_sf_board)
	.DB  HIGH(_sf_board),0x52,0x45,0x53,0x55,0x4D,0x45,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  LOW(_sf_resume),HIGH(_sf_resume),0x56,0x4F,0x4C,0x54,0x41,0x47
	.DB  0x45,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,LOW(_sf_voltages),HIGH(_sf_voltages),0x43,0x55,0x52,0x52,0x45
	.DB  0x4E,0x54,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,LOW(_sf_currents),HIGH(_sf_currents),0x50,0x4F,0x57,0x45
	.DB  0x52,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,LOW(_sf_powers_act),HIGH(_sf_powers_act),0x50,0x4F,0x57
	.DB  0x45,0x52,0x46,0x41,0x43,0x54,0x4F,0x52
	.DB  0x0,0x0,0x0,0x0,LOW(_sf_powerfactors),HIGH(_sf_powerfactors),0x45,0x4E
	.DB  0x45,0x52,0x47,0x59,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,LOW(_sf_energies_act),HIGH(_sf_energies_act)
_LOGO_KNUERR_G00E:
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
_FontLookup_Extended_G00E:
	.DB  0x0,0x7,0x5,0x7,0x0
_FontLookup_G00E:
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
_0x40000:
	.DB  0xA,0x63,0x72,0x65,0x61,0x74,0x65,0x20
	.DB  0x70,0x72,0x6F,0x63,0x65,0x73,0x73,0x20
	.DB  0x6E,0x72,0x2E,0x25,0x64,0x20,0x2E,0x2E
	.DB  0x0
_0xC0005:
	.DB  0x1
_0xC0006:
	.DB  0x1
_0xC0000:
	.DB  0xA,0x2D,0x0,0xA,0x2B,0x0,0xA,0x49
	.DB  0x3A,0x20,0x53,0x65,0x6E,0x64,0x42,0x75
	.DB  0x66,0x66,0x65,0x72,0x66,0x28,0x29,0x0
_0xE0000:
	.DB  0xA,0x49,0x3A,0x20,0x50,0x72,0x69,0x6A
	.DB  0x6D,0x75,0x74,0x20,0x73,0x74,0x72,0x69
	.DB  0x6E,0x67,0x3A,0x20,0x0,0xA,0x45,0x3A
	.DB  0x20,0x4E,0x65,0x64,0x6F,0x73,0x74,0x61
	.DB  0x74,0x65,0x63,0x6E,0x79,0x20,0x62,0x75
	.DB  0x66,0x66,0x65,0x72,0x2C,0x20,0x73,0x74
	.DB  0x72,0x69,0x6E,0x67,0x3A,0x0
_0x160000:
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
_0x180000:
	.DB  0xA,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x0,0xA,0x66
	.DB  0x72,0x65,0x71,0x75,0x65,0x6E,0x63,0x65
	.DB  0x3A,0x20,0x25,0x75,0x2E,0x25,0x75,0x20
	.DB  0x48,0x7A,0x0,0xA,0x74,0x65,0x6D,0x70
	.DB  0x65,0x72,0x61,0x74,0x75,0x72,0x65,0x3A
	.DB  0x20,0x25,0x64,0x2E,0x25,0x64,0xB0,0x43
	.DB  0x0,0xA,0x76,0x6F,0x6C,0x74,0x61,0x67
	.DB  0x65,0x3A,0x20,0x25,0x6C,0x64,0x20,0x7C
	.DB  0x20,0x25,0x6C,0x64,0x20,0x7C,0x20,0x25
	.DB  0x6C,0x64,0x0,0xA,0x63,0x75,0x72,0x72
	.DB  0x65,0x6E,0x74,0x3A,0x20,0x25,0x6C,0x64
	.DB  0x20,0x7C,0x20,0x25,0x6C,0x64,0x20,0x7C
	.DB  0x20,0x25,0x6C,0x64,0x0
_0x1C0000:
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
_0x1E0004:
	.DB  LOW(_0x1E0003),HIGH(_0x1E0003),LOW(_0x1E0003+23),HIGH(_0x1E0003+23),LOW(_0x1E0003+46),HIGH(_0x1E0003+46),LOW(_0x1E0003+69),HIGH(_0x1E0003+69)
	.DB  LOW(_0x1E0003+92),HIGH(_0x1E0003+92),LOW(_0x1E0003+115),HIGH(_0x1E0003+115),LOW(_0x1E0003+138),HIGH(_0x1E0003+138),LOW(_0x1E0003+161),HIGH(_0x1E0003+161)
_0x1E0000:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0
_0x220000:
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
	.DB  0x20,0x0,0x20,0x49,0x50,0x3A,0x20,0x25
	.DB  0x33,0x75,0x2E,0x25,0x33,0x75,0x2E,0x25
	.DB  0x33,0x75,0x2E,0x25,0x33,0x75,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x4D,0x41,0x43,0x3A,0x20,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x32,0x58,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x32,0x58,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x32,0x58,0x20,0x20,0x20
	.DB  0x0,0x20,0x55,0x20,0x6C,0x69,0x6E,0x65
	.DB  0x73,0x3A,0x20,0x25,0x75,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x49,0x20,0x6C,0x69,0x6E,0x65,0x73,0x3A
	.DB  0x20,0x25,0x75,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x46,0x72,0x65,0x71,0x75,0x65,0x6E
	.DB  0x63,0x65,0x3A,0x20,0x25,0x75,0x2E,0x25
	.DB  0x75,0x20,0x48,0x7A,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x54,0x65,0x6D,0x70
	.DB  0x65,0x72,0x61,0x74,0x75,0x72,0x65,0x3A
	.DB  0x20,0x25,0x75,0x2E,0x25,0x75,0xB0,0x43
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x4C,0x31,0x3A
	.DB  0x20,0x25,0x75,0x2E,0x25,0x75,0x20,0x5B
	.DB  0x56,0x5D,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x4C,0x31,0x3A
	.DB  0x20,0x25,0x75,0x2E,0x25,0x30,0x32,0x75
	.DB  0x20,0x5B,0x41,0x5D,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x4C,0x31,0x3A,0x20
	.DB  0x25,0x6C,0x64,0x2E,0x25,0x64,0x20,0x5B
	.DB  0x57,0x5D,0x20,0x7C,0x20,0x25,0x6C,0x64
	.DB  0x2E,0x25,0x64,0x20,0x5B,0x56,0x41,0x5D
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x4C
	.DB  0x31,0x3A,0x20,0x25,0x6C,0x64,0x2E,0x25
	.DB  0x64,0x20,0x5B,0x57,0x5D,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x4C
	.DB  0x31,0x3A,0x20,0x25,0x75,0x20,0x5B,0x57
	.DB  0x68,0x5D,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x4C,0x31
	.DB  0x3A,0x20,0x25,0x75,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _aux_top_first_S0060001000
	.DW  _0xC0005*2

	.DW  0x01
	.DW  _aux_bottom_first_S0060001000
	.DW  _0xC0006*2

	.DW  0x17
	.DW  _0x1E0003
	.DW  _0x1E0000*2

	.DW  0x17
	.DW  _0x1E0003+23
	.DW  _0x1E0000*2

	.DW  0x17
	.DW  _0x1E0003+46
	.DW  _0x1E0000*2

	.DW  0x17
	.DW  _0x1E0003+69
	.DW  _0x1E0000*2

	.DW  0x17
	.DW  _0x1E0003+92
	.DW  _0x1E0000*2

	.DW  0x17
	.DW  _0x1E0003+115
	.DW  _0x1E0000*2

	.DW  0x17
	.DW  _0x1E0003+138
	.DW  _0x1E0000*2

	.DW  0x17
	.DW  _0x1E0003+161
	.DW  _0x1E0000*2

	.DW  0x09
	.DW  _0x220004
	.DW  _0x220000*2

	.DW  0x17
	.DW  _0x220004+9
	.DW  _0x220000*2+9

	.DW  0x15
	.DW  _0x220008
	.DW  _0x220000*2+32

	.DW  0x0B
	.DW  _0x220009
	.DW  _0x220000*2+76

	.DW  0x0B
	.DW  _0x220009+11
	.DW  _0x220000*2+92

	.DW  0x16
	.DW  _0x220009+22
	.DW  _0x220000*2+108

	.DW  0x1B
	.DW  _0x22000A
	.DW  _0x220000*2+237

	.DW  0x16
	.DW  _0x22000B
	.DW  _0x220000*2+108

	.DW  0x17
	.DW  _0x22000F
	.DW  _0x220000*2+241

	.DW  0x17
	.DW  _0x220013
	.DW  _0x220000*2+241

	.DW  0x17
	.DW  _0x220017
	.DW  _0x220000*2+241

	.DW  0x17
	.DW  _0x22001B
	.DW  _0x220000*2+241

	.DW  0x17
	.DW  _0x22001F
	.DW  _0x220000*2+241

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
;#include <messmodules.h>
;#include <digital_outputs.h>
;#include <buttons.h>
;#include <NT7534.h>
;#include "display.h"
;#include "test_process.h"
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
	CALL _HW_init
; 0000 0021   Digital_outputs_init();
	CALL _Digital_outputs_init
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
	CALL _uKnos_Init
; 0000 0033 
; 0000 0034 
; 0000 0035 
; 0000 0036   //******************************************
; 0000 0037   // PROCESSES
; 0000 0038   // - period in miliseconds, shortest period is 10ms
; 0000 0039   //******************************************
; 0000 003A 
; 0000 003B   //Create_Process( 3000, CommXport_Manager);   //zpracovava buffer naplneny v preruseni
; 0000 003C   Create_Process( 3000,  Messmodul_Manager);    //read and save data from MAXIM
	__GETD1N 0xBB8
	CALL __PUTPARD1
	LDI  R30,LOW(_Messmodul_Manager)
	LDI  R31,HIGH(_Messmodul_Manager)
	CALL SUBOPT_0x0
; 0000 003D   Create_Process(  200, Test_process_buttons);//vypisuje jake tlacitko bylo zmacknuto
	__GETD1N 0xC8
	CALL __PUTPARD1
	LDI  R30,LOW(_Test_process_buttons)
	LDI  R31,HIGH(_Test_process_buttons)
	CALL SUBOPT_0x0
; 0000 003E   Create_Process( 1000, Test_process_leds);     //blika led
	__GETD1N 0x3E8
	CALL __PUTPARD1
	LDI  R30,LOW(_Test_process_leds)
	LDI  R31,HIGH(_Test_process_leds)
	CALL SUBOPT_0x0
; 0000 003F   Create_Process( 500, Display_Manager);       //obsluha dipleje
	__GETD1N 0x1F4
	CALL __PUTPARD1
	LDI  R30,LOW(_Display_Manager)
	LDI  R31,HIGH(_Display_Manager)
	CALL SUBOPT_0x0
; 0000 0040 
; 0000 0041   //Create_Process( 100, CommTerminal_Manager); //zpracovava buffer naplneny prijmutymi znaky
; 0000 0042 
; 0000 0043   //delay before uart output
; 0000 0044   delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0045 
; 0000 0046   //print messages
; 0000 0047   uartSendBufferf(0, STRING_START_MESSAGE);  //start message
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_STRING_START_MESSAGE*2)
	LDI  R31,HIGH(_STRING_START_MESSAGE*2)
	CALL SUBOPT_0x1
; 0000 0048   uartSendBufferf(0, "\n# HW: "); uartSendBufferf(0, HW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, HW_VERSION_S); //version
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,8
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,21
	CALL SUBOPT_0x1
; 0000 0049   uartSendBufferf(0, "\n# SW: "); uartSendBufferf(0, SW_NAME); uartSendBufferf(0, " v"); uartSendBufferf(0, SW_VERSION_S); //version
	__POINTW1FN _0x0,26
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x1
; 0000 004A   uartSendBufferf(0, STRING_SEPARATOR);
	LDI  R30,LOW(_STRING_SEPARATOR*2)
	LDI  R31,HIGH(_STRING_SEPARATOR*2)
	CALL SUBOPT_0x2
; 0000 004B 
; 0000 004C   //Start uKnos
; 0000 004D   uKnos_Start(); //enable interrupt
	CALL _uKnos_Start
; 0000 004E   uartSendBufferf(0,"\nI: System start..");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x0,46
	CALL SUBOPT_0x2
; 0000 004F 
; 0000 0050 while (1){
_0x3:
; 0000 0051 
; 0000 0052     //printf(".");
; 0000 0053     Messmodul_Rest();  //vypisy
	CALL _Messmodul_Rest
; 0000 0054 
; 0000 0055 } //end of while
	RJMP _0x3
_0x5:
; 0000 0056 } //end of main
_0x6:
	RJMP _0x6
;
;void getR(){
; 0000 0058 void getR(){
; 0000 0059     byte aux_data;
; 0000 005A     aux_data = SPI_MasterTransmit(0x38);
;	aux_data -> R17
; 0000 005B     if(aux_data == 0xc1){
; 0000 005C         delay_ms(10);
; 0000 005D         aux_data = SPI_MasterTransmit(0x31);
; 0000 005E         if(aux_data == 0xc2){
; 0000 005F             delay_ms(50);
; 0000 0060             aux_data = SPI_MasterTransmit(0x00);
; 0000 0061             delay_ms(10);
; 0000 0062             aux_data = SPI_MasterTransmit(0x00);
; 0000 0063             if(aux_data == 0x41){
; 0000 0064                 delay_ms(10);
; 0000 0065                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0066                 printf("\nI:1.byte %x", aux_data);
; 0000 0067                 delay_ms(10);
; 0000 0068                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0069                 printf("\nI:2.byte %x", aux_data);
; 0000 006A                 delay_ms(10);
; 0000 006B                 aux_data = SPI_MasterTransmit(0x00);
; 0000 006C                 printf("\nI:3.byte %x", aux_data);
; 0000 006D                 delay_ms(10);
; 0000 006E                 aux_data = SPI_MasterTransmit(0x00);
; 0000 006F                 printf("\nI:4.byte %x", aux_data);
; 0000 0070                 delay_ms(10);
; 0000 0071                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0072                 printf("\nI:5.byte %x", aux_data);
; 0000 0073                 delay_ms(10);
; 0000 0074                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0075                 printf("\nI:6.byte %x", aux_data);
; 0000 0076                 delay_ms(10);
; 0000 0077                 aux_data = SPI_MasterTransmit(0x00);
; 0000 0078                 printf("\nI:7.byte %x", aux_data);
; 0000 0079                 delay_ms(10);
; 0000 007A                 aux_data = SPI_MasterTransmit(0x00);
; 0000 007B                 printf("\nI:8.byte %x", aux_data);
; 0000 007C                 printf("\n=============================================");
; 0000 007D             }
; 0000 007E             else
; 0000 007F                 printf("\nEE: nejsem ready %x",aux_data);
; 0000 0080 
; 0000 0081         }
; 0000 0082         else
; 0000 0083             printf("\nEE: spatna adresa");
; 0000 0084     }
; 0000 0085     else
; 0000 0086         printf("\nEE: spatnej zacatek");
; 0000 0087 }
;
;//**************************************************************************
;// Nastaveni MCU
;//**************************************************************************
;void HW_init(void)
; 0000 008D {
_HW_init:
; 0000 008E     // Crystal Oscillator division factor: 1
; 0000 008F     #pragma optsize-
; 0000 0090     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0091     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0092     #ifdef _OPTIMIZE_SIZE_
; 0000 0093     #pragma optsize+
; 0000 0094     #endif
; 0000 0095 
; 0000 0096     // Input/Output Ports initialization
; 0000 0097     // Port A initialization
; 0000 0098     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0099     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009A     PORTA=0x00;
	OUT  0x2,R30
; 0000 009B     DDRA=0x00;
	OUT  0x1,R30
; 0000 009C 
; 0000 009D     // Port B initialization
; 0000 009E     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009F     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A0     PORTB=0x00;
	OUT  0x5,R30
; 0000 00A1     DDRB=0x00;
	OUT  0x4,R30
; 0000 00A2 
; 0000 00A3     // Port C initialization
; 0000 00A4     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A5     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A6     PORTC=0x00;
	OUT  0x8,R30
; 0000 00A7     DDRC=0x00;
	OUT  0x7,R30
; 0000 00A8 
; 0000 00A9     // Port D initialization
; 0000 00AA     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AB     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AC     PORTD=0x00;
	OUT  0xB,R30
; 0000 00AD     DDRD=0x00;
	OUT  0xA,R30
; 0000 00AE 
; 0000 00AF     // Timer/Counter 0 initialization
; 0000 00B0     // Clock source: System Clock
; 0000 00B1     // Clock value: Timer 0 Stopped
; 0000 00B2     // Mode: Normal top=FFh
; 0000 00B3     // OC0A output: Disconnected
; 0000 00B4     // OC0B output: Disconnected
; 0000 00B5     TCCR0A=0x00;
	OUT  0x24,R30
; 0000 00B6     TCCR0B=0x00;
	OUT  0x25,R30
; 0000 00B7     TCNT0=0x00;
	OUT  0x26,R30
; 0000 00B8     OCR0A=0x00;
	OUT  0x27,R30
; 0000 00B9     OCR0B=0x00;
	OUT  0x28,R30
; 0000 00BA 
; 0000 00BB     // Timer/Counter 1 initialization
; 0000 00BC     // Clock source: System Clock
; 0000 00BD     // Clock value: Timer1 Stopped
; 0000 00BE     // Mode: Normal top=FFFFh
; 0000 00BF     // OC1A output: Discon.
; 0000 00C0     // OC1B output: Discon.
; 0000 00C1     // Noise Canceler: Off
; 0000 00C2     // Input Capture on Falling Edge
; 0000 00C3     // Timer1 Overflow Interrupt: Off
; 0000 00C4     // Input Capture Interrupt: Off
; 0000 00C5     // Compare A Match Interrupt: Off
; 0000 00C6     // Compare B Match Interrupt: Off
; 0000 00C7     TCCR1A=0x00;
	STS  128,R30
; 0000 00C8     TCCR1B=0x00;
	STS  129,R30
; 0000 00C9     TCNT1H=0x00;
	STS  133,R30
; 0000 00CA     TCNT1L=0x00;
	STS  132,R30
; 0000 00CB     ICR1H=0x00;
	STS  135,R30
; 0000 00CC     ICR1L=0x00;
	STS  134,R30
; 0000 00CD     OCR1AH=0x00;
	STS  137,R30
; 0000 00CE     OCR1AL=0x00;
	STS  136,R30
; 0000 00CF     OCR1BH=0x00;
	STS  139,R30
; 0000 00D0     OCR1BL=0x00;
	STS  138,R30
; 0000 00D1 
; 0000 00D2     // Timer/Counter 2 initialization
; 0000 00D3     // Clock source: System Clock
; 0000 00D4     // Clock value: Timer2 Stopped
; 0000 00D5     // Mode: Normal top=FFh
; 0000 00D6     // OC2A output: Disconnected
; 0000 00D7     // OC2B output: Disconnected
; 0000 00D8     ASSR=0x00;
	STS  182,R30
; 0000 00D9     TCCR2A=0x00;
	STS  176,R30
; 0000 00DA     TCCR2B=0x00;
	STS  177,R30
; 0000 00DB     TCNT2=0x00;
	STS  178,R30
; 0000 00DC     OCR2A=0x00;
	STS  179,R30
; 0000 00DD     OCR2B=0x00;
	STS  180,R30
; 0000 00DE 
; 0000 00DF     // External Interrupt(s) initialization
; 0000 00E0     // INT0: Off
; 0000 00E1     // INT1: Off
; 0000 00E2     // INT2: Off
; 0000 00E3     // Interrupt on any change on pins PCINT0-7: Off
; 0000 00E4     // Interrupt on any change on pins PCINT8-15: Off
; 0000 00E5     // Interrupt on any change on pins PCINT16-23: Off
; 0000 00E6     // Interrupt on any change on pins PCINT24-31: Off
; 0000 00E7     EICRA=0x00;
	STS  105,R30
; 0000 00E8     EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00E9     PCICR=0x00;
	STS  104,R30
; 0000 00EA 
; 0000 00EB     // Timer/Counter 0 Interrupt(s) initialization
; 0000 00EC     TIMSK0=0x00;
	STS  110,R30
; 0000 00ED     // Timer/Counter 1 Interrupt(s) initialization
; 0000 00EE     TIMSK1=0x00;
	STS  111,R30
; 0000 00EF     // Timer/Counter 2 Interrupt(s) initialization
; 0000 00F0     TIMSK2=0x00;
	STS  112,R30
; 0000 00F1 
; 0000 00F2     // USART0 initialization
; 0000 00F3     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00F4     // USART0 Receiver: Off
; 0000 00F5     // USART0 Transmitter: On
; 0000 00F6     // USART0 Mode: Asynchronous
; 0000 00F7     // USART0 Baud Rate: 9600
; 0000 00F8     UCSR0A=0x00;
	STS  192,R30
; 0000 00F9     UCSR0B=0x08;
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 00FA     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00FB     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00FC     UBRR0L=0x05; //0x47;
	LDI  R30,LOW(5)
	STS  196,R30
; 0000 00FD 
; 0000 00FE     // Analog Comparator initialization
; 0000 00FF     // Analog Comparator: Off
; 0000 0100     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0101     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0102     ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0103 }
	RET
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
; 0001 002E {

	.CSEG
_uartInit:
; 0001 002F 	// initialize uarts
; 0001 0030     if(nUart)
;	nUart -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE PC+3
	JMP _0x20003
; 0001 0031         uart1Init();
	CALL _uart1Init
; 0001 0032     else
	RJMP _0x20004
_0x20003:
; 0001 0033 	    uart0Init();
	CALL _uart0Init
; 0001 0034 
; 0001 0035 }
_0x20004:
	ADIW R28,1
	RET
;
;void uart0Init(void)
; 0001 0038 {
_uart0Init:
; 0001 0039 	// initialize the buffers
; 0001 003A 	uart0InitBuffers();
	CALL _uart0InitBuffers
; 0001 003B 
; 0001 003C 	// initialize user receive handlers
; 0001 003D 	UartRxFunc[0] = 0;
	LDI  R30,LOW(0)
	STS  _UartRxFunc_G001,R30
	STS  _UartRxFunc_G001+1,R30
; 0001 003E 
; 0001 003F 	// enable RxD/TxD and interrupts
; 0001 0040 	UCSR0B = (1<<RXCIE) | (1<<TXCIE) | (1<<RXEN) | (1<<TXEN);
	LDI  R30,LOW(216)
	STS  193,R30
; 0001 0041 
; 0001 0042 	// set default baud rate
; 0001 0043     // uartSetBaudRate(0, UART0_DEFAULT_BAUD_RATE);
; 0001 0044 
; 0001 0045 	// initialize states
; 0001 0046 	uartReadyTx[0] = 1;
	LDI  R30,LOW(1)
	STS  _uartReadyTx,R30
; 0001 0047 	uartBufferedTx[0] = 0;
	LDI  R30,LOW(0)
	STS  _uartBufferedTx,R30
; 0001 0048 
; 0001 0049 	// clear overflow count
; 0001 004A 	uartRxOverflow[0] = 0;
	STS  _uartRxOverflow,R30
	STS  _uartRxOverflow+1,R30
; 0001 004B 
; 0001 004C 	// enable interrupts
; 0001 004D 	//#asm("sei")
; 0001 004E }
	RET
;
;void uart1Init(void)
; 0001 0051 {
_uart1Init:
; 0001 0052 	// initialize the buffers
; 0001 0053 	uart1InitBuffers();
	CALL _uart1InitBuffers
; 0001 0054 	// initialize user receive handlers
; 0001 0055 	UartRxFunc[1] = 0;
	__POINTW1MN _UartRxFunc_G001,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0001 0056 	// enable RxD/TxD and interrupts
; 0001 0057 	UCSR1B = (1<<RXCIE) | (1<<TXCIE) | (1<<RXEN) | (1<<TXEN);
	LDI  R30,LOW(216)
	STS  201,R30
; 0001 0058 	// set default baud rate
; 0001 0059 //	uartSetBaudRate(1, UART1_DEFAULT_BAUD_RATE);
; 0001 005A 	// initialize states
; 0001 005B 	uartReadyTx[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _uartReadyTx,1
; 0001 005C 	uartBufferedTx[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _uartBufferedTx,1
; 0001 005D 	// clear overflow count
; 0001 005E 	uartRxOverflow[1] = 0;
	__POINTW1MN _uartRxOverflow,2
	STD  Z+0,R26
	STD  Z+1,R27
; 0001 005F 	// enable interrupts
; 0001 0060 	//#asm("sei")
; 0001 0061 }
	RET
;
;void uart0InitBuffers(void)
; 0001 0064 {
_uart0InitBuffers:
; 0001 0065     // initialize the UART0 buffers
; 0001 0066 	bufferInit(&uartTxBuffer[0], uart0TxData, UART0_TX_BUFFER_SIZE);
	LDI  R30,LOW(_uartTxBuffer)
	LDI  R31,HIGH(_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_uart0TxData_G001)
	LDI  R31,HIGH(_uart0TxData_G001)
	CALL SUBOPT_0x3
; 0001 0067 }
	RET
;
;void uart1InitBuffers(void)
; 0001 006A {
_uart1InitBuffers:
; 0001 006B 	// initialize the UART1 buffers
; 0001 006C 	bufferInit(&uartTxBuffer[1], uart1TxData, UART1_TX_BUFFER_SIZE);
	__POINTW1MN _uartTxBuffer,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_uart1TxData_G001)
	LDI  R31,HIGH(_uart1TxData_G001)
	CALL SUBOPT_0x3
; 0001 006D }
	RET
;
;void uartSetRxHandler(byte nUart, void (*rx_func)(unsigned char c))
; 0001 0070 {
_uartSetRxHandler:
; 0001 0071 	if(nUart < 2) // make sure the uart number is within bounds
;	nUart -> Y+2
;	*rx_func -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRLO PC+3
	JMP _0x20005
; 0001 0072 	{
; 0001 0073 		UartRxFunc[nUart] = rx_func; // set the receive interrupt to run the supplied user function
	LDD  R30,Y+2
	CALL SUBOPT_0x4
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0001 0074 	}
; 0001 0075 }
_0x20005:
	ADIW R28,3
	RET
;
;void uartSetBaudRate(byte nUart, dword baudrate, byte double_speed_mode)
; 0001 0078 {
_uartSetBaudRate:
; 0001 0079 	word bauddiv;
; 0001 007A 	byte u2x_flag;
; 0001 007B 
; 0001 007C 	if(double_speed_mode){
	CALL __SAVELOCR4
;	nUart -> Y+9
;	baudrate -> Y+5
;	double_speed_mode -> Y+4
;	bauddiv -> R16,R17
;	u2x_flag -> R19
	LDD  R30,Y+4
	CPI  R30,0
	BRNE PC+3
	JMP _0x20006
; 0001 007D 		bauddiv = ((F_CPU+(baudrate*4L))/(baudrate*8L)-1); // calculate division factor for requested baud rate, and set it
	CALL SUBOPT_0x5
	CALL __LSLD1
	CALL __LSLD1
	__ADDD1N 11059200
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x7
; 0001 007E 		u2x_flag = 1;
	LDI  R19,LOW(1)
; 0001 007F 	}
; 0001 0080 	else{
	RJMP _0x20007
_0x20006:
; 0001 0081 		bauddiv = ((F_CPU+(baudrate*8L))/(baudrate*16L)-1); // calculate division factor for requested baud rate, and set it
	CALL SUBOPT_0x6
	__ADDD1N 11059200
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	__GETD2N 0x10
	CALL __MULD12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x7
; 0001 0082 		u2x_flag = 0;
	LDI  R19,LOW(0)
; 0001 0083 	}
_0x20007:
; 0001 0084 
; 0001 0085 	if(nUart)
	LDD  R30,Y+9
	CPI  R30,0
	BRNE PC+3
	JMP _0x20008
; 0001 0086 	{
; 0001 0087 		UBRR1L = bauddiv;
	STS  204,R16
; 0001 0088 		#ifdef UBRR1H
; 0001 0089 		UBRR1H = (bauddiv>>8);
	STS  205,R17
; 0001 008A 		#endif
; 0001 008B 		UCSR0A &= ~(1 << U2X0); 			//clear
	LDS  R30,192
	ANDI R30,0xFD
	STS  192,R30
; 0001 008C 		UCSR0A |= (u2x_flag << U2X0);		//set (if u2x_flag is set)
	LDI  R26,LOW(192)
	LDI  R27,HIGH(192)
	CALL SUBOPT_0x8
; 0001 008D 	}
; 0001 008E 	else
	RJMP _0x20009
_0x20008:
; 0001 008F 	{
; 0001 0090 		UBRR0L = bauddiv;
	STS  196,R16
; 0001 0091 		#ifdef UBRR0H
; 0001 0092 		UBRR0H = (bauddiv>>8);
	STS  197,R17
; 0001 0093 		#endif
; 0001 0094 		UCSR1A &= ~(1 << U2X0); 			//clear
	LDS  R30,200
	ANDI R30,0xFD
	STS  200,R30
; 0001 0095 		UCSR1A |= (u2x_flag << U2X0);		//set (if u2x_flag is set)
	LDI  R26,LOW(200)
	LDI  R27,HIGH(200)
	CALL SUBOPT_0x8
; 0001 0096 	}
_0x20009:
; 0001 0097 }
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;
;cBuffer* uartGetTxBuffer(byte nUart)
; 0001 009A {
; 0001 009B 	return &uartTxBuffer[nUart]; // return tx buffer pointer
;	nUart -> Y+0
; 0001 009C }
;
;void uartSendByte(byte nUart, byte txData)
; 0001 009F {
; 0001 00A0   // wait for the transmitter to be ready
; 0001 00A1   while(!uartReadyTx[nUart]);
;	nUart -> Y+1
;	txData -> Y+0
; 0001 00A2 
; 0001 00A3   //L.M. - vysilam v preruseni od prijmu
; 0001 00A4   // vyvola se znova preruseni od prijmu ale neprobehlo preruseni od vysilani kde se shazuje flag
; 0001 00A5   //uartReadyTx[nUart] = 0; // set ready state to 0
; 0001 00A6 
; 0001 00A7 	// send byte
; 0001 00A8 	if(nUart)
; 0001 00A9 	{
; 0001 00AA 		while(!(UCSR1A & (1<<UDRE)));
; 0001 00AB 			UDR1 = txData;
; 0001 00AC 	}
; 0001 00AD 	else
; 0001 00AE 	{
; 0001 00AF 		while(!(UCSR0A & (1<<UDRE)));
; 0001 00B0 			UDR0 = txData;
; 0001 00B1 	}
; 0001 00B2 }
;
;void uart0SendByte(u08 data)
; 0001 00B5 {
; 0001 00B6 	// send byte on UART0
; 0001 00B7 	uartSendByte(0, data);
;	data -> Y+0
; 0001 00B8 }
;
;void uart1SendByte(u08 data)
; 0001 00BB {
; 0001 00BC 	// send byte on UART1
; 0001 00BD 	uartSendByte(1, data);
;	data -> Y+0
; 0001 00BE }
;
;void uartAddToTxBuffer(byte nUart, byte data)
; 0001 00C1 {
; 0001 00C2 	// add data byte to the end of the tx buffer
; 0001 00C3 	bufferAddToEnd(&uartTxBuffer[nUart], data);
;	nUart -> Y+1
;	data -> Y+0
; 0001 00C4 }
;
;void uartSendTxBuffer(byte nUart)
; 0001 00C7 {
; 0001 00C8 	// turn on buffered transmit
; 0001 00C9 	uartBufferedTx[nUart] = 1;
;	nUart -> Y+0
; 0001 00CA 	// send the first byte to get things going by interrupts
; 0001 00CB 	uartSendByte(nUart, bufferGetFromFront(&uartTxBuffer[nUart]));
; 0001 00CC }
;
;byte uartSendBuffer(byte nUart, char *buffer, word nBytes)
; 0001 00CF {
; 0001 00D0 	register byte first;
; 0001 00D1 	register word i;
; 0001 00D2 
; 0001 00D3 	// check if there's space (and that we have any bytes to send at all)
; 0001 00D4 	if((uartTxBuffer[nUart].datalength + nBytes < uartTxBuffer[nUart].size) && nBytes)
;	nUart -> Y+8
;	*buffer -> Y+6
;	nBytes -> Y+4
;	first -> R17
;	i -> R18,R19
; 0001 00D5 	{
; 0001 00D6 		first = *buffer++; // grab first character
; 0001 00D7 		// copy user buffer to uart transmit buffer
; 0001 00D8 		for(i = 0; i < nBytes-1; i++)
; 0001 00D9 		{
; 0001 00DA 			bufferAddToEnd(&uartTxBuffer[nUart], *buffer++); // put data bytes at end of buffer
; 0001 00DB 		}
; 0001 00DC 
; 0001 00DD 		// send the first byte to get things going by interrupts
; 0001 00DE 		uartBufferedTx[nUart] = 1;
; 0001 00DF 		uartSendByte(nUart, first);
; 0001 00E0 		return 1; // return success
; 0001 00E1 	}
; 0001 00E2 	else
; 0001 00E3 	{
; 0001 00E4 		return 0; // return failure
; 0001 00E5 	}
; 0001 00E6 }
;void uartSendBufferf(byte nUart, char flash *text){
; 0001 00E7 void uartSendBufferf(byte nUart, char flash *text){
_uartSendBufferf:
; 0001 00E8   while(*text)
;	nUart -> Y+2
;	*text -> Y+0
_0x2001C:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0x2001E
; 0001 00E9   {
; 0001 00EA   	if(nUart){
	LDD  R30,Y+2
	CPI  R30,0
	BRNE PC+3
	JMP _0x2001F
; 0001 00EB     	while (!( UCSR1A & 0x20));
_0x20020:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ PC+3
	JMP _0x20022
	RJMP _0x20020
_0x20022:
; 0001 00EC     	UDR1 = *text++;
	CALL SUBOPT_0x9
	STS  206,R30
; 0001 00ED   	}
; 0001 00EE   	else{
	RJMP _0x20023
_0x2001F:
; 0001 00EF     	while (!( UCSR0A & 0x20));
_0x20024:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ PC+3
	JMP _0x20026
	RJMP _0x20024
_0x20026:
; 0001 00F0     	UDR0 = *text++;
	CALL SUBOPT_0x9
	STS  198,R30
; 0001 00F1   	}
_0x20023:
; 0001 00F2   }
	RJMP _0x2001C
_0x2001E:
; 0001 00F3 }
	ADIW R28,3
	RET
;
;// UART Transmit Complete Interrupt Function
;void uartTransmitService(byte nUart)
; 0001 00F7 {
_uartTransmitService:
; 0001 00F8 	// check if buffered tx is enabled
; 0001 00F9 	if(uartBufferedTx[nUart])
;	nUart -> Y+0
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_uartBufferedTx)
	SBCI R31,HIGH(-_uartBufferedTx)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0x20027
; 0001 00FA 	{
; 0001 00FB 		// check if there's data left in the buffer
; 0001 00FC 		if(uartTxBuffer[nUart].datalength)
	CALL SUBOPT_0xA
	CALL __LSLW3
	__ADDW1MN _uartTxBuffer,4
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BRNE PC+3
	JMP _0x20028
; 0001 00FD 		{
; 0001 00FE 			// send byte from top of buffer
; 0001 00FF 			if(nUart)
	LD   R30,Y
	CPI  R30,0
	BRNE PC+3
	JMP _0x20029
; 0001 0100 				UDR1 =  bufferGetFromFront(&uartTxBuffer[1]);
	__POINTW1MN _uartTxBuffer,8
	ST   -Y,R31
	ST   -Y,R30
	CALL _bufferGetFromFront
	STS  206,R30
; 0001 0101 			else
	RJMP _0x2002A
_0x20029:
; 0001 0102 				UDR0 =  bufferGetFromFront(&uartTxBuffer[0]);
	LDI  R30,LOW(_uartTxBuffer)
	LDI  R31,HIGH(_uartTxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _bufferGetFromFront
	STS  198,R30
; 0001 0103 		}
_0x2002A:
; 0001 0104 		else
	RJMP _0x2002B
_0x20028:
; 0001 0105 		{
; 0001 0106 			uartBufferedTx[nUart] = 0; // no data left
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_uartBufferedTx)
	SBCI R31,HIGH(-_uartBufferedTx)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0001 0107 			uartReadyTx[nUart] = 1; // return to ready state
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_uartReadyTx)
	SBCI R31,HIGH(-_uartReadyTx)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0001 0108 
; 0001 0109       // Comm LED off
; 0001 010A       LED_COMM_OFF;
; 0001 010B 		}
_0x2002B:
; 0001 010C 	}
; 0001 010D 	else
	RJMP _0x2002C
_0x20027:
; 0001 010E 	{
; 0001 010F 		// we're using single-byte tx mode
; 0001 0110 		// indicate transmit complete, back to ready
; 0001 0111 		uartReadyTx[nUart] = 1;
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_uartReadyTx)
	SBCI R31,HIGH(-_uartReadyTx)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0001 0112 
; 0001 0113     // Comm LED off
; 0001 0114     LED_COMM_OFF;
; 0001 0115 	}
_0x2002C:
; 0001 0116 }
	ADIW R28,1
	RET
;
;// UART Receive Complete Interrupt Function
;void uartReceiveService(byte nUart)
; 0001 011A {
_uartReceiveService:
; 0001 011B 	byte c;
; 0001 011C 
; 0001 011D 	// get received char
; 0001 011E 	if(nUart)
	ST   -Y,R17
;	nUart -> Y+1
;	c -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE PC+3
	JMP _0x2002D
; 0001 011F 		c = UDR1;
	LDS  R17,206
; 0001 0120 	else
	RJMP _0x2002E
_0x2002D:
; 0001 0121 		c = UDR0;
	LDS  R17,198
; 0001 0122 
; 0001 0123 	// if there's a user function to handle this receive event
; 0001 0124 	if(UartRxFunc[nUart])
_0x2002E:
	LDD  R30,Y+1
	CALL SUBOPT_0x4
	CALL SUBOPT_0xB
	SBIW R30,0
	BRNE PC+3
	JMP _0x2002F
; 0001 0125 	{
; 0001 0126 		// call it and pass the received data
; 0001 0127 		UartRxFunc[nUart](c);
	LDD  R30,Y+1
	CALL SUBOPT_0x4
	CALL SUBOPT_0xB
	PUSH R31
	PUSH R30
	ST   -Y,R17
	POP  R30
	POP  R31
	ICALL
; 0001 0128 	}
; 0001 0129 
; 0001 012A }
_0x2002F:
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0001 012E {
_usart0_tx_isr:
	CALL SUBOPT_0xC
; 0001 012F 	// service UART0 transmit interrupt
; 0001 0130 	uartTransmitService(0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xD
; 0001 0131 }
	RETI
;
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0001 0134 {
_usart1_tx_isr:
	CALL SUBOPT_0xC
; 0001 0135 	// service UART1 transmit interrupt
; 0001 0136 	uartTransmitService(1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xD
; 0001 0137 }
	RETI
;
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0001 013A {
_usart0_rx_isr:
	CALL SUBOPT_0xC
; 0001 013B 	// service UART0 receive interrupt
; 0001 013C 	uartReceiveService(0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
; 0001 013D }
	RETI
;
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0001 0140 {
_usart1_rx_isr:
	CALL SUBOPT_0xC
; 0001 0141 	// service UART1 receive interrupt
; 0001 0142 	uartReceiveService(1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xE
; 0001 0143 }
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
; 0002 0027 void uKnos_Init(){

	.CSEG
_uKnos_Init:
; 0002 0028     byte i;
; 0002 0029     // Timer/Counter 0 initialization
; 0002 002A     // Clock source: System Clock
; 0002 002B     // Clock value: 10,800 kHz
; 0002 002C     // Mode: CTC top=OCR0A
; 0002 002D     TCCR0A = 0x02;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(2)
	OUT  0x24,R30
; 0002 002E     TCCR0B = 0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0002 002F     TCNT0  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0002 0030     OCR0A  = 0x6C - 1;   // 0x6C=108; //prescaler timeru je 1024!
	LDI  R30,LOW(107)
	OUT  0x27,R30
; 0002 0031     OCR0B  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0002 0032 
; 0002 0033     // Timer/Counter 0 Interrupt(s) initialization
; 0002 0034     TIMSK0=0x02;  //compare match
	LDI  R30,LOW(2)
	STS  110,R30
; 0002 0035 
; 0002 0036     sKernel.delay_after_start = DELAY_AFTER_START / 10;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _sKernel,R30
	STS  _sKernel+1,R31
; 0002 0037 
; 0002 0038     for (i = 0; i < PROCESS_MAX; i++) {
	LDI  R17,LOW(0)
_0x40004:
	CPI  R17,10
	BRLO PC+3
	JMP _0x40005
; 0002 0039         sProcess[i].state = PROCESS_FREE;   //proces volny
	CALL SUBOPT_0xF
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0002 003A     }
_0x40003:
	SUBI R17,-1
	RJMP _0x40004
_0x40005:
; 0002 003B }
	LD   R17,Y+
	RET
;
;void uKnos_Start(){
; 0002 003D void uKnos_Start(){
_uKnos_Start:
; 0002 003E     #asm("sei")
	sei
; 0002 003F }
	RET
;
;//*****************************************************************************
;// Funkce pro vytvoreni periodicky volane funkce -> procesu
;// dword period - perioda volani funkce v ms
;// flash dword *function - adresa funkce, ktera ma byt volana
;//*****************************************************************************
;void Create_Process(dword period,  void (*function)(void)){
; 0002 0046 void Create_Process(dword period,  void (*function)(void)){
_Create_Process:
; 0002 0047   byte i;
; 0002 0048   tProcess *p_aux_process;
; 0002 0049 
; 0002 004A   for (i = 0; i < PROCESS_MAX; i++) {
	CALL __SAVELOCR4
;	period -> Y+6
;	*function -> Y+4
;	i -> R17
;	*p_aux_process -> R18,R19
	LDI  R17,LOW(0)
_0x40007:
	CPI  R17,10
	BRLO PC+3
	JMP _0x40008
; 0002 004B     p_aux_process = &sProcess[i];
	CALL SUBOPT_0xF
	MOVW R18,R30
; 0002 004C     if (p_aux_process->state == PROCESS_FREE) {   // pokud je proces volny
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	BREQ PC+3
	JMP _0x40009
; 0002 004D       p_aux_process->state = PROCESS_STANDBY;
	LDI  R30,LOW(1)
	ST   X,R30
; 0002 004E       p_aux_process->function = function;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTW1RNS 18,1
; 0002 004F       if (period < 10)
	CALL SUBOPT_0x10
	BRLO PC+3
	JMP _0x4000A
; 0002 0050         period = 10;
	CALL SUBOPT_0x11
	__PUTD1S 6
; 0002 0051       p_aux_process->period = ((period<10)? 1 : period/10);
_0x4000A:
	CALL SUBOPT_0x10
	BRLO PC+3
	JMP _0x4000B
	__GETD1N 0x1
	RJMP _0x4000C
_0x4000B:
	CALL SUBOPT_0x12
_0x4000C:
_0x4000D:
	__PUTD1RNS 18,3
; 0002 0052       p_aux_process->counter =((period<10)? 1 : period/10);
	CALL SUBOPT_0x10
	BRLO PC+3
	JMP _0x4000E
	__GETD1N 0x1
	RJMP _0x4000F
_0x4000E:
	CALL SUBOPT_0x12
_0x4000F:
_0x40010:
	__PUTD1RNS 18,7
; 0002 0053       printf("\ncreate process nr.%d ..",i);
	__POINTW1FN _0x40000,0
	CALL SUBOPT_0x13
; 0002 0054       return;
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; 0002 0055     }
; 0002 0056   }
_0x40009:
_0x40006:
	SUBI R17,-1
	RJMP _0x40007
_0x40008:
; 0002 0057   // tady udelat dbg vypis nebo signalizaci chyby
; 0002 0058 }
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;
;//*****************************************************************************
;// 10 MILISECOND INTERRUPT, kde se periodicky vyvolavaji procesy
;//*****************************************************************************
;// Timer 0 output compare A interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void){
; 0002 005E interrupt [17] void timer0_compa_isr(void){
_timer0_compa_isr:
	CALL SUBOPT_0xC
; 0002 005F   byte i;
; 0002 0060   tProcess *p_aux_process;
; 0002 0061   void (*called_funcion)(void);
; 0002 0062 
; 0002 0063   // povolit vnorena preruseni
; 0002 0064   /*#ifdef ENABLE_RECURSIVE_INTERRUPT
; 0002 0065     ENABLE_INTERRUPT
; 0002 0066   #endif*/
; 0002 0067 
; 0002 0068 
; 0002 0069 
; 0002 006A   //delay after kernel start
; 0002 006B   if(sKernel.delay_after_start != 0){
	CALL __SAVELOCR6
;	i -> R17
;	*p_aux_process -> R18,R19
;	*called_funcion -> R20,R21
	LDS  R30,_sKernel
	LDS  R31,_sKernel+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x40011
; 0002 006C     sKernel.delay_after_start--;
	LDI  R26,LOW(_sKernel)
	LDI  R27,HIGH(_sKernel)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0002 006D     return;
	CALL SUBOPT_0x14
	RETI
; 0002 006E   }
; 0002 006F 
; 0002 0070   TIMSK0=0x00;
_0x40011:
	LDI  R30,LOW(0)
	STS  110,R30
; 0002 0071 
; 0002 0072   // spusteni procesu
; 0002 0073   for (i = 0; i < PROCESS_MAX; i++) {   //pres vsechny procesy
	LDI  R17,LOW(0)
_0x40013:
	CPI  R17,10
	BRLO PC+3
	JMP _0x40014
; 0002 0074     p_aux_process = &sProcess[i];
	CALL SUBOPT_0xF
	MOVW R18,R30
; 0002 0075     if (p_aux_process->state == PROCESS_STANDBY) {
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x40015
; 0002 0076 
; 0002 0077       if (--(p_aux_process->counter) == 0) {    // proces ma byt vyvolan
	MOVW R26,R18
	ADIW R26,7
	CALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTDP1_DEC
	CALL __CPD10
	BREQ PC+3
	JMP _0x40016
; 0002 0078 
; 0002 0079         p_aux_process->state = PROCESS_BUSSY;
	MOVW R26,R18
	LDI  R30,LOW(2)
	ST   X,R30
; 0002 007A 
; 0002 007B         // zavola se odpovidajici funkce
; 0002 007C         //toDo: vyzkouset a zahodit pomocnou promennou, volat primo
; 0002 007D         //printf("\n%d s",i);
; 0002 007E         called_funcion = ( void (*)(void))p_aux_process->function;
	ADIW R26,1
	LD   R20,X+
	LD   R21,X
; 0002 007F         called_funcion();
	MOVW R30,R20
	ICALL
; 0002 0080         //printf("\n%d e",i);
; 0002 0081 
; 0002 0082 
; 0002 0083         // nastaveni periody u procesu
; 0002 0084         p_aux_process->counter = p_aux_process->period;
	MOVW R26,R18
	ADIW R26,3
	CALL __GETD1P
	__PUTD1RNS 18,7
; 0002 0085 
; 0002 0086         //uvolneni procesu pro dalsi volani
; 0002 0087         p_aux_process->state = PROCESS_STANDBY;
	MOVW R26,R18
	LDI  R30,LOW(1)
	ST   X,R30
; 0002 0088       } // if (counter == 0) end
; 0002 0089     } // if (process == PROCESS_STANDBY) end
_0x40016:
; 0002 008A   } // for cyklus end
_0x40015:
_0x40012:
	SUBI R17,-1
	RJMP _0x40013
_0x40014:
; 0002 008B   TIMSK0=0x02;
	LDI  R30,LOW(2)
	STS  110,R30
; 0002 008C }
	CALL SUBOPT_0x14
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
	CALL SUBOPT_0x15
; 0003 0027 	buffer->datalength = 0;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL SUBOPT_0x15
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
	BRNE PC+3
	JMP _0x60003
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
	CALL SUBOPT_0x16
; 0003 0039 		if(buffer->dataindex >= buffer->size)
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__GETWRZ 0,1,6
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	BRSH PC+3
	JMP _0x60004
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
	ADIW R28,3
	RET
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
; 0003 006D 	// begin critical section
; 0003 006E 	CRITICAL_SECTION_START;
;	*buffer -> Y+1
;	data -> Y+0
; 0003 006F 	// make sure the buffer has room
; 0003 0070 	if(buffer->datalength < buffer->size)
; 0003 0071 	{
; 0003 0072 		// save data byte at end of buffer
; 0003 0073 		buffer->dataptr[(buffer->dataindex + buffer->datalength) % buffer->size] = data;
; 0003 0074 		// increment the length
; 0003 0075 		buffer->datalength++;
; 0003 0076 		// end critical section
; 0003 0077 		CRITICAL_SECTION_END;
; 0003 0078 		// return success
; 0003 0079 		return -1;
; 0003 007A 	}
; 0003 007B 	// end critical section
; 0003 007C 	CRITICAL_SECTION_END;
; 0003 007D 	// return failure
; 0003 007E 	return 0;
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
;#include <display.h>
;
;
;
;void Test_process_leds(void){
; 0006 000F void Test_process_leds(void){

	.CSEG
_Test_process_leds:
; 0006 0010     static byte aux_flag = 0;
; 0006 0011 
; 0006 0012     //printf("\nLED CHANGED");
; 0006 0013 
; 0006 0014 
; 0006 0015     LED_2_CHANGE;
	IN   R30,0xB
	LDI  R26,LOW(128)
	EOR  R30,R26
	OUT  0xB,R30
; 0006 0016 
; 0006 0017     if(aux_flag){
	LDS  R30,_aux_flag_S0060000000
	CPI  R30,0
	BRNE PC+3
	JMP _0xC0003
; 0006 0018         LED_1_CHANGE;
	IN   R30,0xB
	LDI  R26,LOW(64)
	EOR  R30,R26
	OUT  0xB,R30
; 0006 0019         aux_flag = 0;
	LDI  R30,LOW(0)
	STS  _aux_flag_S0060000000,R30
; 0006 001A     }
; 0006 001B     else
	RJMP _0xC0004
_0xC0003:
; 0006 001C         aux_flag = 1;
	LDI  R30,LOW(1)
	STS  _aux_flag_S0060000000,R30
; 0006 001D }
_0xC0004:
	RET
;
;
;void Test_process_buttons(){
; 0006 0020 void Test_process_buttons(){
_Test_process_buttons:
; 0006 0021     static byte aux_top_first = 1, aux_bottom_first = 1;

	.DSEG

	.CSEG

	.DSEG

	.CSEG
; 0006 0022 
; 0006 0023     /* BUTTON TOP */
; 0006 0024     if(GET_BUTTON_TOP_STATE == 0){
	SBIC 0x6,7
	RJMP _0xC0007
; 0006 0025         if(aux_top_first){ //prave ted zmacknuto?
	LDS  R30,_aux_top_first_S0060001000
	CPI  R30,0
	BRNE PC+3
	JMP _0xC0008
; 0006 0026             //uartSendBufferf(0,"\nI: Tlacitko TOP  bylo zmacknuto..");
; 0006 0027 
; 0006 0028             printf("\n-");
	__POINTW1FN _0xC0000,0
	CALL SUBOPT_0x17
; 0006 0029             Disp_previous_screen();
	CALL _Disp_previous_screen
; 0006 002A             aux_top_first = 0;
	LDI  R30,LOW(0)
	STS  _aux_top_first_S0060001000,R30
; 0006 002B         }
; 0006 002C     }
_0xC0008:
; 0006 002D     else    //tlacitko pusteno
	RJMP _0xC0009
_0xC0007:
; 0006 002E         aux_top_first = 1;  //vynulovani flagu pro nove zmacknuti
	LDI  R30,LOW(1)
	STS  _aux_top_first_S0060001000,R30
; 0006 002F 
; 0006 0030     /* BUTTON BOTTOM */
; 0006 0031     if(GET_BUTTON_BOTTOM_STATE == 0){ //prave ted zmacknuto?
_0xC0009:
	SBIC 0x6,6
	RJMP _0xC000A
; 0006 0032         if(aux_bottom_first){
	LDS  R30,_aux_bottom_first_S0060001000
	CPI  R30,0
	BRNE PC+3
	JMP _0xC000B
; 0006 0033             //uartSendBufferf(0,"\nI: Tlacitko BOTTOM bylo zmacknuto..");
; 0006 0034 
; 0006 0035             printf("\n+");
	__POINTW1FN _0xC0000,3
	CALL SUBOPT_0x17
; 0006 0036             Disp_next_screen();
	CALL _Disp_next_screen
; 0006 0037             aux_bottom_first = 0;
	LDI  R30,LOW(0)
	STS  _aux_bottom_first_S0060001000,R30
; 0006 0038         }
; 0006 0039     }
_0xC000B:
; 0006 003A     else    //tlacitko pusteno
	RJMP _0xC000C
_0xC000A:
; 0006 003B         aux_bottom_first = 1;   //vynulovani flagu pro nove zmacknuti
	LDI  R30,LOW(1)
	STS  _aux_bottom_first_S0060001000,R30
; 0006 003C }
_0xC000C:
	RET
;
;void Test_process_uart(void){
; 0006 003E void Test_process_uart(void){
; 0006 003F     //char text[] = "\nI: SendBuffer()";
; 0006 0040     //char a= 'a';
; 0006 0041 
; 0006 0042     //uartSendByte(0, a);
; 0006 0043     uartSendBufferf(1,"\nI: SendBufferf()");
; 0006 0044     // uartSendBuffer(0,text, 16);
; 0006 0045 }
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
; 0007 001D {

	.CSEG
; 0007 001E 
; 0007 001F 	//Rx pin init
; 0007 0020 	COMM_TERMINAL_DDR &= ~COMM_TERMINAL_RX_PIN_MASK; 	//0 -> input
; 0007 0021 	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> pullup
; 0007 0022 	//Tx pin init
; 0007 0023 	COMM_TERMINAL_DDR |= COMM_TERMINAL_TX_PIN_MASK; 	//1 -> output
; 0007 0024 	COMM_TERMINAL_PORT |= COMM_TERMINAL_RX_PIN_MASK; 	//1 -> default output = '1'
; 0007 0025 
; 0007 0026     // USART param setting
; 0007 0027     uartInit(COMM_TERMINAL_UART_NR);            // Tx, Rx, TxIRq, RxIRq
; 0007 0028 	uartSetBaudRate(COMM_TERMINAL_UART_NR, COMM_TERMINAL_BAUDRATE, 0);   // Commspeed
; 0007 0029 	uartSetRxHandler(COMM_TERMINAL_UART_NR, CommTerminal_Handler);        // Rx bytes handler
; 0007 002A 
; 0007 002B     // Variables init
; 0007 002C     uartRxBuffer_index = 0;
; 0007 002D }
;
;// CommApp_Handler() - routine for received char from UART.
;// Received char is processed, after last char is received,
;// control "comm_terminal_state" is switched to special state allowing
;// processing and executing of command
;void CommTerminal_Handler(byte data){
; 0007 0033 void CommTerminal_Handler(byte data){
; 0007 0034 
; 0007 0035     if(comm_terminal_state == eWAIT_FOR_CHAR){
;	data -> Y+0
; 0007 0036 
; 0007 0037         //ukoncovaci znak?
; 0007 0038         if ((data == '\n')||(data == '\r')){
; 0007 0039             comm_terminal_state = eWAIT_FOR_PROCESS_OK;
; 0007 003A             return; //-> ukoncovaci znak se do bufferu nevklada
; 0007 003B         }
; 0007 003C 
; 0007 003D         //ulozeni znaku do bufferu
; 0007 003E         uartRxBuffer[uartRxBuffer_index++] = data;
; 0007 003F 
; 0007 0040         //je jeste misto pro dalsi prijem?
; 0007 0041         if(uartRxBuffer_index ==  RX_BUFFER_SIZE){
; 0007 0042            comm_terminal_state = eWAIT_FOR_PROCESS_KO;
; 0007 0043         }
; 0007 0044     }
; 0007 0045 }
;void CommTerminal_Manager(void){
; 0007 0046 void CommTerminal_Manager(void){
; 0007 0047     switch(comm_terminal_state){
; 0007 0048         case eWAIT_FOR_PROCESS_OK:
; 0007 0049             uartSendBufferf(COMM_TERMINAL_UART_NR,"\nI: Prijmut string: ");
; 0007 004A             break;
; 0007 004B         case  eWAIT_FOR_PROCESS_KO:
; 0007 004C             uartSendBufferf(COMM_TERMINAL_UART_NR,"\nE: Nedostatecny buffer, string:");
; 0007 004D             break;
; 0007 004E     }
; 0007 004F 
; 0007 0050     if(comm_terminal_state != eWAIT_FOR_CHAR){
; 0007 0051         uartSendBuffer(COMM_TERMINAL_UART_NR, uartRxBuffer, uartRxBuffer_index);
; 0007 0052         uartRxBuffer_index = 0;           //flush buffer
; 0007 0053         comm_terminal_state = eWAIT_FOR_CHAR;  //povoleni dalsiho prijmu
; 0007 0054     }
; 0007 0055 }
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
; 0009 0035 void CommXport_Init(void){

	.CSEG
_CommXport_Init:
; 0009 0036     byte i;
; 0009 0037 
; 0009 0038 	//Rx pin init
; 0009 0039 	COMM_XPORT_DDR &= ~COMM_XPORT_RX_PIN_MASK; 	//0 -> input
	ST   -Y,R17
;	i -> R17
	IN   R30,0xA
	ANDI R30,LOW(0xFC)
	OUT  0xA,R30
; 0009 003A 	COMM_XPORT_PORT |= COMM_XPORT_RX_PIN_MASK; 	//1 -> pullup
	IN   R30,0xB
	ORI  R30,LOW(0x3)
	OUT  0xB,R30
; 0009 003B 	//Tx pin init
; 0009 003C 	COMM_XPORT_DDR |= COMM_XPORT_TX_PIN_MASK; 	//1 -> output
	SBI  0xA,2
; 0009 003D 	COMM_XPORT_PORT |= COMM_XPORT_RX_PIN_MASK; 	//1 -> default output = '1'
	IN   R30,0xB
	ORI  R30,LOW(0x3)
	OUT  0xB,R30
; 0009 003E 
; 0009 003F     // USART param setting
; 0009 0040 	uartInit(COMM_XPORT_UART_NR);            // Tx, Rx, TxIRq, RxIRq
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _uartInit
; 0009 0041 	uartSetBaudRate(COMM_XPORT_UART_NR, COMM_XPORT_BAUDRATE, 0);   // Commspeed
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETD1N 0x2580
	CALL __PUTPARD1
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _uartSetBaudRate
; 0009 0042 	uartSetRxHandler(COMM_XPORT_UART_NR, CommXport_Handler);        // Rx bytes handler
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_CommXport_Handler)
	LDI  R31,HIGH(_CommXport_Handler)
	ST   -Y,R31
	ST   -Y,R30
	CALL _uartSetRxHandler
; 0009 0043 
; 0009 0044     /* VARIABLES */
; 0009 0045 
; 0009 0046     //ip address
; 0009 0047     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x120004:
	CPI  R17,4
	BRLO PC+3
	JMP _0x120005
; 0009 0048         sXport.ip_address[i] = i;
	CALL SUBOPT_0x18
	SUBI R30,LOW(-_sXport)
	SBCI R31,HIGH(-_sXport)
	ST   Z,R17
_0x120003:
	SUBI R17,-1
	RJMP _0x120004
_0x120005:
; 0009 004B for(i=0; i<6; i++)
	LDI  R17,LOW(0)
_0x120007:
	CPI  R17,6
	BRLO PC+3
	JMP _0x120008
; 0009 004C         sXport.mac_address[i] = i;
	__POINTW2MN _sXport,4
	CALL SUBOPT_0x18
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
_0x120006:
	SUBI R17,-1
	RJMP _0x120007
_0x120008:
; 0009 004E sProtocol.seq = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _sProtocol,1
; 0009 004F }
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
; 0009 0058 void CommXport_Manager(void){
; 0009 0059 
; 0009 005A     if (sProtocol.comm_state == eWAIT_FOR_PROCESS) {     // new frame
; 0009 005B 
; 0009 005C         // Executing received command and new frame creation
; 0009 005D         CommXport_ProcessCommand();   // command executed ok
; 0009 005E     }
; 0009 005F 
; 0009 0060     //sending
; 0009 0061     CommXport_SendFrames();
; 0009 0062 }
;
;
;/*******************************************/
;// COMMXPORT_SENDFRAMES()
;/*******************************************/
;// - periodicly send frames to xport
;/*******************************************/
;void CommXport_SendFrames(void){
; 0009 006A void CommXport_SendFrames(void){
; 0009 006B     static byte send_group = 0;
; 0009 006C     tMESSMODUL *pMessmodul = &sMm[0];
; 0009 006D     byte aux_data;
; 0009 006E 
; 0009 006F 
; 0009 0070     switch(send_group++){
;	*pMessmodul -> R16,R17
;	aux_data -> R19
; 0009 0071         case eIO:
; 0009 0072             //INPUTS
; 0009 0073             aux_data = (GET_BUTTON_TOP_STATE<<1) | GET_BUTTON_BOTTOM_STATE;
; 0009 0074             CommXport_SendFrame( CMD_GET_INPUTS, &aux_data, 1);
; 0009 0075             //OUTPUTS
; 0009 0076             aux_data = 0xAA;
; 0009 0077             CommXport_SendFrame( CMD_SET_OUTPUTS , &aux_data, 1 );
; 0009 0078             break;
; 0009 0079         case e1F:
; 0009 007A             //1F values
; 0009 007B             CommXport_SendFrame( CMD_MM_GET_FREQUENCY,   (byte*)&pMessmodul->values.frequence,   2);  //FREQUENCE
; 0009 007C             CommXport_SendFrame( CMD_MM_GET_TEMPERATURE, (byte*)&pMessmodul->values.temperature, 2);  //RAWTEMP
; 0009 007D             break;
; 0009 007E         case eVOLTAGES:
; 0009 007F             //VOLTAGEs
; 0009 0080             CommXport_SendFrame( CMD_MM_GET_VOLTAGE_1,  (byte*)&pMessmodul->values.voltage[0],  2);  //VOLTAGE 1
; 0009 0081             CommXport_SendFrame( CMD_MM_GET_VOLTAGE_2,  (byte*)&pMessmodul->values.voltage[1],  2);  //VOLTAGE 2
; 0009 0082             CommXport_SendFrame( CMD_MM_GET_VOLTAGE_3,  (byte*)&pMessmodul->values.voltage[2],  2);  //VOLTAGE 3
; 0009 0083             break;
; 0009 0084         case eCURRENTS:
; 0009 0085             //CURRENTs
; 0009 0086             CommXport_SendFrame( CMD_MM_GET_CURRENT_1,  (byte*)&pMessmodul->values.current[0],  2);  //CURRENT 1
; 0009 0087             CommXport_SendFrame( CMD_MM_GET_CURRENT_2,  (byte*)&pMessmodul->values.current[1],  2);  //CURRENT 2
; 0009 0088             CommXport_SendFrame( CMD_MM_GET_CURRENT_3,  (byte*)&pMessmodul->values.current[2],  2);  //CURRENT 3
; 0009 0089             break;
; 0009 008A         case ePOWERS:
; 0009 008B             //POWERs
; 0009 008C             CommXport_SendFrame( CMD_MM_GET_POWER_1,  (byte*)&pMessmodul->values.power_act[0],  2);  //POWER 1
; 0009 008D             CommXport_SendFrame( CMD_MM_GET_POWER_2,  (byte*)&pMessmodul->values.power_act[1],  2);  //POWER 2
; 0009 008E             CommXport_SendFrame( CMD_MM_GET_POWER_3,  (byte*)&pMessmodul->values.power_act[2],  2);  //POWER 3
; 0009 008F             break;
; 0009 0090         case eENERGIES:
; 0009 0091             //ENERGIES
; 0009 0092             CommXport_SendFrame( CMD_MM_GET_ENERGY_1,  (byte*)&pMessmodul->values.energy_act[0],  2);  //ENERGY 1
; 0009 0093             CommXport_SendFrame( CMD_MM_GET_ENERGY_2,  (byte*)&pMessmodul->values.energy_act[1],  2);  //ENERGY 2
; 0009 0094             CommXport_SendFrame( CMD_MM_GET_ENERGY_3,  (byte*)&pMessmodul->values.energy_act[2],  2);  //ENERGY 3
; 0009 0095             break;
; 0009 0096         case ePFS:
; 0009 0097             //POWER FACTOR
; 0009 0098             CommXport_SendFrame( CMD_MM_GET_PF_1,  (byte*)&pMessmodul->values.power_factor[0],  2);  //PF 1
; 0009 0099             CommXport_SendFrame( CMD_MM_GET_PF_2,  (byte*)&pMessmodul->values.power_factor[1],  2);  //PF 2
; 0009 009A             CommXport_SendFrame( CMD_MM_GET_PF_3,  (byte*)&pMessmodul->values.power_factor[2],  2);  //PF 3
; 0009 009B             send_group = eIO;
; 0009 009C             break;
; 0009 009D     }
; 0009 009E 
; 0009 009F     //SYNCHRONIZATION END
; 0009 00A0     CommXport_SendFrame( CMD_SYNC_END,     (byte*)&aux_data,                       0);  //SYNCHRONIZATION END
; 0009 00A1 
; 0009 00A2 }
;
;/*******************************************/
;// COMMXPORT_SENDFRAME()
;/*******************************************/
;// - send frame to xport
;/* ------------------------------------------------------------
; * | STARTBYTE | SEQ | COMMAND | DATALENGTH | DATA | .. | XOR |
; * ------------------------------------------------------------*/
;void CommXport_SendFrame(byte command, byte* pData, byte datalength){
; 0009 00AB void CommXport_SendFrame(byte command, byte* pData, byte datalength){
; 0009 00AC     byte i, xor = COMM_XPORT_STARTBYTE;
; 0009 00AD 
; 0009 00AE     /* CREATING FRAME */
; 0009 00AF 
; 0009 00B0     //start byte
; 0009 00B1     uartAddToTxBuffer(COMM_XPORT_UART_NR, COMM_XPORT_STARTBYTE);      // startbyte added to buffer
;	command -> Y+5
;	*pData -> Y+3
;	datalength -> Y+2
;	i -> R17
;	xor -> R16
; 0009 00B2 
; 0009 00B3     //sequence
; 0009 00B4     uartAddToTxBuffer(COMM_XPORT_UART_NR, ++sProtocol.seq);           // sequence added to buffer
; 0009 00B5     xor ^= sProtocol.seq;                                 // seq added to xor
; 0009 00B6 
; 0009 00B7     //command
; 0009 00B8     uartAddToTxBuffer(COMM_XPORT_UART_NR, command | 0x80); // command added to buffer
; 0009 00B9     xor ^= command;                                        // command added to xor
; 0009 00BA 
; 0009 00BB     //datalength
; 0009 00BC     uartAddToTxBuffer(COMM_XPORT_UART_NR, datalength);           // datalength added to buffer
; 0009 00BD     xor ^= datalength;                          // datalength added to xor
; 0009 00BE 
; 0009 00BF     //data
; 0009 00C0     for (i=0; i<datalength; i++) {                  // all databytes
; 0009 00C1         uartAddToTxBuffer(COMM_XPORT_UART_NR, *(pData+i));    // data byte added to buffer
; 0009 00C2         xor ^= *(pData+i);                             // data byte added to xor
; 0009 00C3     }
; 0009 00C4 
; 0009 00C5     //xor
; 0009 00C6     uartAddToTxBuffer(COMM_XPORT_UART_NR, xor);         // xor added to buffer
; 0009 00C7 
; 0009 00C8     // sending frame
; 0009 00C9     uartSendTxBuffer(COMM_XPORT_UART_NR);
; 0009 00CA 
; 0009 00CB }
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
; 0009 00D6 void CommXport_Handler(byte data){
_CommXport_Handler:
; 0009 00D7 
; 0009 00D8 	switch(sProtocol.comm_state){
;	data -> Y+0
	LDS  R30,_sProtocol
; 0009 00D9 
; 0009 00DA 	    case eWAIT_FOR_STARTBYTE:                // waiting for startbyte
	CPI  R30,0
	BREQ PC+3
	JMP _0x12001A
; 0009 00DB 			if (data == COMM_XPORT_STARTBYTE) {    // start of frame
	LD   R26,Y
	CPI  R26,LOW(0x53)
	BREQ PC+3
	JMP _0x12001B
; 0009 00DC 				sFrame_Rx.data_cnt = 0;          // init databytes counter
	LDI  R30,LOW(0)
	__PUTB1MN _sFrame_Rx,36
; 0009 00DD 				sProtocol.comm_state = eWAIT_FOR_SEQ;  // switch to next state
	LDI  R30,LOW(1)
	STS  _sProtocol,R30
; 0009 00DE // 				LED_7_CHANGE;
; 0009 00DF // 				uartSendBufferf(0,"LED_7_CHANGE");
; 0009 00E0 			}
; 0009 00E1 			break;
_0x12001B:
	RJMP _0x120019
; 0009 00E2 
; 0009 00E3         case eWAIT_FOR_SEQ:                  // awaiting sequence byte
_0x12001A:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x12001C
; 0009 00E4             sFrame_Rx.seq = data;            // seq
	LD   R30,Y
	STS  _sFrame_Rx,R30
; 0009 00E5             sProtocol.comm_state = eWAIT_FOR_CMD;  // switch to nex state
	LDI  R30,LOW(2)
	STS  _sProtocol,R30
; 0009 00E6             break;
	RJMP _0x120019
; 0009 00E7 
; 0009 00E8 		case eWAIT_FOR_CMD:                         // awaiting command byte
_0x12001C:
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x12001D
; 0009 00E9 		    sFrame_Rx.command = data;   // command
	LD   R30,Y
	__PUTB1MN _sFrame_Rx,1
; 0009 00EA 			sProtocol.comm_state = eWAIT_FOR_DATALENGTH;  // switch to next state
	LDI  R30,LOW(3)
	STS  _sProtocol,R30
; 0009 00EB 			break;
	RJMP _0x120019
; 0009 00EC 
; 0009 00ED 		case eWAIT_FOR_DATALENGTH:  // awaiting datalength byte
_0x12001D:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x12001E
; 0009 00EE 			if(data > COMM_XPORT_DATALENGTH_MAX)        // datalength above data buffer (ERROR)
	LD   R26,Y
	CPI  R26,LOW(0x1F)
	BRSH PC+3
	JMP _0x12001F
; 0009 00EF 				sProtocol.comm_state = eWAIT_FOR_STARTBYTE; // switch to starting state
	LDI  R30,LOW(0)
	STS  _sProtocol,R30
; 0009 00F0 			else {      // ok
	RJMP _0x120020
_0x12001F:
; 0009 00F1 				sFrame_Rx.datalength = data;
	LD   R30,Y
	__PUTB1MN _sFrame_Rx,4
; 0009 00F2                 if (data)     // frame contains data
	CPI  R30,0
	BRNE PC+3
	JMP _0x120021
; 0009 00F3   				    sProtocol.comm_state = eWAIT_FOR_DATA;        // switch to next state
	LDI  R30,LOW(4)
	STS  _sProtocol,R30
; 0009 00F4                 else          // no data, xor is expected
	RJMP _0x120022
_0x120021:
; 0009 00F5   				    sProtocol.comm_state = eWAIT_FOR_XOR;			// switch to xor state
	LDI  R30,LOW(5)
	STS  _sProtocol,R30
; 0009 00F6 			}
_0x120022:
_0x120020:
; 0009 00F7 			break;
	RJMP _0x120019
; 0009 00F8 
; 0009 00F9 		case eWAIT_FOR_DATA:              // awaiting data byte
_0x12001E:
	CPI  R30,LOW(0x4)
	BREQ PC+3
	JMP _0x120023
; 0009 00FA 			sFrame_Rx.data[sFrame_Rx.data_cnt] = data;  // data byte
	__POINTW2MN _sFrame_Rx,5
	__GETB1MN _sFrame_Rx,36
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	STD  Z+0,R26
; 0009 00FB 			sFrame_Rx.data_cnt++;                       // saved data cntr increases
	__GETB1MN _sFrame_Rx,36
	SUBI R30,-LOW(1)
	__PUTB1MN _sFrame_Rx,36
	SUBI R30,LOW(1)
; 0009 00FC 			if (sFrame_Rx.data_cnt >= sFrame_Rx.datalength){ // last data
	__GETB2MN _sFrame_Rx,36
	__GETB1MN _sFrame_Rx,4
	CP   R26,R30
	BRSH PC+3
	JMP _0x120024
; 0009 00FD 				sProtocol.comm_state = eWAIT_FOR_XOR;       // switch to next (xor) state
	LDI  R30,LOW(5)
	STS  _sProtocol,R30
; 0009 00FE 			}
; 0009 00FF // 			uartSendByte(0,sFrame_Rx.data_cnt);
; 0009 0100 // 			LED_2_CHANGE;
; 0009 0101 			break;
_0x120024:
	RJMP _0x120019
; 0009 0102 
; 0009 0103 		case eWAIT_FOR_XOR: // awaiting xor
_0x120023:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x120019
; 0009 0104             sFrame_Rx.xor = data;               // xor
	LD   R30,Y
	__PUTB1MN _sFrame_Rx,35
; 0009 0105             sProtocol.comm_state = eWAIT_FOR_PROCESS; // switch to final state - awating processing
	LDI  R30,LOW(6)
	STS  _sProtocol,R30
; 0009 0106 			break;
; 0009 0107     } // switch end
_0x120019:
; 0009 0108 }
	ADIW R28,1
	RET
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
; 0009 0113 byte CommXport_ProcessCommand(void){
; 0009 0114 
; 0009 0115 	switch(sFrame_Rx.command){
; 0009 0116 
; 0009 0117         // system commands
; 0009 0118         case CMD_SYNC_END:                // Set seq to value 0, any rx frame is new
; 0009 0119             sFrame_Rx.seq = 0;
; 0009 011A             break;
; 0009 011B 
; 0009 011C         // unknown command
; 0009 011D 	    default:
; 0009 011E             return RSP_UNKNOWN_COMMAND;
; 0009 011F 		    break;
; 0009 0120 	}
; 0009 0121   return RSP_OK;
; 0009 0122 }
;
;
;
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
; 000A 000E {

	.CSEG
_SPI_MasterInit:
; 000A 000F 
; 000A 0010     /* Set MOSI and SCK output, all others input */
; 000A 0011     //DDRB = 0xB0;
; 000A 0012 
; 000A 0013     DDRB.4 = 1; //ss output
	SBI  0x4,4
; 000A 0014     DDRB.5 = 1; //mosi output
	SBI  0x4,5
; 000A 0015     DDRB.6 = 0; //miso input
	CBI  0x4,6
; 000A 0016     DDRB.7 = 1; //SCK output
	SBI  0x4,7
; 000A 0017     //printf("\nDDR_SPI: %x, %x \n", DDRB, (1<<DD_MOSI)|(1<<DD_SCK));
; 000A 0018 
; 000A 0019     /* Enable SPI, Master, set clock rate fck/16 */
; 000A 001A     SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0);
	LDI  R30,LOW(83)
	OUT  0x2C,R30
; 000A 001B 
; 000A 001C }
	RET
;
;//**********************************************************************************************
;byte SPI_MasterTransmit(byte tx_data)
; 000A 0020 {
_SPI_MasterTransmit:
; 000A 0021   //byte auxb;
; 000A 0022 
; 000A 0023   //auxb = SPDR;        // vycteni bufferu (shozeni pripadneho flagu SPIF)
; 000A 0024 
; 000A 0025   /* Start transmission */
; 000A 0026   SPDR = tx_data;
;	tx_data -> Y+0
	LD   R30,Y
	OUT  0x2E,R30
; 000A 0027 
; 000A 0028   /* Wait for transmission complete */
; 000A 0029   while(!(SPSR & (1<<SPIF)));
_0x14000B:
	IN   R30,0x2D
	ANDI R30,LOW(0x80)
	BREQ PC+3
	JMP _0x14000D
	RJMP _0x14000B
_0x14000D:
; 000A 002A 
; 000A 002B   //read
; 000A 002C   return(SPDR);
	IN   R30,0x2E
	ADIW R28,1
	RET
; 000A 002D }
;
;unsigned char SPI_MasterTransmit2(unsigned char data)
; 000A 0030 {
; 000A 0031 SPDR=data;
;	data -> Y+0
; 000A 0032 while ((SPSR & (1<<SPIF))==0);
; 000A 0033 return SPDR;
; 000A 0034 }
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
; 000B 0020 void maxq_Init(){

	.CSEG
_maxq_Init:
; 000B 0021 
; 000B 0022     SPI_MasterInit();
	CALL _SPI_MasterInit
; 000B 0023 }
	RET
;
;/*******************************************/
;// MAXQ_READ_WRITE()
;/*******************************************/
;// - read/write data from/to maxim
;// - see page 23 in MAXIM datasheet
;/*******************************************/
;signed char maxq_read_write(byte read_write, word address, char* pData, byte datalength){
; 000B 002B signed char maxq_read_write(byte read_write, word address, char* pData, byte datalength){
_maxq_read_write:
; 000B 002C     byte aux_data = 0x00;
; 000B 002D     byte aux_datalength = 0;
; 000B 002E     byte i, address1, address2;
; 000B 002F 
; 000B 0030     PORTB.3 = 0;
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
	CBI  0x5,3
; 000B 0031 
; 000B 0032     //MSB and LSB portion of address
; 000B 0033     address1 = (byte)(address>>8) & 0x0F;
	LDD  R30,Y+10
	LDI  R31,0
	ANDI R30,LOW(0xF)
	MOV  R18,R30
; 000B 0034     address2 = (byte) (address & 0xFF);
	LDD  R30,Y+9
	MOV  R21,R30
; 000B 0035 
; 000B 0036     //1.BYTE
; 000B 0037     aux_data = SPI_MasterTransmit(read_write<<7 | datalength<<4 | address1); //0x1 ->read&datalength=2, 0x1 - MSB address -> A line
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
	CALL SUBOPT_0x19
; 000B 0038     delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 000B 0039 
; 000B 003A 
; 000B 003B     if(aux_data == MAXQ_FIRST_BYTE_ACK){
	CPI  R17,193
	BREQ PC+3
	JMP _0x160005
; 000B 003C 
; 000B 003D         //2.BYTE
; 000B 003E         aux_data = SPI_MasterTransmit(address2); //LSB address
	ST   -Y,R21
	CALL _SPI_MasterTransmit
	MOV  R17,R30
; 000B 003F 
; 000B 0040         if(aux_data == MAXQ_SECOND_BYTE_ACK){
	CPI  R17,194
	BREQ PC+3
	JMP _0x160006
; 000B 0041 
; 000B 0042             if(read_write ==  eREAD){
	LDD  R30,Y+11
	CPI  R30,0
	BREQ PC+3
	JMP _0x160007
; 000B 0043 
; 000B 0044                 //maxim ready?
; 000B 0045                 for(i=0; i<30; i++){
	LDI  R19,LOW(0)
_0x160009:
	CPI  R19,30
	BRLO PC+3
	JMP _0x16000A
; 000B 0046                     delay_us(MAXQ_DELAY_2);
	__DELAY_USW 276
; 000B 0047                     aux_data = SPI_MasterTransmit(0x00); //
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
; 000B 0048                     if(aux_data == 0x41)
	CPI  R17,65
	BREQ PC+3
	JMP _0x16000B
; 000B 0049                         break;
	RJMP _0x16000A
; 000B 004A                     //printf("\nE: Maxim is not ready, once again..");
; 000B 004B                 }
_0x16000B:
_0x160008:
	SUBI R19,-1
	RJMP _0x160009
_0x16000A:
; 000B 004C             }
; 000B 004D             else
	RJMP _0x16000C
_0x160007:
; 000B 004E                 aux_data = 0x41;
	LDI  R17,LOW(65)
; 000B 004F 
; 000B 0050             // READ / WRITE DATA
; 000B 0051             if(aux_data == 0x41){
_0x16000C:
	CPI  R17,65
	BREQ PC+3
	JMP _0x16000D
; 000B 0052 
; 000B 0053                 for(i=0; i<(1<<datalength); i++){
	LDI  R19,LOW(0)
_0x16000F:
	LDD  R30,Y+6
	LDI  R26,LOW(1)
	CALL __LSLB12
	CP   R19,R30
	BRLO PC+3
	JMP _0x160010
; 000B 0054 
; 000B 0055                     delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 000B 0056 
; 000B 0057                     //read
; 000B 0058                     if(read_write ==  eREAD){
	LDD  R30,Y+11
	CPI  R30,0
	BREQ PC+3
	JMP _0x160011
; 000B 0059                         aux_data = SPI_MasterTransmit(0x00); //
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
; 000B 005A                         *(byte *)(pData+aux_datalength) = aux_data;
	MOV  R30,R16
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 000B 005B                         aux_datalength++;
	SUBI R16,-1
; 000B 005C                         //printf("\nI: read succesfull: 0x%x", aux_data);
; 000B 005D                     }
; 000B 005E 
; 000B 005F                     //write
; 000B 0060                     else if(read_write == eWRITE){
	RJMP _0x160012
_0x160011:
	LDD  R26,Y+11
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x160013
; 000B 0061                         byte aux_answer;
; 000B 0062                         aux_data = *(byte *)(pData+aux_datalength);
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
; 000B 0063                         aux_answer = SPI_MasterTransmit(aux_data); //
	ST   -Y,R17
	CALL _SPI_MasterTransmit
	ST   Y,R30
; 000B 0064                         aux_datalength++;
	SUBI R16,-1
; 000B 0065                         if(aux_answer != 0x41)
	LD   R26,Y
	CPI  R26,LOW(0x41)
	BRNE PC+3
	JMP _0x160014
; 000B 0066                             printf("\nE: write wasnt succesfull");
	__POINTW1FN _0x160000,0
	CALL SUBOPT_0x17
; 000B 0067                         //else
; 000B 0068                             //printf("\nI: write succesfull: 0x%x", aux_data);
; 000B 0069 
; 000B 006A 
; 000B 006B                     }
_0x160014:
	ADIW R28,1
; 000B 006C                     else
	RJMP _0x160015
_0x160013:
; 000B 006D                         printf("\nE: wrong operation (read/write)");
	__POINTW1FN _0x160000,27
	CALL SUBOPT_0x17
; 000B 006E 
; 000B 006F                 }
_0x160015:
_0x160012:
_0x16000E:
	SUBI R19,-1
	RJMP _0x16000F
_0x160010:
; 000B 0070 
; 000B 0071                 // check write operation
; 000B 0072                 if(read_write == eWRITE){
	LDD  R26,Y+11
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x160016
; 000B 0073                     for(i=0; i<30; i++){
	LDI  R19,LOW(0)
_0x160018:
	CPI  R19,30
	BRLO PC+3
	JMP _0x160019
; 000B 0074                         delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 000B 0075                         aux_data = SPI_MasterTransmit(0x00);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
; 000B 0076                         if(aux_data != 0x4E){
	CPI  R17,78
	BRNE PC+3
	JMP _0x16001A
; 000B 0077                             printf("\nE:good, next step 0x%x", aux_data);
	__POINTW1FN _0x160000,60
	CALL SUBOPT_0x13
; 000B 0078                             break;
	RJMP _0x160019
; 000B 0079                         }
; 000B 007A                         else
	RJMP _0x16001B
_0x16001A:
; 000B 007B                             printf("\nE:wrong, once again");
	__POINTW1FN _0x160000,84
	CALL SUBOPT_0x17
; 000B 007C                     }
_0x16001B:
_0x160017:
	SUBI R19,-1
	RJMP _0x160018
_0x160019:
; 000B 007D                     if(aux_data != 0x41)
	CPI  R17,65
	BRNE PC+3
	JMP _0x16001C
; 000B 007E                         printf("\nE: write failed!");
	__POINTW1FN _0x160000,105
	CALL SUBOPT_0x17
; 000B 007F                     //else
; 000B 0080                         //printf("\nWRITE COPLETE!!\n\n");
; 000B 0081                  }
_0x16001C:
; 000B 0082 
; 000B 0083             }
_0x160016:
; 000B 0084             else
	RJMP _0x16001D
_0x16000D:
; 000B 0085                 printf("\nE: SYNC(3.byte) : %x", aux_data);
	__POINTW1FN _0x160000,123
	CALL SUBOPT_0x13
; 000B 0086                 //uartSendBufferf(0,"\nE: SYNC (3.byte)");
; 000B 0087         }
_0x16001D:
; 000B 0088          else
	RJMP _0x16001E
_0x160006:
; 000B 0089             uartSendBufferf(0,"\nE: ADDRESS (2.byte)");
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW1FN _0x160000,145
	CALL SUBOPT_0x2
; 000B 008A     }
_0x16001E:
; 000B 008B     //else{
; 000B 008C         //printf("\nE: CMD 1.B: %x", aux_data);
; 000B 008D     //}
; 000B 008E 
; 000B 008F 
; 000B 0090     PORTB.3 = 1;
_0x160005:
	SBI  0x5,3
; 000B 0091     delay_us(MAXQ_DELAY);
	__DELAY_USB 184
; 000B 0092     return aux_datalength;
	MOV  R30,R16
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; 000B 0093 
; 000B 0094 }
;
;signed char maxq_read(word address, char* pData, byte datalength){
; 000B 0096 signed char maxq_read(word address, char* pData, byte datalength){
_maxq_read:
; 000B 0097     return maxq_read_write(eREAD, address, pData, datalength);
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
	CALL _maxq_read_write
	ADIW R28,5
	RET
; 000B 0098 }
;signed char maxq_read_enum(eCOMMNADS_INDEX cmd_index, char* pData){
; 000B 0099 signed char maxq_read_enum(eCOMMNADS_INDEX cmd_index, char* pData){
; 000B 009A     return maxq_read_write(eREAD, COMMAND_DEF[cmd_index].address, pData, COMMAND_DEF[cmd_index].size);
;	cmd_index -> Y+2
;	*pData -> Y+0
; 000B 009B }
;
;signed char maxq_write(word address, char* pData, byte datalength){
; 000B 009D signed char maxq_write(word address, char* pData, byte datalength){
; 000B 009E     return maxq_read_write(eWRITE, address, pData, datalength);
;	address -> Y+3
;	*pData -> Y+1
;	datalength -> Y+0
; 000B 009F }
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
;signed int buffer2signed(byte *pBuffer, byte length);
;
;tMESSMODUL  sMm[1];
;
;
;//flash tMESSMODUL_REQUEST_DEF MESSMODUL_REQUEST_DEF[3] = {
;//    {&sMm.flags.voltage[0], 0, 6, (byte *)&sMm.values.voltages[0]}, //voltages
;//    {&sMm.flags.voltage[0], 0, 6, (byte *)&sMm.values.voltages[0]}, //voltages
;//    {&sMm.flags.voltage[0], 0, 6, (byte *)&sMm.values.voltages[0]} //voltages
;//};
;
;void Messmodul_Init(){
; 000C 001F void Messmodul_Init(){

	.CSEG
_Messmodul_Init:
; 000C 0020 
; 000C 0021     //tMESSMODUL *pMessmodul = &sMm[0];
; 000C 0022 
; 000C 0023 
; 000C 0024     maxq_Init();
	CALL _maxq_Init
; 000C 0025     //memset(&pMessmodul->flags, 0, sizeof(pMessmodul->flags));
; 000C 0026 
; 000C 0027     //PORTB=0x00;
; 000C 0028     //DDRB=0xB0;
; 000C 0029 
; 000C 002A     //CS AS OUTPUT
; 000C 002B     DDRB.3 = 1;
	SBI  0x4,3
; 000C 002C     PORTB.3 = 1;
	SBI  0x5,3
; 000C 002D }
	RET
;
;/*******************************************/
;// MESSMODUL_SPI()
;/*******************************************/
;// receive reqeusted values from Messmodule
;// convert ADC values to electrical quantity
;/*******************************************/
;void Messmodul_spi(byte nr_messmodul){
; 000C 0035 void Messmodul_spi(byte nr_messmodul){
_Messmodul_spi:
; 000C 0036     byte i;
; 000C 0037     //byte buffer[10];
; 000C 0038 
; 000C 0039     tMESSMODUL *pMessmodul = &sMm[nr_messmodul];
; 000C 003A     tMAXQ_REGISTERS sMaxq_registers;
; 000C 003B     tMAXQ_REGISTERS *pMaxq_registers = &sMaxq_registers;
; 000C 003C 
; 000C 003D 
; 000C 003E     /*******************************************/
; 000C 003F     // GET VALUES FROM MAXIM
; 000C 0040     /*******************************************/
; 000C 0041 
; 000C 0042     //1F values
; 000C 0043     maxq_read( AFE_LINEFR,      (byte *)&pMaxq_registers->linefr,  eTWO_BYTES);
	SBIW R28,28
	SUBI R29,1
	CALL __SAVELOCR6
;	nr_messmodul -> Y+290
;	i -> R17
;	*pMessmodul -> R18,R19
;	sMaxq_registers -> Y+6
;	*pMaxq_registers -> R20,R21
	__GETB1SX 290
	LDI  R26,LOW(101)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sMm)
	SBCI R31,HIGH(-_sMm)
	MOVW R18,R30
	MOVW R30,R28
	ADIW R30,6
	MOVW R20,R30
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,8
	CALL SUBOPT_0x1A
; 000C 0044     maxq_read( AFE_RAWTEMP,     (byte *)&(pMaxq_registers->rawtemp), eTWO_BYTES);
	LDI  R30,LOW(3073)
	LDI  R31,HIGH(3073)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,10
	CALL SUBOPT_0x1A
; 000C 0045 
; 000C 0046     //CONVERION CONSTANT
; 000C 0047     //maxq_read( AFE_VOLT_CC,     (byte *)&pMessmodul->values.volt_cc,    eTWO_BYTES);
; 000C 0048     //maxq_read( AFE_AMP_CC,      (byte *)&pMessmodul->values.amp_cc,     eTWO_BYTES);
; 000C 0049     //maxq_read( AFE_PWR_CC,      (byte *)&pMessmodul->values.pwr_cc,     eTWO_BYTES);
; 000C 004A     //maxq_read( AFE_ENR_CC,      (byte *)&pMessmodul->values.enr_cc,     eTWO_BYTES);
; 000C 004B 
; 000C 004C     //VOLTAGE
; 000C 004D     //vrms
; 000C 004E     maxq_read( AFE_A_VRMS,      (byte *)&pMaxq_registers->vrms[0],    eFOUR_BYTES);
	LDI  R30,LOW(456)
	LDI  R31,HIGH(456)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,12
	CALL SUBOPT_0x1B
; 000C 004F     maxq_read( AFE_B_VRMS,      (byte *)&pMaxq_registers->vrms[1],    eFOUR_BYTES);
	LDI  R30,LOW(692)
	LDI  R31,HIGH(692)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,16
	CALL SUBOPT_0x1B
; 000C 0050     maxq_read( AFE_C_VRMS,      (byte *)&pMaxq_registers->vrms[2],    eFOUR_BYTES);
	LDI  R30,LOW(928)
	LDI  R31,HIGH(928)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,20
	CALL SUBOPT_0x1B
; 000C 0051     //V.X
; 000C 0052     maxq_read( AFE_V_A, pMaxq_registers->v_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2097)
	LDI  R31,HIGH(2097)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x1C
; 000C 0053     maxq_read( AFE_V_B, pMaxq_registers->v_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2098)
	LDI  R31,HIGH(2098)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x1C
; 000C 0054     maxq_read( AFE_V_C, pMaxq_registers->v_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2100)
	LDI  R31,HIGH(2100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-108)
	SBCI R31,HIGH(-108)
	CALL SUBOPT_0x1C
; 000C 0055     //memset(pMaxq_registers->v_x[3], 0, 8); //nulove
; 000C 0056 
; 000C 0057 
; 000C 0058     //CURRENT
; 000C 0059     //irms
; 000C 005A     maxq_read( AFE_A_IRMS,      (byte *)&pMaxq_registers->irms[0],    eFOUR_BYTES);
	LDI  R30,LOW(460)
	LDI  R31,HIGH(460)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,24
	CALL SUBOPT_0x1B
; 000C 005B     maxq_read( AFE_B_IRMS,      (byte *)&pMaxq_registers->irms[1],    eFOUR_BYTES);
	LDI  R30,LOW(696)
	LDI  R31,HIGH(696)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,28
	CALL SUBOPT_0x1B
; 000C 005C     maxq_read( AFE_C_IRMS,      (byte *)&pMaxq_registers->irms[2],    eFOUR_BYTES);
	LDI  R30,LOW(932)
	LDI  R31,HIGH(932)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,32
	CALL SUBOPT_0x1B
; 000C 005D     //I.X
; 000C 005E     maxq_read( AFE_I_A, pMaxq_registers->i_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2113)
	LDI  R31,HIGH(2113)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-124)
	SBCI R31,HIGH(-124)
	CALL SUBOPT_0x1C
; 000C 005F     maxq_read( AFE_I_B, pMaxq_registers->i_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2114)
	LDI  R31,HIGH(2114)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-132)
	SBCI R31,HIGH(-132)
	CALL SUBOPT_0x1C
; 000C 0060     maxq_read( AFE_I_C, pMaxq_registers->i_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2116)
	LDI  R31,HIGH(2116)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-140)
	SBCI R31,HIGH(-140)
	CALL SUBOPT_0x1C
; 000C 0061     //maxq_read( AFE_I_N, pMaxq_registers->i_x[3], eEIGHT_BYTES);
; 000C 0062 
; 000C 0063     //POWER FACTOR
; 000C 0064     maxq_read( AFE_A_PF,        (byte *)&pMaxq_registers->pf[0],      eTWO_BYTES);
	LDI  R30,LOW(454)
	LDI  R31,HIGH(454)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,36
	CALL SUBOPT_0x1A
; 000C 0065     maxq_read( AFE_B_PF,        (byte *)&pMaxq_registers->pf[1],      eTWO_BYTES);
	LDI  R30,LOW(690)
	LDI  R31,HIGH(690)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,38
	CALL SUBOPT_0x1A
; 000C 0066     maxq_read( AFE_C_PF,        (byte *)&pMaxq_registers->pf[2],      eTWO_BYTES);
	LDI  R30,LOW(926)
	LDI  R31,HIGH(926)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,40
	CALL SUBOPT_0x1A
; 000C 0067     //pMaxq_registers->pf[3] = 0; //nulove
; 000C 0068 
; 000C 0069     //POWER
; 000C 006A     //active power
; 000C 006B     maxq_read( AFE_A_ACT,     (byte *)&pMaxq_registers->act[0],   eFOUR_BYTES);
	LDI  R30,LOW(464)
	LDI  R31,HIGH(464)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,44
	CALL SUBOPT_0x1B
; 000C 006C     maxq_read( AFE_B_ACT,     (byte *)&pMaxq_registers->act[1],   eFOUR_BYTES);
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,48
	CALL SUBOPT_0x1B
; 000C 006D     maxq_read( AFE_C_ACT,     (byte *)&pMaxq_registers->act[2],   eFOUR_BYTES);
	LDI  R30,LOW(936)
	LDI  R31,HIGH(936)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,52
	CALL SUBOPT_0x1B
; 000C 006E     //apparent power
; 000C 006F     maxq_read( AFE_A_APP,     (byte *)&pMaxq_registers->app[0],   eFOUR_BYTES);
	LDI  R30,LOW(472)
	LDI  R31,HIGH(472)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,56
	CALL SUBOPT_0x1B
; 000C 0070     maxq_read( AFE_B_APP,     (byte *)&pMaxq_registers->app[1],   eFOUR_BYTES);
	LDI  R30,LOW(708)
	LDI  R31,HIGH(708)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	ADIW R30,60
	CALL SUBOPT_0x1B
; 000C 0071     maxq_read( AFE_C_APP,     (byte *)&pMaxq_registers->app[2],   eFOUR_BYTES);
	LDI  R30,LOW(944)
	LDI  R31,HIGH(944)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-64)
	SBCI R31,HIGH(-64)
	CALL SUBOPT_0x1B
; 000C 0072     //real power
; 000C 0073     maxq_read( AFE_PWRP_A, pMaxq_registers->pwrp_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2049)
	LDI  R31,HIGH(2049)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-156)
	SBCI R31,HIGH(-156)
	CALL SUBOPT_0x1C
; 000C 0074     maxq_read( AFE_PWRP_B, pMaxq_registers->pwrp_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2050)
	LDI  R31,HIGH(2050)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-164)
	SBCI R31,HIGH(-164)
	CALL SUBOPT_0x1C
; 000C 0075     maxq_read( AFE_PWRP_C, pMaxq_registers->pwrp_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2052)
	LDI  R31,HIGH(2052)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-172)
	SBCI R31,HIGH(-172)
	CALL SUBOPT_0x1C
; 000C 0076     //maxq_read( AFE_PWRP_T, pMaxq_registers->pwrp_x[3], eEIGHT_BYTES);
; 000C 0077     //apparent power
; 000C 0078     maxq_read( AFE_PWRS_A, pMaxq_registers->pwrs_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2081)
	LDI  R31,HIGH(2081)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-188)
	SBCI R31,HIGH(-188)
	CALL SUBOPT_0x1C
; 000C 0079     maxq_read( AFE_PWRS_B, pMaxq_registers->pwrs_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2082)
	LDI  R31,HIGH(2082)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-196)
	SBCI R31,HIGH(-196)
	CALL SUBOPT_0x1C
; 000C 007A     maxq_read( AFE_PWRS_C, pMaxq_registers->pwrs_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2084)
	LDI  R31,HIGH(2084)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-204)
	SBCI R31,HIGH(-204)
	CALL SUBOPT_0x1C
; 000C 007B     //maxq_read( AFE_PWRS_T, pMaxq_registers->pwrs_x[3], eEIGHT_BYTES);
; 000C 007C 
; 000C 007D     //ENERGY
; 000C 007E     //real positive energy
; 000C 007F     maxq_read( AFE_A_EAPOS,     (byte *)&pMaxq_registers->eapos[0],   eFOUR_BYTES);
	LDI  R30,LOW(488)
	LDI  R31,HIGH(488)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-68)
	SBCI R31,HIGH(-68)
	CALL SUBOPT_0x1B
; 000C 0080     maxq_read( AFE_B_EAPOS,     (byte *)&pMaxq_registers->eapos[1],   eFOUR_BYTES);
	LDI  R30,LOW(724)
	LDI  R31,HIGH(724)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-72)
	SBCI R31,HIGH(-72)
	CALL SUBOPT_0x1B
; 000C 0081     maxq_read( AFE_C_EAPOS,     (byte *)&pMaxq_registers->eapos[2],   eFOUR_BYTES);
	LDI  R30,LOW(960)
	LDI  R31,HIGH(960)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-76)
	SBCI R31,HIGH(-76)
	CALL SUBOPT_0x1B
; 000C 0082     //real negative energy
; 000C 0083     maxq_read( AFE_A_EANEG,     (byte *)&pMaxq_registers->eaneg[0], eFOUR_BYTES);
	LDI  R30,LOW(492)
	LDI  R31,HIGH(492)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-80)
	SBCI R31,HIGH(-80)
	CALL SUBOPT_0x1B
; 000C 0084     maxq_read( AFE_B_EANEG,     (byte *)&pMaxq_registers->eaneg[1], eFOUR_BYTES);
	LDI  R30,LOW(728)
	LDI  R31,HIGH(728)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x1B
; 000C 0085     maxq_read( AFE_C_EANEG,     (byte *)&pMaxq_registers->eaneg[2], eFOUR_BYTES);
	LDI  R30,LOW(964)
	LDI  R31,HIGH(964)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-88)
	SBCI R31,HIGH(-88)
	CALL SUBOPT_0x1B
; 000C 0086     //activ energy
; 000C 0087     maxq_read( AFE_ENRP_A,     (byte *)&pMaxq_registers->enrp_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2161)
	LDI  R31,HIGH(2161)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-220)
	SBCI R31,HIGH(-220)
	CALL SUBOPT_0x1C
; 000C 0088     maxq_read( AFE_ENRP_B,     (byte *)&pMaxq_registers->enrp_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2162)
	LDI  R31,HIGH(2162)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-228)
	SBCI R31,HIGH(-228)
	CALL SUBOPT_0x1C
; 000C 0089     maxq_read( AFE_ENRP_C,     (byte *)&pMaxq_registers->enrp_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2164)
	LDI  R31,HIGH(2164)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-236)
	SBCI R31,HIGH(-236)
	CALL SUBOPT_0x1C
; 000C 008A     //maxq_read( AFE_ENRP_T,     (byte *)&pMaxq_registers->enrp_x[3], eEIGHT_BYTES);
; 000C 008B     //apparent energy
; 000C 008C     maxq_read( AFE_ENRS_A,     (byte *)&pMaxq_registers->enrs_x[0], eEIGHT_BYTES);
	LDI  R30,LOW(2161)
	LDI  R31,HIGH(2161)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-252)
	SBCI R31,HIGH(-252)
	CALL SUBOPT_0x1C
; 000C 008D     maxq_read( AFE_ENRS_B,     (byte *)&pMaxq_registers->enrs_x[1], eEIGHT_BYTES);
	LDI  R30,LOW(2162)
	LDI  R31,HIGH(2162)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-260)
	SBCI R31,HIGH(-260)
	CALL SUBOPT_0x1C
; 000C 008E     maxq_read( AFE_ENRS_C,     (byte *)&pMaxq_registers->enrs_x[2], eEIGHT_BYTES);
	LDI  R30,LOW(2164)
	LDI  R31,HIGH(2164)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SUBI R30,LOW(-268)
	SBCI R31,HIGH(-268)
	CALL SUBOPT_0x1C
; 000C 008F     //maxq_read( AFE_ENRS_T,     (byte *)&pMaxq_registers->enrs_x[3], eEIGHT_BYTES);
; 000C 0090 
; 000C 0091 
; 000C 0092     /*******************************************/
; 000C 0093     // CONVERT & RESTRICT & STORE THE VALUES
; 000C 0094     /*******************************************/
; 000C 0095     pMessmodul->values.frequence =  pMaxq_registers->linefr;
	MOVW R26,R20
	ADIW R26,8
	CALL __GETW1P
	__PUTW1RNS 18,2
; 000C 0096     pMessmodul->values.temperature =  pMaxq_registers->rawtemp / 76;
	MOVW R30,R20
	LDD  R26,Z+10
	LDD  R27,Z+11
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL __DIVW21U
	MOVW R26,R18
	ST   X+,R30
	ST   X,R31
; 000C 0097 
; 000C 0098     for(i=0; i<4; i++){
	LDI  R17,LOW(0)
_0x180008:
	CPI  R17,4
	BRLO PC+3
	JMP _0x180009
; 000C 0099         dword unsigned_value;
; 000C 009A         signed long signed_value;
; 000C 009B 
; 000C 009C         //******************************************
; 000C 009D         // CONVERT
; 000C 009E         //*******************************************
; 000C 009F 
; 000C 00A0         //VOLTAGE
; 000C 00A1         unsigned_value = (*(dword *)pMaxq_registers->v_x[i]) >> 8;
	SBIW R28,8
;	nr_messmodul -> Y+298
;	sMaxq_registers -> Y+14
;	unsigned_value -> Y+4
;	signed_value -> Y+0
	MOVW R26,R20
	SUBI R26,LOW(-92)
	SBCI R27,HIGH(-92)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1D
; 000C 00A2         pMessmodul->values.voltage[i] = (unsigned_value * VOLTAGE_CONVERSION) / 100000;
	ADIW R26,4
	CALL SUBOPT_0x18
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0x1EAC
	CALL __MULD12U
	CALL SUBOPT_0x1E
	CALL __DIVD21U
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 000C 00A3 
; 000C 00A4         //CURRENT
; 000C 00A5         unsigned_value = (*(dword *)pMaxq_registers->i_x[i]) >> 8;
	MOVW R26,R20
	SUBI R26,LOW(-124)
	SBCI R27,HIGH(-124)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1D
; 000C 00A6         pMessmodul->values.current[i] =  (unsigned_value * CURRENT_CONVERSION) / 10000;
	ADIW R26,12
	CALL SUBOPT_0x18
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETD1S 4
	__GETD2N 0x319
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x2710
	CALL __DIVD21U
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 000C 00A7 
; 000C 00A8         //POWER
; 000C 00A9         //activ power
; 000C 00AA         signed_value = buffer2signed(pMaxq_registers->pwrp_x[i], 8);
	MOVW R26,R20
	SUBI R26,LOW(-156)
	SBCI R27,HIGH(-156)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
; 000C 00AB         pMessmodul->values.power_act[i] = (signed_value * POWER_ACT_CONVERSION) / 100000;
	ADIW R26,20
	CALL SUBOPT_0x18
	CALL SUBOPT_0x20
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL __DIVD21
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000C 00AC 
; 000C 00AD         //apparent power
; 000C 00AE         //signed_value = buffer2signed(pMessmodul->values.pwrs_x[i], 8)
; 000C 00AF         //pMessmodul->values.energy[i]  = (signed_value * POWER_APP_CONVERSION) / 100000;
; 000C 00B0 
; 000C 00B1         //POWER FACTOR
; 000C 00B2         pMessmodul->values.power_factor[i] = pMaxq_registers->pf[i];
	MOVW R26,R18
	SUBI R26,LOW(-84)
	SBCI R27,HIGH(-84)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x20
	MOVW R0,R30
	MOVW R26,R20
	ADIW R26,36
	CALL SUBOPT_0x18
	CALL SUBOPT_0x22
	MOVW R26,R0
	CALL __CWD1
	CALL __PUTDP1
; 000C 00B3 
; 000C 00B4         //ENERGY
; 000C 00B5         //activ energy
; 000C 00B6         signed_value = buffer2signed(pMaxq_registers->enrp_x[i], 8);
	MOVW R26,R20
	SUBI R26,LOW(-220)
	SBCI R27,HIGH(-220)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
; 000C 00B7         pMessmodul->values.energy_act[i]  = (signed_value * ENERGY_ACT_CONVERSION) / 100000;
	ADIW R26,52
	CALL SUBOPT_0x18
	CALL SUBOPT_0x20
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL __DIVD21
	POP  R26
	POP  R27
	CALL __PUTDP1
; 000C 00B8 
; 000C 00B9         //apparent energy
; 000C 00BA         //signed_value = buffer2signed(pMessmodul->values.enrs_x[i], 8)
; 000C 00BB         //pMessmodul->values.energy_app[i]  = (signed_value * ENERGY_APP_CONVERSION) / 100000;
; 000C 00BC 
; 000C 00BD         //******************************************
; 000C 00BE         // RESTRICTIONS
; 000C 00BF         //*******************************************
; 000C 00C0 
; 000C 00C1         //VOLTAGE
; 000C 00C2         if(pMessmodul->values.voltage[i] < VOLTAGE_MIN)
	CALL SUBOPT_0x23
	CALL SUBOPT_0x22
	SBIW R30,20
	BRLO PC+3
	JMP _0x18000A
; 000C 00C3             pMessmodul->values.voltage[i] = 0;
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 000C 00C4 
; 000C 00C5         //CURRENT
; 000C 00C6         if(pMessmodul->values.current[i] < CURRENT_MIN)
_0x18000A:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x22
	SBIW R30,5
	BRLO PC+3
	JMP _0x18000B
; 000C 00C7             pMessmodul->values.current[i] = 0;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x24
; 000C 00C8 
; 000C 00C9         //POWER
; 000C 00CA         if(pMessmodul->values.power_act[i] < POWER_ACT_MIN)
_0x18000B:
	MOVW R26,R18
	ADIW R26,20
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	BRLT PC+3
	JMP _0x18000C
; 000C 00CB             pMessmodul->values.power_act[i] = 0;
	MOVW R26,R18
	ADIW R26,20
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
; 000C 00CC         if(pMessmodul->values.power_app[i] < POWER_APP_MIN)
_0x18000C:
	MOVW R26,R18
	ADIW R26,36
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	BRLT PC+3
	JMP _0x18000D
; 000C 00CD             pMessmodul->values.power_app[i] = 0;
	MOVW R26,R18
	ADIW R26,36
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
; 000C 00CE 
; 000C 00CF         //ENERGY
; 000C 00D0         if(pMessmodul->values.energy_act[i] < ENERGY_ACT_MIN)
_0x18000D:
	MOVW R26,R18
	ADIW R26,52
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	BRLT PC+3
	JMP _0x18000E
; 000C 00D1             pMessmodul->values.energy_act[i] = 0;
	MOVW R26,R18
	ADIW R26,52
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
; 000C 00D2         if(pMessmodul->values.energy_app[i] < ENERGY_APP_MIN)
_0x18000E:
	MOVW R26,R18
	SUBI R26,LOW(-68)
	SBCI R27,HIGH(-68)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	BRLT PC+3
	JMP _0x18000F
; 000C 00D3             pMessmodul->values.energy_app[i] = 0;
	MOVW R26,R18
	SUBI R26,LOW(-68)
	SBCI R27,HIGH(-68)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
; 000C 00D4     }
_0x18000F:
	ADIW R28,8
_0x180007:
	SUBI R17,-1
	RJMP _0x180008
_0x180009:
; 000C 00D5 
; 000C 00D6     sMm[0].rest_flag = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _sMm,100
; 000C 00D7 }
	CALL __LOADLOCR6
	ADIW R28,35
	SUBI R29,-1
	RET
;
;/*******************************************/
;// MESSMODUL_MANAGER()
;/*******************************************/
;// process function
;/*******************************************/
;void Messmodul_Manager(){
; 000C 00DE void Messmodul_Manager(){
_Messmodul_Manager:
; 000C 00DF 
; 000C 00E0     //printf("\nMM start");
; 000C 00E1     PORTB.3 = 0;
	CBI  0x5,3
; 000C 00E2     Messmodul_spi(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _Messmodul_spi
; 000C 00E3     PORTB.3 = 1;
	SBI  0x5,3
; 000C 00E4 
; 000C 00E5     //printf("\nMM end");
; 000C 00E6 }
	RET
;
;
;/*******************************************/
;// MESSMODUL_REST()
;/*******************************************/
;// "while fuction", print debug messages
;/*******************************************/
;void Messmodul_Rest(){
; 000C 00EE void Messmodul_Rest(){
_Messmodul_Rest:
; 000C 00EF 
; 000C 00F0     if(sMm[0].rest_flag){
	__GETB1MN _sMm,100
	CPI  R30,0
	BRNE PC+3
	JMP _0x180014
; 000C 00F1         tMESSMODUL *pMessmodul = &sMm[0];
; 000C 00F2         //print values
; 000C 00F3         printf("\n============");
	SBIW R28,2
	LDI  R30,LOW(_sMm)
	LDI  R31,HIGH(_sMm)
	ST   Y,R30
	STD  Y+1,R31
;	*pMessmodul -> Y+0
	__POINTW1FN _0x180000,0
	CALL SUBOPT_0x17
; 000C 00F4         printf("\nfrequence: %u.%u Hz", pMessmodul->values.frequence/1000, pMessmodul->values.frequence%1000);
	__POINTW1FN _0x180000,14
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2B
	CALL _printf
	ADIW R28,10
; 000C 00F5         printf("\ntemperature: %d.%d�C", pMessmodul->values.temperature / 10, abs(pMessmodul->values.temperature % 10));
	__POINTW1FN _0x180000,35
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2A
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x2D
	CALL __MODW21U
	CALL SUBOPT_0x2E
	CALL _printf
	ADIW R28,10
; 000C 00F6         //printf("\nCC: volt:%d, amp:%d", pMessmodul->values.volt_cc, pMessmodul->values.amp_cc);
; 000C 00F7         //printf("\nPF: %d, %d, %d", pMessmodul->values.pf[0], pMessmodul->values.pf[1], pMessmodul->values.pf[2]);
; 000C 00F8         //printf("\nPF: %ld, %ld, %ld", pMessmodul->values.pf[0], pMessmodul->values.pf[1], pMessmodul->values.pf[2]);
; 000C 00F9         //printf("\nVRMS: 0x%lx, 0x%lx, 0x%lx", pMessmodul->values.vrms[0], pMessmodul->values.vrms[1], pMessmodul->values.vrms[2]);
; 000C 00FA         //printf("\nIRMS: 0x%lx, 0x%lx, 0x%lx", pMessmodul->values.irms[0], pMessmodul->values.irms[1], pMessmodul->values.irms[2]);
; 000C 00FB         //printf("\nACT: %ld, %ld, %ld", pMessmodul->values.act[0], pMessmodul->values.act[1], pMessmodul->values.act[2]);
; 000C 00FC         //printf("\nACT: %x, %x, %x", pMessmodul->values.act[0], pMessmodul->values.act[1], pMessmodul->values.act[2]);
; 000C 00FD         //printf("\nACT: %lx, %lx, %lx", pMessmodul->values.act[0], pMessmodul->values.act[1], pMessmodul->values.act[2]);
; 000C 00FE         //printf("\nACT: %ld, %ld, %ld", pMessmodul->values.act[0], pMessmodul->values.act[1], pMessmodul->values.act[2]);
; 000C 00FF         //printf("\nEAPOS: %lx, %lx, %lx", pMessmodul->values.eapos[0], pMessmodul->values.eapos[1], pMessmodul->values.eapos[2]);
; 000C 0100         //printf("\nEANEG: %lx, %lx, %lx", pMessmodul->values.eaneg[0], pMessmodul->values.eaneg[1], pMessmodul->values.eaneg[2]);
; 000C 0101         //printf("\nvoltage: %u, %u, %u", pMessmodul->values.voltage[0], pMessmodul->values.voltage[1], pMessmodul->values.voltage[2]);
; 000C 0102         //printf("\npwrp: 0x%ld, 0x%ld | 0x%ld,  0x%ld | 0x%ld,  0x%ld",  *(dword *)pMessmodul->values.pwrp_x[0], *((dword *)pMessmodul->values.pwrp_x[0]+1), *(dword *)pMessmodul->values.pwrp_x[1], *((dword *)pMessmodul->values.pwrp_x[1]+1), *(dword *)pMessmodul->values.pwrp_x[2], *((dword *)pMessmodul->values.pwrp_x[2]+1));
; 000C 0103         //printf("\nvrms: %ld | %ld | %ld",  pMessmodul->values.vrms[0],  pMessmodul->values.vrms[1], pMessmodul->values.vrms[2]);
; 000C 0104         //printf("\nirms: %ld | %ld | %ld",  pMessmodul->values.irms[0],  pMessmodul->values.irms[1], pMessmodul->values.irms[2]);
; 000C 0105         printf("\nvoltage: %ld | %ld | %ld",  pMessmodul->values.voltage[0], pMessmodul->values.voltage[1], pMessmodul->values.voltage[2]);
	__POINTW1FN _0x180000,57
	CALL SUBOPT_0x2C
	ADIW R26,4
	CALL SUBOPT_0x2F
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,6
	CALL SUBOPT_0x2F
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADIW R26,8
	CALL SUBOPT_0x2F
	LDI  R24,12
	CALL _printf
	ADIW R28,14
; 000C 0106         //printf("\nvrms: %ld",  pMessmodul->values.vrms[0]);
; 000C 0107         //printf("\nv_x: %ld | %ld",  *(dword *)&(pMessmodul->values.v_x[0][0]), *(dword *)&(pMessmodul->values.v_x[0][4]));
; 000C 0108         //printf("\nv_x: %x,%x,%x,%x,%x,%x,%x,%x", pMessmodul->values.v_x[0][0], pMessmodul->values.v_x[0][1], pMessmodul->values.v_x[0][2], pMessmodul->values.v_x[0][3], pMessmodul->values.v_x[0][4], pMessmodul->values.v_x[0][5], pMessmodul->values.v_x[0][6], pMessmodul->values.v_x[0][7]);
; 000C 0109         //printf("\nv_x: %ld", buffer2signed(pMessmodul->values.v_x[0],8));
; 000C 010A 
; 000C 010B         printf("\ncurrent: %ld | %ld | %ld",  pMessmodul->values.current[0], pMessmodul->values.current[1], pMessmodul->values.current[2]);
	__POINTW1FN _0x180000,83
	CALL SUBOPT_0x2C
	ADIW R26,12
	CALL SUBOPT_0x2F
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,14
	CALL SUBOPT_0x2F
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADIW R26,16
	CALL SUBOPT_0x2F
	LDI  R24,12
	CALL _printf
	ADIW R28,14
; 000C 010C         //printf("\ncurrent A: 0x%ld, 0x%ld | 0x%ld,  0x%lx | 0x%lx,  0x%lx", *(dword *)pMessmodul->values.current[0], *((dword *)pMessmodul->values.current[0]+1),*(dword *)pMessmodul->values.current[1], *((dword *)pMessmodul->values.current[1]+1),*(dword *)pMessmodul->values.current[2], *((dword *)pMessmodul->values.current[2]+1));
; 000C 010D         sMm[0].rest_flag = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _sMm,100
; 000C 010E     }
	ADIW R28,2
; 000C 010F }
_0x180014:
	RET
;
;byte Messmodul_getCountVoltage(){
; 000C 0111 byte Messmodul_getCountVoltage(){
_Messmodul_getCountVoltage:
; 000C 0112     byte i,aux_count = 0;
; 000C 0113     tMESSMODUL *pMessmodul = &sMm[0];
; 000C 0114 
; 000C 0115     for(i=0; i<3; i++)
	CALL SUBOPT_0x30
;	i -> R17
;	aux_count -> R16
;	*pMessmodul -> R18,R19
_0x180016:
	CPI  R17,3
	BRLO PC+3
	JMP _0x180017
; 000C 0116         if(pMessmodul->values.voltage[i])
	CALL SUBOPT_0x23
	CALL SUBOPT_0x22
	SBIW R30,0
	BRNE PC+3
	JMP _0x180018
; 000C 0117             aux_count++;
	SUBI R16,-1
; 000C 0118 
; 000C 0119     return aux_count;
_0x180018:
_0x180015:
	SUBI R17,-1
	RJMP _0x180016
_0x180017:
	MOV  R30,R16
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 000C 011A }
;byte Messmodul_getCountCurrent(){
; 000C 011B byte Messmodul_getCountCurrent(){
_Messmodul_getCountCurrent:
; 000C 011C     byte i,aux_count = 0;
; 000C 011D     tMESSMODUL *pMessmodul = &sMm[0];
; 000C 011E 
; 000C 011F     for(i=0; i<3; i++)
	CALL SUBOPT_0x30
;	i -> R17
;	aux_count -> R16
;	*pMessmodul -> R18,R19
_0x18001A:
	CPI  R17,3
	BRLO PC+3
	JMP _0x18001B
; 000C 0120         if(pMessmodul->values.current[i])
	CALL SUBOPT_0x25
	CALL SUBOPT_0x22
	SBIW R30,0
	BRNE PC+3
	JMP _0x18001C
; 000C 0121             aux_count++;
	SUBI R16,-1
; 000C 0122 
; 000C 0123     return aux_count;
_0x18001C:
_0x180019:
	SUBI R17,-1
	RJMP _0x18001A
_0x18001B:
	MOV  R30,R16
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 000C 0124 }
;
;signed int buffer2signed(byte *pBuffer, byte length){
; 000C 0126 signed int buffer2signed(byte *pBuffer, byte length){
_buffer2signed:
; 000C 0127 
; 000C 0128      //most significant bit is the sign
; 000C 0129      byte my_sign = *(pBuffer + (length-1)) & 0x80 ? 1 : 0;
; 000C 012A      return  (signed int)(my_sign ? -*(long *)pBuffer : *(long *)pBuffer);
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
	BRNE PC+3
	JMP _0x18001D
	LDI  R30,LOW(1)
	RJMP _0x18001E
_0x18001D:
	LDI  R30,LOW(0)
_0x18001E:
_0x18001F:
	MOV  R17,R30
	CPI  R17,0
	BRNE PC+3
	JMP _0x180020
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETD1P
	CALL __ANEGD1
	RJMP _0x180021
_0x180020:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
_0x180021:
_0x180022:
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 000C 012B }
;//**********************************************************************************************
;// maxq318x.c -
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
;#include <my_spi.h>
;#include <delay.h>
;#include <uart2.h>
;#include <maxq318x_commands.h>
;
;/* COMMAND TABLES */
;
;
;// | command | size |
;flash tCOMMAND_DEF COMMAND_DEF[] = {
;    {AFE_STATUS,    1,  eAFE_READ}, //eSTATUS
;    {AFE_OP_MODE1,  1,  eAFE_READ},  //eOP_MODE1
;    {AFE_OP_MODE2,  1,  eAFE_READ},  //eOP_MODE2
;    {AFE_OP_MODE3,  1,  eAFE_READ},  //eOP_MODE3
;    {AFE_IRQ_FLAG,  2,  eAFE_READ},  //eIRQ_FLAG
;    {AFE_IRQ_MASK,  2,  eAFE_READ},  //eIRQ_MASK
;    {AFE_LINEFR,    2,  eAFE_READ},  //eLINEFR
;    {AFE_A_PF,      2,  eAFE_READ},  //eA_PF
;    {AFE_A_VRMS,    4,  eAFE_READ},  //eA_VRMS
;    {AFE_A_IRMS,    4,  eAFE_READ},  //eA_IRMS
;    {AFE_B_PF,      2,  eAFE_READ},  //eB_PF
;    {AFE_B_VRMS,    4,  eAFE_READ},  //eB_VRMS
;    {AFE_B_IRMS,    4,  eAFE_READ},  //eB_IRMS
;    {AFE_C_PF,      2,  eAFE_READ},  //eC_PF
;    {AFE_C_VRMS,    4,  eAFE_READ},  //eC_VRMS
;    {AFE_C_IRMS,    4,  eAFE_READ},  //eC_IRMS
;    {AFE_RAWTEMP,   2,  eAFE_READ}   //eRAWTEMP
;
;};
;//**********************************************************************************************
;// nt7534.c
;// (C)2010 Knuerr s.r.o, Ing. Lubos Melichar
;//**********************************************************************************************
;// - z�kladn� funkce pro pr�ci s radicem/displejem
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
;    { 0x00, 0x07, 0x05, 0x07, 0x00 }      //�
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
; 000E 008F void NT7534_Init(){

	.CSEG
_NT7534_Init:
; 000E 0090 
; 000E 0091     //nastaveni portu
; 000E 0092     PIN_A0_DDR = 1;     //data
	SBI  0x1,2
; 000E 0093     PIN_RES_DDR = 1;    //reset
	SBI  0x1,1
; 000E 0094     NT7534_CS_DDR = 1;  //cs
	SBI  0x4,4
; 000E 0095 
; 000E 0096     //init values
; 000E 0097 
; 000E 0098     //reset
; 000E 0099     RES = 0;
	CBI  0x2,1
; 000E 009A     delay_us(50);
	__DELAY_USB 184
; 000E 009B     RES = 1;
	SBI  0x2,1
; 000E 009C 
; 000E 009D     //CS deactive
; 000E 009E     NT7534_CLEAR_CS;
	SBI  0x5,4
; 000E 009F 
; 000E 00A0     //init SPI
; 000E 00A1     SPI_MasterInit();
	CALL _SPI_MasterInit
; 000E 00A2 
; 000E 00A3     delay_us(50);
	__DELAY_USB 184
; 000E 00A4 
; 000E 00A5     //init display
; 000E 00A6     NT7534_Display_Init();
	CALL _NT7534_Display_Init
; 000E 00A7 
; 000E 00A8     delay_us(50);
	__DELAY_USB 184
; 000E 00A9     NT7534_clear_screen();
	CALL _NT7534_clear_screen
; 000E 00AA     delay_us(50);
	__DELAY_USB 184
; 000E 00AB     knuerr_logo();
	CALL _knuerr_logo
; 000E 00AC }
	RET
;
;//init display
;void NT7534_Display_Init(){
; 000E 00AF void NT7534_Display_Init(){
_NT7534_Display_Init:
; 000E 00B0 
; 000E 00B1     //NT7534_SET_CS;
; 000E 00B2     w_command( 0xA3 );   //LCD bias setting (11)
	LDI  R30,LOW(163)
	ST   -Y,R30
	CALL _w_command
; 000E 00B3     w_command( 0xA1 );   //ADC selection (8)
	LDI  R30,LOW(161)
	ST   -Y,R30
	CALL _w_command
; 000E 00B4     w_command( 0xC0 );   //Select COM output scan direction (15)
	LDI  R30,LOW(192)
	ST   -Y,R30
	CALL _w_command
; 000E 00B5     w_command( 0x24 );   //Setting the built-in resistance ratio for regulation of the V0 voltage (17)
	LDI  R30,LOW(36)
	ST   -Y,R30
	CALL _w_command
; 000E 00B6 
; 000E 00B7     w_command( 0x81 );   //Electric volume Mode Set (18)
	LDI  R30,LOW(129)
	ST   -Y,R30
	CALL _w_command
; 000E 00B8     w_command( 0x2F );   //Electric volume Register Set (18)
	LDI  R30,LOW(47)
	ST   -Y,R30
	CALL _w_command
; 000E 00B9 
; 000E 00BA     w_command( 0x2F );   //Power control seting (16)
	LDI  R30,LOW(47)
	ST   -Y,R30
	CALL _w_command
; 000E 00BB     w_command( 0xA7 );   // LCD in normal mode (9)
	LDI  R30,LOW(167)
	ST   -Y,R30
	CALL _w_command
; 000E 00BC 
; 000E 00BD     NT7534_clear_screen();
	CALL _NT7534_clear_screen
; 000E 00BE 
; 000E 00BF     w_command( 0x7F );   //Display start line set (2)
	CALL SUBOPT_0x31
; 000E 00C0     w_command( 0xB0 );   //Page address set (3)
	LDI  R30,LOW(176)
	CALL SUBOPT_0x32
; 000E 00C1     w_command( 0x10 );   //Column Address set (4) High nibble (10h to 18h)
; 000E 00C2     w_command( 0x05 );   //Column address set (4) Low nibble (00h to 0Fh)
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _w_command
; 000E 00C3 
; 000E 00C4     NT7534_printf("Inicializace OK");
	__POINTW1FN _0x1C0000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _NT7534_printf
; 000E 00C5 
; 000E 00C6     w_command( 0xAF );   //LCD on (1)
	LDI  R30,LOW(175)
	ST   -Y,R30
	CALL _w_command
; 000E 00C7 
; 000E 00C8     //NT7534_CLEAR_CS;
; 000E 00C9 
; 000E 00CA }
	RET
;
;
;void NT7534_manager(){
; 000E 00CD void NT7534_manager(){
; 000E 00CE     static byte aux_cnt = 0;
; 000E 00CF     byte my_string[20];
; 000E 00D0     //byte* pRows[4] = {"ahoj","cau","nazdar","pic"};
; 000E 00D1 
; 000E 00D2     //NT7534_set_screen(pRows);
; 000E 00D3 
; 000E 00D4     //NT7534_clear_screen();
; 000E 00D5     NT7534_set_position(0,1,0);
;	my_string -> Y+0
; 000E 00D6     aux_cnt++;
; 000E 00D7 
; 000E 00D8     if(aux_cnt<10){
; 000E 00D9         sprintf(my_string, "frekvence:  %d      ", 70 - aux_cnt);
; 000E 00DA         NT7534_print(my_string);
; 000E 00DB         //disp_str("Consider it solved!!!");
; 000E 00DC     }
; 000E 00DD     else if (aux_cnt<11){
; 000E 00DE         NT7534_set_position(0,1,1);
; 000E 00DF         NT7534_printf("Nejsem povinen b�t takov�, jak� bych podle ostatn�ch lid� m�l b�t. Je to jejich omyl, a ne moje selh�n� - Richard Feynman");
; 000E 00E0     }
; 000E 00E1     else
; 000E 00E2         aux_cnt = 0;
; 000E 00E3 
; 000E 00E4 
; 000E 00E5 }
;
;//zobrazi X stringu na X radcich displeje
;void NT7534_set_screen(byte *pRows[NR_ROWS]){
; 000E 00E8 void NT7534_set_screen(byte *pRows[8]){
_NT7534_set_screen:
; 000E 00E9     byte i;
; 000E 00EA 
; 000E 00EB     for(i=0; i<NR_ROWS; i++){
	ST   -Y,R17
;	pRows -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x1C0014:
	CPI  R17,8
	BRLO PC+3
	JMP _0x1C0015
; 000E 00EC          NT7534_set_position(0,1,i);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R17
	CALL _NT7534_set_position
; 000E 00ED          NT7534_print(pRows[i]);
	MOV  R30,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	CALL _NT7534_print
; 000E 00EE     }
_0x1C0013:
	SUBI R17,-1
	RJMP _0x1C0014
_0x1C0015:
; 000E 00EF 
; 000E 00F0 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;void NT7534_set_paging(byte current, byte max){
; 000E 00F1 void NT7534_set_paging(byte current, byte max){
; 000E 00F2     char aus_string[21];
; 000E 00F3     sprintf(aus_string, "                  %u/%u", current, max);
;	current -> Y+22
;	max -> Y+21
;	aus_string -> Y+0
; 000E 00F4     NT7534_set_position(0,1,7);
; 000E 00F5     NT7534_print(aus_string);
; 000E 00F6 }
;
;
;//clear display
;void NT7534_clear_screen(void){
; 000E 00FA void NT7534_clear_screen(void){
_NT7534_clear_screen:
; 000E 00FB     unsigned char i,j;
; 000E 00FC      w_command(0x7F);      //Set Display Start Line = com0
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	CALL SUBOPT_0x31
; 000E 00FD      for(i=0;i<8;i++){
	LDI  R17,LOW(0)
_0x1C0017:
	CPI  R17,8
	BRLO PC+3
	JMP _0x1C0018
; 000E 00FE          w_command(0xB0|i);    //Set Page Address
	MOV  R30,R17
	ORI  R30,LOW(0xB0)
	CALL SUBOPT_0x32
; 000E 00FF          w_command(0x10);      //Set Column Address = 0
; 000E 0100          w_command(0x01);      //Colum from 1 -> 129 auto add
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _w_command
; 000E 0101          for(j=0;j<132;j++)
	LDI  R16,LOW(0)
_0x1C001A:
	CPI  R16,132
	BRLO PC+3
	JMP _0x1C001B
; 000E 0102             w_data( 0x00 );   //Display data write (6)
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _w_data
_0x1C0019:
	SUBI R16,-1
	RJMP _0x1C001A
_0x1C001B:
; 000E 0103 }
_0x1C0016:
	SUBI R17,-1
	RJMP _0x1C0017
_0x1C0018:
; 000E 0104 
; 000E 0105  }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;//set cursor to position
;void NT7534_set_position(unsigned char x_high, unsigned char x_low, unsigned char y){
; 000E 0108 void NT7534_set_position(unsigned char x_high, unsigned char x_low, unsigned char y){
_NT7534_set_position:
; 000E 0109 
; 000E 010A 
; 000E 010B     w_command( 0x7F );   //Display start line set (2)
;	x_high -> Y+2
;	x_low -> Y+1
;	y -> Y+0
	CALL SUBOPT_0x31
; 000E 010C 
; 000E 010D     x_high|=0x10;
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
; 000E 010E     w_command(x_high);
	ST   -Y,R30
	CALL _w_command
; 000E 010F 
; 000E 0110     if(x_high==0x10){
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BREQ PC+3
	JMP _0x1C001C
; 000E 0111         x_low|=0x04;
	LDD  R30,Y+1
	ORI  R30,4
	STD  Y+1,R30
; 000E 0112     }
; 000E 0113     else{
	RJMP _0x1C001D
_0x1C001C:
; 000E 0114         x_low|=0x00;
	LDD  R30,Y+1
	STD  Y+1,R30
; 000E 0115     }
_0x1C001D:
; 000E 0116     w_command(x_low);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _w_command
; 000E 0117 
; 000E 0118     y|=0xB0;
	LD   R30,Y
	ORI  R30,LOW(0xB0)
	ST   Y,R30
; 000E 0119     w_command(y);
	ST   -Y,R30
	CALL _w_command
; 000E 011A }
	ADIW R28,3
	RET
;
;
;/* PRINT CHAR
;   - 2 tabulky znaku FontLookup a FontLookup_Extended
;   - "FontLookup" kopiruje ascii tabulku s offsetem -32, ve "FontLookup_Extended" jsou specielni znaky
;   - specielni znak -> nahradi se 0-31, tiskne se znak s timto indexem z tabulky FontLookup_Extended
;   - normalni znak  -> vezme se jeho ascii hodnota odecte se 32 a tiskne se znak s timto indexem z tabulky FontLookup
;*/
;void NT7534_print_char(unsigned char chr){
; 000E 0123 void NT7534_print_char(unsigned char chr){
_NT7534_print_char:
; 000E 0124 
; 000E 0125     unsigned char i=0;
; 000E 0126 
; 000E 0127 
; 000E 0128     //nahradit specielni znaky (0-31)
; 000E 0129     if(chr == '�')
	ST   -Y,R17
;	chr -> Y+1
;	i -> R17
	LDI  R17,0
	LDD  R26,Y+1
	CPI  R26,LOW(0xB0)
	BREQ PC+3
	JMP _0x1C001E
; 000E 012A         chr = 0;
	LDI  R30,LOW(0)
	STD  Y+1,R30
; 000E 012B 
; 000E 012C     //escape unprintable chars with space
; 000E 012D     else if ( (chr < 0x20) || (chr > 0x7b) ) // resim pouze tisknutelne znaky - tj. 32(sp) az 123(z) viz. ASCII
	RJMP _0x1C001F
_0x1C001E:
	LDD  R26,Y+1
	CPI  R26,LOW(0x20)
	BRSH PC+3
	JMP _0x1C0021
	CPI  R26,LOW(0x7C)
	BRLO PC+3
	JMP _0x1C0021
	RJMP _0x1C0020
_0x1C0021:
; 000E 012E         chr = 64; // pokud bude zadan netisknutelny znak, napise se misto nej mezera
	LDI  R30,LOW(64)
	STD  Y+1,R30
; 000E 012F 
; 000E 0130 
; 000E 0131     for(i=0; i<5; i++){
_0x1C0020:
_0x1C001F:
	LDI  R17,LOW(0)
_0x1C0024:
	CPI  R17,5
	BRLO PC+3
	JMP _0x1C0025
; 000E 0132 
; 000E 0133         //specielni znaky -> FontLookup_Extended
; 000E 0134         if(chr<32)
	LDD  R26,Y+1
	CPI  R26,LOW(0x20)
	BRLO PC+3
	JMP _0x1C0026
; 000E 0135             w_data(FontLookup_Extended[chr][i]);
	LDD  R30,Y+1
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_FontLookup_Extended_G00E*2)
	SBCI R31,HIGH(-_FontLookup_Extended_G00E*2)
	MOVW R26,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x33
; 000E 0136 
; 000E 0137         //normalni znak -> FontLookup
; 000E 0138         else
	RJMP _0x1C0027
_0x1C0026:
; 000E 0139             w_data(FontLookup[chr-32][i]); //odecitam 32 pro dosazeni pozadovane radky v Look up tabulce
	LDD  R30,Y+1
	SUBI R30,LOW(32)
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_FontLookup_G00E*2)
	SBCI R31,HIGH(-_FontLookup_G00E*2)
	MOVW R26,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x33
; 000E 013A     }
_0x1C0027:
_0x1C0023:
	SUBI R17,-1
	RJMP _0x1C0024
_0x1C0025:
; 000E 013B 
; 000E 013C     w_data(0); // odsazeni za pismenkem
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _w_data
; 000E 013D 
; 000E 013E }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;//print string
;void NT7534_print(unsigned char *cp){
; 000E 0141 void NT7534_print(unsigned char *cp){
_NT7534_print:
; 000E 0142 
; 000E 0143     for (; *cp; cp++)
;	*cp -> Y+0
_0x1C0029:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x1C002A
; 000E 0144         NT7534_print_char(*cp);
	ST   -Y,R30
	CALL _NT7534_print_char
_0x1C0028:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x1C0029
_0x1C002A:
; 000E 0145 }
	ADIW R28,2
	RET
;
;//print flash string
;void NT7534_printf(unsigned char flash *cp){
; 000E 0148 void NT7534_printf(unsigned char flash *cp){
_NT7534_printf:
; 000E 0149 
; 000E 014A     for (; *cp; cp++)
;	*cp -> Y+0
_0x1C002C:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0x1C002D
; 000E 014B         NT7534_print_char(*cp);
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	ST   -Y,R30
	CALL _NT7534_print_char
_0x1C002B:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x1C002C
_0x1C002D:
; 000E 014C }
	ADIW R28,2
	RET
;
;//send command or data, basic function for w_command() and w_data()
;void w_command_data(byte command_data, byte data){
; 000E 014F void w_command_data(byte command_data, byte data){
_w_command_data:
; 000E 0150 
; 000E 0151     //active CS
; 000E 0152     NT7534_SET_CS;
;	command_data -> Y+1
;	data -> Y+0
	CBI  0x5,4
; 000E 0153 
; 000E 0154     if(command_data)
	LDD  R30,Y+1
	CPI  R30,0
	BRNE PC+3
	JMP _0x1C0030
; 000E 0155         PIN_A0 = 0;
	CBI  0x2,2
; 000E 0156     else
	RJMP _0x1C0033
_0x1C0030:
; 000E 0157         PIN_A0 = 1;
	SBI  0x2,2
; 000E 0158 
; 000E 0159     delay_us(10);
_0x1C0033:
	__DELAY_USB 37
; 000E 015A 
; 000E 015B     SPI_MasterTransmit(data);
	LD   R30,Y
	ST   -Y,R30
	CALL _SPI_MasterTransmit
; 000E 015C 
; 000E 015D     delay_us(10);
	__DELAY_USB 37
; 000E 015E 
; 000E 015F     //deactive CS
; 000E 0160     NT7534_CLEAR_CS;
	SBI  0x5,4
; 000E 0161 }
	ADIW R28,2
	RET
;
;void w_command(unsigned char data){
; 000E 0163 void w_command(unsigned char data){
_w_command:
; 000E 0164     w_command_data(1, data);
;	data -> Y+0
	LDI  R30,LOW(1)
	CALL SUBOPT_0x34
; 000E 0165 }
	RET
;
;void w_data(unsigned char data){
; 000E 0167 void w_data(unsigned char data){
_w_data:
; 000E 0168     w_command_data(0, data);
;	data -> Y+0
	LDI  R30,LOW(0)
	CALL SUBOPT_0x34
; 000E 0169 }
	RET
;
;
;
;
;/* TEST FUNCTIONs */
;
;
;void knuerr_logo(void){
; 000E 0171 void knuerr_logo(void){
_knuerr_logo:
; 000E 0172     byte i;
; 000E 0173     word row;
; 000E 0174 
; 000E 0175     for(row=0; row<8; row++){
	CALL __SAVELOCR4
;	i -> R17
;	row -> R18,R19
	__GETWRN 18,19,0
_0x1C0039:
	__CPWRN 18,19,8
	BRLO PC+3
	JMP _0x1C003A
; 000E 0176         NT7534_set_position(0,1,(byte)row);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R18
	CALL _NT7534_set_position
; 000E 0177         for(i=0;i<128;i++)
	LDI  R17,LOW(0)
_0x1C003C:
	CPI  R17,128
	BRLO PC+3
	JMP _0x1C003D
; 000E 0178             w_data(LOGO_KNUERR[i + 128*row]);
	__MULBNWRU 18,19,128
	MOV  R26,R17
	LDI  R27,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_LOGO_KNUERR_G00E*2)
	SBCI R31,HIGH(-_LOGO_KNUERR_G00E*2)
	LPM  R30,Z
	ST   -Y,R30
	CALL _w_data
_0x1C003B:
	SUBI R17,-1
	RJMP _0x1C003C
_0x1C003D:
; 000E 0179 }
_0x1C0038:
	__ADDWRN 18,19,1
	RJMP _0x1C0039
_0x1C003A:
; 000E 017A }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;//chessboard
;void chessboard(void){
; 000E 017C void chessboard(void){
; 000E 017D     unsigned char i,j;
; 000E 017E 
; 000E 017F      w_command(0x40);      //Set Display Start Line = com0
;	i -> R17
;	j -> R16
; 000E 0180      for(i=0;i<8;i++)
; 000E 0181      {
; 000E 0182              w_command(0xB0|i);    //Set Page Address
; 000E 0183              w_command(0x10);      //Set Column Address = 0
; 000E 0184              w_command(0x04);      //Colum from 1 -> 129 auto add
; 000E 0185 
; 000E 0186         if(i%2)
; 000E 0187           {
; 000E 0188              for(j=0;j<8;j++)
; 000E 0189              {
; 000E 018A                      //disp_write(0x10|j,0);      //Set Column Address = 0
; 000E 018B 
; 000E 018C                      w_data( 0xFF );   //Display data write (6)
; 000E 018D                      w_data( 0x00 );   //Display data write (6)
; 000E 018E                      w_data( 0x00 );   //Display data write (6)
; 000E 018F                      w_data( 0x00 );   //Display data write (6)
; 000E 0190                      w_data( 0x00 );   //Display data write (6)
; 000E 0191                      w_data( 0x00 );   //Display data write (6)
; 000E 0192                      w_data( 0x00 );   //Display data write (6)
; 000E 0193                      w_data( 0x00 );   //Display data write (6)
; 000E 0194                      w_data( 0xFF );   //Display data write (6)
; 000E 0195                      w_data( 0xFF );   //Display data write (6)
; 000E 0196                      w_data( 0xFF );   //Display data write (6)
; 000E 0197                      w_data( 0xFF );   //Display data write (6)
; 000E 0198                      w_data( 0xFF );   //Display data write (6)
; 000E 0199                      w_data( 0xFF );   //Display data write (6)
; 000E 019A                      w_data( 0xFF );   //Display data write (6)
; 000E 019B                      w_data( 0xFF );   //Display data write (6)
; 000E 019C              }
; 000E 019D           }
; 000E 019E 
; 000E 019F         else
; 000E 01A0           {
; 000E 01A1             for(j=0;j<8;j++)
; 000E 01A2              {
; 000E 01A3                      w_data( 0xFF );   //Display data write (6)
; 000E 01A4                      w_data( 0xFF );   //Display data write (6)
; 000E 01A5                      w_data( 0xFF );   //Display data write (6)
; 000E 01A6                      w_data( 0xFF );   //Display data write (6)
; 000E 01A7                      w_data( 0xFF );   //Display data write (6)
; 000E 01A8                      w_data( 0xFF );   //Display data write (6)
; 000E 01A9                      w_data( 0xFF );   //Display data write (6)
; 000E 01AA                      w_data( 0xFF );   //Display data write (6)
; 000E 01AB                      w_data( 0x00 );   //Display data write (6)
; 000E 01AC                      w_data( 0x00 );   //Display data write (6)
; 000E 01AD                      w_data( 0x00 );   //Display data write (6)
; 000E 01AE                      w_data( 0x00 );   //Display data write (6)
; 000E 01AF                      w_data( 0x00 );   //Display data write (6)
; 000E 01B0                      w_data( 0x00 );   //Display data write (6)
; 000E 01B1                      w_data( 0x00 );   //Display data write (6)
; 000E 01B2                      w_data( 0x00 );   //Display data write (6)
; 000E 01B3              }
; 000E 01B4           }
; 000E 01B5 
; 000E 01B6 
; 000E 01B7 
; 000E 01B8 
; 000E 01B9      }
; 000E 01BA  }
;
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
;
;#include <NT7534.h>
;#include <display.h>
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
; 000F 0018 void Display_Init(){

	.CSEG
_Display_Init:
; 000F 0019 
; 000F 001A //    for(i=0; i<NR_ROWS; i++)
; 000F 001B //        sDisplay.pRows[i] = sDisplay.rows_text[i];
; 000F 001C 
; 000F 001D     sDisplay.screen_index = 0;
	LDI  R30,LOW(0)
	STS  _sDisplay,R30
; 000F 001E     //sDisplay.current_screen_function = sSCREEN_GROUP[0].function;
; 000F 001F 
; 000F 0020 
; 000F 0021     //init display
; 000F 0022     NT7534_Init();
	CALL _NT7534_Init
; 000F 0023 
; 000F 0024 
; 000F 0025 }
	RET
;
;void Display_Manager(){
; 000F 0027 void Display_Manager(){
_Display_Manager:
; 000F 0028     byte* pRows[NR_ROWS] = {    "                      ", //21
; 000F 0029                                 "                      ",
; 000F 002A                                 "                      ",
; 000F 002B                                 "                      ",
; 000F 002C                                 "                      ",
; 000F 002D                                 "                      ",
; 000F 002E                                 "                      ",
; 000F 002F                                 "                      "};
; 000F 0030 
; 000F 0031 //    sprintf(sDisplay.rows_text[0], "nulovy");
; 000F 0032 //    sprintf(sDisplay.rows_text[1], "prvy");
; 000F 0033 //    sprintf(sDisplay.rows_text[2], "treti");
; 000F 0034 //    sprintf(sDisplay.rows_text[3], "ctvrty");
; 000F 0035 
; 000F 0036     //sDisplay.current_screen_function(sDisplay.pRows);
; 000F 0037 
; 000F 0038     //sSCREEN_GROUP[sDisplay.screen_index].function(pRows);
; 000F 0039 
; 000F 003A     //funkce z indexu naplni stringy
; 000F 003B     Display_screens_setStrings(sDisplay.screen_index, pRows);
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x1E0004*2)
	LDI  R31,HIGH(_0x1E0004*2)
	CALL __INITLOCB
;	pRows -> Y+0
	LDS  R30,_sDisplay
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _Display_screens_setStrings
; 000F 003C 
; 000F 003D     //incrementy screen
; 000F 003E     //Disp_next_screen();
; 000F 003F     //rot_inc(&sDisplay.screen_index, NR_SCREEN-1);
; 000F 0040 
; 000F 0041     //set screen
; 000F 0042     NT7534_set_screen(pRows);
	CALL SUBOPT_0x35
	CALL _NT7534_set_screen
; 000F 0043     //NT7534_set_paging(sDisplay.screen_index+1, NR_SCREEN);
; 000F 0044 
; 000F 0045 //    printf("\n screen");
; 000F 0046 //    for(i=0; i<NR_ROWS; i++){
; 000F 0047 //        printf("%s", sDisplay.rows_text[i]);
; 000F 0048 //    }
; 000F 0049 
; 000F 004A }
	ADIW R28,16
	RET

	.DSEG
_0x1E0003:
	.BYTE 0xB8
;
;
;void Disp_next_screen(){
; 000F 004D void Disp_next_screen(){

	.CSEG
_Disp_next_screen:
; 000F 004E     rot_inc(&sDisplay.screen_index, NR_SCREEN-1);
	CALL SUBOPT_0x36
	CALL _rot_inc
; 000F 004F }
	RET
;
;void Disp_previous_screen(){
; 000F 0051 void Disp_previous_screen(){
_Disp_previous_screen:
; 000F 0052     rot_dec(&sDisplay.screen_index, NR_SCREEN-1);
	CALL SUBOPT_0x36
	CALL _rot_dec
; 000F 0053 }
	RET
;
;//rotacni incrementace, mozna udelat jako makro
;void rot_inc(byte *var, byte max){
; 000F 0056 void rot_inc(byte *var, byte max){
_rot_inc:
; 000F 0057 	if(*var < max)
;	*var -> Y+1
;	max -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R26,X
	LD   R30,Y
	CP   R26,R30
	BRLO PC+3
	JMP _0x1E0005
; 000F 0058 		(*var)++;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 000F 0059 	else
	RJMP _0x1E0006
_0x1E0005:
; 000F 005A 		*var = 0;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
; 000F 005B }
_0x1E0006:
	ADIW R28,3
	RET
;
;//rotacni incrementace, mozna udelat jako makro
;void rot_dec(byte *var, byte max){
; 000F 005E void rot_dec(byte *var, byte max){
_rot_dec:
; 000F 005F 	if(*var == 0)
;	*var -> Y+1
;	max -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CPI  R30,0
	BREQ PC+3
	JMP _0x1E0007
; 000F 0060         *var = max;
	LD   R30,Y
	ST   X,R30
; 000F 0061 	else
	RJMP _0x1E0008
_0x1E0007:
; 000F 0062         (*var)--;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 000F 0063 
; 000F 0064 }
_0x1E0008:
	ADIW R28,3
	RET
;
;//**********************************************************************************************
;//
;//*****************************************************************
;
;#include <types.h>
;#include <stdio.h>
;#include <utils.h>
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
;#include <display.h>
;#include <display_screens.h>
;#include <messmodules.h>
;#include "comm_xport.h"
;
;byte sf_board(byte* pTexts[NR_ROWS]);
;byte sf_resume(byte* pTexts[NR_ROWS]);
;byte sf_voltages(byte* pTexts[NR_ROWS]);
;byte sf_currents(byte* pTexts[NR_ROWS]);
;byte sf_powers(byte* pTexts[NR_ROWS]);
;byte sf_powers_act(byte* pTexts[NR_ROWS]);
;//byte sf_powers_app(byte* pTexts[NR_ROWS]);
;byte sf_powerfactors(byte* pTexts[NR_ROWS]);
;byte sf_energies_act(byte* pTexts[NR_ROWS]);
;//byte sf_energies_app(byte* pTexts[NR_ROWS]);
;
;//byte sf_vrms(byte* pTexts[NR_ROWS]);
;//byte sf_irms(byte* pTexts[NR_ROWS]);
;//byte sf_act(byte* pTexts[NR_ROWS]);
;//byte sf_app(byte* pTexts[NR_ROWS]);
;//byte sf_eapos_eaneg(byte* pTexts[NR_ROWS]);
;
;flash tSCREEN sSCREEN_GROUP[NR_SCREEN] = {
;    {"BOARD", sf_board},
;    {"RESUME", sf_resume},
;    {"VOLTAGE", sf_voltages},
;    {"CURRENT", sf_currents},
;    {"POWER", sf_powers_act},
;    {"POWERFACTOR", sf_powerfactors},
;    {"ENERGY", sf_energies_act}
;};
;
;#define AUX_STRING_SIZE     40
;
;//title, underline
;void getHeader(byte index, byte* pTexts[NR_ROWS]){
; 0011 0037 void getHeader(byte index, byte* pTexts[8]){

	.CSEG
_getHeader:
; 0011 0038     byte aux_string[AUX_STRING_SIZE];
; 0011 0039 
; 0011 003A     //check string length
; 0011 003B     if(strlenf(sSCREEN_GROUP[index].title)>TITLE_SIZE)
	SBIW R28,40
;	index -> Y+42
;	pTexts -> Y+40
;	aux_string -> Y+0
	LDD  R30,Y+42
	CALL SUBOPT_0x37
	CALL _strlenf
	SBIW R30,16
	BRSH PC+3
	JMP _0x220003
; 0011 003C         return;
	ADIW R28,43
	RET
; 0011 003D 
; 0011 003E     //title
; 0011 003F     strcpy(aux_string , "        "); strcatf(aux_string, sSCREEN_GROUP[index].title); strcatf(aux_string, "     ");
_0x220003:
	CALL SUBOPT_0x35
	__POINTW1MN _0x220004,0
	CALL SUBOPT_0x38
	LDD  R30,Y+44
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
	__POINTW1FN _0x220000,3
	CALL SUBOPT_0x3A
; 0011 0040     strncpy(pTexts[0], aux_string, NR_COLUMNS);
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
; 0011 0041 
; 0011 0042     //underline
; 0011 0043     strncpy(pTexts[1] ,"      ============    ", NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	__POINTW1MN _0x220004,9
	CALL SUBOPT_0x3D
; 0011 0044 
; 0011 0045 }
	ADIW R28,43
	RET

	.DSEG
_0x220004:
	.BYTE 0x20
;
;//clear unused rows, pagging
;void getFooter(byte first_unused_row, byte index, byte* pTexts[NR_ROWS]){
; 0011 0048 void getFooter(byte first_unused_row, byte index, byte* pTexts[8]){

	.CSEG
_getFooter:
; 0011 0049     byte i;
; 0011 004A     byte aux_string[AUX_STRING_SIZE];
; 0011 004B 
; 0011 004C     //clear unused rows
; 0011 004D     for(i=first_unused_row; i<(NR_ROWS-1); i++)
	SBIW R28,40
	ST   -Y,R17
;	first_unused_row -> Y+44
;	index -> Y+43
;	pTexts -> Y+41
;	i -> R17
;	aux_string -> Y+1
	LDD  R17,Y+44
_0x220006:
	CPI  R17,7
	BRLO PC+3
	JMP _0x220007
; 0011 004E         strncpy(pTexts[i] , "                    ", NR_COLUMNS);
	MOV  R30,R17
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	LDI  R31,0
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x220008,0
	CALL SUBOPT_0x3D
_0x220005:
	SUBI R17,-1
	RJMP _0x220006
_0x220007:
; 0011 0051 sprintf(aux_string, "                 %u/%u", index+1, 7);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x220000,53
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+47
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x3E
	__GETD1N 0x7
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0011 0052     strncpy(pTexts[NR_ROWS-1], aux_string, NR_COLUMNS);
	LDD  R30,Y+41
	LDD  R31,Y+41+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	MOVW R30,R28
	ADIW R30,3
	CALL SUBOPT_0x3D
; 0011 0053 
; 0011 0054 }
	LDD  R17,Y+0
	ADIW R28,45
	RET

	.DSEG
_0x220008:
	.BYTE 0x15
;
;//global function, set all strings
;void Display_screens_setStrings(byte index, byte* pTexts[NR_ROWS]){
; 0011 0057 void Display_screens_setStrings(byte index, byte* pTexts[8]){

	.CSEG
_Display_screens_setStrings:
; 0011 0058     byte nr_row;
; 0011 0059 
; 0011 005A     //title, underline (row 0,1)
; 0011 005B     getHeader(index, pTexts);
	ST   -Y,R17
;	index -> Y+3
;	pTexts -> Y+1
;	nr_row -> R17
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _getHeader
; 0011 005C 
; 0011 005D     nr_row = sSCREEN_GROUP[index].function(pTexts);
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
; 0011 005E 
; 0011 005F     //clear unused rows, pagging
; 0011 0060     getFooter(nr_row, index, pTexts);
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _getFooter
; 0011 0061 }
	LDD  R17,Y+0
	ADIW R28,4
	RET
;
;
;//******************************************
;// SCREEN FUNCTIONS
;//*******************************************
;
;//board
;byte sf_board(byte* pTexts[NR_ROWS]){
; 0011 0069 byte sf_board(byte* pTexts[8]){
_sf_board:
; 0011 006A     byte aux_string[AUX_STRING_SIZE];
; 0011 006B 
; 0011 006C     strcpy(aux_string , " HW ver.: "); strcatf(aux_string, HW_VERSION_S); strcatf(aux_string, "    ");
	SBIW R28,40
;	pTexts -> Y+40
;	aux_string -> Y+0
	CALL SUBOPT_0x35
	__POINTW1MN _0x220009,0
	CALL SUBOPT_0x38
	__POINTW1FN _0x220000,87
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x39
	__POINTW1FN _0x220000,4
	CALL SUBOPT_0x3A
; 0011 006D     strncpy(pTexts[2], aux_string, NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3C
; 0011 006E 
; 0011 006F     strcpy(aux_string , " SW ver.: "); strcatf(aux_string, SW_VERSION_S); strcatf(aux_string, "    ");
	CALL SUBOPT_0x35
	__POINTW1MN _0x220009,11
	CALL SUBOPT_0x38
	__POINTW1FN _0x220000,103
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x39
	__POINTW1FN _0x220000,4
	CALL SUBOPT_0x3A
; 0011 0070     strncpy(pTexts[3], aux_string, NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	CALL SUBOPT_0x40
; 0011 0071 
; 0011 0072     strncpy(pTexts[4], "                     ", NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+8
	LDD  R27,Z+9
	ST   -Y,R27
	ST   -Y,R26
	__POINTW1MN _0x220009,22
	CALL SUBOPT_0x3D
; 0011 0073 
; 0011 0074     sprintf(aux_string ," IP: %3u.%3u.%3u.%3u        ", sXport.ip_address[0], sXport.ip_address[1], sXport.ip_address[2], sXport.ip_address[3]);
	CALL SUBOPT_0x35
	__POINTW1FN _0x220000,130
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_sXport
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,1
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,2
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,3
	CALL SUBOPT_0x3E
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0011 0075     strncpy(pTexts[5], aux_string, NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+10
	LDD  R27,Z+11
	CALL SUBOPT_0x40
; 0011 0076 
; 0011 0077     sprintf(aux_string ," MAC: %02X%02X%02X%02X%02X%02X   ", sXport.mac_address[0], sXport.mac_address[1], sXport.mac_address[2], sXport.mac_address[3], sXport.mac_address[4], sXport.mac_address[5]);
	CALL SUBOPT_0x35
	__POINTW1FN _0x220000,159
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _sXport,4
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,5
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,6
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,7
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,8
	CALL SUBOPT_0x3E
	__GETB1MN _sXport,9
	CALL SUBOPT_0x3E
	LDI  R24,24
	CALL _sprintf
	ADIW R28,28
; 0011 0078     strncpy(pTexts[6], aux_string, NR_COLUMNS);
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	CALL SUBOPT_0x40
; 0011 0079 
; 0011 007A     return NR_ROWS-1;
	LDI  R30,LOW(7)
	ADIW R28,42
	RET
; 0011 007B }

	.DSEG
_0x220009:
	.BYTE 0x2C
;
;//
;byte sf_resume(byte* pTexts[NR_ROWS]){
; 0011 007E byte sf_resume(byte* pTexts[8]){

	.CSEG
_sf_resume:
; 0011 007F 
; 0011 0080     byte aux_string[AUX_STRING_SIZE];
; 0011 0081     tMESSMODUL *pMessmodul = &sMm[0];
; 0011 0082 
; 0011 0083     sprintf(aux_string ," U lines: %u         ", Messmodul_getCountVoltage());
	SBIW R28,40
	ST   -Y,R17
	ST   -Y,R16
;	pTexts -> Y+42
;	aux_string -> Y+2
;	*pMessmodul -> R16,R17
	__POINTWRM 16,17,_sMm
	CALL SUBOPT_0x41
	__POINTW1FN _0x220000,193
	ST   -Y,R31
	ST   -Y,R30
	CALL _Messmodul_getCountVoltage
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x42
; 0011 0084     strncpy(pTexts[2], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x43
; 0011 0085 
; 0011 0086     sprintf(aux_string ," I lines: %u         ", Messmodul_getCountCurrent());
	CALL SUBOPT_0x41
	__POINTW1FN _0x220000,215
	ST   -Y,R31
	ST   -Y,R30
	CALL _Messmodul_getCountCurrent
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x42
; 0011 0087     strncpy(pTexts[3], aux_string, NR_COLUMNS);
	LDD  R26,Z+6
	LDD  R27,Z+7
	CALL SUBOPT_0x44
; 0011 0088 
; 0011 0089     strncpy(pTexts[4] ,"                          ", NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	LDD  R26,Z+8
	LDD  R27,Z+9
	ST   -Y,R27
	ST   -Y,R26
	__POINTW1MN _0x22000A,0
	CALL SUBOPT_0x3D
; 0011 008A 
; 0011 008B     sprintf(aux_string ," Frequence: %u.%u Hz      ", pMessmodul->values.frequence/1000, pMessmodul->values.frequence%1000);
	CALL SUBOPT_0x41
	__POINTW1FN _0x220000,264
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	MOVW R30,R16
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2B
	CALL _sprintf
	ADIW R28,12
; 0011 008C     strncpy(pTexts[5], aux_string, NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	LDD  R26,Z+10
	LDD  R27,Z+11
	CALL SUBOPT_0x44
; 0011 008D 
; 0011 008E     sprintf(aux_string ," Temperature: %u.%u�C      ", pMessmodul->values.temperature/10,pMessmodul->values.temperature%10);
	CALL SUBOPT_0x41
	__POINTW1FN _0x220000,291
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2A
	MOVW R26,R16
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2B
	CALL _sprintf
	ADIW R28,12
; 0011 008F     strncpy(pTexts[6], aux_string, NR_COLUMNS);
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	CALL SUBOPT_0x44
; 0011 0090 
; 0011 0091     return NR_ROWS-1;
	LDI  R30,LOW(7)
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,44
	RET
; 0011 0092 
; 0011 0093 }

	.DSEG
_0x22000A:
	.BYTE 0x1B
;
;//VOLTAGES
;byte sf_voltages(byte* pTexts[NR_ROWS]){
; 0011 0096 byte sf_voltages(byte* pTexts[8]){

	.CSEG
_sf_voltages:
; 0011 0097     byte aux_string[AUX_STRING_SIZE];
; 0011 0098     tMESSMODUL *pMessmodul = &sMm[0];
; 0011 0099     word i;
; 0011 009A 
; 0011 009B     strncpy(pTexts[2] ,"                     ", NR_COLUMNS);
	CALL SUBOPT_0x45
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pMessmodul -> R16,R17
;	i -> R18,R19
	__POINTW1MN _0x22000B,0
	CALL SUBOPT_0x3D
; 0011 009C 
; 0011 009D 
; 0011 009E     for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x22000D:
	__CPWRN 18,19,3
	BRLO PC+3
	JMP _0x22000E
; 0011 009F         sprintf(aux_string ,"      L1: %u.%u [V]    ", pMessmodul->values.voltage[i]/10, pMessmodul->values.voltage[i]%10);
	CALL SUBOPT_0x46
	__POINTW1FN _0x220000,319
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	ADIW R26,4
	MOVW R30,R18
	CALL SUBOPT_0x22
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2A
	MOVW R26,R16
	ADIW R26,4
	MOVW R30,R18
	CALL SUBOPT_0x22
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x47
; 0011 00A0         strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x48
; 0011 00A1     }
_0x22000C:
	__ADDWRN 18,19,1
	RJMP _0x22000D
_0x22000E:
; 0011 00A2 
; 0011 00A3 
; 0011 00A4     return NR_ROWS-2;
	CALL SUBOPT_0x49
	RET
; 0011 00A5 }

	.DSEG
_0x22000B:
	.BYTE 0x16
;
;//CURRENTS
;byte sf_currents(byte* pTexts[NR_ROWS]){
; 0011 00A8 byte sf_currents(byte* pTexts[8]){

	.CSEG
_sf_currents:
; 0011 00A9     byte aux_string[AUX_STRING_SIZE];
; 0011 00AA     tMESSMODUL *pMessmodul = &sMm[0];
; 0011 00AB     word i;
; 0011 00AC 
; 0011 00AD 
; 0011 00AE     strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x45
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pMessmodul -> R16,R17
;	i -> R18,R19
	__POINTW1MN _0x22000F,0
	CALL SUBOPT_0x3D
; 0011 00AF 
; 0011 00B0     for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x220011:
	__CPWRN 18,19,3
	BRLO PC+3
	JMP _0x220012
; 0011 00B1         sprintf(aux_string ,"      L1: %u.%02u [A]      ", pMessmodul->values.current[i]/100, pMessmodul->values.current[i]%100,);
	CALL SUBOPT_0x46
	__POINTW1FN _0x220000,343
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	ADIW R26,12
	MOVW R30,R18
	CALL SUBOPT_0x22
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x2A
	MOVW R26,R16
	ADIW R26,12
	MOVW R30,R18
	CALL SUBOPT_0x22
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x47
; 0011 00B2         strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x48
; 0011 00B3     }
_0x220010:
	__ADDWRN 18,19,1
	RJMP _0x220011
_0x220012:
; 0011 00B4 
; 0011 00B5     return NR_ROWS-2;
	CALL SUBOPT_0x49
	RET
; 0011 00B6 
; 0011 00B7 }

	.DSEG
_0x22000F:
	.BYTE 0x17
;
;/*******************************************/
;// POWER
;/*******************************************/
;
;//active & apparent power
;byte sf_powers(byte* pTexts[NR_ROWS]){
; 0011 00BE byte sf_powers(byte* pTexts[8]){

	.CSEG
; 0011 00BF     byte aux_string[AUX_STRING_SIZE];
; 0011 00C0     tMESSMODUL *pMessmodul = &sMm[0];
; 0011 00C1     word i;
; 0011 00C2 
; 0011 00C3     strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pMessmodul -> R16,R17
;	i -> R18,R19
; 0011 00C4 
; 0011 00C5     for(i=0; i<3;i++){
; 0011 00C6         sprintf(aux_string ," L1: %ld.%d [W] | %ld.%d [VA]", pMessmodul->values.power_act[i]/10, abs(pMessmodul->values.power_act[i]%10), pMessmodul->values.power_app[i]/10, abs(pMessmodul->values.power_app[i]%10));
; 0011 00C7         strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
; 0011 00C8     }
; 0011 00C9 
; 0011 00CA     return NR_ROWS-2;
; 0011 00CB }

	.DSEG
_0x220013:
	.BYTE 0x17
;
;//active power
;byte sf_powers_act(byte* pTexts[NR_ROWS]){
; 0011 00CE byte sf_powers_act(byte* pTexts[8]){

	.CSEG
_sf_powers_act:
; 0011 00CF     byte aux_string[AUX_STRING_SIZE];
; 0011 00D0     tMESSMODUL *pMessmodul = &sMm[0];
; 0011 00D1     word i;
; 0011 00D2 
; 0011 00D3     strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x45
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pMessmodul -> R16,R17
;	i -> R18,R19
	__POINTW1MN _0x220017,0
	CALL SUBOPT_0x3D
; 0011 00D4 
; 0011 00D5     for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x220019:
	__CPWRN 18,19,3
	BRLO PC+3
	JMP _0x22001A
; 0011 00D6         sprintf(aux_string ,"      L1: %ld.%d [W]   ", pMessmodul->values.power_act[i]/10, abs(pMessmodul->values.power_act[i]%10));
	CALL SUBOPT_0x46
	__POINTW1FN _0x220000,401
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	ADIW R26,20
	MOVW R30,R18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4A
	CALL __DIVD21
	CALL __PUTPARD1
	MOVW R26,R16
	ADIW R26,20
	MOVW R30,R18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4A
	CALL __MODD21
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x47
; 0011 00D7         strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x48
; 0011 00D8     }
_0x220018:
	__ADDWRN 18,19,1
	RJMP _0x220019
_0x22001A:
; 0011 00D9 
; 0011 00DA     return NR_ROWS-2;
	CALL SUBOPT_0x49
	RET
; 0011 00DB 
; 0011 00DC }

	.DSEG
_0x220017:
	.BYTE 0x17
;
;//ACTIVE POWER
;byte sf_energies_act(byte* pTexts[NR_ROWS]){
; 0011 00DF byte sf_energies_act(byte* pTexts[8]){

	.CSEG
_sf_energies_act:
; 0011 00E0     byte aux_string[AUX_STRING_SIZE];
; 0011 00E1     tMESSMODUL *pMessmodul = &sMm[0];
; 0011 00E2     word i;
; 0011 00E3 
; 0011 00E4     strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x45
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pMessmodul -> R16,R17
;	i -> R18,R19
	__POINTW1MN _0x22001B,0
	CALL SUBOPT_0x3D
; 0011 00E5 
; 0011 00E6     for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x22001D:
	__CPWRN 18,19,3
	BRLO PC+3
	JMP _0x22001E
; 0011 00E7         sprintf(aux_string ,"      L1: %u [Wh]     ", pMessmodul->values.energy_act[i]);
	CALL SUBOPT_0x46
	__POINTW1FN _0x220000,425
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	ADIW R26,52
	MOVW R30,R18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4B
; 0011 00E8         strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x48
; 0011 00E9     }
_0x22001C:
	__ADDWRN 18,19,1
	RJMP _0x22001D
_0x22001E:
; 0011 00EA 
; 0011 00EB     return NR_ROWS-2;
	CALL SUBOPT_0x49
	RET
; 0011 00EC 
; 0011 00ED }

	.DSEG
_0x22001B:
	.BYTE 0x17
;
;//POWER FACTOR
;byte sf_powerfactors(byte* pTexts[NR_ROWS]){
; 0011 00F0 byte sf_powerfactors(byte* pTexts[8]){

	.CSEG
_sf_powerfactors:
; 0011 00F1     byte aux_string[AUX_STRING_SIZE];
; 0011 00F2     tMESSMODUL *pMessmodul = &sMm[0];
; 0011 00F3     word i;
; 0011 00F4 
; 0011 00F5     strncpy(pTexts[2] ,"                      ", NR_COLUMNS);
	CALL SUBOPT_0x45
;	pTexts -> Y+44
;	aux_string -> Y+4
;	*pMessmodul -> R16,R17
;	i -> R18,R19
	__POINTW1MN _0x22001F,0
	CALL SUBOPT_0x3D
; 0011 00F6 
; 0011 00F7     for(i=0; i<3;i++){
	__GETWRN 18,19,0
_0x220021:
	__CPWRN 18,19,3
	BRLO PC+3
	JMP _0x220022
; 0011 00F8         sprintf(aux_string ,"      L1: %u        ", pMessmodul->values.power_factor[i]);
	CALL SUBOPT_0x46
	__POINTW1FN _0x220000,448
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-84)
	SBCI R27,HIGH(-84)
	MOVW R30,R18
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4B
; 0011 00F9         strncpy(pTexts[i+3], aux_string, NR_COLUMNS);
	CALL SUBOPT_0x48
; 0011 00FA     }
_0x220020:
	__ADDWRN 18,19,1
	RJMP _0x220021
_0x220022:
; 0011 00FB 
; 0011 00FC     return NR_ROWS-2;
	CALL SUBOPT_0x49
	RET
; 0011 00FD 
; 0011 00FE }

	.DSEG
_0x22001F:
	.BYTE 0x17
;
;/*************/
;/* REGISTERS */
;/*************/
;/*
;void sf_vrms(byte* pTexts[NR_ROWS]){
;
;    tMESSMODUL *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       VRMS           ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %lu [V]     ", pMessmodul->values.vrms[0]>>8);
;    sprintf(pTexts[4] ,"      L2: %lu [V]     ", pMessmodul->values.vrms[1]>>8);
;    sprintf(pTexts[5] ,"      L3: %lu [V]     ", pMessmodul->values.vrms[2]>>8);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}*/
;
;/*
;void sf_irms(byte* pTexts[NR_ROWS]){
;
;    tMESSMODUL *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       IRMS           ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %lu [A]     ", pMessmodul->values.irms[0]>>8);
;    sprintf(pTexts[4] ,"      L2: %lu [A]     ", pMessmodul->values.irms[1]>>8);
;    sprintf(pTexts[5] ,"      L3: %lu [A]     ", pMessmodul->values.irms[2]>>8);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}*/
;/*
;void sf_act(byte* pTexts[NR_ROWS]){
;
;    tMESSMODUL *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       ACT            ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %ld [W]     ", pMessmodul->values.act[0]);
;    sprintf(pTexts[4] ,"      L2: %ld [W]     ", pMessmodul->values.act[1]);
;    sprintf(pTexts[5] ,"      L3: %ld [W]     ", pMessmodul->values.act[2]);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}
;
;void sf_app(byte* pTexts[NR_ROWS]){
;
;    tMESSMODUL *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"       APP            ");
;    sprintf(pTexts[1] ,"      =========       ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"      L1: %ld [VA]     ", pMessmodul->values.app[0]);
;    sprintf(pTexts[4] ,"      L2: %ld [VA]     ", pMessmodul->values.app[1]);
;    sprintf(pTexts[5] ,"      L3: %ld [VA]     ", pMessmodul->values.app[2]);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;} */
;
;/* ENERGY */
;/*
;void sf_eapos_eaneg(byte* pTexts[NR_ROWS]){
;
;    tMESSMODUL *pMessmodul = &sMm[0];
;
;    sprintf(pTexts[0] ,"      EAPOS, EANEG    ");
;    sprintf(pTexts[1] ,"      ============    ");
;    sprintf(pTexts[2] ,"                      ");
;    sprintf(pTexts[3] ,"  L1: %ld , %ld       ", pMessmodul->values.eapos[0], pMessmodul->values.eaneg[0]);
;    sprintf(pTexts[4] ,"  L2: %ld , %ld       ", pMessmodul->values.eapos[1], pMessmodul->values.eaneg[1]);
;    sprintf(pTexts[5] ,"  L3: %ld , %ld       ", pMessmodul->values.eapos[2], pMessmodul->values.eaneg[2]);
;    sprintf(pTexts[6] ,"                      ");
;    sprintf(pTexts[7] ,"                      ");
;
;}*/
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
	BREQ PC+3
	JMP _0x2000008
	RJMP _0x2000006
_0x2000008:
	LD   R30,Y
	STS  198,R30
	ADIW R28,1
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x16
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
	BRNE PC+3
	JMP _0x2000016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ PC+3
	JMP _0x2000017
	RJMP _0x2000018
_0x2000017:
	__CPWRN 16,17,2
	BRSH PC+3
	JMP _0x2000019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x16
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRPL PC+3
	JMP _0x200001A
	CALL SUBOPT_0x16
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
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,11
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x15
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
	BREQ PC+3
	JMP _0x2000022
	CPI  R18,37
	BREQ PC+3
	JMP _0x2000023
	LDI  R17,LOW(1)
	RJMP _0x2000024
_0x2000023:
	CALL SUBOPT_0x4C
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x2000025
	CPI  R18,37
	BREQ PC+3
	JMP _0x2000026
	CALL SUBOPT_0x4C
	LDI  R17,LOW(0)
	RJMP _0x2000021
_0x2000026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+3
	JMP _0x2000027
	LDI  R16,LOW(1)
	RJMP _0x2000021
_0x2000027:
	CPI  R18,43
	BREQ PC+3
	JMP _0x2000028
	LDI  R20,LOW(43)
	RJMP _0x2000021
_0x2000028:
	CPI  R18,32
	BREQ PC+3
	JMP _0x2000029
	LDI  R20,LOW(32)
	RJMP _0x2000021
_0x2000029:
	RJMP _0x200002A
_0x2000025:
	CPI  R30,LOW(0x2)
	BREQ PC+3
	JMP _0x200002B
_0x200002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+3
	JMP _0x200002C
	ORI  R16,LOW(128)
	RJMP _0x2000021
_0x200002C:
	RJMP _0x200002D
_0x200002B:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200002E
_0x200002D:
	CPI  R18,48
	BRSH PC+3
	JMP _0x2000030
	CPI  R18,58
	BRLO PC+3
	JMP _0x2000030
	RJMP _0x2000031
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
	BREQ PC+3
	JMP _0x2000032
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
	BREQ PC+3
	JMP _0x2000038
	CALL SUBOPT_0x4D
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x4E
	RJMP _0x2000039
	RJMP _0x200003A
_0x2000038:
	CPI  R30,LOW(0x73)
	BREQ PC+3
	JMP _0x200003B
_0x200003A:
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4F
	CALL _strlen
	MOV  R17,R30
	RJMP _0x200003C
	RJMP _0x200003D
_0x200003B:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x200003E
_0x200003D:
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4F
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200003C:
	ANDI R16,LOW(127)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x200003F
	RJMP _0x2000040
_0x200003E:
	CPI  R30,LOW(0x64)
	BREQ PC+3
	JMP _0x2000041
_0x2000040:
	RJMP _0x2000042
_0x2000041:
	CPI  R30,LOW(0x69)
	BREQ PC+3
	JMP _0x2000043
_0x2000042:
	ORI  R16,LOW(4)
	RJMP _0x2000044
_0x2000043:
	CPI  R30,LOW(0x75)
	BREQ PC+3
	JMP _0x2000045
_0x2000044:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000046
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x50
	LDI  R17,LOW(10)
	RJMP _0x2000047
_0x2000046:
	__GETD1N 0x2710
	CALL SUBOPT_0x50
	LDI  R17,LOW(5)
	RJMP _0x2000047
	RJMP _0x2000048
_0x2000045:
	CPI  R30,LOW(0x58)
	BREQ PC+3
	JMP _0x2000049
_0x2000048:
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
	CALL SUBOPT_0x50
	LDI  R17,LOW(8)
	RJMP _0x2000047
_0x200004C:
	__GETD1N 0x1000
	CALL SUBOPT_0x50
	LDI  R17,LOW(4)
_0x2000047:
	SBRS R16,1
	RJMP _0x200004D
	CALL SUBOPT_0x4D
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETD1P
	CALL SUBOPT_0x51
	RJMP _0x200004E
_0x200004D:
	SBRS R16,2
	RJMP _0x200004F
	CALL SUBOPT_0x4D
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	CALL SUBOPT_0x51
	RJMP _0x2000050
_0x200004F:
	CALL SUBOPT_0x4D
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x51
_0x2000050:
_0x200004E:
	SBRS R16,2
	RJMP _0x2000051
	LDD  R26,Y+15
	TST  R26
	BRMI PC+3
	JMP _0x2000052
	__GETD1S 12
	CALL __ANEGD1
	CALL SUBOPT_0x51
	LDI  R20,LOW(45)
_0x2000052:
	CPI  R20,0
	BRNE PC+3
	JMP _0x2000053
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
	BRLO PC+3
	JMP _0x2000058
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
	CALL SUBOPT_0x4C
	SUBI R21,LOW(1)
	RJMP _0x2000056
_0x2000058:
_0x2000055:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BREQ PC+3
	JMP _0x200005D
_0x200005E:
	CPI  R19,0
	BRNE PC+3
	JMP _0x2000060
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
	CALL SUBOPT_0x4C
	CPI  R21,0
	BRNE PC+3
	JMP _0x2000063
	SUBI R21,LOW(1)
_0x2000063:
	SUBI R19,LOW(1)
	RJMP _0x200005E
_0x2000060:
	RJMP _0x2000064
_0x200005D:
_0x2000066:
	CALL SUBOPT_0x52
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRSH PC+3
	JMP _0x2000068
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
	SBRS R16,4
	RJMP _0x200006C
	RJMP _0x200006D
_0x200006C:
	CPI  R18,49
	BRLO PC+3
	JMP _0x200006F
	__GETD2S 8
	__CPD2N 0x1
	BRNE PC+3
	JMP _0x200006F
	RJMP _0x200006E
_0x200006F:
	RJMP _0x2000071
_0x200006E:
	CP   R21,R19
	BRSH PC+3
	JMP _0x2000073
	SBRC R16,0
	RJMP _0x2000073
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
	CALL SUBOPT_0x4E
	CPI  R21,0
	BRNE PC+3
	JMP _0x2000077
	SUBI R21,LOW(1)
_0x2000077:
_0x2000076:
_0x2000075:
_0x200006D:
	CALL SUBOPT_0x4C
	CPI  R21,0
	BRNE PC+3
	JMP _0x2000078
	SUBI R21,LOW(1)
_0x2000078:
_0x2000072:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x52
	CALL __MODD21U
	CALL SUBOPT_0x51
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x50
_0x2000065:
	__GETD1S 8
	CALL __CPD10
	BRNE PC+3
	JMP _0x2000067
	RJMP _0x2000066
_0x2000067:
_0x2000064:
	SBRS R16,0
	RJMP _0x2000079
_0x200007A:
	CPI  R21,0
	BRNE PC+3
	JMP _0x200007C
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x4E
	RJMP _0x200007A
_0x200007C:
_0x2000079:
_0x200007D:
_0x2000039:
	LDI  R17,LOW(0)
_0x2000037:
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
	CALL SUBOPT_0x53
	SBIW R30,0
	BREQ PC+3
	JMP _0x200007E
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_0x200007E:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x53
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL SUBOPT_0x3B
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
	CALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
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
	CALL SUBOPT_0x3B
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
	CALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG
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
_strcpy:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
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

	.CSEG

	.DSEG
_sMm:
	.BYTE 0x65
_sXport:
	.BYTE 0xA
_uartReadyTx:
	.BYTE 0x2
_uartBufferedTx:
	.BYTE 0x2
_uartTxBuffer:
	.BYTE 0x10
_uartRxOverflow:
	.BYTE 0x4
_uart0TxData_G001:
	.BYTE 0x30
_uart1TxData_G001:
	.BYTE 0x30
_UartRxFunc_G001:
	.BYTE 0x4
_sKernel:
	.BYTE 0x2
_sProcess:
	.BYTE 0x6E
_aux_flag_S0060000000:
	.BYTE 0x1
_aux_top_first_S0060001000:
	.BYTE 0x1
_aux_bottom_first_S0060001000:
	.BYTE 0x1
_uartRxBuffer:
	.BYTE 0xA
_comm_terminal_state:
	.BYTE 0x1
_sFrame_Rx:
	.BYTE 0x25
_sProtocol:
	.BYTE 0x2
_sDisplay:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _bufferInit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_UartRxFunc_G001)
	LDI  R27,HIGH(_UartRxFunc_G001)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	CALL SUBOPT_0x5
	__GETD2N 0x8
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	CALL __DIVD21U
	__SUBD1N 1
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	MOV  R0,R26
	LD   R26,X
	MOV  R30,R19
	LSL  R30
	OR   R30,R26
	MOV  R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xB:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	CALL _uartTransmitService
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	CALL _uartReceiveService
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(11)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sProcess)
	SBCI R31,HIGH(-_sProcess)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	__GETD2S 6
	__CPD2N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	__GETD2S 6
	CALL SUBOPT_0x11
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x18:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	CALL _SPI_MasterTransmit
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _maxq_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _maxq_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x1C:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _maxq_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1D:
	CALL __LSLW3
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSRD12
	__PUTD1S 4
	MOVW R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x186A0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1F:
	CALL __LSLW3
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _buffer2signed
	CALL __CWD1
	CALL __PUTD1S0
	MOVW R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	CALL __GETD1S0
	__GETD2N 0x19C
	CALL __MULD12
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x22:
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOVW R26,R18
	ADIW R26,4
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	MOVW R26,R18
	ADIW R26,12
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x26:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x27:
	CALL __GETD1P
	__CPD1N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	__GETD1N 0x0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LDD  R26,Z+2
	LDD  R27,Z+3
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2A:
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2B:
	CALL __MODW21U
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	CALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _abs
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2F:
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	CALL __SAVELOCR4
	LDI  R16,0
	__POINTWRM 18,19,_sMm
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(127)
	ST   -Y,R30
	JMP  _w_command

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	ST   -Y,R30
	CALL _w_command
	LDI  R30,LOW(16)
	ST   -Y,R30
	JMP  _w_command

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	ST   -Y,R30
	JMP  _w_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _w_command_data
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x35:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(_sDisplay)
	LDI  R31,HIGH(_sDisplay)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(17)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_sSCREEN_GROUP*2)
	SBCI R31,HIGH(-_sSCREEN_GROUP*2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpy
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	CALL _strcatf
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcatf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3C:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	JMP  _strncpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x3D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	JMP  _strncpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x3E:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	LDD  R26,Z+4
	LDD  R27,Z+5
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	ST   -Y,R27
	ST   -Y,R26
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	MOVW R30,R28
	ADIW R30,4
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	ST   -Y,R27
	ST   -Y,R26
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x45:
	SBIW R28,40
	CALL __SAVELOCR4
	__POINTWRM 16,17,_sMm
	LDD  R30,Y+44
	LDD  R31,Y+44+1
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x47:
	CALL _sprintf
	ADIW R28,12
	MOVW R30,R18
	ADIW R30,3
	LDD  R26,Y+44
	LDD  R27,Y+44+1
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x48:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(6)
	CALL __LOADLOCR4
	ADIW R28,46
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4B:
	CALL __GETD1P
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	MOVW R30,R18
	ADIW R30,3
	LDD  R26,Y+44
	LDD  R27,Y+44+1
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4C:
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
SUBOPT_0x4D:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4E:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4F:
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
SUBOPT_0x50:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	__GETD1S 8
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
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
