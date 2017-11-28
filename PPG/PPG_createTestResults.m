function [ RESULT_testData ] = PPG_createTestResults( seconds, fs, smoothness )
%CREATETESTDATA Summary of this function goes here
%   Detailed explanation goes here

maxPertubation = 1.5;
averageValue = 98.0;

if nargin == 2
   smoothness = 0.5; 
end

if smoothness > 1
    smoothness = 1;
end
if smoothness < 0
    smoothness = 0;
end

smoothnessFactor = 6 - 4.5*smoothness;

movingMeanWindow = uint16(fs/smoothnessFactor);

pertubation = rand(1, seconds*fs);

RESULT_testData = averageValue + maxPertubation*pertubation;
RESULT_testData = movmean(RESULT_testData,movingMeanWindow);

end

