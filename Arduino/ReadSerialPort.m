function main
global h value msgtype ecgbuffer bufferlen
    addpath('../GUI & Tests/')
    close all

    msgtype = 0;
    value = uint16(0);

    samplefreq = 360;
    windowsize = 10;

    bufferlen = windowsize * samplefreq;
    ecgbuffer = zeros(bufferlen,1);

    %t = testapp;

    %t.UIAxes.YLim = [0, 1023];
    %xtime = (0:bufferlen-1)/samplefreq;
    %xtime = windowsize - xtime;

    instrfind
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
        clear instrfind;
    end

    s = serial('COM9','BaudRate',1000000);
    
    s.BytesAvailableFcn = @cb;
    s.BytesAvailableFcnCount = 1;
    s.BytesAvailableFcnMode = 'byte';

    fopen(s);

    h = axes;
    while ishandle(h)

    end
end

function cb (s, event, time)
global h value msgtype ecgbuffer bufferlen
    %if s.BytesAvailable >= 1
    %    s.BytesAvailable
        x = uint16(fread(s, 1));

        if bitand(x, 128) ~= 0 % 128 == 0b10000000
            % if it's a header byte
            msgtype = bitand(x, 7); % 7 == 0b0111
            value = bitshift(bitand(x, 112), 3); % 112 == 0b01110000 
        else 
            % if it's a data byte
            value = bitor(value, x);
            if msgtype == 0 % ECG signal
                ecgbuffer(1:(bufferlen-1)) = ecgbuffer(2:bufferlen);
                ecgbuffer(bufferlen) = value;
                value;
                value = uint16(0);
                if ishandle(h)
                    plot(h, ecgbuffer);
                    drawnow
                end
            end
        end
    %end
end