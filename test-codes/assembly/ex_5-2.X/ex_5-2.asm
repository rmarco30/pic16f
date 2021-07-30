;******************************************************************************
;                                                                             *
;    Filename: ex_5-2.asm                                                     *
;    Date: November 14, 2020                                                  *
;    Description: Add the values 7D, EB, C5, 5B store the sum at L_Byte       *
;                   and H_Byte.                                               *
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

D2      EQU     0x04        ;for delay
D3      EQU     0x05        ;for delay
R1      EQU     0x40
R2      EQU     0x41
R3      EQU     0x42
R4      EQU     0x43      
L_Byte  EQU     0x06        ;assign RAM loc 6 to L_byte of sum
H_Byte  EQU     0x07        ;assign RAM loc 7 to H_byte of sum
  
        MOVLW   0x7D
        MOVWF   R1
        MOVLW   0xEB
        MOVWF   R2
        MOVLW   0xC5
        MOVWF   R3
        MOVLW   0x5B
        MOVWF   R4
        CLRF    PORTB
        CLRF    PORTD
        CLRF    TRISB
        CLRF    TRISD

        MOVLW 	0			;clear WREG (WREG = 0)
        MOVWF 	H_Byte		;H_Byte = 0
        ADDWF 	0x40, W		;WREG = 0 + 7DH, C=0
        BNC     N_1			;branch if C = 0
        INCF 	H_Byte, F	;increment (now H_Byte = 0)
        
N_1     CALL    UPDATE
        CALL    DELAY
        CALL    DELAY
        CALL    DELAY
        MOVF    PORTD, W
        ADDWF 	0x41, W		;WREG = 7D + EB = 68H and C = 1
        BNC 	N_2			;
        INCF 	H_Byte, F	;C = 1, increment (now H_Byte = 1)
        
N_2     CALL    UPDATE
        CALL    DELAY
        CALL    DELAY
        CALL    DELAY
        MOVF    PORTD, W
        ADDWF 	0x42, W		;WREG = 68 + C5 = 2D and C = 1
        BNC 	N_3			;
        INCF	H_Byte		;C = 1, increment (now H_Byte = 2)
        
N_3     CALL    UPDATE
        CALL    DELAY
        CALL    DELAY
        CALL    DELAY
        MOVF    PORTD, W
        ADDWF	0x43, W		;WREG = 2D + 5B = F8h and C = 0
        BNC		N_4			;
        INCF	H_Byte, F	;(H_Byte = 2)
        
N_4     CALL    UPDATE
        CALL    DELAY
        CALL    DELAY
        CALL    DELAY
        MOVF    PORTD, W
        MOVWF	L_Byte		;now L_Byte = 88h
        GOTO    $           ;stay here forever


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

;----------------------- routine to update PORTB and PORTD
UPDATE  MOVWF   PORTD
        MOVFF   H_Byte, PORTB
        RETURN

		END
