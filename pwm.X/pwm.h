/* 
 * File:   
 * Author: 
 * Comments:
 * Revision history: 
 */


#ifndef PWM_H
#define	PWM_H

#include <xc.h>
#include <stdint.h>

/* this function initializes the pwm module.
 * 
 * PR2 value must be calculated using the formula:
 * 
 *      PR2_VAL = [PWMperiod/(4 * Tosc * TMR2Pre-scaler)] - 1
 * 
 *      where:
 *      PWMperiod = 1/PWMfrequency
 *      Tosc = 1/Fosc
 * 
 *      note: PR2_VAL must not exceed 255.
 */
void pwm_init(uint8_t PR2_VAL);


/* this function sets the duty cycle of the pwm.
 * 
 * PWMdc = (CCPR1L:CCP1CON<5:4> * Tosc * TMR2Pre-scaler)
 * 
 * example: PWMfreq = 20KHz, Desired Duty Cycle = 50%, TMR2Pre-scaler = 1, Fosc = 20MHz
 * 
 *          Duty Cycle * (1/PWMfreq) = (CCPR1L:CCP1CON<5:4>) * (1/Fosc) * 1
 *          0.50 * (1/20KHz) = (CCPR1L:CCP1CON<5:4>) * 1/20MHz * 1
 *          CCPR1L:CCP1CON<5:4> = 500 = DUTY_CYCLE_VAL
 *          thus, 50% duty cycle is mapped to 500, 100% duty cycle is mapped to 1000.
 * 
 *          note: the above calculation is a 10-bit pwm, resolution may change depending on the specifications of PWM,
 *                to check the resolution for different specifications, use this formula:
 * 
 *                  PWMresolution = (log(Fosc/Fpwm)/log(2)) bit
 * 
 *                       if 10-bit DUTY_CYCLE_VAL must not exceed 1024.
 *                       if 8-bit DUTY_CYCLE_VAL must not exceed 255.
 */
void pwm_duty_cycle(uint16_t DUTY_CYCLE_VAL);



void pwm_duty_cycle(uint16_t DUTY_CYCLE_VAL) {
    
    CCP1CONbits.CCP1Y = (DUTY_CYCLE_VAL) & 1;
    CCP1CONbits.CCP1X = (DUTY_CYCLE_VAL) & 2;
    CCPR1L = (DUTY_CYCLE_VAL) >> 2;
    
}

void pwm_init(uint8_t PR2_VAL) {
    
    PR2 = PR2_VAL;              // pwm frequency = 20KHz
    TRISC2 = 0;                 // set RC2 as output for the pwm
    T2CONbits.T2CKPS0 = 0;      // set timer2 pre-scaler value
    T2CONbits.T2CKPS1 = 0;      // set timer2 pre-scaler value
    CCP1CONbits.CCP1M3 = 1;     // choose pwm mode
    CCP1CONbits.CCP1M2 = 1;     // choose pwm mode
    T2CONbits.TMR2ON = 1;       // enable timer2
    
}

#endif