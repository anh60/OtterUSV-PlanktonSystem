/*
* level_switch.cpp
*
* Andreas Holleland
* 2023
*/

//---------------------------- HEADERS -----------------------------------------

#include <Arduino.h>
#include "level_switch.h"


//---------------------------- GLOBALS -----------------------------------------

// GPIO connected to level switch
#define LEVEL_PIN 5

// CPU time when level switch is triggered
uint32_t lT;

// Level switch measurement delay
const uint32_t lMin = 1000;

// Flag raised when level switch is triggered
bool checkLevel = false;


//---------------------------- FUNCTIONS ---------------------------------------


/**
 * @brief Get the measurement delay value
 * 
 * @return uint32_t 
 */
uint32_t get_level_limit(){
    return lMin;
}


/**
 * @brief Start timer and set flag
 * 
 */
void start_level_timer(){
    lT = millis();
    checkLevel = true;
}


/**
 * @brief Get the start time of the level switch
 * 
 * @return uint32_t 
 */
uint32_t get_level_time(){
    return lT;
}


/**
 * @brief Set level switch flag value
 * 
 */
void reset_level_flag(){
    checkLevel = false;
}


/**
 * @brief Get level switch flag value
 * 
 * @return true 
 * @return false 
 */
bool get_level_flag(){
    return checkLevel;
}


/**
 * @brief Read level switch GPIO
 * 
 * @return true, if pin state = 0 (sensor active)
 * @return false, if pin state = 1 (sensor idle)
 */
bool read_level(){
    if(digitalRead(LEVEL_PIN) == 0){
        return true;
    }
    return false;
}


/**
 * @brief Initialize the level switch
 * 
 */
void level_switch_init(){
    pinMode(LEVEL_PIN, INPUT);
}