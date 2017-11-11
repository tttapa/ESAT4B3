clc
 
%User Defined Properties 
serialPort = 'COM5';            % define COM port #

plotTitle = 'ECG Simulation';   % plot title
xLabel = 'Sample';              % x-axis label
yLabel = 'ECG';                 % y-axis label
plotGrid = 'off';               % do not show gridlines

terminationValue = 65535;       % if we receive this value, we should stop
samplesShown = 1000;            % number of samples displayed on the screen
maxSamples = 100000;            % pre-allocated size of time and data variables

waitMillis = 1;

timeoutSeconds = 10;
timeoutStarted = false;
timeoutStartTime = 0;

%Define Function Variables
time = 1:maxSamples;
data = zeros(1, maxSamples);
samplesReceived = 0;
 
% Close and delete open serial ports
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
    clear instrfind;
end

% Exit script if port is not available
if(~ismember(serialPort, seriallist))
   disp(['Serial port ' serialPort ' not available: session terminated.']);
   return;
end

%Open Serial COM Port
s = serial(serialPort,'BaudRate',115200);
fopen(s);

%Set up plot
plotGraph = plot(time,data,'-r','LineWidth',1);
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([0 samplesShown -inf inf]);
grid(plotGrid);

% Loop when plot is active
while ishandle(plotGraph)
    
    % Update plot and wait
    drawnow;
    java.lang.Thread.sleep(waitMillis);
    
    % If there are not bytes available, start timeout timer and break the
    % while loop if the timer surpasses timeoutSeconds.
    if(s.BytesAvailable == 0)
        if(timeoutStarted)
            disp(toc(timeoutStartTime));
            if(toc(timeoutStartTime) > timeoutSeconds)
               disp(['No data found in ' int2str(timeoutSeconds) ' seconds: timeout limit reached.']);
               break;
            end
        else
            timeoutStarted = true;
            timeoutStartTime = tic;
        end
        
        % Skip the rest of this while loop
        continue;
    end
    
    % There are bytes available, reset the timeout boolean and read the
    % data
    timeoutStarted = false;
    dat = fscanf(s,'%f');

    % If we've hit the terminate value, exit the while loop
    if(ismember(terminationValue, dat))
        break;
    end
    
    % Make sure data type is correct
    if(~isempty(dat) && isfloat(dat))
        data(samplesReceived + 1:samplesReceived + length(dat)) = dat;
        samplesReceived = samplesReceived + length(dat);    
         
        % If samplesShown > 0, scroll the data
        if(samplesShown > 0)
            startSample = max([samplesReceived-samplesShown+1 1]);
            endSample = max([samplesReceived 2]);
            
            set(plotGraph, ...
                'XData',time(startSample:endSample), ...
                'YData',data(startSample:endSample));
            axis([startSample endSample -inf inf]);
            
        % If samplesShown <= 0, show all of the data on the plot
        else
            set(plotGraph,'XData',time,'YData',data);
            axis([0 samplesReceived -inf inf]);
        end
        
    end
    
end
 
%Close Serial COM Port and Delete useless Variables
fclose(s);
clear data dat endSample maxSamples plotGraph plotGrid plotTitle s ...
    samplesReceived samplesShown startSample serialPort ...
    terminationValue time timeoutSeconds timeoutStarted ...
    timeoutStartTime xLabel yLabel waitMillis;
 
 
disp('Session terminated.');