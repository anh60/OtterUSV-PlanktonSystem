/*
* valve.h
*
* Andreas Holleland
* 2023
*/

#ifndef VALVE_H_
#define VALVE_H_

uint32_t get_valve_limit();

void start_valve_timer();

uint32_t get_valve_time();

void set_valve(bool value);

void valve_init();

#endif /* VALVE_H_ */