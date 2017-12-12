#include <Serial_Protocol.h>
#include <RunningAverage.h>

const uint8_t pressurePins[4] = { A0, A1, A2, A3 };
const float Pres_samplefreq = 50;

void setup() {
  Serial.begin(115200);
}

void loop() {
  const static unsigned long Pres_interval = round(1e6 / Pres_samplefreq);
  static unsigned long Pres_prevmicros = micros();

  if (!Serial) { // For ATmega32U4 and other USB Arduino's
    Pres_prevmicros = micros();
  } else if (micros() - Pres_prevmicros >= Pres_interval) {
    measurePressureAndSend();
    Pres_prevmicros += Pres_interval;
  }
}

void measurePressureAndSend() {
  static RunningAverage<uint16_t, 16> pressureAverages[4]; // average over 16 samples
  static uint16_t previousPressVals[4] = {};

  for (uint8_t i = 0; i < 4; i++) {
    uint16_t pressureVal = analogRead(pressurePins[i]);
    pressureVal = pressureAverages[i].add(pressureVal);
    
    if (previousPressVals[i] != pressureVal) {
      send(pressureVal, PRESSURE_A + i);
      previousPressVals[i] = pressureVal;
    }
  }
}

