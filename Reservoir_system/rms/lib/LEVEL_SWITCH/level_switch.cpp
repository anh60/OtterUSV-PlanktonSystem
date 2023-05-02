/*
* level_switch.cpp
*
* Andreas Holleland
* 2023
*/

#include "level_switch.h"
#include "fsm.h"

#define LEVEL_PIN 4

void ISR_LEVEL(){
    set_sys_state(LEVEL_BIT, (~(get_sys_state() >> LEVEL_BIT) & 1));
}

void level_switch_init(){
    pinMode(LEVEL_PIN, INPUT);
    attachInterrupt(digitalPinToInterrupt(LEVEL_PIN), ISR_LEVEL, CHANGE);
}