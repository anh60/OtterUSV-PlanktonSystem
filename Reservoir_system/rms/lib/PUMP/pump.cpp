/*
* pump.cpp
*
* Andreas Holleland
* 2023
*/

#include "pump.h"
#include "fsm.h"

#define PUMP_PIN 2

uint16_t pumpTimer;

void pump_init(){
    pinMode(PUMP_PIN, OUTPUT);
    pumpTimer = 0;
}

void switch_pump(){
    digitalWrite(PUMP_PIN, (get_sys_state() >> PUMP_BIT) & 1);
}