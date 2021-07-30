/* 
 * File:   
 * Author: 
 * Comments:
 * Revision history: 
 */

#ifndef SSD1306_H
#define	SSD1306_H

#include "ssd1306-font.h"
#include "ssd1306-images.h"
#include "i2c.h"
#include <stdint.h>
#include <string.h>
#include <xc.h>

#define OLED_ADDRESS    0x78

void oled_cmd(uint8_t data);
void oled_goto_xy(uint8_t col_s, uint8_t col_e, uint8_t page_s, uint8_t page_e);
void oled_clear(void);
void oled_write_data(char *data);
void oled_image(const unsigned char *image_data);
void oled_init(void);


void oled_cmd(uint8_t data) {
    i2c_is_idle();
    i2c_start();
    i2c_write(OLED_ADDRESS);
    i2c_write(0x00);
    i2c_write(data);
    i2c_stop();
}

void oled_goto_xy(uint8_t col_s, uint8_t col_e, uint8_t page_s, uint8_t page_e) {
    i2c_is_idle();
    i2c_start();
    i2c_write(OLED_ADDRESS);
    i2c_write(0x00);
    i2c_write(0x21);
    i2c_write(col_s);
    i2c_write(col_e);
    i2c_write(0x22);
    i2c_write(page_s);
    i2c_write(page_e);
    i2c_stop();
}

void oled_clear(void) {
    oled_goto_xy(0x00, 0x7f, 0x00, 0x07);
    for (int i=0; i<1023; i++) {
        i2c_is_idle();
        i2c_start();
        i2c_write(OLED_ADDRESS);
        i2c_write(0x40);
        i2c_write(0x00);
        i2c_stop();
    }
}

void oled_write_data(char *data) {
    unsigned int len = strlen(data);
    for(int g=0; g<len; g++) {
        for(int index=0; index<5; index++) {
            i2c_start();
            i2c_write(OLED_ADDRESS);
            i2c_write(0x40);
            i2c_write(ASCII[data[g] - 0x20][index]);
            i2c_stop();
        }
    }
}

void oled_image(const unsigned char *image_data) {
  oled_goto_xy(0x00, 0x7F, 0x00, 0x07);    
  for (int i=0; i<=1023; i++) {    
    i2c_is_idle();
    i2c_start();
    i2c_write(OLED_ADDRESS);
    i2c_write(0x40);
    i2c_write(image_data[i]);
    i2c_stop();
  }
}

void oled_init(void) {
    oled_cmd(0xAE); /* Entire Display OFF */
    oled_cmd(0xD5); /* Set Display Clock Divide Ratio and Oscillator Frequency */
    oled_cmd(0x80); /* Default Setting for Display Clock Divide Ratio and Oscillator Frequency that is recommended */
    oled_cmd(0xA8); /* Set Multiplex Ratio */
    oled_cmd(0x3F); /* 64 COM lines */
    oled_cmd(0xD3); /* Set display offset */
    oled_cmd(0x00); /* 0 offset */
    oled_cmd(0x40); /* Set first line as the start line of the display */
    oled_cmd(0x8D); /* Charge pump */
    oled_cmd(0x14); /* Enable charge dump during display on */
    oled_cmd(0x20); /* Set memory addressing mode */
    oled_cmd(0x00); /* Horizontal addressing mode */
    oled_cmd(0xA1); /* Set segment remap with column address 127 mapped to segment 0 */
    oled_cmd(0xC8); /* Set com output scan direction, scan from com63 to com 0 */
    oled_cmd(0xDA); /* Set com pins hardware configuration */
    oled_cmd(0x12); /* Alternative com pin configuration, disable com left/right remap */
    oled_cmd(0x81); /* Set contrast control */
    oled_cmd(0x80); /* Set Contrast to 128 */
    oled_cmd(0xD9); /* Set pre-charge period */
    oled_cmd(0xF1); /* Phase 1 period of 15 DCLK, Phase 2 period of 1 DCLK */
    oled_cmd(0xDB); /* Set Vcomh deselect level */
    oled_cmd(0x20); /* Vcomh deselect level ~ 0.77 Vcc */
    oled_cmd(0xA4); /* Entire display ON, resume to RAM content display */
    oled_cmd(0xA6); /* Set Display in Normal Mode, 1 = ON, 0 = OFF */
    oled_cmd(0x2E); /* Deactivate scroll */
    oled_cmd(0xAF); /* Display on in normal mode */
}


#endif