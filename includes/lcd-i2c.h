/* 
 * File:
 * Author:
 * Comments:
 * Revision history: v1
 */
 
#ifndef LCD_I2C_H
#define	LCD_I2C_H

#include "i2c.h"



#define LCD_BACKLIGHT         0x08
#define LCD_NOBACKLIGHT       0x00
#define LCD_FIRST_ROW         0x80
#define LCD_SECOND_ROW        0xC0
#define LCD_THIRD_ROW         0x94
#define LCD_FOURTH_ROW        0xD4
#define LCD_CLEAR             0x01
#define LCD_RETURN_HOME       0x02
#define LCD_ENTRY_MODE_SET    0x04
#define LCD_CURSOR_OFF        0x0C
#define LCD_UNDERLINE_ON      0x0E
#define LCD_BLINK_CURSOR_ON   0x0F
#define LCD_MOVE_CURSOR_LEFT  0x10
#define LCD_MOVE_CURSOR_RIGHT 0x14
#define LCD_TURN_ON           0x0C
#define LCD_TURN_OFF          0x08
#define LCD_SHIFT_LEFT        0x18
#define LCD_SHIFT_RIGHT       0x1C
#define LCD_TYPE              2 // 0 -> 5x7 | 1 -> 5x10 | 2 -> 2 lines

#define I2C_SLAVE_ADDRESS  0x4E
#define _XTAL_FREQ 20000000

unsigned char RS, i2c_add, BackLight_State = LCD_BACKLIGHT;

void i2c_slave(unsigned char data);
void lcd_data(unsigned char nibble);
void lcd_cmd(unsigned char cmd);
void lcd_init(void);
void lcd_clear(void);
void lcd_goto_xy(unsigned char row, unsigned char column);
void lcd_shift_left(void);
void lcd_shift_right(void);
void lcd_back_light_off(void);
void lcd_back_light_on(void);
void lcd_write_char(char data);
void lcd_write_string(char *str);


void i2c_slave(unsigned char data) {
    i2c_is_idle();
    i2c_start();
    i2c_write(I2C_SLAVE_ADDRESS);
    i2c_write(data | BackLight_State);
    i2c_stop();
}

void lcd_data(unsigned char nibble) {
    nibble |= RS;
    i2c_slave(nibble | 0x04);
    i2c_slave(nibble & 0xFB);
    __delay_us(50);
}

void lcd_cmd(unsigned char cmd) {
    RS = 0;
    lcd_data(cmd & 0xF0);           // 0000 0001 & 1111 0000
    lcd_data((cmd << 4) & 0xF0);
}

void lcd_init(void) {
    
    i2c_init();
    __delay_ms(250);
    __delay_ms(20);
    i2c_slave(0x00);
    __delay_ms(30);
    lcd_cmd(0x03);
    __delay_ms(5);
    lcd_cmd(0x03);
    __delay_ms(5);
    lcd_cmd(0x03);
    __delay_ms(5);
    lcd_cmd(LCD_RETURN_HOME);
    __delay_ms(5);
    lcd_cmd(0x20 | (LCD_TYPE << 2));
    __delay_ms(50);
    lcd_cmd(LCD_TURN_ON);
    __delay_ms(50);
    lcd_cmd(LCD_CLEAR);
    __delay_ms(50);
    lcd_cmd(LCD_ENTRY_MODE_SET | LCD_RETURN_HOME);
    __delay_ms(50);
}

void lcd_clear(void) {
    lcd_cmd(0x01);
    __delay_ms(5);
}

void lcd_goto_xy(unsigned char row, unsigned char column) {
    switch(row) {
        case 2:
            lcd_cmd(0xC0 + column-1);
            break;
        case 3:
            lcd_cmd(0x94 + column-1);
            break;
        case 4:
            lcd_cmd(0xD4 + column-1);
            break;
        default:
            lcd_cmd(0x80 + column-1);        
    }
}

void lcd_shift_left(void) {
    lcd_cmd(LCD_SHIFT_LEFT);
    __delay_us(40);
}

void lcd_shift_right(void) {
    lcd_cmd(LCD_SHIFT_RIGHT);
    __delay_us(40);
}

void lcd_back_light_off(void) {
    BackLight_State = LCD_NOBACKLIGHT;
    i2c_slave(0x00);
}

void lcd_back_light_on(void) {
    BackLight_State = LCD_BACKLIGHT;
    i2c_slave(0x00);
}

void lcd_write_char(char data) {
    RS = 1;
    lcd_data(data & 0xF0);
    lcd_data((data << 4) & 0xF0);
}

void lcd_write_string(char *str) {
    for(int i=0; str[i] != '\0'; i++) {
        lcd_write_char(str[i]);
    }
}

#endif

