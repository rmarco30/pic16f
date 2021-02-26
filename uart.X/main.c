
#define _XTAL_FREQ      20000000

#include "config-bits.h"
#include "uart.h"
#include <xc.h>



void main(void) {
    
    char str[20];
    
    uart_init();
    __delay_ms(200);
 
    while(1) {
        uart_rx_str(str);       // read received string
        __delay_ms(1000);       
        uart_tx_str(str);       // transmit string after 1 sec
    }
}