function [ RESULT_saturation ] = calculateSaturation( INPUT_redSignal, INPUT_infraredSignal, INPUT_fs, INPUT_startSample, INPUT_endSample )
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

if nargin == 3
    INPUT_startSample = 1;
    INPUT_endSample = length(INPUT_redSignal);
elseif nargin == 4
    INPUT_endSample = length(INPUT_redSignal);
end

if INPUT_startSample < 1
   INPUT_startSample = 1; 
end

if INPUT_endSample > length(INPUT_redSignal)
   INPUT_endSample = length(INPUT_redSignal); 
end


%%
% FILTERING
%
filteredRedSignal = filter_PPG(INPUT_redSignal, fs, INPUT_startSample, INPUT_endSample);
filteredInfraredSignal = filter_PPG(INPUT_infraredSignal, fs, INPUT_startSample, INPUT_endSample);


%%
% CALCULATION
%

[~, ~, acRed, dcRed] = analyzePPG(INPUT_redSignal(INPUT_startSample:INPUT_endSample), filteredRedSignal(INPUT_startSample:INPUT_endSample), fs, 120);
[~, ~, acInfrared, dcInfrared] = analyzePPG(INPUT_infraredSignal(INPUT_startSample:INPUT_endSample), filteredInfraredSignal(INPUT_startSample:INPUT_endSample), fs, 120);

RESULT_saturation = (110 - 25 * (acRed/acInfrared) * (dcInfrared/dcRed));
