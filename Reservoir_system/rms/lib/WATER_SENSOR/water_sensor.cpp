/*
* water_sensor.cpp
*
* Andreas Holleland
* 2023
*/

#include "water_sensor.h"
#include "fsm.h"

#define WATER_PIN 5

void ISR_WATER(){
    set_sys_state(WATER_BIT, (~(get_sys_state() >> WATER_BIT) & 1));
}

void level_switch_init(){
    pinMode(WATER_PIN, INPUT);
    attachInterrupt(digitalPinToInterrupt(WATER_PIN), ISR_WATER, CHANGE);
}