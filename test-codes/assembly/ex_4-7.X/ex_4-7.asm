;******************************************************************************
;                                                                             *
;    Filename: ex_4-7.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Send ASCII 'Y' to PORTD when RB2 = 1, ASCII 'N' if RB2 = 0  *
;		  use BTFSC instruction				              *
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
    
		BSF	TRISB, 2	;make RB2 an input
		CLRF	TRISD		;make PORTD an output port
AGAIN		BTFSC	PORTB, 2	;bit test RB2 for LOW
		BRA	OVER		;it must be HIGH
		MOVLW	A'N'		;WREG = 'N' ASCII letter N
		MOVWF	PORTD		;issue WREG to PORTD
		BRA	AGAIN		;we can use GOTO
OVER		MOVLW	A'Y'		;WREG = 'Y' ASCII letter Y
		MOVWF	PORTD		;issue WREG to PORTD
		BRA	AGAIN		;we can use GOTO

		END







