/*
* water_sensor.h
*
* Andreas Holleland
* 2023
*/

#ifndef WATER_SENSOR_H_
#define WATER_SENSOR_H_

uint32_t get_water_limit();

uint32_t get_water_time();

void reset_water_flag();

bool get_water_flag();

bool read_water();

void water_sensor_init();

#endif /* WATER_SENSOR_H_ */