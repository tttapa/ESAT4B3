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
    messagesPerSerialParse = 32;
    
%% Settings

    windowsize = 5;  % show 5 seconds of ECG and PPG data

    framerate = 30;  % frames per second
    
% ECG
    ECG_gain = 140;
    ECG_mVref = 5000;
    ECG_baseline = int16(1023*5/2);

    ECG_samplefreq = 360;
    
    % TODO: why are there transients at the start of the vector, but not at
    % the end?
    ECG_extrasamples = ECG_samplefreq * 2; % samples containing transients are cut off the plot
    
    ECG_range = [-6e0 6e0]; % [-inf inf]; for automatic ranges
    
    ECG_lineWidth = 2;
    ECG_cursorWidth = 10;
    
    BPM_statsInterval = 1*60;  % seconds
    
    BPM_minimumAllowedValue = 40;
    
% PPG    
    PPG_samplefreq = 300;
    PPG_extrasamples = PPG_samplefreq * 0;
    PPG_range = [-512 512];
    SPO2_Bufferlen = 60;
    
    PPG_lineWidth = 2;
    PPG_cursorWidth = 10;
    PPG_baseline = 0;
    
    SPO2_statsInterval = 1*60;  % seconds
    
% Pressure    
    PresHighThreshold = 600;
    PresLowThreshold = 400;
    
    Steps_Interval = 15*60;  % seconds (15 min)
    Steps_Timeframe = 24*60*60 / (15*60) * Steps_Interval;  % seconds (24h), the time frame of the bar graph
    
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

    s = startSerial(serialPort, baudrate, bytesPerMessage * messagesPerSerialParse, ...
        @handleIncomingMessage, @serialerror);
    if s == false
        return;
    end

%% Initializations

% GUI
    frameduration = 1.0 / framerate;
    gui = GUI_createGUI();
    gui.HealthVisionUIFigure.DeleteFcn = @closeapp;
    userdatafcns = UserDataFcns; % WHY MATLAB, WHY?
    userdatafcns.userPrompt(gui);
    username = gui.userdata.name;
    
% ECG
    gui.ECGButton30m.UserData = 30*60;
    gui.ECGButton2h.UserData  = 2*60*60;
    gui.ECGButton6h.UserData  = 6*60*60;
    ecgStats = Stats(gui.userdata,'BPM.csv', BPM_statsInterval, ...
        gui.ECGAxesDetail, gui.ECGStatisticsButtonGroup, ...
        gui.ECGMinEditField, gui.ECGMaxEditField, gui.ECGAvgEditField);
    ecg = ECG(windowsize, ECG_extrasamples, ...
        ECG_samplefreq, ...
        ECG_range, ECG_lineWidth, ECG_cursorWidth, ...
        ECG_baseline, ECG_mVref, ECG_gain, ...
        gui.GraphPanel, gui.ECGAxesHome, gui.ECGButton, ...
        gui.ECGGauge, BPM_minimumAllowedValue, ...
        ecgStats);

% PPG  
    gui.PPGButton30m.UserData = 30*60;
    gui.PPGButton2h.UserData  = 2*60*60;
    gui.PPGButton6h.UserData  = 6*60*60;
    ppgStats = Stats(gui.userdata,'SPO2.csv', SPO2_statsInterval, ...
        gui.PPGAxesDetail3, gui.PPGStatisticsButtonGroup, ...
        gui.PPGMinEditField, gui.PPGMaxEditField, gui.PPGAvgEditField);
    ppg = PPG(windowsize, PPG_extrasamples, PPG_samplefreq, SPO2_Bufferlen, ...
        PPG_range, PPG_lineWidth, PPG_cursorWidth, ...
        PPG_baseline, ...
        gui.PPGPanel, gui.PPGAxesHome, gui.PPGAxesDetail1, gui.PPGAxesDetail2, gui.PPGButton, ...
        ppgStats);
    
% Pressure
    presStats = StepStats(gui.userdata,'Steps.csv', Steps_Interval, ...
        gui.StepsAxesHome, Steps_Timeframe, ...
        gui.StepsGauge, ...
        gui.StepsButton);
    pres = Pressure(PresHighThreshold, PresLowThreshold, ...
        gui.StepsPanel, gui.StepsAxesDetail1, gui.StepsAxesDetail2, ...
        gui.StepsLampLB, gui.StepsLampLF, gui.StepsLampRB, gui.StepsLampRF, ...
        presStats);

%% Main loop

    fopen(s);
    frametime = tic;
    running = true;
    SecondTimer_prevTime = int64(posixtime(datetime('now')));
    
    while running % && exist(string(s.Port),'file') % TODO: this doesn't work ... How to check if the serial device is still available?
    % Update all GUI plots
        if toc(frametime) >= frameduration
            frametime = tic;
            ecg.draw;
            ppg.draw;
            pres.draw;
        end

    % Every second
        now =   int64(posixtime(datetime('now')));
        if now - SecondTimer_prevTime >= 1
        % BPM
            ecg.displayBPM;
            if mod (now, BPM_statsInterval) == 0
                ecg.updateStats(now);
            end
        % SPO2
            ppg.displaySPO2;
            if mod (now, SPO2_statsInterval) == 0
                ppg.updateStats(now);
            end
        % Steps
            pres.stats.updateStepGauge; % TODO: kan properder
            if mod (now, Steps_Interval) == 0
                pres.updateStats(now);
            end

            SecondTimer_prevTime = SecondTimer_prevTime + 1;  % Add only one to make sure never to skip a second
        end
        pause(frameduration/10);  % Pause to give some CPU time to other processes
    end

%% Close serial port when finished
    disp('Done.');

    function closeapp(~, ~)
        stop;
        running = false;
    end

    function serialerror(~, ~, ~) % TODO: necessary?
        stop;
        running = false;
    end

    function stop
        fclose(s);
        delete(s);
        delete(ecg);
        delete(ppg);
        delete(pres);
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
                disp(strcat({'Received command: '}, string(Command(value))));
        end
    end

end % end of main function