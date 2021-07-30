/*
 * PIC16F877A 4bit LCD demonstration
 */

#define _XTAL_FREQ  20000000

#include "config-bits.h"
#include "lcd-4bit.h"
#include <xc.h>



void main() {
 
  lcd_init();
  lcd_clear();

  while(1)
  {
      lcd_goto_xy(1,1);
      lcd_write_string("PATRICIA");
      lcd_goto_xy(2,1);
      lcd_write_string("MAE <333");
  }
}