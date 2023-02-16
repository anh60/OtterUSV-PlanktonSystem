/*
* sensors.cpp
*
* Andreas Holleland
* 2023
*/

#include "sensors.h"

#define LEVEL_PIN 4
#define WATER_PIN 5

void sensors_init(){
    pinMode(LEVEL_PIN, INPUT);
    pinMode(WATER_PIN, INPUT);
}

bool read_level(){
    if(digitalRead(LEVEL_PIN) == 1){
        return 1;
    }
    return 0;
}

bool read_water(){
    if(digitalRead(WATER_PIN) == 1){
        return 1;
    }
    return 0;
}