#ifndef LCD_4BIT_H
#define LCD_4BIT_H

#include <pic16f877a.h>
#include <xc.h>

// #define LCD_RS 			TRISD2
// #define LCD_EN 			TRISD3
#define LCD_DATA_PORT 	TRISB
#define RS 				RB2
#define EN 				RB3
#define D4 				RB4
#define D5 				RB5
#define D6 				RB6
#define D7 				RB7
#define _XTAL_FREQ 		20000000

void lcd_clock(void);
void lcd_init(void);
void lcd_clear(void);
//void lcd_shift_left(void);
//void lcd_shift_right(void);
void lcd_cmd(unsigned char);
void lcd_data(unsigned char);
void lcd_goto_xy(unsigned char, unsigned char);
void lcd_write(char);
void lcd_write_string(char*);

#endif