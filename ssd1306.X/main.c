/*
 * PIC16F877A SSD1306 OLED demonstration
 */
#pragma warning disable 520

#define _XTAL_FREQ  20000000

#include <xc.h>
#include "config-bits.h"
#include "i2c-master.h"
#include "ssd1306.h"



void main(void) {
    
    oled_init();
    __delay_ms(100);
    oled_clear();
    
    while(1) {
        oled_image(Smiley_1);
        __delay_ms(200);
        oled_image(Smiley_2);
        __delay_ms(200);
        oled_image(Smiley_3);
        __delay_ms(200);
        oled_image(Smiley_4);
        __delay_ms(200);
        oled_clear();
        oled_goto_xy(0x00, 0x7F, 0x02, 0x07);
        oled_write_data("PATRICIA MAE <3");
        __delay_ms(2000);
    }
    
}