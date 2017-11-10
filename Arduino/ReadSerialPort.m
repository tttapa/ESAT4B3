function main
% global h value msgtype ecgbuffer bufferlen samplefreq
    addpath('../GUI & Tests/')
    close all

    msgtype = 0; % initialization of variables used in callback functions 
    value = uint16(0); % "

    samplefreq = 360;
    windowsize = 10; % show 10 seconds of data

    bufferlen = windowsize * samplefreq;
    ecgbuffer = zeros(bufferlen,1); % create an empty buffer
    
    instrfind % List serial ports
    if ~isempty(instrfind) % Close and delete open serial ports
        fclose(instrfind);
        delete(instrfind);
        clear instrfind;
    end

    % Add a serial port
    if isunix % Linux
        s = serial('/dev/ttyACM0','BaudRate',1000000);
    elseif ispc % Windows
        s = serial('COM9','BaudRate',1000000);
    end
    
    tic;
    
    s.BytesAvailableFcn = @cb; % Callback function
    s.BytesAvailableFcnCount = 100; % On every byte received
    s.BytesAvailableFcnMode = 'byte';

    fopen(s); % Open the serial port
    h = axes;
    while ishandle(h)

    end

    function cb (s, event, time) % Callback function that executes when a new byte arrives on the serial port
    %global h value msgtype ecgbuffer bufferlen samplefreq
        % Print how many samples (2 Bytes) it should have received in the time it received one sample
        disp(toc * samplefreq * 2 / s.BytesAvailableFcnCount) 
        tic;
        x = uint16(fread(s, s.BytesAvailableFcnCount)); % Read the data from the buffer

        for i = 1:s.BytesAvailableFcnCount
            % https://github.com/tttapa/ESAT4B3/blob/master/Arduino/Serial-Protocol.md
            if bitand(x(i), 128) ~= 0 % 128 == 0b10000000
                % if it's a header byte
                msgtype = bitand(x(i), 7); % 7 == 0b0111
                value = bitshift(bitand(x(i), 112), 3); % 112 == 0b01110000 
            else 
                % if it's a data byte
                value = bitor(value, x(i));
                if msgtype == 0 % ECG signal
                    ecgbuffer(1:(bufferlen-1)) = ecgbuffer(2:bufferlen); % shift the buffer
                    ecgbuffer(bufferlen) = value; % add the new value to the buffer
                    value;
                    value = uint16(0);
                end
            end
        end
        if ishandle(h)
            plot(h, ecgbuffer); % Plot the buffer
            drawnow
        end
    end
end