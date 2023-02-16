/*
* pump.cpp
*
* Andreas Holleland
* 2023
*/

#include "pump.h"

#define PUMP_PIN 2

uint16_t pumpTimer;

void pump_init(){
    pinMode(PUMP_PIN, OUTPUT);
    pumpTimer = 0;
}

void start_pump(){
    digitalWrite(PUMP_PIN, 1);
}

void stop_pump(){
    digitalWrite(PUMP_PIN, 0);
}