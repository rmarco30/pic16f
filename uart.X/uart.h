#ifndef UART_H
#define	UART_H

#include <stdio.h>
#include <stdint.h>
#include <xc.h>

void uart_init(void);
void uart_tx_char(const char data);
char uart_rx_char(void);

void uart_tx_str(const char *str);
void uart_rx_str(char *p_str);


void uart_init(void) {
    
    TRISC6 = 1;
    TRISC7 = 1;
    SPEN = 1;               // configure serial port RC6 as TX, RC7 as RX
    BRGH = 1;               // high speed 
    SPBRG = 129;            // baud rate = 9600; baud rate = Fosc/(16(x+1))
    SYNC = 0;               // asynchronous mode
    CREN = 1;               // enable continuous receive
    
    INTCONbits.GIE = 1;     // enable global interrupt enable bit
    INTCONbits.PEIE = 1;    // enable unmasked peripheral interrupts
    PIE1bits.RCIE = 1;
    PIE1bits.TXIE = 1;
    PIR1bits.RCIF = 0;
    PIR1bits.TXIF = 0;
    
    TX9 = 0;                // select 8-bit transmission
    RX9 = 0;                // selects 8-bit reception
    TXEN = 1;               // enable transmission
}

void uart_tx_char(const char data) {
    
    while (TXIF == 0);     // wait until TXREG is empty. TXIF = 1 -> TXREG is empty, TXIF = 0 -> TXREG is full
    TXREG = data;         // transfer data to TXREG, TXIF will be set
}

char uart_rx_char(void) {
    
    if(RCSTAbits.FERR) {                    // if framing error occurs
        uint8_t framing_error = RCREG;      // read RCREG to remove the error
    }
    if (RCSTAbits.OERR) {                   // check for overrun error, will happen if the 3rd byte is received and RCREG is still full
        CREN = 0;                           // to clear OERR if set, reset CREN by clearing and setting it again
        CREN = 1;
    }
    while (RCIF == 0);                      // wait until data is received, if received successfully RCIF will be set
    return RCREG;                         // return received data to calling function
}

void uart_tx_str(const char *str) {
    
    for (uint8_t i = 0; str[i] != '\0'; i++)    // scan the each byte until NULL character
        uart_tx_char(str[i]);               // transmit each character byte
}

void uart_rx_str(char *p_str) {
    
    char ch;
    char len = 0;
    
    while (1) {
        ch = uart_rx_char();

        if((ch=='\r') || (ch=='\n'))    //read till enter key is pressed
        {                               //once enter key is pressed null terminate the string
            p_str[len] = 0;             //and break the loop
            break;                  
        }
        else if((ch=='\b') && (len!=0))
        {
            len--;                      //If backspace is pressed then decrement the index to remove the old char
        }
        else
        {
            p_str[len] = ch;         //copy the char into string and increment the index
            len++;
        }
    }
}


#endif