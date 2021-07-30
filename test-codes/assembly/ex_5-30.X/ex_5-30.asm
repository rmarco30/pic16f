;******************************************************************************
;                                                                             *
;    Filename: ex_5-30.asm                                                    *
;    Date: November 14, 2020                                                  *
;    Description: Count the number of 1's in a given byte                     *
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

R1		EQU     0x20			;fileReg loc for number of 1s
COUNT	EQU     0x21			;fileReg loc for counter
VALREG	EQU     0x22			;fileReg for the byte
D2      EQU     0x05            ;for delay
D3      EQU     0x06            ;for delay
        
        CLRF    PORTB
        CLRF    PORTD
        CLRF    TRISB
        CLRF    TRISD
        
		BCF		STATUS, C		;C = 0
		CLRF	R1              ;R1 keeps the number of 1s
		MOVLW	0x08            ;counter = 08 to rotate 8 times
		MOVWF	COUNT
		MOVLW	0x97            ; 1001 0111
		MOVWF	VALREG
        MOVWF   PORTB
        
AGAIN	
        RLCF	VALREG, F		;rotate it through the C once
		BNC		NEXT			;check for C
		INCF	R1, F           ;if C = 1 then add one to R1 reg
        MOVFF   R1, PORTD
        CALL    DELAY
        CALL    DELAY
        
NEXT	DECF	COUNT, F
		BNZ		AGAIN           ;go through this 8 times
                                ;now loc 0x20 has the number of 1s

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
