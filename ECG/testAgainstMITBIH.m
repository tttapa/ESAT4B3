addpath('../BIH')
dataset = '103';

nb_samples = 360*100; % how many samples to test
[ samplefreq, dualecg, annotations, annotationSamples ] = readSignalAndAnnotations('../BIH/', dataset, nb_samples); % directory containing data, dataset number, number of samples

ecg = dualecg(:,1); % only look at the first signal
Rpeaks = annotationSamples(annotations(:) == 1)+1; % only use the annotations for R-peaks (https://www.physionet.org/physiotools/wfdb/lib/ecgcodes.h) TODO

figure
samples = 1:nb_samples; % X axis
hold on
plot(samples, ecg) % plot the raw ECG signal
scatter(Rpeaks, ecg(Rpeaks),50,'b') % plot the expert annotations

waveletFilteredECG = waveletFilterECG(ecg, 5, [0,0,1,1,1,0]); % perform the wavelet transformation filter
plot(waveletFilteredECG); % plot the wavelet filtered signal

maxBPM = 200; % Max BPM expected
[bpm, locations] = calculate_bpm2(waveletFilteredECG', samplefreq, maxBPM); % find the peaks and BPM

scatter(locations, ecg(locations),20,'r') % plot the detected R-peaks
