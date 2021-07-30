;******************************************************************************
;                                                                             *
;    Filename: ex_3-8.asm                                                     *
;    Date: October 17, 2020                                                    *
;    Description: Add 3 10 times to WREG and display the sum to PORTB using     *
;		  BNZ instruction.		                	      *
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
R2	EQU	0x61		; use 0x61 GPR address for delay1 ; size 1 byte
R3	EQU	0x62		; use 0x62 GPR address for delay2 ; size 1 byte
	
COUNT   EQU	0x25		; use loc 25H for counter ; size 1 byte
	MOVLW   D'10'		; WREG = 10 (decimal) for counter
	MOVWF   COUNT		; load the counter
	MOVLW   0		; WREG = 0
    
AGAIN:
	ADDLW	3		; add 3 to WREG (WREG = sum)
	RCALL	UPDATE
	DECF	COUNT, F
	BNZ	AGAIN
;	MOVWF   PORTB		; send sum to PORTB
	GOTO    $		; if count = 0, 'goto delay' will be skipped and
				; the program counter will loop at the current address
				; until reset
				
				
;------ UPDATE PORTB
UPDATE
	MOVWF	PORTB
	RCALL	DELAY
	MOVFF	PORTB, WREG
	RETURN
	
;------ DELAY ROUTINE
DELAY
	MOVLW	D'255'
	MOVWF	R2
RET	MOVLW	D'255'
	MOVWF	R3
HERE	NOP
	NOP
	DECF	R3, F
	BNZ	HERE
	DECF	R2, F
	BNZ	RET
	RETURN

	END