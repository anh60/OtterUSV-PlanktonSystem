/*
* main.cpp
*
* Andreas Holleland
* 2023
*/

#include <Arduino.h>

#include "fsm.h"
#include "comms.h"
#include "sensors.h"

void setup() {
  fsm_init();
  comms_init();
  sensors_init();
}

void loop() {

  check_ctrl_msg();

  if(update_sys_state()){
    transmit_status();
  }
  
}
