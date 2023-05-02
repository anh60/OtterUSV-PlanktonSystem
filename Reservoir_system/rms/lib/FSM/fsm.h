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
  PUMP_BIT,   // 0 - Pump           (0 = OFF, 1 = ON) 
  VALVE_BIT,  // 1 - Valve          (0 = CLOSED, 1 = OPEN)
  LEVEL_BIT,  // 2 - Level switch   (0 = NOT FULL, 1 = FULL)
  WATER_BIT   // 3 - Liquid sensor  (0 = NO LEAK, 1 = LEAK)
} status_bit;

void fsm_init();

uint8_t get_sys_state();

void set_sys_state(status_bit k, bool val);

bool update_sys_state();

void reset_sys();

#endif /* FSM_H_ */
