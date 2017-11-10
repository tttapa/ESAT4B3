addpath('../Data');
load('100m.mat');
samplefreq = 360; DT = 1/samplefreq;
ecg = val(1,1:3600);
t = 0:DT:(numel(ecg)*DT)-DT;
[cfs,f] = cwt(ecg,'bump',1/DT,'VoicesPerOctave',32);
helperCWTTimeFreqPlot(cfs,t,f,'surf','CWT of ECG signal',...
    'seconds','Hz')