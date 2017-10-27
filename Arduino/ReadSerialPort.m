function main
global bufferlen ecgbuffer msgtype value
    msgtype = 0;
    value = uint16(0);

bufferlen = 360*5;
ecgbuffer = zeros(bufferlen,1);

fclose(instrfind);
instrfind
s = serial('COM9','BaudRate',115200);
s.BytesAvailableFcnCount = 1;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcn = @serialevent;
fopen(s);
pause(10);
fclose(s);
end

function [] = serialevent(obj,event,time)
global bufferlen ecgbuffer msgtype value
    x = uint16(fread(obj, 1));
    
    if bitand(x, 128) % 128 == 0b10000000
        % if it's a header byte
        msgtype = bitand(x, 96); % 96 == 0b01100000
        value = bitshift(bitand(x, 7), 7); % 7 == 0b111 
    else 
        % if it's a data byte
        value = bitor(value, x);
        if msgtype == 0 % ECG signal
            ecgbuffer(1:(bufferlen-1)) = ecgbuffer(2:bufferlen);
            ecgbuffer(bufferlen) = value;
            value;
            value = uint16(0);
            assignin('base', 'ecgbuffer', ecgbuffer);
            plot(ecgbuffer);
        end
    end
end
