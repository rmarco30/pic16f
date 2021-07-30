/*
 * File:   lcd.c
 * Author: marco
 *
 */

#include "lcd_4bit.h"

void lcd_clock(void) {
    
    EN = 1;
    __delay_us(500);
    EN = 0;
    __delay_us(500);
}

void lcd_data(unsigned char data) {                     // this function extracts the high nibble of the data
                                                        // by ANDing each high bits and sets the data to the data bus to be shifted in
    if (data & 1)                                       
        D4 = 1;
    else
        D4 = 0;
    
    if (data & 2)
        D5 = 1;
    else
        D5 = 0;
    
    if (data & 4)
        D6 = 1;
    else
        D6 = 0;
    
    if (data & 8)
        D7 = 1;
    else
        D7 = 0;
}

void lcd_cmd(unsigned char cmd) {                       // function to send command to lcd
    
    RS = 0;                                             // select the instruction register, RS = 0
    lcd_data(cmd);                                      // extract the higher nibble of command
    lcd_clock();                                        // pulse in the clock to shift in the data
    
}

void lcd_clear(void) {                                  // this function clears the lcd screen
    lcd_cmd(0);
    lcd_cmd(1);
    __delay_ms(2);
}

void lcd_goto_xy(unsigned char r, unsigned char c) {
    unsigned char temp, low4, high4;
    if (r == 1) {
        temp = 0x80 + c - 1;
        high4 = temp >> 4;
        low4 = temp & 0x0F;
        lcd_cmd(high4);
        lcd_cmd(low4);
    }
    if (r == 2) {
        temp = 0xC0 + c - 1;
        high4 = temp >> 4;
        low4 = temp & 0x0F;
        lcd_cmd(high4);
        lcd_cmd(low4);
    }
}

void lcd_init(void) {
    __delay_ms(20);                     
    LCD_DATA_PORT = TRISB & 0x03;                       // configure data pins                                
    lcd_cmd(0x03);                                      // initialization procedure as stated in the datasheet
    __delay_ms(5);                                      // 2 line display, 5x8 font, auto increment address
    lcd_cmd(0x03);                                      // blink off, cursor off, shift off
    __delay_us(200);
    lcd_cmd(0x03);
    lcd_cmd(0x02);
    lcd_cmd(0x02);
    lcd_cmd(0x08);
    lcd_cmd(0x00);
    lcd_cmd(0x0C);
    lcd_cmd(0x00);
    lcd_cmd(0x06);
}

void lcd_write(char byte) {                             // this function writes a byte of character to lcd screen

    char low_nibble, high_nibble;                        

    low_nibble = byte & 0x0F;                           // extract the low nibble of a byte
    high_nibble = byte & 0xF0;                          // extract the high nibble of the byte

    RS = 1;                                             // select the data register
    lcd_data(high_nibble >> 4);                         // set the data to the data pins (high nibble)
    lcd_clock();                                        // pulse in the clock
    lcd_data(low_nibble);                               // set the data to the data pins (low nibble)
    lcd_clock();
}

void lcd_write_string(char *str) {                      // function to write a string in lcd screen

    for (int i = 0; str[i] != '\0'; i++) {              // scan the input string until NULL character is not encountered
        lcd_write(str[i]);                              // read each byte and send to lcd screen
    }                     
}

//void lcd_shift_left() {                                 // function to shift entire display to left
//    lcd_cmd(0x01);
//    lcd_cmd(0x08);
//}
//
//void lcd_shift_right() {                                // function to shift entire display to right
//    lcd_cmd(0x01);
//    lcd_cmd(0x0C);
//}