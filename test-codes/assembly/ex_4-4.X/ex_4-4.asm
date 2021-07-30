;******************************************************************************
;                                                                             *
;    Filename: ex_4-4.asm				                      *
;    Date: October 24, 2020                                                   *
;    Description: Sends 45H to PORTD and pulse RC0 when RB2 becomes HIGH      *
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
    
		BSF	TRISB, 2	;make RB2 an input
		CLRF	TRISD		;make PORTD an output port
		CLRF	PORTD
		BCF	TRISC, 0	;make RD3 an output
		MOVLW	0x45		;WREG = 45H
AGAIN_1		BTFSS	PORTB, 2	;bit test RB2 for HIGH
		BRA	AGAIN_1		;keep checking if LOW
		MOVWF	PORTD		;issue WREG to PORTC
		BSF	PORTC, 0	;bit set fileReg RD3 (H-to-L)
		CALL	DELAY
		BCF	PORTC, 0	;bit clear fileReg RD3 (L)
		
		GOTO	main		;repeat from the start



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




