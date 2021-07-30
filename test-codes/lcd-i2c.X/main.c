/*
 * PIC16F877A LCD-I2C demonstration
 */

#pragma warning disable 520     // disable warning "function not called"

#define _XTAL_FREQ  20000000

#include <xc.h>
#include "config-bits.h"
#include "lcd-i2c.h"




void main(void) {
    
    lcd_init();
    __delay_ms(50);
    lcd_clear();
    
    while(1) {
        
        lcd_goto_xy(1,1);
        lcd_write_string("testing row 1");
        __delay_ms(1000);
        lcd_clear();
        lcd_goto_xy(2,1);
        lcd_write_string("testing row 2");
        __delay_ms(1000);
        lcd_clear();
        lcd_write_string("display shift");
        lcd_clear();
        lcd_write_string("patricia mae");
        __delay_ms(1000);
        lcd_shift_right();
        __delay_ms(300);
        lcd_shift_right();
        __delay_ms(300);
        lcd_shift_right();
        __delay_ms(300);
        lcd_shift_left();
        __delay_ms(300);
        lcd_shift_left();
        __delay_ms(300);
        lcd_shift_left();
        __delay_ms(300);
        lcd_clear();
        lcd_back_light_off();
        __delay_ms(500);
        lcd_back_light_on();
        __delay_ms(500);
        lcd_back_light_off();
        __delay_ms(500);
        lcd_back_light_on();
        __delay_ms(500);
        
    }
    
}