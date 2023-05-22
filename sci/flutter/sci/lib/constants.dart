const String mqtt_broker = "mqtt.eclipseprojects.io";
const String mqtt_client_name = "sci_client";
const int mqtt_broker_port = 1883;

abstract class topics {
  static const String STATUS_FLAGS = "planktoscope/status/flags";
  static const String STATUS_CONNECTED = "planktoscope/status/connected";
  static const String CTRL_SAMPLE = "planktoscope/control/sample";
  static const String CAL_CURRPOS = "planktoscope/calibrate/currpos";
  static const String CAL_NEXTPOS = "planktoscope/calibrate/nextpos";
  static const String CAL_PHOTO = "planktoscope/calibrate/photo";
}
