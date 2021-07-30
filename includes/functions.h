#include <stdint.h>

uint16_t map(uint16_t, uint16_t, uint16_t, uint16_t, uint16_t);


uint16_t map(uint16_t value, uint16_t fromLow, uint16_t fromHigh, uint16_t toLow, uint16_t toHigh) {
    
    return ((long)(value - fromLow) * (long)(toHigh - toLow)) / (fromHigh - fromLow) + toLow;
    
}