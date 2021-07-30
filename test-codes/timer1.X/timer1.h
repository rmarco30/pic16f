#ifndef TIMER1_H
#define TIMER1_H

#include <stdint.h>
#include <xc.h>


uint8_t overflow = 0;

void timer1_init(void);
void __interrupt() ISR(void);


void timer1_init(void) {
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR1IE = 1;
    PIR1bits.TMR1IF = 0;
    T1CONbits.TMR1CS = 0;
    T1CONbits.T1CKPS1 = 0;
    T1CONbits.T1CKPS0 = 0;
    TMR1 = 15536;   
}


void __interrupt() ISR(void) {
    
    if(PIR1bits.TMR1IF) {
        overflow++;     // 1 overflow = 10ms
        TMR1 = 15536;   // pre-load value to timer1 each overflow
        PIR1bits.TMR1IF = 0;     // clear timer1 interrupt flag
    }
    
// used for demo_timer1 in proteus    
//    if(overflow == 100) {
//            PORTBbits.RB0 = ~PORTBbits.RB0;
//            overflow = 0;
//        }
    
}

#endif