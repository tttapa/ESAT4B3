class BPMCounter {
    constructor(samplefreq = 360, threshold = 511, minBPM = 30, maxBPM = 220, difThreshold = 0) {
        this.samplefreq = samplefreq;
        this.threshold = threshold;
        this.maxdistance = samplefreq * 60 / minBPM;
        this.mindistance = samplefreq * 60 / maxBPM;
        this.difThreshold = difThreshold;

        this.ctr = 0;
        this.prevCtr = 0;
        this.max = 0;
        this.prevValue = 0;
    }
    run(value) {
        let distance = 0;
        let dif = value - this.prevValue;
        if (this.prevCtr > 0)
            this.prevCtr++;

        if (this.max > 0) {                        // Registering peak
            if (value >= this.max) {                  // New maximum
                this.ctr = 0;
                this.max = value;
            } else if (value < this.threshold) {      // End of peak
                this.ctr++;
                if (this.prevCtr > 0) {                   // there was a previous peak
                    distance = this.prevCtr - this.ctr;          // calculate the difference from the previous peak
                    if (distance >= this.mindistance) {
                        this.BPM = 60.0 * this.samplefreq / distance;
                    } else {
                        distance = -1;
                        this.BPM = 0;
                    }
                }
                this.prevCtr = this.ctr;
                this.max = 0;
            } else {                             // Falling peak, still above threshold
                this.ctr++;
            }
        } else if (this.prevCtr >= this.maxdistance) {  // Previous peak was too long ago, forget it
            this.prevCtr = 0;
            distance = -1;
            this.BPM = 0;
        } else if (value >= this.threshold && (dif >= this.difThreshold || this.difThreshold === 0)) {      // New peak, first sample above threshold
            this.ctr = 0;
            this.max = value;
        }
        this.prevValue = value;
        return distance;
    }
    getBPM() {
        return this.BPM;
    }
};

module.exports = { BPMCounter };