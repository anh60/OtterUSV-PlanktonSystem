/*
* valve.cpp
*
* Andreas Holleland
* 2023
*/

//---------------------------- HEADERS -----------------------------------------

#include <Arduino.h>
#include "valve.h"


//---------------------------- GLOBALS -----------------------------------------

// GPIO connected to valve relay
#define VALVE_PIN 3

// Valve start time
uint32_t vT;

// Valve time limit
const uint32_t vMin = 30000;


//---------------------------- FUNCTIONS ---------------------------------------


/**
 * @brief Get the valve time limit
 * 
 * @return uint32_t 
 */
uint32_t get_valve_limit(){
    return vMin;
}


/**
 * @brief Start the valve timer
 * 
 */
void start_valve_timer(){
    vT = millis();
}


/**
 * @brief Get the start time of the valve
 * 
 * @return uint32_t 
 */
uint32_t get_valve_time(){
    return vT;
}


/**
 * @brief Set value on the valve relay GPIO
 * 
 * @param value 
 */
void set_valve(bool value){
    digitalWrite(VALVE_PIN, value);
}


/**
 * @brief Initialize the valve
 * 
 */
void valve_init(){
    pinMode(VALVE_PIN, OUTPUT);
}