int sys_status = 0;

abstract class status_flag {
  static int RMS_PUMP = 0;
  static int RMS_VALVE = 1;
  static int RMS_FULL = 2;
  static int RMS_LEAK = 3;
  static int CONNECTED = 4;
  static int SAMPLING = 5;
  static int LEAK = 6;
}
