fileID = fopen('200.dat', 'r');
bytes = fread(fileID, 'uint8');

byteslength = length(bytes);

datalength = 8*byteslength/12/2;

ecg = int16.empty(datalength, 0);

dataindex = uint32(1);

step = 0;

twelvebit = uint16(0);

for i = 1:byteslength
    byte = int16(bytes(i));
    step;
    if(step == 0)
        twelvebit = byte;
    end
    if(step == 1)
        twelvebit = bitor(twelvebit, bitshift(bitand(byte, bin2dec('00001111')), 8));
        ecg(dataindex) = twelvebit;
        dataindex = dataindex + 1;
        twelvebit = bitshift(bitand(byte, bin2dec('11110000')), 4);
    end
    if(step == 2)
        twelvebit = bitor(twelvebit, byte);
        ecg(dataindex) = twelvebit;
        dataindex = dataindex + 1;
    end
    step = step + 1;
    if (step == 3)
        step = 0;
    end    
end

fileID = fopen('200.dat');
bytes = uint8(fread(fileID));

byteslength = length(bytes);

datalength = 8*byteslength/12/2;

ecg = int16.empty(datalength, 0);

dataindex = uint32(1);

step = 0;

twelvebit = uint16(0);

for i = 1:byteslength
    byte = int16(bytes(i));
    step;
    if(step == 0)
        twelvebit = byte;
    end
    if(step == 1)
        twelvebit = bitor(twelvebit, bitshift(bitand(byte, bin2dec('00001111')), 8));
        ecg(dataindex) = twelvebit;
        dataindex = dataindex + 1;
        twelvebit = bitshift(bitand(byte, bin2dec('11110000')), 4);
    end
    if(step == 2)
        twelvebit = bitor(twelvebit, byte);
        ecg(dataindex) = twelvebit;
        dataindex = dataindex + 1;
    end
    step = step + 1;
    if (step == 3)
        step = 0;
    end    
end