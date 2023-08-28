/*
* pump.cpp
*
* Andreas Holleland
* 2023
*/

//---------------------------- HEADERS -----------------------------------------

#include <Arduino.h>
#include "pump.h"


//---------------------------- GLOBALS -----------------------------------------

// GPIO connected to pump relay
#define PUMP_PIN 2

// CPU time when pump start
uint32_t pT;

// Pump time limit
const uint32_t pMax = 30000;


//---------------------------- FUNCTIONS ---------------------------------------


/**
 * @brief Get the pump max time
 * 
 * @return uint32_t 
 */
uint32_t get_pump_limit(){
    return pMax;
}


/**
 * @brief Start the pump timer
 * 
 */
void start_pump_timer(){
    pT = millis();
}


/**
 * @brief Get the start time of the pump
 * 
 * @return uint32_t 
 */
uint32_t get_pump_time(){
    return pT;
}


/**
 * @brief Set value of pump relay GPIO
 * 
 * @param value 
 */
void set_pump(bool value){
    digitalWrite(PUMP_PIN, value);
}


/**
 * @brief Initialize pump
 * 
 */
void pump_init(){
    pinMode(PUMP_PIN, OUTPUT);
}