/*
* sensors.h
*
* Andreas Holleland
* 2023
*/

#ifndef SENSORS_H_
#define SENSORS_H_

#include <Arduino.h>

void sensors_init();
bool read_level();
bool read_water();

#endif /* SENSORS_H_ */