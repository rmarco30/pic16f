;******************************************************************************
;                                                                             *
;    Filename: ex_3-11.asm                                                    *
;    Date: October 17, 2020                                                   *
;    Description: This program will count from 0x00 to 0xFF and display the   *
;		  value in PORTB with delay each increment		      *
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
;R3	EQU	0x06
;R2	EQU	0x05
COUNT	EQU	0x07		;use loc 07 for count up
MYREG	EQU	0x08		;use loc 08 for delay


	MOVLW	0		;WREG = 0
	MOVWF	COUNT		;COUNT = 0
BACK	CALL	DISP
	GOTO	BACK
	
;-------increment and put it in PORTB
DISP 	INCF 	COUNT, F 	;increment
	MOVFF	COUNT, PORTB	;send it to PORTB
	CALL	DELAY
	RETURN			;return to caller

;-------this is the delay subroutine
	ORG 	300H		;put time delay at address 300H
DELAY	MOVLW	0xFF		;WREG = 255, the counter
	MOVWF	MYREG
AGAIN	NOP			;no operation wastes clock cycles
	NOP
	DECF 	MYREG, F
	BNZ 	AGAIN		;repeat until MYREG becomes 0
	RETURN			;return to caller
	
	END
	
	
;------ DELAY ROUTINE 2 - to have much longer delay uncomment this code and
;------ comment the above delay subroutine. also the R2 and R3 at top
	
;DELAY
;	MOVLW	D'255'
;	MOVWF	R2
;RET	MOVLW	D'255'
;	MOVWF	R3
;HERE	NOP
;	NOP
;	DECF	R3, F
;	BNZ	HERE
;	DECF	R2, F
;	BNZ	RET
;	RETURN
;
;	END
	
	
	
	
	

