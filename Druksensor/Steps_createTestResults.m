function [ RESULT_steps ] = Steps_createTestResults()
%STEPS_CREATETESTRESULTS Summary of this function goes here
%   Detailed explanation goes here

intervalMinutes = 15;
numMeasurements = uint16(24*60/intervalMinutes);

RESULT_steps = zeros(1, numMeasurements);

% 0:00 - 6:30 no steps (0% - 0.2708%) of the day
for i = 1:uint16(0.2708*numMeasurements)

    RESULT_steps(i) = 0;
    
end

% 6:30 - 7:30 few steps
averageSteps = 6000 / numMeasurements;
maxPertubation = 2000 / numMeasurements;
for i = uint16(0.2807*numMeasurements)+1:uint16(0.3125*numMeasurements)

    RESULT_steps(i) = uint16(averageSteps + maxPertubation*rand);
    
end



% 7:30 - 12:00 varying number of steps
averageSteps = 15000 / numMeasurements;
maxPertubation = 15000 / numMeasurements;
for i = uint16(0.3125*numMeasurements)+1:uint16(0.5*numMeasurements)

    RESULT_steps(i) = uint16(averageSteps + maxPertubation*rand);
    
end

% 12:00 - 14:00 few steps
averageSteps = 4000 / numMeasurements;
maxPertubation = 1000 / numMeasurements;
for i = uint16(0.5*numMeasurements)+1:uint16(0.5833*numMeasurements)

    RESULT_steps(i) = uint16(averageSteps + maxPertubation*rand);
    
end


% 14:00 - 19:00 varying number of steps
averageSteps = 12000 / numMeasurements;
maxPertubation = 8000 / numMeasurements;
for i = uint16(0.5833*numMeasurements)+1:uint16(0.7917*numMeasurements)

    RESULT_steps(i) = uint16(averageSteps + maxPertubation*rand);
    
end
