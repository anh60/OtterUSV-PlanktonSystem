/*
* comms.cpp
*
* Andreas Holleland
* 2023
*/

#include "comms.h"
#include "fsm.h"

#define baud 9600

// CONTROL SIGNALS
const uint8_t C_PUMP    = 0x01;     // Start pumping
const uint8_t C_FLUSH   = 0x02;     // Start flushing
const uint8_t C_STOP    = 0x03;     // Return to IDLE state
const uint8_t C_STATUS  = 0x04;     // Request current status

void comms_init(){
    Serial1.begin(baud);
}

void transmit_status(){
    Serial1.write(get_sys_state());
}

static void handle_msg_pump(){
    set_sys_state(PUMP_BIT, 1);
    set_sys_state(VALVE_BIT, 0);
}

static void handle_msg_flush(){
    set_sys_state(PUMP_BIT, 0);
    set_sys_state(VALVE_BIT, 1);
}

static void handle_msg_stop(){
    set_sys_state(PUMP_BIT, 0);
    set_sys_state(VALVE_BIT, 0);
}

static void handle_msg_status(){
    transmit_status();
}

static void msg_handler(uint8_t msg){
    switch (msg)
    {
    case C_PUMP:
        handle_msg_pump();
        break;
    
    case C_FLUSH:
        handle_msg_flush();
        break;
    
    case C_STOP:
        handle_msg_stop();
        break;

    case C_STATUS: 
        handle_msg_status();
        break;

    default:
        break;
    }
}

void check_ctrl_msg(){
    if(Serial1.available() > 0){
        uint8_t msg = Serial1.read();
        msg_handler(msg);
    }
}