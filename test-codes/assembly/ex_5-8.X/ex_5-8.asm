;******************************************************************************
;                                                                             *
;    Filename: ex_5-8.asm                                                     *
;    Date: November 14, 2020                                                  *
;    Description: Convert 0xFD to decimal.                                    *
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

NUME		EQU     0x15			;RAM location for NUME
QU          EQU     0x20			;RAM location for quotient
RMND_L      EQU 	0x22            ;decimal ones place
RMND_M      EQU     0x23            ;decimal tens place
RMND_H      EQU     0x24            ;decimal hundreds place
MYNUM       EQU     0xFD			;FDH = 253 in decimal
MYDEN       EQU     D'10'           ;253/10
       
            CLRF    PORTA
            CLRF    PORTB
            CLRF    PORTD
            CLRF    TRISA
            CLRF    TRISB
            CLRF    TRISD
            MOVLW   0x0f
            MOVWF   ADCON1
            MOVLW   0x07
            MOVWF   CMCON
            CLRF    W
		
            MOVLW   MYNUM
            MOVWF   NUME
            MOVLW   MYDEN
            CLRF    QU
D_1         INCF    QU
            SUBWF   NUME
            BC      D_1
            ADDWF   NUME
            DECF    QU
            MOVFF   NUME,RMND_L
            MOVFF   QU, NUME
            CLRF    QU
D_2         INCF    QU
            SUBWF   NUME
            BC      D_2
            ADDWF   NUME
            DECF    QU
            MOVFF   NUME, RMND_M
            MOVFF   QU, RMND_H
            MOVFF   RMND_L, PORTD
            MOVFF   RMND_M, PORTB
            MOVFF   RMND_H, PORTA     
HERE        GOTO    HERE

            
            END
