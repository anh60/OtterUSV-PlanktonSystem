# OtterUSV-PlanktonSystem
Automatic water sampling and plankton imaging system for the Otter USV. This system was developed as part of my master thesis in Embedded Computing Systems at the Norwegian University of Science and Technology (NTNU). 

## Content

* Plankton Imaging System (PIS)
System for capturing images with a microscope, storing the images, and controlling the water sampling system (RMS). This can be controlled/monitored with the SCI application or by publishing/subscribing to certain MQTT topics. Code is written in python and runs on a Raspberry PI 4B.

* Reservoir Management System (RMS)
MCU based electronic control system responsible for managing the state of a reservoir/water tank. Can be controlled/monitored through a physical RS232 connection. The microcontroller is an Arduino Nano Every, and code is written in C++ using the PlatformIO development environment.

* Supervisory Control Interface (SCI)
Desktop/mobile application written in Dart using the Flutter framework for controlling/monitoring the PIS and RMS.

* Test
Folder containing a script for monitoring and logging MQTT traffic on relevant topics. Test logs from lab experiments can also be found here.


## Folder structure
Here is an overview of the relevant folders within the repository.

```bash
├───pis                             # Plankton Imaging System
│   ├───data                            # Persistant data (only on RPI)
│   └───src                             # Source code
│       ├───cam                             # Camera
│       ├───data                            # Image file system
│       ├───mqtt                            # MQTT client
│       ├───pump                            # 5V pump
│       ├───rms                             # RMS communication
│       ├───sample                          # Sample routine
│       ├───sensor                          # Leak sensor
│       └───state                           # State machine
├───rms                             # Reservoir Management System
│   ├───lib                             # Drivers
│   │   ├───COMMS                           # UART communication
│   │   ├───FSM                             # State machine
│   │   ├───LEVEL_SWITCH                    # Level switch sensor
│   │   ├───PUMP                            # Pump
│   │   ├───VALVE                           # Valve
│   │   └───WATER_SENSOR                    # Leak sensor
│   ├───src                                 # Main application
├───sci                             # Supervisory Control Interface
│   ├───console                         # Terminal applications (testing)
│   └───flutter                         # Flutter application (GUI)
│       └───sci                       
│           └───lib                     # Application source code
│               ├───controllers             # Backend controllers
│               ├───pages                   # Pages
│               └───widgets                 # Custom widgets
└───test                            # System tests (documented in report)
    ├───logs                            # Test logs
    └───src                             # Test/logging script
```