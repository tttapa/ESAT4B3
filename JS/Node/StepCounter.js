class StepCounter {
    constructor() {
        this.lowThres = 400;
        this.highThres = 600;
        this.steps = 0;
        this.stepping = false;
    }
    add(value) {
        if(this.stepping) {
            if (value < this.lowThres) {
                this.stepping = false;
            }
        } else {
            if (value > this.highThres) {
                this.stepping = true;
                this.steps++;
                return true;
            }
        }
        return false;
    }
    reset() {
        this.steps = 0;
    }
}

module.exports = { StepCounter };