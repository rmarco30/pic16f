/* 
 * File:
 * Author:
 * Comments:
 * Revision history: v1
 */
 
#ifndef I2C_SLAVE_H
#define	I2C_SLAVE_H

#include <stdint.h>
#include <xc.h>


void i2c_slave_init(uint8_t addr);
uint8_t i2c_slave_write(uint8_t data_tx);
uint8_t i2c_slave_read(void);


void i2c_slave_init(uint8_t addr) {
    TRISC |= 0x18;
    SSPADD = addr;
    SSPSTAT |= 0x80;
    SSPCON = 0x36;
    SSPCON2 |= 0x01;
    INTCON |= 0xC0;
    PIE1 |= 0x08;
//    PIR1 |= 0x08;
}

uint8_t i2c_slave_read(void) {                  // slave receiver, master transmitter
    
    uint8_t dummy = 0;
    uint8_t data_rx;
    
                     
    if(SSPCONbits.SSPOV || SSPCONbits.WCOL) {   // Bus error check
        dummy = SSPBUF;
        SSPCONbits.SSPOV = 0;
        SSPCONbits.WCOL = 0;
        }

    if(SSPSTATbits.D_nA == 0) {                 // last byte received was address
        dummy = SSPBUF;                         // read SSPBUF to clear BF bit
        while(SSPSTATbits.BF != 0);             // check if buffer is empty
        SSPCONbits.CKP = 1;                     // release the clock
    }
    
    if(SSPSTATbits.D_nA == 1) {                 // last byte received was data
        data_rx = SSPBUF;                       // read the received data to clear BF bit
        while(SSPSTATbits.BF != 0);             // check if buffer is empty
        SSPCONbits.CKP = 1;                     // release the clock
    }
    
    else {
        dummy = SSPBUF;
        SSPCONbits.SSPOV = 0;
        SSPCONbits.WCOL = 0;        
        SSPCONbits.CKP = 1;
    }
    
    return data_rx;
}


uint8_t i2c_slave_write(uint8_t data_tx) {      // slave transmitter, master receiver
    
    uint8_t dummy = 0;
    
    if(SSPCONbits.SSPOV || SSPCONbits.WCOL) {   // Bus error check
        dummy = SSPBUF;
        SSPCONbits.SSPOV = 0;
        SSPCONbits.WCOL = 0;
        }
    
    dummy = SSPBUF;
    while(SSPSTATbits.BF != 0);
    SSPBUF = data_tx;
    while(SSPSTATbits.BF != 1);
    SSPCONbits.CKP = 1;
    while(PIR1bits.SSPIF == 0);
    PIR1bits.SSPIF = 0;

    return 0;
}

#endif