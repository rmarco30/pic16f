;******************************************************************************
;                                                                             *
;    Filename:                                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             * 
;******************************************************************************
;                                                                             *
;    Files required: P18F4550.INC                                             *
;                                                                             *
;******************************************************************************

	#include <P18F4550.INC>     ; processor specific variable definitions

;******************************************************************************
;Configuration bits
    
    CONFIG WDT = OFF            ; disable watchdog timer
    CONFIG MCLRE = ON           ; MCLEAR Pin on
    CONFIG LVP = OFF            ; Low-Voltage programming disabled
    CONFIG FOSC = INTOSCIO_EC   ; Internal oscillator, port function on RA6

;******************************************************************************
;Variable definitions

;		UDATA

delay1  res 1
delay2  res 1

;******************************************************************************
;Reset vector
; This code will start executing when a reset occurs.

RESET_VECTOR	CODE	0x0000

                goto	main		;go to start of main code

;******************************************************************************
;Start of main program
; The main program code is placed here.
		


main:
;delay1  res	0x060
;delay2  res	0x061
    clrf    PORTD
    clrf    TRISD
    clrf    delay1
    clrf    delay2

loop:
    btg     PORTD, RD1          ;Toggle PORT D PIN 1 (20)
    
delay:
    decfsz  delay1, 1           ;Decrement Delay1 by 1, skip next instruction if Delay1 is 0
    goto    delay
    decfsz  delay2, 1
    goto    delay
    goto    loop
    
    END