/*
* fsm.h
*
* Andreas Holleland
* 2023
*/

#ifndef FSM_H_
#define FSM_H_

#include <Arduino.h>

typedef enum
{
  IDLE, 
  PUMPING, 
  FLUSHING
} state;

void fsm_init();
state get_state();
void set_state(state s);
bool update_state();

#endif /* FSM_H_ */
