/*
* main.cpp
*
* Andreas Holleland
* 2023
*/

#include <Arduino.h>

#include "fsm.h"
#include "comms.h"
#include "pump.h"
#include "valve.h"
#include "level_switch.h"
#include "water_sensor.h"

void setup() {

  // Initialize peripherals
  fsm_init();           // State machine
  comms_init();         // UART/RS232 communication
  pump_init();          // Pump
  valve_init();         // Valve
  level_switch_init();  // Level switch (reservoir measurement)
  water_sensor_init();  // Water level sensor (leak detection)

}

void loop() {

  // Check UART if control commands has been received
  check_ctrl_msg();

  // Check if system state has changed
  if(check_sys_state()){

    // Transmit system state over UART/RS232
    transmit_status();
  }

  switch_pump();
  switch_valve();
}
