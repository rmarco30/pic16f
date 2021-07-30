;******************************************************************************
;                                                                             *
;    Filename: ex_4-1.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Toggle PORTB, PORTC and PORTD every 1/4 of a second	      *
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
    
R1	EQU	0x7
R2	EQU	0x8

	CLRF	TRISB
	CLRF	TRISC
	CLRF	TRISD
	MOVLW	0x55
	MOVWF	PORTB
	MOVWF	PORTC
	MOVWF	PORTD
L3	COMF	PORTB, F
	COMF	PORTC, F
	COMF	PORTD, F
	CALL	QDELAY
	BRA	L3

;--------- ¼ second delay

QDELAY
	MOVLW	D'200'
	MOVWF	R1
D1	MOVLW	D'200'
	MOVWF	R2
D2	NOP
	NOP
	DECF 	R2, F
	BNZ	D2
	DECF	R1, F
	BNZ	D1
	RETURN
	END


