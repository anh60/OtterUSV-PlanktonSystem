/*
* main.cpp
*
* Andreas Holleland
* 2023
*/

//---------------------------- HEADERS -----------------------------------------

#include <Arduino.h>
#include "fsm.h"
#include "comms.h"
#include "pump.h"
#include "valve.h"
#include "level_switch.h"
#include "water_sensor.h"


//---------------------------- FUNCTIONS ---------------------------------------

/**
 * @brief Initialize modules
 * 
 */
void setup() {
  // Finite State Machine
  fsm_init();

  // UART/RS232 communication
  comms_init(); 

  // Pump        
  pump_init(); 

  // Solenoid valve         
  valve_init();

  // Level switch (reservoir measurement)
  level_switch_init();

  // Water level sensor (leak detection)
  water_sensor_init();  
}


/**
 * @brief Main loop
 * 
 */
void loop() {
  // Check if control commands has been received
  check_ctrl_msg();

  // Check if system state has changed
  if(check_sys_state()){

    // Transmit state over UART/RS232
    transmit_state();

  }
}
