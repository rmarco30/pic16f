/*
 * PIC16F877A PWM demonstration
 */

#define _XTAL_FREQ      20000000

#include "config-bits.h"
#include "pwm.h"
#include <xc.h>


uint16_t value;

void main(void) {
    
    pwm_init(249);

    while(1) {
        
        value = 0;
        
        while(value < 1000) {
            pwm_duty_cycle(value);
            value++;
            __delay_ms(1);
        }
        
        while(value > 0) {
            pwm_duty_cycle(value);
            value--;
            __delay_ms(1);
        }
    }

}