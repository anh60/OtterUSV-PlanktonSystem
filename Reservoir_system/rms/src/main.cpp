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
#include "sensors.h"

void setup() {
  fsm_init();
  comms_init();
  pump_init();
  valve_init();
  sensors_init();
}

void loop() {

  check_ctrl_msg();

  if(update_sys_state()){
    transmit_status();
    switch_pump();
    switch_valve();
  }
  
}
