/*
* level_switch.cpp
*
* Andreas Holleland
* 2023
*/

#include "level_switch.h"
#include "fsm.h"

#define LEVEL_PIN 5

//void ISR_LEVEL(){
//}

bool readLevel(){
    if(digitalRead(LEVEL_PIN) == 0){
        return true;
    }
    return false;
}

void level_switch_init(){
    pinMode(LEVEL_PIN, INPUT);
    //attachInterrupt(digitalPinToInterrupt(LEVEL_PIN), ISR_LEVEL, RISING);
}