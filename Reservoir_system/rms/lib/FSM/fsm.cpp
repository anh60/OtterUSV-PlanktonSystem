/*
* fsm.cpp
*
* Andreas Holleland
* 2023
*/

#include "fsm.h"
#include "pump.h"
#include "valve.h"

state currState;
state nextState;

void fsm_init(){
    currState = IDLE;
    nextState = IDLE;
}

static void set_output(){
    switch(currState)
    {
    case IDLE:
        stop_pump();
        close_valve();
        break;

    case PUMPING:
        start_pump();
        close_valve();
        break;

    case FLUSHING:
        stop_pump();
        open_valve();
        break;

    default:
        break;
    }
}

state get_state(){
    return currState;
}

void set_state(state s){
    nextState = s;
}

bool update_state(){
    if (nextState != currState){
        currState = nextState;
        set_output();
        return 1;
    }
    return 0;
}