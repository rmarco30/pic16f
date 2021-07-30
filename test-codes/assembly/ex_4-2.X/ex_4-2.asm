;******************************************************************************
;                                                                             *
;    Filename: ex_4-2.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Toggle each bit of PORTD with a delay in between	      *
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
    
	CLRF	TRISD		;make PORTD an output port
	CLRF	PORTD
	CALL	DELAY
	BSF	PORTD,  0	;bit set turns on RD0
	CALL	DELAY		;delay before next one
	BSF	PORTD,  1	;turn on RD1
	CALL	DELAY		;delay before next one
	BSF	PORTD,  2
	CALL	DELAY
	BSF	PORTD,  3
	CALL	DELAY
	BSF	PORTD,  4
	CALL	DELAY
	BSF	PORTD,  5
	CALL	DELAY
	BSF	PORTD,  6
	CALL	DELAY
	BSF	PORTD,  7
	CALL	DELAY
	GOTO	main


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




