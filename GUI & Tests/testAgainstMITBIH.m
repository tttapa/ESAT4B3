close all;

addpath('../BIH')
addpath('../ECG')
dataset = '100';

nb_samples = 360*10; % how many samples to test
[ samplefreq, dualecg, annotations, annotationSamples ] = readSignalAndAnnotations('../BIH/', dataset, nb_samples); % directory containing data, dataset number, number of samples

samples = 1:nb_samples; % X axis
rawecg = dualecg(:,2)'; % only look at the first signal
Rpeaks = annotationSamples(annotations(:) == 1)+1; % only use the annotations for R-peaks (https://www.physionet.org/physiotools/wfdb/lib/ecgcodes.h) TODO

time = samples/samplefreq;
whitenoise = 60*wgn(nb_samples,1,0)';
noise = 360*sin(time*2*pi/2) + 36*sin(time*2*pi*50) + whitenoise; % 0.5 and 50 Hz + white gaussian noise

ecg = rawecg;
% ecg = ecg + noise;

figure
hold on
plot(samples, ecg + 1000)
plot(samples, rawecg) % plot the raw ECG signal
scatter(Rpeaks, rawecg(Rpeaks),50,'b') % plot the expert annotations

waveletFilteredECG = waveletFilterECG(ecg, 5, [0,0,1,1,1,0]); % perform the wavelet transformation filter
plot(waveletFilteredECG.^2/200); % plot the square of the wavelet filtered signal
plot(waveletFilteredECG-500); % plot the wavelet filtered signal


% Max BPM expected
maxBPM = 220;        
[bpm, locations] = calculateBPM(waveletFilteredECG', samplefreq, maxBPM);

scatter(locations, rawecg(locations),20,'r') % plot the detected R-peaks

%%
missed = 0;
falsePositive = 0;

expertIndex = 1;
testIndex = 1;

while (expertIndex <= length(Rpeaks) && testIndex <= length(locations))
    if (abs(Rpeaks(expertIndex) - locations(testIndex)) > 4)
        if (Rpeaks(expertIndex) > locations(testIndex))
            falsePositive = falsePositive + 1;
            disp ("False positive:");
            disp(locations(testIndex));
            testIndex = testIndex + 1;
        else
            missed = missed + 1;
            disp ("Missed:");
            disp(Rpeaks(expertIndex));
            expertIndex = expertIndex + 1;
        end 
    else
        testIndex = testIndex + 1;
        expertIndex = expertIndex + 1;
    end
end
