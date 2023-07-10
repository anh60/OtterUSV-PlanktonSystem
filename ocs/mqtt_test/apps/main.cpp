#include <iostream>
#include "../mqtt_client_test/include/mqtt_client_test.h"

int main(int, char**) {
    std::string helloJim = generateHelloString("Jim");
    std::cout << helloJim << std::endl;

    return 0;
}