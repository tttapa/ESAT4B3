// #define DEBUG // Print the message as binary ASCII instead of sending raw bytes

enum message_type {
  ECG         = 0b000,
  PPG_RED     = 0b001,
  PPG_IR      = 0b010,
  PRESSURE_A  = 0b011,
  PRESSURE_B  = 0b100,
  PRESSURE_C  = 0b101,
  PRESSURE_D  = 0b110,
  COMMAND     = 0b111
};

enum command_type : uint16_t {
  NO_PANIC    = 0b0000,
  PANIC       = 0b0001,
  LED_OFF     = 0b0010,
  LED_ON      = 0b0011,
  BUZZER_OFF  = 0b0100,
  BUZZER_ON   = 0b0101
};

void encode(uint8_t (&buffer)[2], uint16_t value, message_type type = COMMAND);  // Function prototypes
void decode(uint8_t (&buffer)[2], uint16_t &value, message_type &type);
void send(uint16_t value, message_type type = COMMAND);
bool receive(uint16_t &value, message_type &type);
void printBin(Stream &s, uint8_t data);

void encode(uint8_t (&buffer)[2], uint16_t value, message_type type = COMMAND) {
  buffer[1] = value & 0b01111111;         // l
  buffer[0] = (value >> 3) & 0b01110000;  // m
  buffer[0] |= (type & 0b0111);           // t
  buffer[0] |= 0b10000000;                // set msb
}

void decode(uint8_t (&buffer)[2], uint16_t &value, message_type &type) {
  value = buffer[1] | ((buffer[0] & 0b01110000) << 3);
  type = static_cast<message_type>(buffer[0] & 0b0111);
}

void send(uint16_t value, message_type type = COMMAND) {
  uint8_t messageToSend[2];
  encode(messageToSend, value, type);
#ifdef DEBUG
  for (uint8_t i = 0; i < sizeof(messageToSend); i++)
    printBin(Serial, messageToSend[i]);
  Serial.println();
#else
  Serial.write(messageToSend, sizeof(messageToSend));
#endif
}

bool receive(uint16_t &value, message_type &type) {
  if (!Serial.available())
    return false;
  static uint8_t messageReceived[2] = {};
  uint8_t data = Serial.read();
  if (data & 0b10000000) {  // If it's a header byte (first byte)
    messageReceived[0] = data;
    return false;
  } else if (messageReceived[0]) {  // If it's a data byte (second byte) and a first byte has been received
    messageReceived[1] = data;
    decode(messageReceived, value, type);
    messageReceived[0] = 0;
    return true;
  } else {
    return false;
  }
}

void printBin(Stream &s, uint8_t data) {
  for (int8_t i = 7; i >= 0; i--)
    s.print(data & (1 << i) ? '1' : '0');
  s.print(' ');
}
