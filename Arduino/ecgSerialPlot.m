function ecgSerialPlot

clc; close all
 
%% User Defined Properties 

% serialPortWin   = 'COM5';                   % define COM port for Windows
% serialPortLinux = '/dev/ttyACM0';           % define serial port for Linux
% serialPortOSX   = '/dev/tty.usbmodemabcde'; % define serial port for Mac OSX

baudrate = 1000000;             % Serial port baud rate

plotTitle = 'ECG Signal';       % plot title
xLabel = 'Time (s)';            % x-axis label
yLabel = 'ECG';                 % y-axis label
plotGrid = 'off';               % do not show gridlines

%%

msgtype = 0; % initialization of variables used in callback function
value = uint16(0); % '

samplefreq = 360;
bytesPerSample = 2;
framerate = 60; % frames per second
samplesPerRedraw = round(samplefreq/framerate);
windowsize = 10; % show 10 seconds of data

bufferlen = windowsize * samplefreq;
ecgbuffer = zeros(bufferlen,1); % create an empty buffer
time = linspace(-windowsize, 0, bufferlen);

%% Serial port stuff

% Close and delete open serial ports
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
    clear instrfind;
end

% Detect operating system and select correct port
if ismac && exist('serialPortOSX', 'var')
    serialPort = serialPortOSX;
elseif isunix && exist('serialPortLinux', 'var')
    serialPort = serialPortLinux;
elseif ispc && exist('serialPortWin', 'var')
    serialPort = serialPortWin;
else
    serialPort = '';
end

% Check if there are serial ports available on the system
if isempty(seriallist)
    disp('No serial ports available.');
    return;
end

% If no port specified, select the first serial port in the system
if strcmp(serialPort, '')
    sl = seriallist;
    serialPort = sl(1);
    msg = strcat({'Selected serial port '}, serialPort, '.');
    disp(msg);
    
% Exit script if port is not available
elseif(~ismember(serialPort, seriallist))
    errmsg = strcat({'Serial port '}, serialPort, {' not available.'});
    disp(errmsg);
    return;
end

%Open serial port
s = serial(serialPort, 'BaudRate', baudrate);

s.BytesAvailableFcn = @cb; % Callback function
s.BytesAvailableFcnCount = bytesPerSample * samplesPerRedraw; % On every x bytes received
s.InputBufferSize = 2.^(ceil(log2(s.BytesAvailableFcnCount))+1);
% disp(strcat({'Input buffer size: '}, string(s.InputBufferSize)));
% disp(strcat({'Bytes per redraw:  '}, string(s.BytesAvailableFcnCount)));
s.BytesAvailableFcnMode = 'byte';
    
%% Set up plot

figure;
plotGraph = plot(time,ecgbuffer,'-r','LineWidth',1);
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([-windowsize 0 0 1023]);
grid(plotGrid);

%% Main loop

fopen(s);
tic;
while ishandle(plotGraph)
    pause(1); % Don't ramp up the CPU to 100%
end
 
%% Close serial sort when finished
fclose(s);
clear s;

disp('Done.')

%% Serial callback

function cb (s, ~, ~) % Callback function that executes when a new byte arrives on the serial port
        % Print how many samples (2 Bytes) it should have received in the time it received one sample
        disp(strcat({'Samples sent / samples received = '}, string(toc * samplefreq * 2 / s.BytesAvailableFcnCount)));
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
        if ishandle(plotGraph)
            set(plotGraph,'YData',ecgbuffer);
            drawnow
        end
    end
end