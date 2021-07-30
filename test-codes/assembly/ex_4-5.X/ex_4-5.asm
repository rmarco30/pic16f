;******************************************************************************
;                                                                             *
;    Filename: ex_4-5.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Send LOW to HIGH pulse to RD5 when RB3 goes LOW	      *
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
    
		BSF	TRISB, 3	;make RB3 an input
		BCF	TRISD, 5	;make RD5 an output
HERE_1		BTFSC	PORTB, 3	;keep monitoring RB3 for HIGH
		BRA	HERE_1		;stay in the loop
		BSF	PORTD, 5	;make RD5 HIGH
		CALL	DELAY
		BCF	PORTD, 5	;make RD5 LOW for H-to-L
		BRA	HERE_1




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




