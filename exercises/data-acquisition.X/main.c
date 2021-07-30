/*
 * File:   main.c
 * Author: Marco
 *
 * Created on October 21, 2020, 2:04 PM
 */

#include "config.h"
#include "lcd_4bit.h"
#include <stdint.h>
#include <stdio.h>
#include <xc.h>
#define _XTAL_FREQ      20000000
#define trig_pin        RC0
#define echo_pin        RC1

void timer1_init(void);
long map(uint16_t, uint16_t, uint16_t, uint16_t, uint16_t);
uint16_t overflow;


void main(void) {
    
    uint16_t distance;
    uint16_t duration;
    char chr_distance[20];
    char chr_duration[20];
    
    TRISD = 0x00;
    PORTD = 0x00;
    TRISC0 = 0;
    TRISC1 = 1;
    PORTCbits.RC0 = 1;
    
    timer1_init();
    lcd_init();
    
    lcd_write_string("DAS");
    lcd_goto_xy(2,1);
    lcd_write_string("usm simulation");
    __delay_ms(2000);
    lcd_clear();
    
    while(1) {
        
        __delay_ms(500);
        
        trig_pin = 0;
        __delay_us(10);
        trig_pin = 1;
        
        if(echo_pin) {
            
            T1CONbits.TMR1ON = 1;
            while(echo_pin);
            T1CONbits.TMR1ON = 0;
            duration = overflow;
            overflow = 0;
            TMR1 = 60536;
            PIR1bits.TMR1IF = 0;
            
//            duration = duration * 1000;
//            distance = duration * 0.034 / 2;   
            distance = duration * 17; // distance = duration * 34 / 2
            
            PORTD = (unsigned char) map(distance, 17, 408, 0, 255);
            
            lcd_clear();
            
            sprintf(chr_distance, "%d", distance);
            lcd_goto_xy(1,1);
            lcd_write_string("distance: ");
            lcd_write_string(chr_distance);
            lcd_write_string("cm");
            
            sprintf(chr_duration, "%d", duration);
            lcd_goto_xy(2,1);
            lcd_write_string("duration: ");
            lcd_write_string(chr_duration);
            lcd_write_string("ms");
        }
    }
}

void __interrupt() ISR(void) {
    
    if(PIR1bits.TMR1IF) {
        overflow++;
        TMR1 = 60536;
        PIR1bits.TMR1IF = 0;
    } 
}

void timer1_init(void) {
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR1IE = 1;
    PIR1bits.TMR1IF = 0;
    T1CONbits.TMR1CS = 0;
    T1CONbits.T1CKPS1 = 0;
    T1CONbits.T1CKPS0 = 0;
    TMR1 = 60536;
}

long map(uint16_t value, uint16_t fromLow, uint16_t fromHigh, uint16_t toLow, uint16_t toHigh) {
    
    return ((long)(value - fromLow) * (long)(toHigh - toLow)) / (fromHigh - fromLow) + toLow;
    
}