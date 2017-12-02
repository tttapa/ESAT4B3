function [SPO2] = PPG_getSPO2(INPUT_filteredR, INPUT_dcR, INPUT_filteredIR, INPUT_dcIR, maxBPM, fs)

startR = uint16(length(INPUT_filteredR)/6);
startIR = uint16(length(INPUT_filteredIR)/6);

noTransferR = INPUT_filteredR(startR:end);
noTransferIR = INPUT_filteredIR(startIR:end);

AC_red = PPG_getAC(noTransferR, maxBPM, fs);
AC_infrared = PPG_getAC(noTransferIR, maxBPM, fs);

R = (AC_red/INPUT_dcR)/(AC_infrared/INPUT_dcIR);

SPO2 = 110 - 25*R;

end



function [RESULT_AC] = PPG_getAC(INPUT_filtered, INPUT_maxBPM, INPUT_fs)

% ANALYZE_ECG returns a list of peaks and their respective locations in the
% data.
%
% @param INPUT_data - column vector of data
% @param INPUT_fs - sample rate
% @param INPUT_maxBPM - highest expected BPM

%% SETUP

% Minimum expected samples per heartbeat using sample rate & max BPM
minHeartbeatLength = floor(INPUT_fs * 60 / INPUT_maxBPM);

%% EXECUTION

% Find the peaks within this interval
%   -> Parameter 3: minDistance must be <= length(INPUT_data) - 2
[RESULT_peaks, ~] = getPeaks(INPUT_filtered, 0, min([minHeartbeatLength, length(INPUT_filtered) - 2]));

RESULT_AC = mean(RESULT_peaks);

end


