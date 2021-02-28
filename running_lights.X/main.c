/*
 * turned on led will shift 1 bit to the left or right depending on the state of
 * direction variable controlled by a button at PORTB0 configured with external interrupt.
 */

#define _XTAL_FREQ          20000000
#define SHIFT_DELAY         100

#include <xc.h>
#include "config-bits.h"

volatile uint8_t direction = 0;

void main() {
    
    OPTION_REG = 0x3f;                                  // PORTB pull-ups enabled, INTEDG set to falling edge
    INTCON = 0x90;                                      // GIE enabled, INTE enabled
    
    TRISD = 0x00;                                       // initialize all bits of PORTD as output
    TRISB |= 0x01;                                      // initialize PORTB0 as input
    PORTD |= 0x01;                                      // initialize PORTD0 to high

    
    while(1) {
        
        switch(direction) {                             // poll direction variable
                
            case 0:                                     // shift left if direction = 0
                __delay_ms(SHIFT_DELAY);
                PORTD = (unsigned char)(PORTD << 1);
                
                if(PORTD == 0x00) {                     // if PORTD overflows reset to 0x01
                    PORTD = 0x01;
                }
                break;
                
            case 1:                                     // shift left if direction = 1
                __delay_ms(SHIFT_DELAY);
                PORTD = (unsigned char)(PORTD >> 1);
                
                if(PORTD == 0x00) {                     // if PORTD overflows reset to 0x80
                    PORTD = 0x80;
                }
                break;
                
            default:
                // do nothing
                break;
        }
    }
}

void __interrupt() interrupt_manager(void) {
    INTCONbits.GIE = 0;                                 // disable Global Interrupt to service
                                                        // whichever interrupt flag is set first
    if(INTCONbits.INTF) {
        direction = !direction;                         // toggle the direction variable
        INTF = 0;
    }
    
    INTCONbits.GIE = 1;
}