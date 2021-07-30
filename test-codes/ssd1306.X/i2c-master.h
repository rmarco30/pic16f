/* 
 * File:
 * Author:
 * Comments:
 * Revision history: v1
 */
 
#ifndef I2C_H
#define	I2C_H

#include <stdint.h>

void i2c_master_init( unsigned long baud_rate);
void i2c_is_idle(void);
void i2c_start(void);
void i2c_rep_start(void);
void i2c_stop(void);
uint8_t i2c_write(uint8_t d_addr);
uint8_t i2c_read(uint8_t ack);                      // 0 = ack, 1 = nack


// MASTER FUNCTIONS

void i2c_master_init(unsigned long baud_rate) {
    TRISC |= 0x18;
    SSPADD = (uint8_t)((_XTAL_FREQ / (4 * baud_rate)) - 1);
    SSPSTAT |= 0x80;
    SSPCON |= 0x28;
    SSPCON2 |= 0x00;
    PIR1bits.SSPIF = 0;
}

void i2c_is_idle(void){                             // checks if the bus is idle
    while((SSPCON2 & 0x1F) || (SSPSTAT & 0x04));    // checks if SEN, RSEN, PEN, RCEN, ACKEN, R_nW bit is idle or 0;
}

void i2c_start(void){
    i2c_is_idle();                                  // checks if the bus is idle
    SSPCON2bits.SEN = 1;                            // initiate start condition
    while(SSPCON2bits.SEN);                         // wait for start condition to finish
    PIR1bits.SSPIF = 0;                             // clear interrupt flag
}

void i2c_rep_start(void){
    i2c_is_idle();                                  // checks if the bus is idle
    SSPCON2bits.RSEN = 1;                           // initiate repeated start condition
    while(SSPCON2bits.RSEN);                        // wait for repeated start condition to finish
    PIR1bits.SSPIF = 0;                             // clear interrupt flag
}

void i2c_stop(void){
    i2c_is_idle();                                  // checks if the bus is idle
    SSPCON2bits.PEN = 1;                            // initiate stop condition
    while(SSPCON2bits.PEN);                         // wait for stop condition to finish
    PIR1bits.SSPIF = 0;                             // clear interrupt flag
}

uint8_t i2c_write(uint8_t d_addr) {
    i2c_is_idle();                                  // checks if the bus is idle
    SSPBUF = d_addr;                                // load the data to SSPBUF
    if (SSPCONbits.WCOL) {                          // checks if write collision occur
        SSPCONbits.WCOL = 0;                        // if true, clear WCOL bit
        SSPBUF = d_addr;                            // reload data or address to SSPBUF
    }
    while(PIR1bits.SSPIF != 1);                     // 
    if(SSPCON2bits.ACKSTAT) {
        i2c_stop();
    }
    PIR1bits.SSPIF = 0;
    return SSPCON2bits.ACKSTAT;
}

uint8_t i2c_read(uint8_t ack) {
    uint8_t data;
    i2c_is_idle();
    SSPCON2bits.RCEN = 1;
    while(SSPSTATbits.BF != 1);
    data = SSPBUF;
    SSPCON2bits.ACKDT = ack;
    SSPCON2bits.ACKEN = 1;
    while(SSPCON2bits.ACKEN);
    PIR1bits.SSPIF = 0;
    return data;
}

#endif