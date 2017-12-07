close all;
addpath('../Def');
% addpath('../Data');
load('../Data/100m.mat');
samplefreq = 360;
time = 15;
signal = val(1:samplefreq*time);
signal = signal - mean(signal);
framerate = 30;

settings = ECG_setup(samplefreq);
tic;
for i = 1:framerate*time
    ECG_filter(signal, settings);
end
toc
filtered_A = ECG_filter(signal, settings);

notch    = FIRFilter(settings.b_notch);
lowpass  = IIRFilter(settings.b_lowpass, settings.a_lowpass);
highpass = IIRFilter(settings.b_highpass, settings.a_highpass);

filtered_B = zeros(1,length(signal));
index = 1;
for sample = signal
    filtered_B(index) = notch.filter(lowpass.filter(highpass.filter(sample)));
    index = index + 1;
end

notch    = FIRFilter(settings.b_notch);
lowpass  = IIRFilter(settings.b_lowpass, settings.a_lowpass);
highpass = IIRFilter(settings.b_highpass, settings.a_highpass);

tic;
for sample = signal
    notch.filter(lowpass.filter(highpass.filter(sample)));
end
toc

figure
hold on
plot(signal);
plot(filtered_A);
plot(filtered_B);

% filtered_A - filtered_B