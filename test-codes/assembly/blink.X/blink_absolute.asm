;***************************************************************************

#include <p18f4550.inc>

;***************************************************************************
; configuration bits

    CONFIG WDT = OFF            ; disable watchdog timer
    CONFIG MCLRE = ON           ; MCLEAR Pin on
    CONFIG LVP = OFF            ; Low-Voltage programming disabled
    CONFIG FOSC = INTOSCIO_EC   ; Internal oscillator, port function on RA6

;***************************************************************************
; variable definitions

    cblock  0x060               ; general purpose register start at address 0x060
    delay1                  ; delay1 will have address 0x061
    delay2             ; delay2 will have address 0x062
    endc

;***************************************************************************
; reset vector. this code will execute after a reset

    org     0                   
    goto    main

;***************************************************************************
; main program starts here
    
main:
; delay1 res 0x061
; delay2 res 0x062
    clrf    PORTD
    clrf    TRISD
    movlw   0xff
    movwf   delay1
    movwf   delay2

loop:
    btg     PORTD, RD1          ;Toggle PORT D PIN 1 (20)

delay:
    decfsz  delay1, 1           ;Decrement Delay1 by 1, skip next instruction if Delay1 is 0
    goto    delay
    decfsz  delay2, 1
    goto    delay
    goto    loop

    end