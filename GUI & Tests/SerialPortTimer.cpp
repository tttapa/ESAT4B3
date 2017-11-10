#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <stdint.h>
#include <ctime>
#include <chrono>

int set_interface_attribs(int fd, int speed, int parity)
{
    struct termios tty;
    memset(&tty, 0, sizeof tty);
    if (tcgetattr(fd, &tty) != 0)
    {
        printf("error %d from tcgetattr", errno);
        return -1;
    }

    cfsetospeed(&tty, speed);
    cfsetispeed(&tty, speed);

    tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8; // 8-bit chars
    // disable IGNBRK for mismatched speed tests; otherwise receive break
    // as \000 chars
    tty.c_iflag &= ~IGNBRK; // disable break processing
    tty.c_lflag = 0;        // no signaling chars, no echo,
                            // no canonical processing
    tty.c_oflag = 0;        // no remapping, no delays
    tty.c_cc[VMIN] = 0;     // read doesn't block
    tty.c_cc[VTIME] = 5;    // 0.5 seconds read timeout

    tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl

    tty.c_cflag |= (CLOCAL | CREAD);   // ignore modem controls,
                                       // enable reading
    tty.c_cflag &= ~(PARENB | PARODD); // shut off parity
    tty.c_cflag |= parity;
    tty.c_cflag &= ~CSTOPB;
    tty.c_cflag &= ~CRTSCTS;

    if (tcsetattr(fd, TCSANOW, &tty) != 0)
    {
        printf("error %d from tcsetattr", errno);
        return -1;
    }
    return 0;
}

void set_blocking(int fd, int should_block)
{
    struct termios tty;
    memset(&tty, 0, sizeof tty);
    if (tcgetattr(fd, &tty) != 0)
    {
        printf("error %d from tggetattr", errno);
        return;
    }

    tty.c_cc[VMIN] = should_block ? 1 : 0;
    tty.c_cc[VTIME] = 5; // 0.5 seconds read timeout

    if (tcsetattr(fd, TCSANOW, &tty) != 0)
        printf("error %d setting term attributes", errno);
}

enum message_type : uint8_t
{
    ECG = 0b000,
    PPG_RED = 0b001,
    PPG_IR = 0b010,
    PRESSURE_A = 0b011,
    PRESSURE_B = 0b100,
    PRESSURE_C = 0b101,
    PRESSURE_D = 0b110,
    COMMAND = 0b111
};

enum command_type : uint16_t
{
    NO_PANIC = 0b0000,
    PANIC = 0b0001,
    LED_OFF = 0b0010,
    LED_ON = 0b0011,
    BUZZER_OFF = 0b0100,
    BUZZER_ON = 0b0101
};

void decode(uint8_t (&buffer)[2], uint16_t &value, message_type &type)
{
    value = buffer[1] | ((buffer[0] & 0b01110000) << 3);
    type = static_cast<message_type>(buffer[0] & 0b0111);
}

bool receive(int fd, uint16_t &value, message_type &type)
{
    uint8_t data;
    int n = read(fd, &data, 1); // read up to 64 characters if ready to read
    if (n == 0)
        return false;
    static uint8_t messageReceived[2] = {};
    if (data & 0b10000000)
    { // If it's a header byte (first byte)
        messageReceived[0] = data;
        return false;
    }
    else if (messageReceived[0])
    { // If it's a data byte (second byte) and a first byte has been received
        messageReceived[1] = data;
        decode(messageReceived, value, type);
        messageReceived[0] = 0;
        return true;
    }
    else
    {
        return false;
    }
}

int main()
{
    const char *portname = "/dev/ttyACM0";

    int fd = open(portname, O_RDWR | O_NOCTTY | O_SYNC);

    if (fd < 0)
    {
        printf("error %d opening %s: %s", errno, portname, strerror(errno));
        return 1;
    }

    set_interface_attribs(fd, B115200, 0); // set speed to 115,200 bps, 8n1 (no parity)
    set_blocking(fd, 0);                   // set no blocking

    uint16_t value;
    message_type type;

    std::chrono::time_point<std::chrono::high_resolution_clock> start = std::chrono::high_resolution_clock::now();
    std::chrono::time_point<std::chrono::high_resolution_clock> end;

    while (1)
    {
        if (receive(fd, value, type))
        {
            end = std::chrono::high_resolution_clock::now();
            double duration = (std::chrono::duration_cast<std::chrono::milliseconds>(end - start)).count();
            printf("%d\t%lf ms\r\n", value, duration);
            start = end;
        }
    }
}