const String mqtt_broker = "mqtt.eclipseprojects.io";
const String mqtt_client_name = "sci_client";
const int mqtt_broker_port = 1883;

abstract class topics {
  static String STATUS = "planktoscope_status";
  static String SAMPLE = "planktoscope_sample";
  static String POS = "planktoscope_pos";
}
