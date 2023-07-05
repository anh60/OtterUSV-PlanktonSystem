const List<String> pscopeLabels = [
  'Sampling',
  'Pump',
  'Calibrating',
  'Leak',
  '-',
  '-',
  '-',
  '-',
];

const List<String> rmsLabels = [
  'Pump',
  'Valve',
  'Leak',
  'Full',
  '-',
  '-',
  '-',
  '-',
];

const int rms_pump = 0;
const int rms_valve = 1;
const int rms_full = 2;
const int rms_leak = 3;
const int sampling = 4;
const int pump = 5;
const int calibrating = 6;
const int leak = 7;

class StatusController {
  StatusByte pscope = StatusByte('PIS', pscopeLabels, 0);
  StatusByte rms = StatusByte('RMS', rmsLabels, 0);

  void setStatus(String statusMessage) {
    int status = int.parse(statusMessage);

    rms.setFlag(0, (status >> rms_pump) & 1);
    rms.setFlag(1, (status >> rms_valve) & 1);
    rms.setFlag(2, (status >> rms_full) & 1);
    rms.setFlag(3, (status >> rms_leak) & 1);

    pscope.setFlag(0, (status >> sampling) & 1);
    pscope.setFlag(1, (status >> pump) & 1);
    pscope.setFlag(2, (status >> leak) & 1);
    pscope.setFlag(3, (status >> calibrating) & 1);
  }
}

class StatusByte {
  String label;
  List<String> flagLabels;
  int flags;

  StatusByte(this.label, this.flagLabels, this.flags);

  void setFlag(int flag, int value) {
    if (value == 1) {
      flags |= (1 << flag);
    } else {
      flags &= (~(1 << flag));
    }
  }
}
