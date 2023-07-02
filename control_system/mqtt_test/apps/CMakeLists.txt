cmake_minimum_required(VERSION 3.26)
project(main)
add_executable(main main.cpp)
target_link_libraries(main PRIVATE mqtt_client_test)