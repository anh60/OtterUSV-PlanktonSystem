/*
* main.cpp
*
* Andreas Holleland
* 2023
*/

#include <Arduino.h>

#include "fsm.h"
#include "pump.h"
#include "valve.h"
#include "comms.h"
#include "sensors.h"

void setup() {
  fsm_init();
  pump_init();
  valve_init();
  comms_init();
  sensors_init();
}

void loop() {
  check_ctrl_msg();

  if(read_level()){
    set_state(IDLE);
    set_status_msg(S_FULL);
  }

  if(read_water()){
    set_state(IDLE);
    set_status_msg(S_LEAK);
  }

  if(update_state()){
    transmit_status();
  }

}
