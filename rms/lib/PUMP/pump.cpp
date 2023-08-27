/*
* pump.cpp
*
* Andreas Holleland
* 2023
*/

#include "pump.h"
#include "fsm.h"

#define PUMP_PIN 2

void pump_init(){
    pinMode(PUMP_PIN, OUTPUT);
}

void switch_pump(){
    digitalWrite(PUMP_PIN, (get_sys_state() >> PUMP_FLAG) & 1);
}