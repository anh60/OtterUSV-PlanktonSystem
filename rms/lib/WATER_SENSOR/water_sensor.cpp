/*
* water_sensor.cpp
*
* Andreas Holleland
* 2023
*/

//---------------------------- HEADERS -----------------------------------------

#include <Arduino.h>
#include "water_sensor.h"


//---------------------------- GLOBALS -----------------------------------------

// GPIO connected to water sensor
#define WATER_PIN 4

// CPU time when ISR is called
uint32_t wT;

// Water sensor measurement delay
const uint32_t wMin = 1000;

// Flag raised when ISR is called
bool checkWater;


//---------------------------- FUNCTIONS ---------------------------------------

/**
 * @brief Get the measurement delay value
 * 
 * @return uint32_t
 */
uint32_t get_water_limit(){
    return wMin;
}


/**
 * @brief Get the time when ISR was called last
 * 
 * @return uint32_t 
 */
uint32_t get_water_time(){
    return wT;
}


/**
 * @brief Set the flag to 0
 * 
 */
void reset_water_flag(){
    checkWater = false;
}


/**
 * @brief Get the current value of the flag
 * 
 * @return true 
 * @return false 
 */
bool get_water_flag(){
    return checkWater;
}


/**
 * @brief ISR callback
 * 
 */
void isr_water(){
    wT = millis();
    checkWater = true;
}


/**
 * @brief Reads the current value on the input
 * 
 * @return true if logic level HIGH (active)
 * @return false if logic level LOW (idle)
 */
bool read_water(){
    if(digitalRead(WATER_PIN) == 1){
        return true;
    }
    return false;
}


/**
 * @brief Initialize the sensor
 * 
 */
void water_sensor_init(){
    pinMode(WATER_PIN, INPUT);
    attachInterrupt(digitalPinToInterrupt(WATER_PIN), isr_water, CHANGE);
}