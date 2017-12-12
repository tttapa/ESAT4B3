#include "Serial_Protocol.h"

const float samplefreq = 360e0;
const uint8_t analogPin = A0;
const uint8_t panicPin = 2;

void setup() {
  Serial.begin(1000000);
  while (!Serial);
  pinMode(panicPin, INPUT_PULLUP);
}

const unsigned long interval = round(1e6 / samplefreq);

void loop() {
  static unsigned long prevmicros = micros();
  if (micros() - prevmicros >= interval) {
    uint16_t value = analogRead(analogPin);
    // send(value, ECG);
    prevmicros += interval;
  }

  static bool prevPanicState = HIGH;
  bool panicState = digitalRead(panicPin);
  if (panicState != prevPanicState) {
    if (panicState == LOW) {
      send(PANIC);
    }
    prevPanicState = panicState;
  }
}

