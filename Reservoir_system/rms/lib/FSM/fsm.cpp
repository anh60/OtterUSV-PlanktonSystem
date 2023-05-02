/*
* fsm.cpp
*
* Andreas Holleland
* 2023
*/

#include "fsm.h"

uint8_t curr_sys_state;
uint8_t next_sys_state;

/**
 * @brief Initialise state machine
 * 
 */
void fsm_init(){
    curr_sys_state = 0x00;
    next_sys_state = 0x00;
}

/**
 * @brief Get current state of system
 * 
 * @return uint8_t curr_sys_state
 */
uint8_t get_sys_state(){
    return curr_sys_state;
}

/**
 * @brief Sets a particular status bit to be updated to a desired value.
 * Changes are made to the "next_sys_state" variable.
 * 
 * @param k status bit to be written (status_bit enum)
 * @param val value (0 or 1) to be written
 */
void set_sys_state(status_bit k, bool val){
    if(val){
        next_sys_state |= 1 << k;
        return;
    }
    next_sys_state &= ~(1 << k);
}

/**
 * @brief Checks if any external events has triggered a state change.
 * 
 * @return 1 (true)
 * @return 0 (false)
 */
bool update_sys_state(){
    if (curr_sys_state != next_sys_state){
        curr_sys_state = next_sys_state;
        return 1;
    }
    return 0;
}

void reset_sys(){
    // Flush reservoir
    //
    // Stop reservoir
    // Stop pump
    //
    // Clear timers
    //
    // Confirm sensor values
    //
    // Set status = 0x00
}