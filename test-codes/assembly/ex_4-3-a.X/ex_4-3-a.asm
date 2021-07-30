;******************************************************************************
;                                                                             *
;    Filename: ex_4-3-a.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Create a square wave of 50% duty cycle on bit 0 of PORTC    *
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
    
		BCF	TRISC, 0	;clear TRIS bit for RC0 = out
HERE1		BSF	PORTC, 0	;set to HIGH RC0 (RC0 = 1)
		CALL	DELAY	;call the delay subroutine
		BCF	PORTC, 0	;RCO = 0
		CALL	DELAY
		BRA	HERE1		;keep doing it


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




