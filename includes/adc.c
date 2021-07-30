/********************************************
 * @file        adc.c
 * @author      Roldan Marco
 * @version     V1.0
 * @date        
 * @brief       pic16f877a adc demo code
 *******************************************/

/* Includes -------------------------------*/
#include "adc.h"


/**
 * @brief       initialize adc channels
 * @param       none
 * @retval      none
 */
void adc_init(void) {
    TRISA = 0xFF;
    TRISE = 0xFF;
    ADCON0 = 0b01000001;
    ADCON1 = 0b11000000;                                    // 8 adc channels enabled
}

/**
 * @brief       read adc channels
 * @param       channel: adc channel to be read
 * @retval      10 bit ADC value
 */
uint16_t adc_read(unsigned char channel) {
    ADCON0 &= 0b11000111;                                   // Clearing the Channel Selection Bits
    ADCON0 |= channel << 3;                                 // Setting the required Bits
    __delay_ms(2);                                          // Acquisition time to charge hold capacitor
    GO_nDONE = 1;                                           // Initializes A/D Conversion
    while(GO_nDONE);                                        // Wait for A/D Conversion to complete
    return ((uint16_t)(ADRESH << 8) + (uint16_t)ADRESL);    // Returns Result
}