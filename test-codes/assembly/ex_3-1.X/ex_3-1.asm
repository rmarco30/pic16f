;******************************************************************************
;                                                                             *
;    Filename: ex_3-1.asm                                                     *
;    Date: October 4, 2020                                                    *
;    Description: Add 10 times to WREG and display the sum to PORTB using     *
;		  DECFSZ instruction.		                	      *
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
    CONFIG  PBADEN = OFF        ; PORTB<4:0> pins are configured as digital I/O on Reset)
				
;******************************************************************************
; reset vector ; this code will execute after a reset

	org     0               ; set program origin to 0    
	goto    main

;******************************************************************************
; main program starts here
    
main:
	clrf    TRISB		; PORTB<7:0> as output
	clrf    PORTB		; clear PORTB
delay1	equ	0x61		; use 0x61 GPR address for delay1 ; size 1 byte
delay2	equ	0x62		; use 0x62 GPR address for delay2 ; size 1 byte
	clrf	delay1		; initialize delay1 variable to 0
	clrf	delay2		; initialize delay2 variable to 0
	
count   equ	0x25		; use loc 25H for counter ; size 1 byte
	movlw   d'10'		; WREG = 10 (decimal) for counter
	movwf   count		; load the counter
	movlw   0		; WREG = 0
    
again:
	addlw	3		; add 3 to WREG (WREG = sum)
	movwf   PORTB		; send sum to PORTB
	decfsz  count, f	; decrement counter, skip if count = 0
	goto	delay		; delay to visualize the process
	goto    $		; if count = 0, 'goto delay' will be skipped and
				; the program counter will loop at the current address
				; until reset

delay:				; delay routine
	decfsz  delay1, 1
	goto    delay
	decfsz  delay2, 1
	goto    delaY
	goto    again

	
	end