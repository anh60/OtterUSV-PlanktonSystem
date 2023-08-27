/*
* fsm.h
*
* Andreas Holleland
* 2023
*/

#ifndef FSM_H_
#define FSM_H_

#include <Arduino.h>

/*
* Defines bits of state variable
*/
typedef enum
{
  PUMP_FLAG,   // 0 - Pump           (0 = OFF, 1 = ON) 
  VALVE_FLAG,  // 1 - Valve          (0 = CLOSED, 1 = OPEN)
  FULL_FLAG,  // 2 - Level switch   (0 = NOT FULL, 1 = FULL)
  LEAK_FLAG   // 3 - Liquid sensor  (0 = NO LEAK, 1 = LEAK)
} state_flags;

void fsm_init();

uint8_t get_sys_state();

void set_sys_state(state_flags k, bool val);

bool check_sys_state();

void reset_sys();

#endif /* FSM_H_ */
