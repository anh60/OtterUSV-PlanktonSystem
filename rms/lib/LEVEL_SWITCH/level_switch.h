/*
* level_switch.h
*
* Andreas Holleland
* 2023
*/

#ifndef LEVEL_SWITCH_H_
#define LEVEL_SWITCH_H_

uint32_t get_level_limit();

void start_level_timer();

uint32_t get_level_time();

void reset_level_flag();

bool get_level_flag();

bool read_level();

void level_switch_init();

#endif /* LEVEL_SWITCH_H_ */