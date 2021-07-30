;******************************************************************************
;                                                                             *
;    Filename: ex_4-9.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Send status of pin RB0 to fileReg loc 0x20, use RD0 to see  *
;		  its value.						      *
;    IDE: MPLABX v5.30							      *
;    Compiler: mpasm v5.86						      *
;******************************************************************************

#include <p18f4550.inc>

;******************************************************************************
; configuration bits		

    CONFIG WDT = OFF
    CONFIG MCLRE = ON
    CONFIG LVP = OFF
    CONFIG FOSC = HS		; internal oscillator. Fosc = 1MHz
    CONFIG PBADEN = OFF		; PORTB<4:0> pins are configured as digital I/O on Reset)
				
;******************************************************************************
; reset vector ; this code will execute after a reset

	org     0               ; set program origin to 0    
	goto    main

;******************************************************************************
; main program starts here
    
main:
    
MYBITREG	EQU     0x20                ;set aside loc 0x20 reg
		
            BCF     TRISD, 0
            BSF     TRISB, 0            ;make RB0 an input
AGAIN		BTFSS	PORTB, 0            ;bit test RB0 for HIGH
            GOTO	OVER                ;it must be LOW (BRA is OK too)
            BSF     MYBITREG, 0         ;set bit 0 of fileReg
            MOVFF	MYBITREG, PORTD	    ;copy value of MYBITREG to PORTD
            GOTO	AGAIN               ;we can use BRA too
OVER		BCF     MYBITREG, 0         ;clear bit 0 of fileReg
            MOVFF	MYBITREG, PORTD	    ;copy value of MYBITREG to PORTD
            GOTO	AGAIN               ;we can use BRA too

            END




