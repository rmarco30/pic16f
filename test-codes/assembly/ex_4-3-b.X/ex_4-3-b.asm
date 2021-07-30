;******************************************************************************
;                                                                             *
;    Filename: ex_4-3-b.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Create a square wave of 66% duty cycle on bit 7 of PORTC    *
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

R2  EQU	0x2
R3  EQU	0x3
R4  EQU	0x4
    
		BCF	TRISC, 7	;clear TRISC3 bit for output
BACK1		BSF	PORTC, 7	;RC3 = 1
		CALL	DELAY		;call the delay subroutine
		CALL	DELAY		;twice for 66%
		BCF	PORTC, 7	;RC3 = 0
		CALL	DELAY		;call delay once for 33%
		BRA	BACK1		;keep doing it


;--------- this is the delay subroutine, XTAL = 10MHz

DELAY		MOVLW	d'20'
		MOVWF	R4
BACK		MOVLW	d'100'
		MOVWF	R3
AGAIN		MOVLW	d'250'
		MOVWF	R2
HERE		NOP
		NOP
		DECF	R2, F
		BNZ	HERE
		DECF	R3, F
		BNZ	AGAIN
		DECF	R4, F
		BNZ	BACK
		RETURN	
		
		END




