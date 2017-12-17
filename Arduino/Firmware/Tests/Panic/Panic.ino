#include "Serial_Protocol.h"

const uint8_t buttonPin = 2;

void setup() {
  Serial.begin(115200);
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  while (digitalRead(buttonPin) == HIGH);
  send(PANIC, COMMAND);
  while (digitalRead(buttonPin) == LOW);
  delay(500);
}

