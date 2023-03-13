/*
* sensors.cpp
*
* Andreas Holleland
* 2023
*/

#include "sensors.h"
#include "fsm.h"

#define LEVEL_PIN 4
#define WATER_PIN 5

void ISR_LEVEL(){
    set_sys_state(LEVEL_BIT, (~(get_sys_state() >> LEVEL_BIT) & 0x01));
    
    set_sys_state(PUMP_BIT, 0);
    set_sys_state(VALVE_BIT, 0);
}

void ISR_WATER(){
    set_sys_state(WATER_BIT, (~(get_sys_state() >> WATER_BIT) & 0x01));
    set_sys_state(PUMP_BIT, 0);
    set_sys_state(VALVE_BIT, 0);
}

void sensors_init(){
    pinMode(LEVEL_PIN, INPUT);
    pinMode(WATER_PIN, INPUT);
    //attachInterrupt(digitalPinToInterrupt(LEVEL_PIN), ISR_LEVEL, RISING);
    attachInterrupt(digitalPinToInterrupt(WATER_PIN), ISR_WATER, CHANGE);
}