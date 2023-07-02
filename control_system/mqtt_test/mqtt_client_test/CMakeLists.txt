cmake_minimum_required(VERSION 3.11-3.18)

project(mqtt_client_test)
add_library(mqtt_client_test src/mqtt_client_test.cpp)
target_include_directories(${PROJECT_NAME} PUBLIC mqtt_client_test/include)