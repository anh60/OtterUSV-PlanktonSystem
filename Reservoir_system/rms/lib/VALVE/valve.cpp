/*
* valve.cpp
*
* Andreas Holleland
* 2023
*/

#include "valve.h"
#include "fsm.h"

#define VALVE_PIN 3

uint16_t flushTimer;

void valve_init(){
    pinMode(VALVE_PIN, OUTPUT);
    flushTimer = 0;
}

void switch_valve(){
    digitalWrite(VALVE_PIN, (get_sys_state() >> VALVE_BIT) & 1);
}