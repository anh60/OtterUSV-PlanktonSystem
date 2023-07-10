/*
* comms.h
*
* Andreas Holleland
* 2023
*/

#ifndef COMMS_H_
#define COMMS_H_

#include <Arduino.h>

void comms_init();
void transmit_status();
void check_ctrl_msg();

#endif /* COMMS_H_ */