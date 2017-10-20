function [ RESULT_BPM, RESULT_LOCATIONS ] = calculate_bpm( INPUT_data, INPUT_fs, INPUT_maxBPM )
%CALCULATE_BPM Summary of this function goes here
%   Detailed explanation goes here

[~, locations] = analyze_ecg(INPUT_data, INPUT_fs, INPUT_maxBPM);

if length(locations) > 1
    firstBeat = locations(1);
    lastBeat = locations(length(locations));
    
    % # Beats = length(result2) - 1
    % # Minutes = # samples 
    RESULT_BPM =  (length(locations) - 1)/((lastBeat - firstBeat) / INPUT_fs / 60);
else
    RESULT_BPM = 0;
end

RESULT_LOCATIONS = locations;

end

