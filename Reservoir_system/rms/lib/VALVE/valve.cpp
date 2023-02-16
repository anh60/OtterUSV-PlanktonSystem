/*
* valve.cpp
*
* Andreas Holleland
* 2023
*/

#include "valve.h"

#define VALVE_PIN 3

uint16_t flushTimer;

void valve_init(){
    pinMode(VALVE_PIN, OUTPUT);
    flushTimer = 0;
}

void open_valve(){
    digitalWrite(VALVE_PIN, 1);
}

void close_valve(){
    digitalWrite(VALVE_PIN, 0);
}