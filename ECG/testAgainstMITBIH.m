addpath('../BIH')
dataset = '103';

nb_samples = 360*100; % how many samples to test
[ samplefreq, dualecg, annotations, annotationSamples ] = readSignalAndAnnotations('../BIH/', dataset, nb_samples); % directory containing data, dataset number, number of samples

samples = 1:nb_samples; % X axis
rawecg = dualecg(:,1)'; % only look at the first signal
Rpeaks = annotationSamples(annotations(:) == 1)+1; % only use the annotations for R-peaks (https://www.physionet.org/physiotools/wfdb/lib/ecgcodes.h) TODO

time = samples/samplefreq;
whitenoise = 60*wgn(nb_samples,1,0)';
noise = 360*sin(time*2*pi/2) + 36*sin(time*2*pi*50) + whitenoise; % 0.5 and 50 Hz + white gaussian noise

ecg = rawecg;
ecg = ecg + noise;

figure
hold on
plot(samples, ecg + 1000)
plot(samples, rawecg) % plot the raw ECG signal
scatter(Rpeaks, rawecg(Rpeaks),50,'b') % plot the expert annotations

waveletFilteredECG = waveletFilterECG(ecg, 5, [0,0,1,1,1,0]); % perform the wavelet transformation filter
plot(waveletFilteredECG); % plot the wavelet filtered signal

% Max BPM expected
maxBPM = 220;        
[bpm, locations] = calculate_bpm3(waveletFilteredECG', samplefreq, maxBPM);

scatter(locations, rawecg(locations),20,'r') % plot the detected R-peaks
