/*
* water_sensor.cpp
*
* Andreas Holleland
* 2023
*/

#include "water_sensor.h"
#include "fsm.h"

#define WATER_PIN 4

// CPU time when ISR is called
uint32_t wT;

// Flag raised when ISR is called
bool checkWater;

uint32_t get_water_time(){
    return wT;
}

void reset_water_flag(){
    checkWater = false;
}

bool get_water_flag(){
    return checkWater;
}

void isr_water(){
    wT = millis();
    checkWater = true;
}

bool read_water(){
    if(digitalRead(WATER_PIN) == 1){
        return true;
    }
    return false;
}

void water_sensor_init(){
    pinMode(WATER_PIN, INPUT);
    attachInterrupt(digitalPinToInterrupt(WATER_PIN), isr_water, CHANGE);
}