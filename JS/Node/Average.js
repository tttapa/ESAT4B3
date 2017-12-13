class MovingAverage {
    constructor(length) {
        this.length = parseInt(length);
        this.previousValues = Array.apply(null, Array(this.length)).map(Number.prototype.valueOf,0);;
        this.sum = 0;
        this.filled = 0;
        this.index = 0;
    }
    add(value) {
        this.sum -= this.previousValues[this.index];
        this.previousValues[this.index] = value;
        this.sum += value;
        this.index++;
        if (this.index === this.length) {
            this.index = 0;
        }
        if (this.filled < this.length) {
            this.filled++;
        }
        return this.sum / this.filled;
    }
    getAverage() {
        return this.sum / this.filled;
    }
}

class Average {
    constructor() {
        this.sum = 0;
        this.filled = 0;
    }
    add(value) {
        this.sum += value;
        this.filled++;
        return this.sum / this.filled;
    }
    reset() {
        this.sum = 0;
        this.filled = 0;
    }
    getAverage() {
        return this.sum / this.filled;
    }
}

module.exports = { MovingAverage, Average };