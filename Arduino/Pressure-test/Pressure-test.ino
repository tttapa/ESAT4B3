#include "Serial_Protocol.h"
#include "RunningAverage.h"

RunningAverage<8> pressureAverage;
uint16_t previousPressVal = 0;
const uint8_t pressurePin = A4;

const float Pres_samplefreq = 50;

void setup() {
  Serial.begin(115200);
}

const unsigned long Pres_interval = round(1e6 / Pres_samplefreq);

void loop() {
  static unsigned long Pres_prevmicros = micros();
  if (!Serial) {
    Pres_prevmicros = micros();
  } else if (micros() - Pres_prevmicros >= Pres_interval) {
    uint16_t pressureVal = analogRead(pressurePin);
    pressureVal = pressureAverage.add(pressureVal);
    if (previousPressVal != pressureVal) {
      send(pressureVal, PRESSURE_A);
      previousPressVal = pressureVal;
    }
    Pres_prevmicros += Pres_interval;
  }
}

