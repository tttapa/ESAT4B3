#ifndef BPMCOUNTER_H
#define BPMCOUNTER_H

#include <stdint.h>

class BPMCounter {
  public:
    BPMCounter(unsigned int samplefreq = 360, uint16_t threshold = 511, uint8_t minBPM = 30, uint8_t maxBPM = 220)
      : samplefreq(samplefreq), threshold(threshold), maxdistance(samplefreq * 60 / minBPM), mindistance(samplefreq * 60 / maxBPM) {}
    int run(uint16_t value) {
        unsigned int distance = 0;
        if (prevCtr > 0)
            prevCtr++;

        if (max > 0) {                        // Registering peak
            if (value >= max) {                  // New maximum
                ctr = 0;
                max = value;
            } else if (value < threshold) {      // End of peak
                ctr++;
                if (prevCtr > 0) {                   // there was a previous peak
                    distance = prevCtr - ctr;          // calculate the difference from the previous peak
                    if (distance >= mindistance) {
                        BPM = 60.0 * samplefreq / distance;
                    } else {
                        distance = -1;
                        BPM = 0;
                    }
                }
                prevCtr = ctr;
                max = 0;
            } else {                             // Falling peak, still above threshold
                ctr++;
            }
        } else if (prevCtr >= maxdistance) {  // Previous peak was too long ago, forget it
            prevCtr = 0;
            distance = -1;
            BPM = 0;
        } else if (value >= threshold) {      // New peak, first sample above threshold
            ctr = 0;
            max = value;
        }
        return distance;
    }
    float getBPM() {
        return BPM;
    }
  private:
    const unsigned int samplefreq;
    const unsigned int maxdistance;
    const unsigned int mindistance;
    const uint16_t threshold = 511;
    unsigned int ctr, prevCtr = 0;
    uint16_t max = 0;
    float BPM = 0;
};

#endif