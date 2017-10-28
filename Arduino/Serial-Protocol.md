## Arduino
### Serial Protocol
Serial messages consist of 2 bytes. To prevent framing errors, the first header byte has the msb (most significant bit) set to 1, and the following data byte has the msb set to 0.    
The format is as follows:  

| Byte 1 |     |     |     |     |     |     |     |     | 
|:-------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| bit    |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  | 
| value  | *1* | *t* | *t* | *t* | *x* | *m* | *m* | *m* | 

| Byte 2 |     |     |     |     |     |     |     |     | 
|:-------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:| 
| bit    |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  | 
| value  | *0* | *l* | *l* | *l* | *l* | *l* | *l* | *l* |

*`t`:* message type (3-bit)  
*`x`:* reserved (1-bit)  
*`m`:* three most significant bits of 10-bit value (3-bit)  
*`l`:* seven least significant bits of 10-bit value (7-bit)  

#### Message types
`000`: ECG  
`001`: PPG red  
`010`: PPG IR  
`011`: Pressure A  
`100`: Pressure B  
`101`: Pressure C  
`110`: Pressure D  
`111`: Panic button  

### Implementation
#### Sender

```arduino
uint16_t encode(uint16_t value, uint8_t type);  // Function prototype

void setup() {
  Serial.begin(1000000);
}
const uint8_t type = 0;
const unsigned long interval = round(1e6 / 360e0);

void loop() {
  static unsigned long prevmicros = micros();
  if (micros() - prevmicros >= interval) {
    uint16_t value = analogRead(A0);
    uint16_t messageToSend = encode(value, type);
    Serial.write((uint8_t*)&messageToSend, sizeof(messageToSend));
    prevmicros += interval;
  }
}

uint16_t encode(uint16_t value, uint8_t type) {
  uint8_t LSB = value & 0b01111111;     // l
  uint8_t MSB = (value >> 7) & 0b0111;  // m
  MSB |= (type & 0b0111) << 4;          // t
  MSB |= 0b10000000;                    // MSB set msb
  return (uint16_t) LSB << 8 | MSB;  // AVR is little endian, so MSB goes to LSB position to correct byte order when transmitting byte by byte
}
```
