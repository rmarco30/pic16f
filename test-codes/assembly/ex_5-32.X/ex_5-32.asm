;******************************************************************************
;                                                                             *
;    Filename: ex_5-32.asm                                                    *
;    Date: November 14, 2020                                                  *
;    Description: Convert BCD to ASCII numbers                                *
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

BCD_VAL	EQU     0x29
L_ASC	EQU     0x06			;set aside file register location
H_ASC	EQU     0x07			;set aside file register location
    
        CLRF    PORTB
        CLRF    PORTD
        CLRF    TRISB
        CLRF    TRISD
	
		MOVLW	BCD_VAL         ;WREG = 29H, packed BCD
		ANDLW	0x0F			;mask the uppter nibble (W = 09)
		IORLW	0x30			;make it an ASCII, W = 39H (?9?)
		MOVWF	L_ASC           ;save it (L_ASC = 39H ASCII char)
        MOVWF   PORTD
		MOVLW	BCD_VAL         ;W = 29H get BCD data once more
		ANDLW	0xF0			;mask the lower nibble (W = 20H)
		SWAPF	WREG, W         ;swap nibbles (WREG = 02H)
		IORLW	0x30			;make it an ASCII, W = 32H (?2?)
		MOVWF	H_ASC           ;save it (H_ASC = 32H ASCII char)
        MOVWF   PORTB

        GOTO    $

        END
