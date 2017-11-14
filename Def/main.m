function main
% MAIN The main function for running the "slimme thuiszorgmonitor"
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
    messagesPerSerialParse = 6;
    
%% Plot settings

    framerate = 30; % frames per secondend
    
    % ECG 
    
    ECG_gain = 140;
    ECG_mVref = 5000;

    ECG_samplefreq = 360;
    ECG_windowsize = 5; % show 5 seconds of data
    
    % TODO: why are there transients at the start of the vector, but not at
    % the end?
    ECG_extrasamples = ECG_samplefreq * 2; % samples containing transients are cut off the plot
    
    ECG_range = [-6e0 6e0]; % [-inf inf];
    ECG_baseline = int16(511);
    
    % PPG
    
    PPG_samplefreq = 30;
    PPG_windowsize = 10; % show 10 seconds of data

    PPG_range = [0 1023];
    
%% Initializations

    msgtype = message_type(0); % initialization of variables used in callback function
    value = uint16(0);         % "

    frameduration = 1.0 / framerate;
    
    ECG_scalingFactor = ECG_mVref / 1023.0 / ECG_gain;
    ECG_visiblesamples = ECG_windowsize * ECG_samplefreq;
    ECG_bufferlen = ECG_visiblesamples + ECG_extrasamples;
    ECG_buffer = int16(zeros(ECG_bufferlen,1)); % create an empty buffer
    ECG_filtered = double(zeros(ECG_bufferlen,1));
    ECG_time = linspace(-ECG_windowsize, 0, ECG_visiblesamples);
    ECG_settings = ECG_setup(ECG_samplefreq);
    
    BPM_minuteSum = 0;
    recording = false;

    ECG_BPM_previousTime = uint64(0);
    
    bpmtime = tic;
    
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

    s.BytesAvailableFcn = @serialcb; % Callback function for serial port
    s.BytesAvailableFcnCount = bytesPerMessage * messagesPerSerialParse; % On every x bytes received
    s.InputBufferSize = 2.^(ceil(log2(s.BytesAvailableFcnCount))+1);
    % disp(strcat({'Input buffer size: '}, string(s.InputBufferSize)));
    % disp(strcat({'Bytes per redraw:  '}, string(s.BytesAvailableFcnCount)));
    s.BytesAvailableFcnMode = 'byte';
    
    s.ErrorFcn = @serialerror;
    s.BreakInterruptFcn = @serialerror;

%% Set up plot

    gui = GUI_app;
    gui.UIFigure.DeleteFcn = @closeapp;

    ECG_plot = plot(gui.UIAxes, ECG_time,ECG_buffer(ECG_extrasamples+1:ECG_bufferlen));
    set(gui.UIAxes,'XLim',[-ECG_windowsize 0],'YLim',ECG_range);
    
    PPG_plot = plot(gui.UIAxes2, PPG_time,PPG_buffer);
    set(gui.UIAxes2,'XLim',[-PPG_windowsize 0],'YLim',PPG_range);
    
%% Main loop

    fopen(s);
    frametime = tic;
    running = true;
    % disp(string(s.Port))
    % disp(exist('/dev/ttyACM1','file'))
    while running % && exist(string(s.Port),'file') % TODO: this doesn't work ... How to check if the serial device is still available?
        if toc(frametime) >= frameduration
            frametime = tic;
            drawAll;
        end
        now = uint64(posixtime(datetime('now')));
        if ECG_BPM_previousTime == 0
            ECG_BPM_previousTime = now;
        end
        if now - ECG_BPM_previousTime >= 1
            displayBPM;
            ECG_BPM_previousTime = ECG_BPM_previousTime + 1;
        end
            
        pause(frameduration/10);
    end

%% Close serial port when finished
    fclose(s);
    delete(s);
    disp('Done.');

    function closeapp(~, ~)
        running = false;
    end

    function serialerror(Error, err_msg, time) % TODO: necessary?
        running = false;
    end

%% Serial callback

    function serialcb (s, ~, ~) % Callback function that executes when a new byte arrives on the serial port
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
                ECG_buffer(ECG_bufferlen) = int16(value) - ECG_baseline; % add the new value to the buffer
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
    % ECG plot
        ECG_filtered = ECG_filter(ECG_buffer, ECG_settings);
        % ECG_filtered = double(ECG_buffer);
        ECG_filtered = ECG_filtered(ECG_extrasamples+1:ECG_bufferlen);
        ECG_filtered = ECG_filtered * ECG_scalingFactor;
        set(ECG_plot,'YData',ECG_filtered);
        
        
    % PPG plot
        set(PPG_plot,'YData',PPG_buffer);
    end

    function displayBPM
        BPM = ECG_getBPM(ECG_filtered, ECG_samplefreq);
        gui.beatrateEditField.Value = BPM;
        gui.Gauge.Value = BPM;
        
        BPM_minuteSum = BPM_minuteSum + BPM;
        
        now = uint64(posixtime(datetime('now')));
        if mod (now, 60) == 0
            if recording
                saveBPM(BPM_minuteSum / 60);
            end
            BPM_minuteSum = 0;
            recording = true;
        end
    end
    
    function saveBPM(BPM)
        disp(strcat({'Average BPM: '}, string(BPM)));
    end

end % end of main function