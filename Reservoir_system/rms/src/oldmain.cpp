/*
* main.cpp
*
* Andreas Holleland
* 2023
*/

#include <Arduino.h>

// GPIOs
#define PUMP  2             // D2 - Pump relay
#define VALVE 3             // D3 - Solenoid valve relay
#define LEVEL 4             // D4 - Level switch output
#define WATER 5             // D5 - Water level sensor output

// CONTROL SIGNALS
const char CMD1 = '1';      // Fill reservoir
const char CMD2 = '2';      // Stop pump
const char CMD3 = '3';      // Flush reservoir
const char CMD4 = '4';      // Close valve
const char CMD5 = '5';      // Request status
const char CMD6 = '6';      // Force Idle state (communication problem)

// STATUS SIGNALS
const char STA1 = '1';      // Reservoir idle
const char STA2 = '2';      // Reservoir full
const char STA3 = '3';      // Pumping started
const char STA4 = '4';      // Flushing started
const char STA5 = '5';      // Internal leak detected

// ERROR SIGNALS
const char ERR1 = '6';      // Pump already on
const char ERR2 = '7';      // Pump already off
const char ERR3 = '8';      // Valve already open
const char ERR4 = '9';      // Valve already closed

char status;                // Current status
char prevStatus;

// FSM STATES
typedef enum
{
  IDLE, 
  PUMPING, 
  FLUSHING, 
  LEAK
} state;

state currState;            // Current FSM state
state nextState;            // Next FSM state

// Finite State Machine
void FSM() {
  if (nextState != currState){
    currState = nextState;    
    switch(currState){
      case IDLE:
        digitalWrite(PUMP, 0);
        digitalWrite(VALVE, 0);
        break;
      case PUMPING:
        digitalWrite(PUMP, 1);
        digitalWrite(VALVE, 0);
        break;
      case FLUSHING:
        digitalWrite(PUMP, 0);
        digitalWrite(VALVE, 1);
        break;
      case LEAK:
        digitalWrite(PUMP, 0);
        digitalWrite(VALVE, 0);
        break;
    }
  }
}

// UART-RS232 communication
void uartHandler() {
  if(Serial1.available() > 0){
    char rx = Serial1.read();
    switch(rx){
      case CMD1:
        if(currState == PUMPING){
          status = ERR1;
        }
        else{
          nextState = PUMPING;
          status = STA3;
          prevStatus = status;
        }
        break;
      case CMD2:
        if(currState == IDLE || currState == FLUSHING){
          status = ERR2;
        }
        else{
          nextState = IDLE;
          status = STA1;
          prevStatus = status;
        }
        break;
      case CMD3:
        if(currState == FLUSHING){
          status = ERR3;
        }
        else{
          nextState = FLUSHING;
          status = STA4;
          prevStatus = status;
        }
        break;
      case CMD4:
        if(currState == IDLE || currState == PUMPING){
          status = ERR4;
        }
        else{
          nextState = IDLE;
          status = STA1;
          prevStatus = status;          
        }
        break;
      case CMD5:
        status = prevStatus;
        break;
      case CMD6:
        nextState = IDLE;
        status = STA1;
        prevStatus = status;
        break;
    }
  }
}

// Read level switch
void readLevel(){
  if(digitalRead(LEVEL) == 1){
    nextState = IDLE;
    status = STA2;
  }
}

// Read water level sensor
void readWater(){
  if(digitalRead(WATER) == 1){
    nextState = LEAK;
    status = STA5;
    prevStatus = status;
  }
}

void setup() {

  // Initialize GPIOs
  pinMode(PUMP, OUTPUT);
  pinMode(VALVE, OUTPUT);
  pinMode(LEVEL, INPUT);
  pinMode(WATER, INPUT);

  // Initialize UART
  Serial1.begin(9600);

  // Set initial states
  currState = IDLE;
  nextState = IDLE;
  status = STA1;
  prevStatus = STA1;
}

void loop() {
  uartHandler();
  readLevel();
  readWater();
  FSM();
  Serial1.println(status);
}