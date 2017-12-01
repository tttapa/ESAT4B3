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

    baudrate = 115200;             % Serial port baud rate

    bytesPerMessage = 2;
    messagesPerSerialParse = 16;
    
%% Settings

    windowsize = 5; % show 5 seconds of data

    framerate = 15; % frames per second
    
    secondsPerMinute = 5; % 60
    secondsPerQuarterH = 5; % 15*60
    
% ECG
    ECG_gain = 140;
    ECG_mVref = 5000;

    ECG_samplefreq = 360;
    
    % TODO: why are there transients at the start of the vector, but not at
    % the end?
    ECG_extrasamples = ECG_samplefreq * 2; % samples containing transients are cut off the plot
    
    ECG_range = [-6e0 6e0]; % [-inf inf]; for automatic ranges
    ECG_baseline = int16(511);
    
    ECG_lineWidth = 2;
    ECG_cursorWidth = 10;
    
    BPM_minimumAllowedValue = 40;
    
% PPG    
    PPG_samplefreq = 50 ;
    PPG_extrasamples = PPG_samplefreq * 0;
    PPG_range = [-512 512];
    SPO2_Bufferlen = 15;
    
    PPG_lineWidth = 2;
    PPG_cursorWidth = 10;
    PPG_baseline = 0;
    
% Pressure    
    PresHighThreshold = 600;
    PresLowThreshold = 400;
    
%% Serial port stuff

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

    s = startSerial(serialPort, baudrate, bytesPerMessage * messagesPerSerialParse, @handleIncomingMessage, @serialerror);
    if s == false
        return;
    end

%% Initializations

% GUI
    frameduration = 1.0 / framerate;
    gui = HealthVision;
    gui.HealthVisionUIFigure.DeleteFcn = @closeapp;
    
% ECG
    ecg = ECG(windowsize, ECG_extrasamples, ECG_samplefreq, ...
        ECG_range, ECG_lineWidth, ECG_cursorWidth, ...
        ECG_baseline, ECG_mVref, ECG_gain, ...
        gui.GraphPanel, gui.ECGAxesHome, gui.ECGAxesDetail, gui.ECGButton, ...
        BPM_minimumAllowedValue);

% PPG    
    ppg = PPG(windowsize, PPG_extrasamples, PPG_samplefreq, SPO2_Bufferlen, ...
        PPG_range, PPG_lineWidth, PPG_cursorWidth, ...
        PPG_baseline, ...
        gui.PPGAxesHome, gui.PPGAxesDetail1, gui.PPGAxesDetail2, gui.PPGButton);
    
% Pressure
    pres = Pressure(PresHighThreshold, PresLowThreshold, ...
        gui.StepsAxesDetail1, gui.StepsAxesDetail2, ...
        gui.StepsLampLB, gui.StepsLampLF, gui.StepsLampRB, gui.StepsLampRF);

%% Main loop

    fopen(s);
    frametime = tic;
    running = true;
    SecondTimer_prevTime= uint64(posixtime(datetime('now')));
    firstMinute = true;
    
    while running % && exist(string(s.Port),'file') % TODO: this doesn't work ... How to check if the serial device is still available?
        if toc(frametime) >= frameduration
            frametime = tic;
            drawAll;
            % drawnow;
        end
        now = uint64(posixtime(datetime('now')));
        if now - SecondTimer_prevTime >= 1
            everySecond;
            if mod (now, secondsPerMinute) == 0
                everyMinute;
            end
            if mod (now, secondsPerQuarterH) == 0
                everyQuarterH;
            end
            SecondTimer_prevTime = SecondTimer_prevTime + 1;
        end
        pause(frameduration/3);
    end

%% Close serial port when finished
    fclose(s);
    delete(s);
    disp('Done.');

    function closeapp(~, ~)
        running = false;
    end

    function serialerror(~, ~, ~) % TODO: necessary?
        running = false;
    end

%% Handling of incoming messages

    function handleIncomingMessage (value, msgtype)
        switch msgtype 
            case 'ECG'
                ecg.add(value);
            case 'PPG_RED'
                ppg.add_RD(value);
            case 'PPG_IR'
                ppg.add_IR(value);
            case 'PRESSURE_A'
                pres.add_HL(value);
            case 'PRESSURE_B'
                pres.add_TL(value);
            case 'PRESSURE_C'
                pres.add_HR(value);
            case 'PRESSURE_D'
                pres.add_TR(value);
            case 'COMMAND'
        end
    end

%% Draw everything to the app

    function drawAll
        ecg.draw;
        ppg.draw;
        pres.draw;
    end

    function everySecond
        ecg.displayBPM;
        ppg.displaySPO2;
    end

    function everyMinute
        if firstMinute % ignore the first (incomplete) minute
            firstMinute = false;
        else
    % Save BPM minute average
            ecg.saveBPM(now);
            ppg.saveSPO2(now);
        end
        ecg.resetBPM;
        ppg.resetSPO2;
    end

    function everyQuarterH
        pres.saveSteps;
        pres.resetSteps;
    end

end % end of main function