function [RESULT_AC, RESULT_DC, RESULT_locations] = PPG_getACDC(INPUT_filtered, INPUT_unfiltered, INPUT_maxBPM, INPUT_fs)

% ANALYZE_ECG returns a list of peaks and their respective locations in the
% data.
%
% @param INPUT_data - column vector of data
% @param INPUT_fs - sample rate
% @param INPUT_maxBPM - highest expected BPM

%% SETUP

% Minimum expected samples per heartbeat using sample rate & max BPM
minHeartbeatLength = floor(INPUT_fs * 60 / INPUT_maxBPM);

% Percentage of highest value that will be the cut-off value
% cutOffFactor = 0.4;

%% EXECUTION
    
% Find the highest value in the interval, and calculate the cut-off value
% highestValue = max(INPUT_data);
% cutOffValue = highestValue*cutOffFactor;

% Find the peaks within this interval
%   -> Parameter 3: minDistance must be <= length(INPUT_data) - 2
[RESULT_peaks, RESULT_locations] = getPeaks(INPUT_filtered, 0, min([minHeartbeatLength, length(INPUT_filtered) - 2]));

RESULT_AC = mean(RESULT_peaks);
RESULT_DC = mean(INPUT_unfiltered);

end

