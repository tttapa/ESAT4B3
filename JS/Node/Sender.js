class BufferedSender {
    constructor(ws, message_type, length) {
        this.ws = ws;
        this.length = length;
        this.counter = 0;
        this.buffer = new Uint16Array(length + 1);
        this.buffer[0] = message_type;
    }

    send(value) {
        this.buffer[++this.counter] = value;
        if (this.counter == this.length) {
            this.ws.broadcast(this.buffer);
            this.counter = 0;
        }
    }
};

const message_type = {
    ECG         : 0,
    PPG_RED     : 1,
    PPG_IR      : 2,
    PRESSURE_A  : 3,
    PRESSURE_B  : 4,
    PRESSURE_C  : 5,
    PRESSURE_D  : 6,
    COMMAND     : 7,
    BPM         : 8,
    SPO2        : 9,
    STEPS       : 10,
};

module.exports = { BufferedSender, message_type };