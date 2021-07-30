;******************************************************************************
;                                                                             *
;    Filename: ex_5-6.asm                                                     *
;    Date: November 14, 2020                                                  *
;    Description: Subtract 4C - 6E store the result at MYREG                  *
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

D2      EQU     0x04            ;for delay
D3      EQU     0x05            ;for delay
MYREG	EQU     0x20
        
        CLRF    PORTB
        CLRF    TRISB
        CLRF    PORTD
        CLRF    TRISD
        
		MOVLW	0x4C			;load WREG (WREG = 4CH)
        MOVWF   PORTB
		MOVWF	MYREG           ;MYREG = 4ch
        CALL    DELAY
        CALL    DELAY
        CALL    DELAY
		MOVLW	0x6E			;WREG = 6EH
        MOVWF   PORTD
        CALL    DELAY
        CALL    DELAY
        CALL    DELAY
        MOVF    PORTD, W
		SUBWF	MYREG, W		;WREG=MYREG-WREG. 4C-6E = DE, N=1
		BNN		NEXT			;if N=0 (C=1), jump to NEXT target
		NEGF	WREG			;take 2's complement of WREG
    	CLRF    PORTB
        MOVWF	MYREG           ;save the result in MYREG
        MOVFF   MYREG, PORTD
        GOTO    $
        
NEXT	CLRF    PORTB
        MOVWF	MYREG           ;save the result in MYREG
        MOVFF   MYREG, PORTD

        
        GOTO    $

        
;----------------------- this is the delay subroutine
	
DELAY
        MOVLW	D'255'
        MOVWF	D2
RET     MOVLW	D'255'
        MOVWF	D3
HERE	NOP
        NOP
        DECF	D3, F
        BNZ     HERE
        DECF	D2, F
        BNZ     RET
        RETURN
        

		END










