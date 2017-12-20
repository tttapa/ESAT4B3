#include <MIDI_Controller.h>
#include "DigitalCC.h"

// USBDebugMIDI_Interface midi(115200);

const uint8_t velocity = 0b01111111; // The velocity of the buttons (0b01111111 = 127 = 100%)
const unsigned int latchTime = 100;  // How long a note will be held on, in DigitalLatch mode (in milliseconds).

const int speedMultiply = 1; // If the jog wheels or other encoders are too slow in your software, increase this value
                             // (it will be multiplied with the actual speed of the encoder, as the name implies.) Default is 1.

//_____________________________________________________________________________________________________________________________________________________________________________________________

Analog faders[] = {
    {A0, 0x00, 1}, // Create a new instance of class 'Analog' on pin A0, controller number 0x07 (channel volume), on MIDI channel 1.
    {A1, 0x01, 1},
    {A2, 0x02, 1},
    {A3, 0x03, 1},
};

Analog knobsTop[] = {
    {A4, 0x08, 1}, // Create a new instance of class 'Analog' on pin A4, controller number 0x10 (General Purpose Controller 1), on MIDI channel 1.
    {A5, 0x09, 1},
    {A6, 0x0A, 1},
    {A7, 0x0B, 1},
};

/*
Analog knobsSide[] = {
    {A8,  0x08, 1}, // Create a new instance of class 'Analog' called 'potSide1', on pin A8, controller number 0x0A (pan), on MIDI channel 1.
    {A9,  0x09, 1},
    {A10, 0x0A, 1},
    {A11, 0x0B, 1},
};
*/

Analog side = {A8,  0x24, 1};

DigitalCC switches[] = { // MATLAB only supports control messages
    {2, 0x10, 1},
    {3, 0x11, 1},
    {5, 0x12, 1},
    {7, 0x13, 1},
};

// RotaryEncoder enc = {1, 0, 0x2F, 1, speedMultiply, NORMAL_ENCODER, TWOS_COMPLEMENT}; // Create a new instance of class 'RotaryEncoder' called enc, on pins 1 and 0, controller number 0x2F, on MIDI channel 1, at normal speed, using a normal encoder (4 pulses per click/step), using the TWOS_COMPLEMENT sign option

Bank bank(4); // A bank with four channels

BankSelector bankselector(bank, 11, LED_BUILTIN, BankSelector::TOGGLE); // A bank selector with a single toggle switch on pin 11 and an LED for feedback on pin 13

//_____________________________________________________________________________________________________________________________________________________________________________________________

void setup()
{
    bank.add(faders, Bank::CHANGE_ADDRESS); // Add the control elements to the bank
    // bank.add(knobsSide, Bank::CHANGE_ADDRESS);
    bank.add(knobsTop, Bank::CHANGE_ADDRESS);
    bank.add(switches, Bank::CHANGE_ADDRESS);
}

//_____________________________________________________________________________________________________________________________________________________________________________________________

void loop() // Refresh all inputs
{
    MIDI_Controller.refresh();
}
