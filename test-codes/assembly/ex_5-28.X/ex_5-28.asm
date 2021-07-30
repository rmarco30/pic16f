;******************************************************************************
;                                                                             *
;    Filename: ex_5-28.asm                                                    *
;    Date: November 14, 2020                                                  *
;    Description: Send 0x41 serially via PORTA0. Put HIGH at the start and    *
;                 end of data (total of 10 bits)                              *
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

D2          EQU     0x02
D3          EQU     0x03
RCNT		EQU     0x20			;fileReg loc for counter
MYREG       EQU     0x21			;fileReg loc for rotate
VAL         EQU     0x22
            
            CLRF    PORTA
            CLRF    TRISA
            MOVLW   0x0f
            MOVWF   ADCON1
            MOVLW   0x07
            MOVWF   CMCON
            CLRF    PORTD
            CLRF    TRISD
            CLRF    PORTB
            CLRF    TRISB
            

            MOVLW	0x41			;WREG = 41. value to be send serially
            MOVWF   MYREG
            MOVWF   VAL
            BCF		STATUS, C		;C = 0
            MOVLW	0x8				;counter
            MOVWF	RCNT			;load the counter
            BSF		PORTA, 0		;RB1 = high
            INCF    PORTB
            CALL    DELAY
            CALL    DELAY

AGAIN
            RRCF	MYREG, F		;rotate right via carry
            RRNCF   PORTD, F
            
            BNC		OVER
            BSF		PORTA, 0		;set the carry bit to PB0
            BSF     PORTD, 7
            INCF    PORTB
            CALL    DELAY
            CALL    DELAY
            BRA		NEXT

OVER
            BCF		PORTA, 0
            BCF     PORTD, 7
            INCF    PORTB
            CALL    DELAY
            CALL    DELAY

NEXT
            
            DECF	RCNT
            BNZ		AGAIN
            BSF		PORTA, 0		;RB1 = high
            INCF    PORTB
            
            GOTO    $
            
;----------------------- this is the delay subroutine
	
DELAY
        MOVLW       D'255'
        MOVWF       D2
RET     MOVLW       D'255'
        MOVWF       D3
HERE	NOP
        NOP
        DECF        D3, F
        BNZ         HERE
        DECF        D2, F
        BNZ         RET
        RETURN

        END
