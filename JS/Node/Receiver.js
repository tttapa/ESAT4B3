class Receiver {
    constructor () {
        this.byte0 = 0;
        this.byte1 = 0;
    }
    receive(data) {
        if (data & 0b10000000) {  // If it's a header byte (first byte)
            this.byte0 = data;
            return null;
        } else if (this.byte0 !== 0) {  // If it's a data byte (second byte) and a first byte has been received
            this.byte1 = data;
            let message = this.decode();
            this.byte0 = 0;
            return message;
        } else {
            return null;
        }
    }
    decode() {
        let message = new Object();
        message.value = this.byte1 | ((this.byte0 & 0b01110000) << 3);
        message.type = this.byte0 & 0b0111;
        return message;
    }
};
const message_type = {
    ECG         : 0b000,
    PPG_RED     : 0b001,
    PPG_IR      : 0b010,
    PRESSURE_A  : 0b011,
    PRESSURE_B  : 0b100,
    PRESSURE_C  : 0b101,
    PRESSURE_D  : 0b110,
    COMMAND     : 0b111
}
module.exports = { Receiver, message_type };