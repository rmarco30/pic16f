;******************************************************************************
;                                                                             *
;    Filename: ex_3-6.asm                                                     *
;    Date: October 17, 2020                                                    *
;    Description: Add values 79H, F5H and E2H. Use BNC instruction to make    *
;		  the decisions.		                	      *
;    IDE: MPLABX v5.30							      *
;    Compiler: mpasm v5.86						      *
;******************************************************************************

#include <p18f4550.inc>

;******************************************************************************
; configuration bits		

    CONFIG WDT = OFF
    CONFIG MCLRE = ON
    CONFIG LVP = OFF
    CONFIG FOSC = INTOSCIO_EC   ; internal oscillator. Fosc = 1MHz
    CONFIG PBADEN = OFF		; PORTB<4:0> pins are configured as digital I/O on Reset)
				
;******************************************************************************
; reset vector ; this code will execute after a reset

	org     0               ; set program origin to 0    
	goto    main

;******************************************************************************
; main program starts here
    
main:
    
R2	EQU	0x07		;address 08H will be used for delay
R3	EQU	0x08		;address 08H will be used for delay
L_Byte	EQU	0x05		;assign RAM loc 5 to L_byte of sum
H_Byte	EQU	0x06		;assign RAM loc 6 to H_byte of sum
	CLRF	TRISB
	CLRF	TRISD
	CLRF	PORTD
	CLRF	PORTB
	
	MOVLW	0x0		;clear WREG (WREG = 0)
	MOVWF	H_Byte		;H_Byte = 0
	ADDLW	0x79		;WREG = 0 + 79H = 79H, C = 0
	BNC	N_1		;if C = 0, add next number
	INCF	H_Byte, F	;C = 1, increment (now H_Byte = 0)
N_1	ADDLW	0xF5		;WREG = 79H + F5H = 6EH and C = 1
	BNC	N_2		;branch of CY = 0
	INCF	H_Byte, F	;C = 1, increment (now H_Byte = 1)
	RCALL	UPDATE		;update the leds
N_2	ADDLW	0xE2		;WREG = 6E + E2 = 50 and C = 1
	BNC	OVER		;branch if C = 0
	INCF	H_Byte, F	;C = 1, increment (now H_Byte = 2)
	RCALL	UPDATE		;update the leds
OVER	MOVWF	L_Byte		;now L_Byte = 50H, and H_Byte = 02)
	GOTO	$
	
;------ this routine is called to update the leds for the sum
UPDATE
	MOVWF	PORTD		; copy sum to PORTD (low byte)
	MOVFF	H_Byte, PORTB	; copy sum to PORTB (high byte)
	RCALL	DELAY
	MOVFF	PORTD, WREG	; copy the sum again to WREG for next addition
	MOVFF	PORTB, H_Byte	; copy the sum again to H_bytte for next increment
	RETURN

;------ DELAY ROUTINE
DELAY
	MOVLW	D'255'
	MOVWF	R2
AGAIN	MOVLW	D'255'
	MOVWF	R3
HERE	NOP
	NOP
	DECF	R3, F
	BNZ	HERE
	DECF	R2, F
	BNZ	AGAIN
	RETURN

	END