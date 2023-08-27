/*
* fsm.cpp
*
* Andreas Holleland
* 2023
*/

#include "fsm.h"

#include "level_switch.h"
#include "water_sensor.h"

// Timers (milliseconds)
uint32_t pT;    // CPU time when pump start
uint32_t vT;    // CPU time when valve starts
uint32_t lT;    // CPU time when level switch is triggered
uint32_t cT;    // Current CPU time

// Timer thresholds (milliseconds)
const uint32_t pMax = 30000;    // Pump max time
const uint32_t vMin = 30000;    // Valve min time
const uint32_t lMin = 1000;     // Level switch min time
const uint32_t wMin = 1000;     // Water sensor min time

// Flag to check level switch
bool checkLevel = false;

// Current and next system state
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
 * @brief Sets a particular state flag to be updated to a desired value.
 * Changes are made to the "next_sys_state" variable.
 * 
 * @param k state bit to be written (state_flag enum)
 * @param val value (0 or 1) to be written
 */
void set_sys_state(state_flags k, bool val){
    if(val){
        next_sys_state |= 1 << k;
        return;
    }
    next_sys_state &= ~(1 << k);
}


/**
 * @brief Manages the timer/flags associated with the level switch.
 * 
 */
void manage_level_switch(){
    // If level switch has not been triggered
    if(checkLevel == false){
        // Check level switch
        if((readLevel() == true)){
            lT = millis();
            checkLevel = true;
        }
    }
    // If level switch was triggered
    else{
        // Check again after a short delay
        if(((cT - lT) >= lMin) && (readLevel() == true)){
            set_sys_state(PUMP_FLAG, 0);
            set_sys_state(FULL_FLAG, 1);
            checkLevel = false;
        }
    }
}


/**
 * @brief Manages the timer and flags/transitions associated with the pump
 * 
 */
void manage_pump(){
    // Pump flags
    uint8_t pCurr = ((curr_sys_state >> PUMP_FLAG) & 1);
    uint8_t pNext = ((next_sys_state >> PUMP_FLAG) & 1);

    // Pump state transition
    if((pCurr == 0) && (pNext == 1)){

        // Check if full, if true -> revert flag
        if(((curr_sys_state >> FULL_FLAG) & 1) == 1){
            set_sys_state(PUMP_FLAG, 0);
        }

        // If not full, start the timer
        else{
            pT = millis();
        }
    }

    // Pump state
    if((pCurr == 1) && (pNext == 1)){

        // Get current time
        cT = millis();

        // If less than max time, check level switch
        if((cT - pT) < pMax){
            manage_level_switch();
        }

        // If pMax reached
        else if ((cT - pT) >= pMax){
            set_sys_state(PUMP_FLAG, 0);
            set_sys_state(FULL_FLAG, 1);
        }
    }
}


/**
 * @brief Manages the timer and flags/transitions associated with the valve
 * 
 */
void manage_valve(){
    // Valve flags
    uint8_t vCurr = ((curr_sys_state >> VALVE_FLAG) & 1);
    uint8_t vNext = ((next_sys_state >> VALVE_FLAG) & 1);

    // Flush state transition
    if((vCurr == 0) && (vNext == 1)){
        vT = millis();
    }

    // Flush state
    if((vCurr == 1) && (vNext == 1)){
        cT = millis();
        if((cT - vT) >= vMin){
            set_sys_state(VALVE_FLAG, 0);
            set_sys_state(FULL_FLAG, 0);
        }
    }
}


/**
 * @brief Manages the flags and timer associated with the leak sensor
 * 
 */
void manage_leak(){
    // Leak flags
    uint8_t lCurr = ((curr_sys_state >> LEAK_FLAG) & 1);

    // If ISR was executed
    if(get_water_flag() == true){

        // Get current time
        cT = millis();

        // State of input when ISR was executed
        bool pinState;

        // If not in leak state, must be a rising edge
        if(lCurr == 0){
            pinState = true;
        }
        // If in leak state, must be a falling edge
        else{
            pinState = false;
        }

        // Check sensor after a short delay
        if((cT - get_water_time()) >= wMin){
            if(read_water() == pinState){
                set_sys_state(LEAK_FLAG, pinState);
            }
            reset_water_flag();
        }
    }

    // Leak state
    if(lCurr == 1){
        set_sys_state(PUMP_FLAG, 0);
        set_sys_state(VALVE_FLAG, 0);
    }
}

/**
 * @brief Manages flags/transitions of FSM
 * 
 */
void manage_flags(){

    // Manage pump state
    manage_pump();

    // Manage valve state
    manage_valve();

    // Manage leak sensor state
    manage_leak();

}

/**
 * @brief Checks if any external events has triggered a state change.
 * 
 * @return 1 (true)
 * @return 0 (false)
 */
bool check_sys_state(){
    manage_flags();
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