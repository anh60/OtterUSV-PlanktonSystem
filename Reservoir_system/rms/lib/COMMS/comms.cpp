/*
* comms.cpp
*
* Andreas Holleland
* 2023
*/

#include "comms.h"
#include "fsm.h"

#define baud 9600

char currStatus;
char prevStatus;

void comms_init(){
    Serial1.begin(baud);
    currStatus = S_IDLE;
    prevStatus = S_IDLE;
}

char get_status_msg(){
    return currStatus;
}

void set_status_msg(char msg){
    currStatus = msg;
}

static void handle_msg_pump(){
    if (get_state() == PUMPING){
        currStatus = E_PUMPING;
        return;
    }
    set_state(PUMPING);
    currStatus = S_PUMPING;
    prevStatus = currStatus;
}

static void handle_msg_flush(){
    if (get_state() == FLUSHING){
        currStatus = E_FLUSHING;
        return;
    }
    set_state(FLUSHING);
    currStatus = S_FLUSHING;
    prevStatus = currStatus;
}

static void handle_msg_stop(){
    if (get_state() == IDLE){
        currStatus = E_IDLE;
        return;
    }
    set_state(IDLE);
    currStatus = S_IDLE;
    prevStatus = currStatus;
}

static void handle_msg_status(){
    currStatus = prevStatus;
}

static void msg_handler(char msg){
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
        char rx = Serial1.read();
        msg_handler(rx);
    }
}

void transmit_status(){
    Serial1.println(currStatus);
}