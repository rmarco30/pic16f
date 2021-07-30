;******************************************************************************
;                                                                             *
;    Filename: ex_5-29.asm                                                    *
;    Date: November 14, 2020                                                  *
;    Description: Receive serial data via RC7                                 *
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

RCNT		EQU     0x20			;fileReg loc for counter
MYREG       EQU     0x21			;fileReg loc for incoming byte
            
            CLRF    PORTB
            CLRF    TRISB
            
            BSF		TRISC, 7		;make RC7 and input bit
            MOVLW	0x8             ;counter
            MOVWF	RCNT			;load the counter
            
AGAIN       
            RRCF	MYREG, F		;rotate right carry into MYREG
            
            BTFSC	PORTC, 7		;skip if RC7 = 0
            BSF		STATUS, C		;carry = 1
            
            BTFSS	PORTC, 7		;skip if RC7 = 1
            BCF		STATUS, C		;otherwise carry = 0
            
            
            MOVF    MYREG, W
            IORWF   PORTB, F
            RRNCF   PORTB
            DECF	RCNT, F         ;decrement the counter
            BNZ		AGAIN           ;repeat until RCNT = 0
                                    ;now loc 21H has the byte

            END



