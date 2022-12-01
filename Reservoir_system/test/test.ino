// GPIOs
#define PUMP  2
#define VALVE 3
#define LEVEL 4
#define WATER 5

// CONTROL COMMANDS
#define CMD1 0x01
#define CMD2 0x02
#define CMD3 0x03
#define CMD4 0x04
#define CMD5 0x05

// STATUS SIGNALS
#define S1 0x01
#define S2 0x02
#define S3 0x03
#define S4 0x04
#define S5 0x05

void setup() {

  // Initialize GPIOs
  pinMode(PUMP, OUTPUT);
  pinMode(VALVE, OUTPUT);
  pinMode(LEVEL, INPUT);
  pinMode(WATER, INPUT);

  // Initialize UART
  //Serial1.begin(9600);
  Serial.begin(9600);
}

void loop() {

}
