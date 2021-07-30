;******************************************************************************
;                                                                             *
;    Filename: ex_3-9.asm                                                     *
;    Date: October 17, 2020                                                   *
;    Description: Toggle PORTB by sending values 55H and AAH continuosly      *
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
    
MYREG	EQU 	0x08		;use location 08 as counter
BACK	MOVLW 	0x55		;load WREG with 55H
	MOVWF 	PORTB		;send 55H to Port B
	CALL 	DELAY		;time delay
	MOVLW 	0xAA		;load WREG with AA (in hex)
	MOVWF 	PORTB		;send AAH to Port B
	CALL 	DELAY
	GOTO 	BACK		;keep doing this indefinitely
	
;----------------------- this is the delay subroutine
	ORG 	300H		;put time delay at address 300H
DELAY	MOVLW 	0xFF		;WREG = 255, the counter
	MOVWF 	MYREG
AGAIN	NOP			;no operation wastes clock cycles
	NOP
	DECF 	MYREG, F
	BNZ 	AGAIN		;repeat until MYREG becomes 0
	RETURN			;return to caller
	END			;end of asm file