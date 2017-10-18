addpath('../BIH')
addpath('../ECG')
nb_samples = 360*100;
[ samplefreq, dualecg, annotations, annotationSamples ] = readSignalAndAnnotations('../BIH/', '100', nb_samples);

ecg = dualecg(:,1);
Rpeaks = annotationSamples(annotations(:) == 1)+1; 

figure
samples = 1:nb_samples;
hold on
plot(samples, ecg)
scatter(Rpeaks, ecg(Rpeaks),50,'b')

waveletFilteredECG = waveletFilterECG(ecg);
plot(waveletFilteredECG);

% Max BPM expected
maxBPM = 150;        
[bpm, locations] = calculate_bpm3(waveletFilteredECG', samplefreq, maxBPM);

scatter(locations, ecg(locations),20,'r')
