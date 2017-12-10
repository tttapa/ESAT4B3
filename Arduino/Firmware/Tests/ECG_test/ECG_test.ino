#include <Serial_Protocol.h>
#include <RunningAverage.h>

#define USE_PROTOCOL

const uint8_t ECG_pin = A4;
const float ECG_samplefreq  = 360;

void setup() {
  Serial.begin(115200);
}

const unsigned long ECG_interval  = round(1e6 / ECG_samplefreq);
void loop() {
  
  static unsigned long ECG_prevmicros = micros();
  if (!Serial) {
    ECG_prevmicros = micros();
  } else if (micros() - ECG_prevmicros >= ECG_interval) {
    uint16_t value = analogRead(ECG_pin);
#ifdef USE_PROTOCOL
    send(value, ECG);
#else
    Serial.println(value);
#endif
    ECG_prevmicros += ECG_interval;
  }
}

