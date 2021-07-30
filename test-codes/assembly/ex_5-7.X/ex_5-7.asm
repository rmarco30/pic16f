;******************************************************************************
;                                                                             *
;    Filename: ex_5-7.asm                                                     *
;    Date: November 14, 2020                                                  *
;    Description: Subtract two 16 bit numbers 2762H - 1296H store the result  *
;                 in H_Byte and L_Byte.                                       *
;    IDE: MPLABX v5.30                                                        *
;    Compiler: mpasm v5.86                                                    *
;                                                                             *
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

l_byte  EQU     0x06
h_byte  EQU     0x07
        
        CLRF    PORTD
        CLRF    PORTB
        CLRF    TRISD
        CLRF    TRISB
        
        MOVLW   0x62
        MOVWF   l_byte
        MOVLW   0x27
        MOVWF   h_byte

        MOVLW   0x96            ;load the low byte (WREG = 96H)
        SUBWF   0x06, F			;F = F - W = 62 - 96 = CCH, C = borrow = 0, N = 1
        MOVLW   0x12            ;load the high byte (WREG = 12H)
        SUBWFB  0x07, F			;F = F - W - B, sub byte with the borrow
        MOVFF   h_byte, PORTB
        MOVFF   l_byte, PORTD
                    
		END