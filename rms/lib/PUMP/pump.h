/*
* pump.h
*
* Andreas Holleland
* 2023
*/

#ifndef PUMP_H_
#define PUMP_H_

uint32_t get_pump_limit();

void start_pump_timer();

uint32_t get_pump_time();

void pump_init();

void set_pump(bool value);

#endif /* PUMP_H_ */