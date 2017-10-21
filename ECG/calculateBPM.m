function [ RESULT_BPM, RESULT_locations ] = calculateBPM( INPUT_data, INPUT_fs, INPUT_maxBPM )
%
% CALCULATE_BPM returns a list of peak locations for a given signal and the
% average BPM over that signal.
%
% @param INPUT_data - column vector of data
% @param INPUT_fs - sample rate
% @param INPUT_maxBPM - maximum expected BPM
%


%%
% Execution
%

% Get the locations of the peaks
[~, RESULT_locations] = analyzeECG(INPUT_data, INPUT_fs, INPUT_maxBPM);

% If we found 2+ peaks, we can calculate the average BPM over the entire
% dataset
if length(RESULT_locations) > 1
    
    % Get the location of the first and last beat
    firstBeat = RESULT_locations(1);
    lastBeat = RESULT_locations(length(RESULT_locations));
    
    % Calculate the average BPM
    numBeats = length(RESULT_locations) - 1;
    numMinutes = (lastBeat - firstBeat) / INPUT_fs / 60;
    RESULT_BPM = numBeats / numMinutes;
    
else
    % If we found 0 peaks or just 1 peak, we cannot calculate a BPM
    RESULT_BPM = 0;
end

end

