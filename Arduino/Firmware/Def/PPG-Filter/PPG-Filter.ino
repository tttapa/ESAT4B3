#define FILTER // uncomment this line to filter the PPG signal on the Arduino instead of in MATLAB

#include <Serial_Protocol.h>
#include <RunningAverage.h>
#ifdef FILTER
#include <FIRFilter.h>
#include <IIRFilter.h>
#endif

const float PPG_samplefreq  = 50;
const uint8_t PPG_pin = A4;
const int16_t DC_offset = 511;

#ifdef FILTER
const float b_lp[] = { 0.638945525159022, 1.27789105031804, 0.638945525159022 };
const float a_lp[] = { 1, 1.14298050253990,  0.412801598096189 };

const float b_hp[] = { 1, -1 };
const float a_hp[] = { 1, -0.9950 };

IIRFilter lp(b_lp, a_lp);
IIRFilter hp(b_hp, a_hp);
#endif

void setup() {
  Serial.begin(115200);
}

void loop() {
  const static unsigned long PPG_interval  = round(1e6 / PPG_samplefreq);
  static unsigned long PPG_prevmicros = micros();
  
  if (!Serial) {
    PPG_prevmicros = micros();
  } else if (micros() - PPG_prevmicros >= PPG_interval) {
    measurePPGAndSend();
    PPG_prevmicros += PPG_interval;
  }
}

void measurePPGAndSend() {
  int16_t value = analogRead(PPG_pin);
#ifdef FILTER
  float filtered = lp.filter(
                   hp.filter(value - DC_offset));
  value = round(filtered) + DC_offset;
#endif
  send(value, PPG_IR);
}
