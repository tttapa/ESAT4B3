function [ RESULT_BPM ] = calculate_bpm2( INPUT_data, INPUT_fs, INPUT_maxBPM )
%CALCULATE_BPM Summary of this function goes here
%   Detailed explanation goes here

[~, result2] = analyze_ecg2(INPUT_data, INPUT_fs, INPUT_maxBPM);

if length(result2) > 1
    firstBeat = result2(1);
    lastBeat = result2(length(result2));
    
    % # Beats = length(result2) - 1
    % # Minutes = # samples 
    RESULT_BPM =  (length(result2) - 1)/((lastBeat - firstBeat) / INPUT_fs / 60);
else
    RESULT_BPM = 0;
end

end

