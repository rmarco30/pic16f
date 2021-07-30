/*
 * PIC16F877A I2C demonstration
 */

#define _XTAL_FREQ              20000000
#define EEPROM_READ_ADDR        0xA1    // 1010 000 0 <- write
#define EEPROM_WRITE_ADDR       0xA0    // 1010 000 1 <- read
#define EEPROM_PAGE_ADDRESS     0x10
#define inc                     RB0
#define dec                     RB1
#define read                    RB2
#define write                   RB3

#include <xc.h>
#include "config-bits.h"
#include "i2c-master.h"
#include "lcd-4bit.h"
#include <stdint.h>
#include <stdio.h>



void main(void) {
    
    uint8_t data = 0;
    char str1[10];
    char str2[10];
    
    TRISB = 0x0F;
    
    i2c_master_init(100000);
    __delay_ms(200);
    lcd_init();
    __delay_ms(100);
    lcd_goto_xy(1,1);
    lcd_write_string("eeprom");
    lcd_goto_xy(2,1);
    lcd_write_string("read/write test");
    __delay_ms(3000);
    lcd_clear();
    
    while(1) {

        if(!inc) {
            __delay_ms(150);
            if(!inc) {
                __delay_ms(150);
                data++;
                if(data == 255) {
                    data = 255;
                }
                sprintf(str1, "%d", data);
                lcd_clear();
                lcd_goto_xy(1,1);
                lcd_write_string("value: ");
                lcd_write_string(str1);
            }
        }
        
        if(!dec) {
            __delay_ms(150);
            if(!dec) {
                __delay_ms(150);
                data--;
                if(data == 0) {
                    data = 0;
                }
                sprintf(str1, "%d", data);
                lcd_clear();
                lcd_goto_xy(1,1);
                lcd_write_string("value: ");
                lcd_write_string(str1);
            }
        }

        if(!write) {
            __delay_ms(150);
            if(!write) {
                __delay_ms(150);
                i2c_is_idle();
                i2c_start();
                i2c_write(EEPROM_WRITE_ADDR);
                i2c_write(EEPROM_PAGE_ADDRESS);
                i2c_write(data);
                i2c_stop();
                lcd_clear();
                lcd_goto_xy(1,1);
                lcd_write_string("write = ");
                lcd_write_string(str1);
            }
        }
        
        if(!read) {
            __delay_ms(150);
            if(!read) {
                __delay_ms(150);
                i2c_is_idle();
                i2c_start();
                i2c_write(EEPROM_WRITE_ADDR);
                i2c_write(EEPROM_PAGE_ADDRESS);
                i2c_rep_start();
                i2c_write(EEPROM_READ_ADDR);
                uint8_t received = i2c_read(1);
                i2c_stop();
                
                sprintf(str2, "%x", received);
                lcd_goto_xy(2,1);
                lcd_write_string("read = 0x");
                lcd_write_string(str2);
//                PORTD = received;
            }
        }
    }
}