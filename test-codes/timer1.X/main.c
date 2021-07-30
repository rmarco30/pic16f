/*
 * PIC16F877A Timer1 demonstration
 */

#define _XTAL_FREQ 20000000

#include "config-bits.h"
#include "timer1.h"
#include <xc.h>



void main() {
    
    TRISB0 = 0;
    TRISB1 = 0;
    TRISD0 = 1;
    PORTBbits.RB0 = 0;
    T1CONbits.TMR1ON = 1;
    
    timer1_init();
    
    while(1) {
        
        if(overflow == 100) {
            RB0 = ~RB0;
            overflow = 0;
        }
        
        RB1 = ~RB1;
        __delay_ms(250);
        
    }
}