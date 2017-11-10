ser = py.serial.Serial('COM9', 1000000)
while 1
    py.serial.Serial.readline(ser)
end