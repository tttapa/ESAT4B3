function [ rSignal, irSignal ] = TEST_createPPGTestData( seconds )
%PPG_CREATETESTDATA Summary of this function goes here
%   Detailed explanation goes here


% Signal details
%
%   fs = 500 Hz
%   seconds_max = 1000
%   seconds_min = 10
%
fs = 500;

if nargin == 0
   seconds = 100; 
end

if seconds > 1000
    seconds = 1000;
end

if seconds < 10
    seconds = 10;
end

seconds = uint16(seconds);


% Load variable
S = load('TEST_PPGSignal.mat');
TEST_PPGSignal = S.TEST_PPGSignal;

% Original signal
originalSignal = TEST_PPGSignal(1:seconds*fs);

% Mean/STD
originalMean = mean(originalSignal);
originalSTD = std(originalSignal);

rMean = 1890;
rSTD = 5;

irMean = 6150;
irSTD = 40;

% Create R/IR Signals
normSignal = (originalSignal - originalMean) / originalSTD;

rSignal = (normSignal * rSTD) + rMean;
irSignal = (normSignal * irSTD) + irMean;

figure, plot(rSignal);
axis([-inf inf 1800 2000]);
figure, plot(irSignal);
axis([-inf inf 6000 6300]);

end

