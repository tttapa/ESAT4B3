#include <Serial_Protocol.h>
#include <RunningAverage.h>

const uint8_t pressurePin = A4;
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
  static RunningAverage<uint16_t, 16> pressureAverage; // average over 16 samples
  static uint16_t previousPressVal = 0;
  
  uint16_t pressureVal = analogRead(pressurePin);
  pressureVal = pressureAverage.add(pressureVal);
  
  if (previousPressVal != pressureVal) {
    send(pressureVal, PRESSURE_A);
    previousPressVal = pressureVal;
  }
}

