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
    pressureAverageLen = 64;
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
    assignin('base', 'GraphPanel', gui.GraphPanel);
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
    PresHL_average = 0; % Heel Left
    PresTL_average = 0; % Toes Left
    PresHR_average = 0; % Heel Right
    PresTR_average = 0; % Toes Right
    
    PresL_stepCtr = StepCounter(PresHighThreshold, PresLowThreshold);
    PresR_stepCtr = StepCounter(PresHighThreshold, PresLowThreshold);
    
    stepsPerQuarter = double.empty();
    
    dirty_feet = false;

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
                PresHL_average = value;
                PresL_stepCtr.add(value);
                dirty_feet = true;
                disp(value);
            case 'PRESSURE_B'
                PresTL_average = value;
                dirty_feet = true;
            case 'PRESSURE_C'
                PresHR_average = value;
                PresR_stepCtr.add(value);
                dirty_feet = true;
            case 'PRESSURE_D'
                PresTR_average = value;
                dirty_feet = true;
            case 'COMMAND'
        end
    end

%% Draw everything to the app

    function drawAll
    % ECG plot
        ecg.draw;
        ppg.draw;
        
    % PPG plot
        % set(PPG_plot,'YData',PPG_buffer);
        
    % Pressure % TODO
        if dirty_feet
            % Heel Left
            [r, g, b] = step_color_category(double(PresHL_average));
            gui.StepsLampLB.Color = [r, g, b];
            % Toes Left
            [r, g, b] = step_color_category(double(PresTL_average));
            gui.StepsLampLF.Color = [r, g, b];
            % Heel Right
            [r, g, b] = step_color_category(double(PresHR_average));
            gui.StepsLampRB.Color = [r, g, b];
            % Toes Right
            [r, g, b] = step_color_category(double(PresTR_average));
            gui.StepsLampRF.Color = [r, g, b];
            dirty_feet = false;
        end
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
        saveSteps(PresL_stepCtr.steps + PresR_stepCtr.steps)
        PresL_stepCtr.reset;
        PresR_stepCtr.reset;
    end
    
    function saveSteps(steps)
        disp(strcat({'Steps last 15 min: '}, string(steps)));
        stepsPerQuarter = [stepsPerQuarter steps];
        fileID = fopen('Steps.csv','a');
        fprintf(fileID,'%d\t%d\r\n', now, steps);
        % fprintf(fileID,'%016X\t%f\r\n', now, BPM);
        fclose(fileID);
    end

end % end of main function