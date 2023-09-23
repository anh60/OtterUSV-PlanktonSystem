# OtterUSV-PlanktonSystem
Automatic water sampling and plankton imaging system for the Otter USV. 


# Relevant folders
├───pis                             # Plankton Imaging System
│   ├───data                        # Persistant data (only on RPI)
│   └───src                         # Source code
│       ├───cam                       # Camera
│       ├───data                      # Image file system
│       ├───mqtt                      # MQTT client
│       ├───pump                      # 5V pump
│       ├───rms                       # RMS communication
│       ├───sample                    # Sample routine
│       ├───sensor                    # Leak sensor
│       └───state                     # State machine
├───rms                             # Reservoir Management System
│   ├───lib                           # Drivers
│   │   ├───COMMS                       # UART communication
│   │   ├───FSM                         # State machine
│   │   ├───LEVEL_SWITCH                # Level switch sensor
│   │   ├───PUMP                        # Pump
│   │   ├───VALVE                       # Valve
│   │   └───WATER_SENSOR                # Leak sensor
│   ├───src                             # Main application
├───sci                             # Supervisory Control Interface
│   ├───console                       # Terminal applications (testing)
│   └───flutter                       # Flutter application (GUI)
│       └───sci                       
│           └───lib                     # Application source code
│               ├───controllers           # Backend controllers
│               ├───pages                 # Main pages
│               └───widgets               # Custom widgets
└───test                            # System tests (documented in report)
    ├───logs                          # Test logs
    └───src                           # Test/logging script