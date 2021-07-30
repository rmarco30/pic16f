#include <p18f4550.inc>

    CONFIG WDT = OFF            ; disable watchdog timer
    CONFIG MCLRE = ON           ; MCLEAR Pin on
    CONFIG LVP = OFF            ; Low-Voltage programming disabled (necessary for debugging)
    CONFIG FOSC = INTOSCIO_EC   ;Internal oscillator, port function on RA6

    cblock  0
        delay1: 1
        delay2: 1
    endc

    org     0

start:
    clrf    PORTD
    clrf    TRISD
    clrf    delay1
    clrf    delay2

main:
    btg     PORTD, RD1          ;Toggle PORT D PIN 1 (20)
    
delay:
    decfsz  delay1, 1           ;Decrement Delay1 by 1, skip next instruction if Delay1 is 0
    goto    delay
    decfsz  delay2, 1
    goto    delay
    goto    main
    
    end