/*
 * File:   newmain.c
 * Author: rmarco30
 *
 * Created on September 3, 2020, 12:29 PM
 */

#include "config.h"
#include "lcd.h"
#include "timer1.h"
#include <stdio.h>  	// for sprintf
#include <string.h> 	// for strcat
#include <stdbool.h>
#include <stdint.h>
#include <xc.h>
#include <pic16f716.h>

#define _XTAL_FREQ      20000000
#define leds            RA2
#define addTime         RB2
#define subTime         RB3
#define start           RB0
#define stop            RB1
#define buzzer          RA3     
#define lid             RA4     // this pin is open-drain

void main(void) {
    
    nRBPU = 0;
    ADCON1 = 0x07;
    
    // variable initialization
    buzzer = 1;
    leds = 0;
    bool operation = 0;
    int time = 120;
    char minutes, seconds;
    char chTime[5];
    
    lcd_init();
    lcd_clear();
    lcd_writeString("UV EXPOSURE BOX");
    __delay_ms(5000);
    lcd_clear();
    timer1_init();
    TMR1ON = 0;
    
    while(1) {
        
        switch (lid) { // conditional statement if the lid is open or close

        lcd_clear();

        case 0: // if lid is open
            lcd_setCursor(1, 1);
            lcd_writeString("please close the");
            lcd_setCursor(2, 1);
            lcd_writeString("lid to continue ");
            while (!lid);
            lcd_clear();
            break;

        case 1: // if lid is close

            if (!addTime) { // increment time
                __delay_ms(50);
                if (!addTime) {
                    if (time != 1800) { // max time is 15 minutes
                        time += 5;
                        __delay_ms(10);
                    }
                }
            }

            if (!subTime) { // decrement time
                __delay_ms(50);
                if (!subTime) {
                    if (time != 5) { // minimum time is 0
                        time -= 5;
                        __delay_ms(10);
                    }
                }
            }

            if (!start) { // toggle operation. start exposing if operation = 1
                __delay_ms(50);
                if (!start) {
                    operation = 1;
                    __delay_ms(10);
                }
            } 

            else { // update lcd when time buttons are pressed
                minutes = time / 60;
                seconds = time % 60;
                if (seconds < 10) {
                    sprintf(chTime, "%2d:0%d", minutes, seconds);
                } else {
                    sprintf(chTime, "%2d:%2d", minutes, seconds);
                }
                lcd_setCursor(2, 1);
                lcd_writeString("time left: ");
                lcd_writeString(chTime);
            }
            

            if (operation) {
                    
                    while (operation == 1) {

                    TMR1ON = 1; // start timer1

                    if (overflow == 100) { // do everything inside this statement every 1 second
                        leds = 1;
                        overflow = 0;
                        minutes = time / 60;
                        seconds = time % 60;
                        if (seconds < 10) {
                            sprintf(chTime, "%2d:0%d", minutes, seconds);
                        } else {
                            sprintf(chTime, "%2d:%2d", minutes, seconds);
                        }
                        lcd_setCursor(1, 1);
                        lcd_writeString("uv exposing. . .");
                        lcd_setCursor(2, 1);
                        lcd_writeString("time left: ");
                        lcd_writeString(chTime);
                        time--;

                        if (time < 0) { // if exposing is finished
                            leds = 0;
                            TMR1IF = 0;
                            TMR1ON = 0;
                            overflow = 0;
                            operation = 0;
                            time = 120;
                            lcd_clear();
                            __delay_ms(10);
                            lcd_setCursor(1, 1);
                            lcd_writeString("uv exposing");
                            lcd_setCursor(2, 1);
                            lcd_writeString("finished");
                            for (int j = 0; j < 6; j++) {
                                for (int i = 0; i < 255; i++) {
                                    buzzer = 1;
                                    __delay_ms(1);
                                    buzzer = 0;
                                }
                                __delay_ms(500);
                            }
                            __delay_ms(3000);
                            lcd_clear();
                        }
                    }

                    if (!lid) { // if lid was opened while exposing is in process
                        lcd_clear();
                        __delay_ms(10);
                        while (!lid) {
                            leds = 0;
                            TMR1IF = 0;
                            TMR1ON = 0;
                            lcd_setCursor(1, 1);
                            lcd_writeString("please close the");
                            lcd_setCursor(2, 1);
                            lcd_writeString("lid to resume");
                            while(!lid){
                                for (int j = 0; j < 1; j++) {
                                    for (int i = 0; i < 255; i++) {
                                        buzzer = 1;
                                        __delay_ms(1);
                                        buzzer = 0;
                                    }
                                    __delay_ms(100);
                                }
                            }
                        }
                        lcd_clear();
                    }

                    if (!stop) { // stop button to terminate ongoing exposing process
                        __delay_ms(50);
                        if (!stop) {
                            leds = 0;
                            TMR1IF = 0;
                            TMR1ON = 0;
                            overflow = 0;
                            operation = 0;
                            time = 120;
                            lcd_clear();
                             __delay_ms(10);
                            lcd_setCursor(1, 1);
                            lcd_writeString("uv exposing");
                            lcd_setCursor(2, 1);
                            lcd_writeString("stopped");
                            for (int j = 0; j < 3; j++) {
                                for (int i = 0; i < 255; i++) {
                                    buzzer = 1;
                                    __delay_ms(1);
                                    buzzer = 0;
                                }
                                __delay_ms(1000);
                            }
                            lcd_clear();
                        }
                    }
                }
            }
        }
    }
}