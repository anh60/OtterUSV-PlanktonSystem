/*
* fsm.cpp
*
* Andreas Holleland
* 2023
*/

//---------------------------- HEADERS -----------------------------------------

#include <Arduino.h>
#include "fsm.h"
#include "pump.h"
#include "valve.h"
#include "level_switch.h"
#include "water_sensor.h"


//---------------------------- GLOBALS -----------------------------------------

// Current CPU time (milliseconds)
uint32_t cT;    

// Current and next system state
uint8_t curr_sys_state;
uint8_t next_sys_state;


//---------------------------- FUNCTIONS ---------------------------------------

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
 * @brief Manages the flags associated with the level switch.
 * 
 */
void manage_level_switch(){
    // If level switch has not been triggered
    if(get_level_flag() == false){

        // Check level switch
        if((read_level() == true)){

            // Start timer and set flag
            start_level_timer();
        }
    }

    // If level switch was triggered
    else{

        // Level switch start time
        uint32_t lT = get_level_time();

        // Level switch time limit
        uint32_t lMin = get_level_limit();

        // Check again after a short delay
        if(((cT - lT) >= lMin) && (read_level() == true)){

            // Clear pump flag
            set_sys_state(PUMP_FLAG, 0);

            // Set full flag
            set_sys_state(FULL_FLAG, 1);

            // Set flag to 0
            reset_level_flag();
        }
    }
}


/**
 * @brief Manages flags/transitions associated with the pump
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
            start_pump_timer();
        }
    }

    // Pump state
    if((pCurr == 1) && (pNext == 1)){

        // Pump start time
        uint32_t pT = get_pump_time();

        // Pump time limit
        uint32_t pMax = get_pump_limit();

        // Current time
        cT = millis();

        // If less than limit, check level switch
        if((cT - pT) < pMax){
            manage_level_switch();
        }

        // If limit reached
        else if ((cT - pT) >= pMax){

            // Clear pump flag
            set_sys_state(PUMP_FLAG, 0);

            // Set full flag
            set_sys_state(FULL_FLAG, 1);
        }
    }
}


/**
 * @brief Manages flags/transitions associated with the valve
 * 
 */
void manage_valve(){
    // Valve flags
    uint8_t vCurr = ((curr_sys_state >> VALVE_FLAG) & 1);
    uint8_t vNext = ((next_sys_state >> VALVE_FLAG) & 1);

    // Flush state transition
    if((vCurr == 0) && (vNext == 1)){
        start_valve_timer();
    }

    // Flush state
    if((vCurr == 1) && (vNext == 1)){

        // Valve start time
        uint32_t vT = get_valve_time();

        // Valve time limit
        uint32_t vMin = get_valve_limit();

        // Current time
        cT = millis();

        // If limit reached
        if((cT - vT) >= vMin){

            // Clear valve flag
            set_sys_state(VALVE_FLAG, 0);

            // Clear full flag
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
        
        // Water sensor start time
        uint32_t wT = get_water_time();

        // Water sensor time limit
        uint32_t wMin = get_water_limit();

        // Current time
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
        if((cT - wT) >= wMin){
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
 * @brief Manages states and transitions
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
 * @brief Checks if any events has triggered a state change
 *        and sets the outputs.
 * 
 * @return 1 (true)
 * @return 0 (false)
 */
bool check_sys_state(){
    // Manage flags/state and transitions
    manage_flags();

    // If state has changed
    if (curr_sys_state != next_sys_state){

        // Update current state
        curr_sys_state = next_sys_state;

        // Set outputs
        set_pump((curr_sys_state >> PUMP_FLAG) & 1);
        set_valve((curr_sys_state >> VALVE_FLAG) & 1);

        return 1;
    }
    return 0;
}