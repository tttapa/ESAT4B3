function main
%MAIN The main function for running the "slimme thuiszorgmonitor"
%   Open a serial port for receiving data from the Arduino, start the GUI,
%   and update the GUI with the filtererd incomming data

    clc; close all
    
%% Serial port settings

    % Comment out serialPortXXX for automatic selection
    % serialPortWin   = 'COM5';                   % define COM port for Windows
    % serialPortLinux = '/dev/ttyACM0';           % define serial port for Linux
    % serialPortOSX   = '/dev/tty.usbmodemabcde'; % define serial port for Mac OSX

    baudrate = 1e6;             % Serial port baud rate

    bytesPerMessage = 2;
    messagesPerSerialParse = 64;
    
%% Plot settings

    framerate = 30; % frames per second
    
    ECG_samplefreq = 360;
    ECG_windowsize = 10; % show 10 seconds of data

    ECG_range = [-511 511];
    
    PPG_samplefreq = 30;
    PPG_windowsize = 10; % show 10 seconds of data

    PPG_range = [0 1023];
    
%% Initializations

    msgtype = message_type(0); % initialization of variables used in callback function
    value = uint16(0);         % "

    frameduration = 1000 / framerate;
    
    ECG_bufferlen = ECG_windowsize * ECG_samplefreq;
    ECG_buffer = zeros(ECG_bufferlen,1); % create an empty buffer
    ECG_time = linspace(-ECG_windowsize, 0, ECG_bufferlen);
    
    PPG_bufferlen = PPG_windowsize * PPG_samplefreq;
    PPG_buffer = zeros(PPG_bufferlen,1); % create an empty buffer
    PPG_time = linspace(-PPG_windowsize, 0, PPG_bufferlen);

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

    % Open serial port
    s = serial(serialPort, 'BaudRate', baudrate);

    s.BytesAvailableFcn = @cb; % Callback function
    s.BytesAvailableFcnCount = bytesPerMessage * messagesPerSerialParse; % On every x bytes received
    s.InputBufferSize = 2.^(ceil(log2(s.BytesAvailableFcnCount))+1);
    % disp(strcat({'Input buffer size: '}, string(s.InputBufferSize)));
    % disp(strcat({'Bytes per redraw:  '}, string(s.BytesAvailableFcnCount)));
    s.BytesAvailableFcnMode = 'byte';

%% Set up plot

    gui = GUI_app;

    ECG_plot = plot(gui.UIAxes, ECG_time,ECG_buffer);
    set(gui.UIAxes,'XLim',[-ECG_windowsize 0],'YLim',ECG_range);
    
    PPG_plot = plot(gui.UIAxes2, PPG_time,PPG_buffer);
    set(gui.UIAxes2,'XLim',[-PPG_windowsize 0],'YLim',PPG_range);
    
%% Main loop

    fopen(s);
    tic;
    while ishandle(ECG_plot)
        % java.lang.Thread.sleep(frameduration);
        % pause(frameduration/1000);
        drawAll;
        drawnow;
    end

%% Close serial port when finished
    fclose(s);
    clear s;

    disp('Done.');

%% Serial callback

    function cb (s, ~, ~) % Callback function that executes when a new byte arrives on the serial port
        % Print how many samples (2 Bytes) it should have received in the time it received one sample
        disp(strcat({'Samples sent / samples received = '}, ...
            string(toc * ECG_samplefreq * 2 / s.BytesAvailableFcnCount)));
        tic;
        x = uint16(fread(s, s.BytesAvailableFcnCount)); % Read the data from the buffer

        for i = 1:s.BytesAvailableFcnCount
            % https://github.com/tttapa/ESAT4B3/blob/master/Arduino/Serial-Protocol.md
            if bitand(x(i), 128) ~= 0 % 128 == 0b10000000
                % if it's a header byte
                msgtype = message_type(bitand(x(i), 7)); % 7 == 0b0111
                value = bitshift(bitand(x(i), 112), 3);  % 112 == 0b01110000 
            else 
                % if it's a data byte
                value = bitor(value, x(i));
                handleIncomingMessage(value, msgtype);
                value = uint16(0);
            end
        end
        
    end

%% Handling of incoming messages

    function handleIncomingMessage (value, msgtype)
        switch msgtype 
            case 'ECG'
                ECG_buffer(1:(ECG_bufferlen-1)) = ECG_buffer(2:ECG_bufferlen); % shift the buffer
                ECG_buffer(ECG_bufferlen) = value; % add the new value to the buffer
            case 'PPG_RED'
            case 'PPG_IR'
            case 'PRESSURE_A'
            case 'PRESSURE_B'
            case 'PRESSURE_C'
            case 'PRESSURE_D'
            case 'COMMAND'
        end
    end

%% Draw everything to the app

    function drawAll
        ECG_filtered = ECG_filter(ECG_buffer, ECG_samplefreq);
        if ishandle(ECG_plot)
            set(ECG_plot,'YData',ECG_filtered);
        end
        if ishandle(PPG_plot)
            set(PPG_plot,'YData',PPG_buffer);
        end
    end

end % end of main function