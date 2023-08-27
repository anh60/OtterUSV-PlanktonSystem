/*
* water_sensor.cpp
*
* Andreas Holleland
* 2023
*/

#include "water_sensor.h"
#include "fsm.h"

#define WATER_PIN 4

void ISR_WATER(){
}

bool readWater(){
    if(digitalRead(WATER_PIN) == 1){
        return true;
    }
    return false;
}

void water_sensor_init(){
    pinMode(WATER_PIN, INPUT);
    //attachInterrupt(digitalPinToInterrupt(WATER_PIN), ISR_WATER, RISING);
}