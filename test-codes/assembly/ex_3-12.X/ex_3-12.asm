;******************************************************************************
;                                                                             *
;    Filename: ex_3-12.asm                                                    *
;    Date: October 17, 2020                                                   *
;    Description: Toggle PORTB by sending values 55H and AAH continuosly.     *
;		  This program is a much efficient version of ex_3-9	      *
;    IDE: MPLABX v5.30							      *
;    Compiler: mpasm v5.86						      *
;******************************************************************************

#include <p18f4550.inc>

;******************************************************************************
; configuration bits		

    CONFIG WDT = OFF
    CONFIG MCLRE = ON
    CONFIG LVP = OFF
    CONFIG FOSC = INTOSCIO_EC   ; internal oscillator. Fosc = 1MHz
    CONFIG PBADEN = OFF		; PORTB<4:0> pins are configured as digital I/O on Reset)
				
;******************************************************************************
; reset vector ; this code will execute after a reset

	org     0               ; set program origin to 0    
	goto    main

;******************************************************************************
; main program starts here
    
main:
	CLRF    TRISB		; PORTB<7:0> as output
	CLRF    PORTB		; clear PORTB

MYREG	EQU	0x08
BACK	MOVLW 	0x55		;load WREG with 55H
	MOVWF 	PORTB		;issue value in PORTB SFR
	RCALL 	DELAY		;time delay
	COMF	PORTB, F	;complement PORT B SFR
	BRA	BACK		;keep doing this indefinitely
	
;----------------------- this is the delay subroutine
	
DELAY	MOVLW 	0xFF		;WREG = 255, the counter
	MOVWF 	MYREG
AGAIN	NOP			;no operation wastes clock cycles
	NOP
	DECF 	MYREG, F
	BNZ 	AGAIN		;repeat until MYREG becomes 0
	RETURN			;return to caller
	
	
	END			;end of asm file


