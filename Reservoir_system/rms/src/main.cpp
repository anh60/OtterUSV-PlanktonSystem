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
  fsm_init();
  comms_init();
  pump_init();
  valve_init();

  //level_switch_init();
  //water_sensor_init();

}

void loop() {

  check_ctrl_msg();

  if(update_sys_state()){
    transmit_status();
    switch_pump();
    switch_valve();
  }
}
