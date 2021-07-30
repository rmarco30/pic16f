;******************************************************************************
;                                                                             *
;    Filename: ex_4-8.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Send status of pin RB0 to pin RB7 using BTFSS instruction.  *
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
    
		BSF	TRISB, 0	;make RB0 an input
		BCF	TRISB, 7	;make RB7 an output
AGAIN		BTFSS	PORTB, 0	;bit test RB0 for HIGH
		GOTO	OVER		;it must be LOW (BRA is OK too)
		BSF	PORTB, 7
		GOTO	AGAIN		;we can use BRA too
OVER		BCF	PORTB, 7
		GOTO	AGAIN		;we can use BRA too
		
		END




