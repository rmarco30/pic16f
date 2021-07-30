;******************************************************************************
;                                                                             *
;    Filename: ex_3-20.asm                                                    *
;    Date: October 24, 2020                                                   *
;    Description: Load 55H to PORTB and toggle it every 1 second	      *
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
		CLRF	TRISB
		CLRF	PORTB
		MOVLW	0x55		;load WREG with 55H
		MOVWF	PORTB		;send 55H to PORTB
BACK1		CALL	DELAY_500MS	;time delay
		COMF	PORTB		;complement PORTB
		GOTO	BACK1		;keep doing this indefinitely

;--------- this is the delay subroutine

DELAY_500MS	MOVLW	d'20'
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

