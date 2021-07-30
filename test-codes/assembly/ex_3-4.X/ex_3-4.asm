;******************************************************************************
;                                                                             *
;    Filename: ex_3-4.asm                                                     *
;    Date: October 4, 2020                                                    *
;    Description: Load value 55h to PORTB and complement it 700 times 	      *
;    IDE: MPLABX v5.30							      *
;    Compiler: mpasm v5.86						      *
;******************************************************************************

#include <p18f4550.inc>

;******************************************************************************
; configuration bits		

    CONFIG WDT = OFF            ; disable watchdog timer
    CONFIG MCLRE = ON           ; MCLEAR Pin on
    CONFIG LVP = OFF            ; Low-Voltage programming disabled (necessary for debugging)
    CONFIG FOSC = INTOSCIO_EC   ; Internal oscillator, port function on RA6
    CONFIG  PBADEN = OFF        ; PORTB<4:0> pins are configured as digital I/O on Reset)
				
;***************************************************************************
; reset vector ; this code will execute after a reset

	org     0               ; set program origin to 0    
	goto    main

;******************************************************************************
; main program starts here
    
main:
	
        clrf    TRISB		; PORTB<7:0> as output
        clrf    PORTB		; clear PORTB
delay1	equ     0x061		; use 0x061 for delay1 ; size 1 byte
delay2	equ     0x062		; use 0x062 for delay2 ; size 1 byte
        clrf	delay1		; initialize delay1 variable to 0
        clrf	delay2		; initialize delay2 variable to 0
	
r1      equ     0x025		
r2      equ     0x026
count_1 equ     d'10'
count_2	equ     d'70'
        movlw	0x55		; WREG = 55h
        movwf	PORTB		; PORTB = 55h
        movlw	count_1		; WREG = 10, outer loop count value
        movwf	r1          ; load 10 into loc 25h(outer loop count)
	
loop_1:
        movlw	count_2		; WREG = 70, inner loop count value
        movwf	r2          ; load 70 into loc 26h

loop_2:
        comf	PORTB, f	; complement PORTB SFR
        decf	r2, f		; decrement fileReg loc 26 (inner loop)
        bnz     delay           ; repeat it 70 times; delay to visualize the process
        decf	r1, f		; decrement fileReg loc 25 (outer loop)
        bnz     loop_1          ; repeat it 10 times
        goto	$           ; if r1=0, loop to current address (this address)

delay:                  ; delay routine
        decfsz  delay1, 1
        goto    delay
        decfsz  delay2, 1
        goto    delay
        goto    loop_2

	
        end


