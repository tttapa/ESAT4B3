function [ RESULT_peaks, RESULT_locations ] = analyze_ecg( INPUT_data, INPUT_fs, INPUT_maxBPM )
% ANALYZE_ECG Displays an analyzed graph of the ECG input data
%   inputData -> column vector of data
%   fs -> sample rate
%   maxBPM -> highest expected BPM



%
% SETUP
%

% Minimum expected samples per heartbeat (using sample rate & max BPM)
minSamplesPerHeartbeat = floor(INPUT_fs * 60 / INPUT_maxBPM);

% Maximum number of heartbeats that we will analyze per interval
heartbeatsPerInterval = 8;

% Calculate the interval size!
%
% CASE 1: length(inputData) > (minSamplesPerHeartbeat * heartbeatsPerInterval)
%   -> Use the calculated value for the interval size
%
% CASE 2: length(inputData) <= (minSamplesPerHeartbeat * heartbeatsPerInterval)
%   -> Use the size of the input data for the interval size
samplesPerInterval = min([heartbeatsPerInterval * minSamplesPerHeartbeat, length(INPUT_data)]);

% Keep track of which sample we are on
counter = 1;
totalCount = length(INPUT_data);

% Result variables
RESULT_peaks = [];
RESULT_locations = [];



%
% EXECUTION
%

% Go through the input data, one interval at a time
while counter <= totalCount
    
    % Get the next interval:
    %   -> Lower limit = counter
    %   -> Upper limit:
    %      CASE 1: length(inputData) > (counter + interval size)
    %           -> use the calculated value for the interval's upper limit
    %      CASE 2: length(inputData) <= (counter + interval size)
    %           -> use the upper limit of the input data for the interval's
    %              upper limit
    upperLim = min([counter+samplesPerInterval-1, length(INPUT_data)]);
    subData = INPUT_data(counter:upperLim, 1);
    

    
    % Detrend the data (subtract it by a polynomial of the sixth degree)
    [p,~,mu] = polyfit((1:numel(subData))',subData,6);
    f_y = polyval(p,(1:numel(subData))',[],mu);
    detrendedData = subData - f_y;
    
    
    % Find the highest value in the interval, and calculate our cut-off
    % value (40% of the maximum value)
    highestValue = max(detrendedData);
    cutOffValue = highestValue*2/5;
    
    % Plot to see exacty what interval the function is looking at
    %figure, plot(detrendedData), title(strcat(num2str(counter), ', ', num2str(cutOffValue)));
    
    % Find the peaks within this interval
    %   -> MinPeakHeight = cut-off value
    %   -> MinPeakDistance = min samples per heartbeat (unless detrended
    %                        data is shorter than the previous value)
    [curPeaks, curLocations] = findpeaks(detrendedData, 'MinPeakHeight',cutOffValue,'MinPeakDistance',min([minSamplesPerHeartbeat, length(detrendedData)-2]));
    
    % Add (counter-1) to each of the locations because with each interval
    % the locations start at 1. They should start at 'counter'.
    curLocations = curLocations + counter - 1;

    
    % Save the results for this loop
    RESULT_peaks = [RESULT_peaks;curPeaks];
    RESULT_locations = [RESULT_locations;curLocations]; 
    
    % Increment the counter, so we can move onto the next interval
    counter = counter + samplesPerInterval;
    
end

end
