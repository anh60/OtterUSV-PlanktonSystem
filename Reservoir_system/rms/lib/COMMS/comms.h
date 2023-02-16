/*
* comms.h
*
* Andreas Holleland
* 2023
*/

#ifndef COMMS_H_
#define COMMS_H_

#include <Arduino.h>

// CONTROL SIGNALS
const char C_PUMP   = '1';            // Start pumping
const char C_FLUSH  = '2';            // Start flushing
const char C_STOP   = '3';            // Return to IDLE state
const char C_STATUS = '4';            // Request current status

// STATUS SIGNALS
const char S_PUMPING    = '1';      // PUMPING
const char S_FLUSHING   = '2';      // FLUSHING
const char S_IDLE       = '3';      // IDLE
const char S_FULL       = '4';      // FULL
const char S_LEAK       = '5';      // LEAK

// ERROR SIGNALS
const char E_PUMPING = '6';         // Already pumping
const char E_FLUSHING = '7';        // Already flushing
const char E_IDLE = '8';            // Already idle

void comms_init();
char get_status_msg();
void set_status_msg(char msg);
void check_ctrl_msg();
void transmit_status();

#endif /* COMMS_H_ */