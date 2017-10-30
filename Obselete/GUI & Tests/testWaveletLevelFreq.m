close all

samples = 360;
samplefreq = 360;

time = ((1:samples)-1)/samplefreq;
ecg = sin(time*2*pi*90); % 120 Hz sine wave

figure, plot(time, ecg);
fourier = fft(ecg);
frequencies = ((1:samples)-1)*samplefreq/samples;
figure, plot(frequencies, 10*log10(fourier), 'o')

%%
wtQRS = modwt(ecg, wv);

[cA1, cD1] = dwt(ecg, wv);
[cA2, cD2] = dwt(cA1, wv);
[cA3, cD3] = dwt(cA2, wv);
[cA4, cD4] = dwt(cA3, wv);
[cA5, cD5] = dwt(cA4, wv);

x4 = idwt(cA5, cD5, wv);

figure
hold on
plot(x4)
plot(cA4)

x3 = idwt(x4, cD4, wv);
x2 = idwt(x3, cD3, wv);
x1 = idwt(x2, cD2, wv);
x0 = idwt(x1, cD1, wv);



levels = floor(log2(length(ecg))) + 1

lowfrequencies = zeros(levels, 1);
highfrequencies = zeros(levels, 1);

for i = 1:(levels-1)
    lowfrequencies(i) = samplefreq / 2.^(i+1);
    highfrequencies(i) = samplefreq / 2.^i;
end
lowfrequencies(levels) = 0;
highfrequencies(levels) = samplefreq / 2.^levels;

energy_by_scales = sum(wtQRS.^2,2);
Levels = (1:levels)';
energy_table = table(Levels,energy_by_scales, lowfrequencies, highfrequencies);
disp(energy_table)
figure
plot(Levels', energy_by_scales','-o')