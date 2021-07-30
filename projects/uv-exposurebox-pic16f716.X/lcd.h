#define lcd_en_delay 500
//#define lcd_data_port_d TRISA
//#define lcd_rs_d TRISA1
//#define lcd_en_d TRISA0
#define RS RA1
#define EN RA0
#define D4 RB7
#define D5 RB6
#define D6 RB5
#define D7 RB4
#define _XTAL_FREQ 20000000
#include <xc.h>
#include <pic16f716.h>
//#include <pic16f877a.h>

void lcd_init();
void lcd_clear();
void lcd_shiftLeft();
void lcd_shiftRight();
void lcd_cmd(unsigned char);
void lcd_data(unsigned char);
void lcd_setCursor(unsigned char, unsigned char);
void lcd_writeChar(char);
void lcd_writeString(char*);


void lcd_init() {
    // IO Pin Configurations
//    lcd_data_port_d = 0x00;
    TRISA = 0b00010000;
    TRISB = 0b00001111; // 0x0f, 0b0000 0000
//    lcd_rs_d = 0;
//    lcd_en_d = 0;
    // The Init. Procedure As Described In The Datasheet
    lcd_data(0x00);
    __delay_ms(30);
    __delay_us(lcd_en_delay);
    lcd_cmd(0x03);
    __delay_ms(5);
    lcd_cmd(0x03);
    __delay_ms(11);
    lcd_cmd(0x03);
    lcd_cmd(0x02);
    lcd_cmd(0x02);
    lcd_cmd(0x08);
    lcd_cmd(0x00);
    lcd_cmd(0x0C);
    lcd_cmd(0x00);
    lcd_cmd(0x06);
}

void lcd_data(unsigned char data) {
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

void lcd_cmd(unsigned char cmd) {
    // Select Command Register
    RS = 0;
    // Move The Command Data To LCD
    lcd_data(cmd);
    // Send The EN Clock Signal
    EN = 1;
    __delay_us(lcd_en_delay);
    EN = 0;
}

void lcd_clear() {
    lcd_cmd(0);
    lcd_cmd(1);
    __delay_ms(1);
}

void lcd_setCursor(unsigned char r, unsigned char c) {
    unsigned char temp, low4, high4;
    if (r == 1) {
        temp = 0x80 + c - 1; //0x80 is used to move the cursor
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

void lcd_writeChar(char data) {
    char low4, high4;
    low4 = data & 0x0F;
    high4 = data & 0xF0;
    RS = 1;
    lcd_data(high4 >> 4);
    EN = 1;
    __delay_us(lcd_en_delay);
    EN = 0;
    __delay_us(lcd_en_delay);
    lcd_data(low4);
    EN = 1;
    __delay_us(lcd_en_delay);
    EN = 0;
    __delay_us(lcd_en_delay);
}

void lcd_writeString(char *str) {
    int i;
    for (i = 0; str[i] != '\0'; i++)
        lcd_writeChar(str[i]);
}

//void lcd_shiftLeft() {
//    lcd_cmd(0x01);
//    lcd_cmd(0x08);
//}

//
//void lcd_shiftRight() {
//    lcd_cmd(0x01);
//    lcd_cmd(0x0C);
//}