function main
addpath('../GUI & Tests/')
global bufferlen ecgbuffer msgtype value t xtime
msgtype = 0;
value = uint16(0);

samplefreq = 360;
windowsize = 10;

bufferlen = windowsize * samplefreq;
ecgbuffer = zeros(bufferlen,1);

t = testapp;

t.UIAxes.YLim = [0, 1023];
xtime = (0:bufferlen-1)/samplefreq;
xtime = windowsize - xtime;

fclose(instrfind);
delete(instrfind);
clear instrfind;
instrfind
s = serial('COM9','BaudRate',115200);
s.BytesAvailableFcnCount = 2;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcn = @serialevent;
fopen(s);
tic;
while (s.Status ~= 'open') && (toc < 5000)
end
if toc > 5000
    disp("Error opening port")
else 
    disp("Port open")
end
pause(10);
end

function [] = serialevent(obj,event,time)
global bufferlen ecgbuffer msgtype value t xtime
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
            value = uint16(0);
            assignin('base', 'ecgbuffer', ecgbuffer);
%            plot(t.UIAxes, xtime, ecgbuffer);
        end
    end
end
