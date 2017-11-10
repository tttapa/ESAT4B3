function [ RESULT_saturation ] = calculateSaturation( INPUT_redSignal, INPUT_infraredSignal, INPUT_fs, INPUT_maxBPM, INPUT_startSample, INPUT_endSample )
%CALCULATE_SATURATION calculates the oxygen saturation using Beer-Lambert's
% law
%
% @param INPUT_redSignal - column vector of red signal data
% @param INPUT_infraredSignal - column vector of infrared signal data
% @param INPUT_startSample - starting sample of the signals
% @param INPUT_endSample - ending sample of the signals

%%
% SETUP
%

if nargin == 4
    INPUT_startSample = 1;
    INPUT_endSample = length(INPUT_redSignal);
elseif nargin == 5
    INPUT_endSample = length(INPUT_redSignal);
end

if INPUT_startSample < 1
   INPUT_startSample = 1; 
end

if INPUT_endSample > length(INPUT_redSignal)
   INPUT_endSample = length(INPUT_redSignal); 
end


% Remove unneccesary parts of the signal
INPUT_redSignal = INPUT_redSignal(INPUT_startSample:INPUT_endSample);
INPUT_infraredSignal = INPUT_infraredSignal(INPUT_startSample:INPUT_endSample);


%%
% FILTERING
%
filteredRedSignal = filter_PPG(INPUT_redSignal, INPUT_fs);
filteredInfraredSignal = filter_PPG(INPUT_infraredSignal, INPUT_fs);


%%
% CALCULATION
%

noiseEnd = 50;

[~, ~, acRed, dcRed] = analyzePPG(INPUT_redSignal(noiseEnd:end), filteredRedSignal(noiseEnd:end), INPUT_fs, INPUT_maxBPM);
[~, ~, acInfrared, dcInfrared] = analyzePPG(INPUT_infraredSignal(noiseEnd:end), filteredInfraredSignal(noiseEnd:end), INPUT_fs, INPUT_maxBPM);

RESULT_saturation = (110 - 25 * (acRed/acInfrared) * (dcInfrared/dcRed));
