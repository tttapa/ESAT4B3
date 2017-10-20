addpath('../../Data')
load('100m.mat')
samplefreq = 360;
seconds = 2;
offset = 0;
ecg = val(1,1+offset:samplefreq*seconds+offset); % Neem één frame uit de input-data
time = (0+offset:samplefreq*seconds-1+offset)/samplefreq; % de tijd in seconden van elke sample

colors = [ 'b', 'r', 'g', 'y', 'c'];

weights = [ 
    0, 0,   0, 1,   1, 0; % blue
    0, 0,   1, 1,   1, 0; % red
    0, 0, 0.5, 1, 0.5, 0; % green
    0, 0, 0.5, 1, 0,   0; % yellow
    0, 0,   1, 1, 0.5, 0; % cyan
    ];

figure, hold on
[rows, cols] = size(weights);
for i = 1:rows
    f = waveletFilterECG(ecg, 5, weights(i,:));
    plot(time, f, colors(i));
end

figure, hold on
for i = 1:rows
    f = waveletFilterECG(ecg, 5, weights(i,:));
    plot(time, f.^2, colors(i));
end

noise = 360*sin(time*2*pi/2) + 36*sin(time*2*pi*50) + 60*wgn(samplefreq*seconds,1,0)'; % 0.5 and 50 Hz + white gaussian noise
noisy = ecg + noise;

figure, hold on
for i = 1:rows
    f = waveletFilterECG(noisy, 5, weights(i,:));
    plot(time, f, colors(i));
end

figure, hold on
for i = 1:rows
    f = waveletFilterECG(noisy, 5, weights(i,:));
    plot(time, f.^2, colors(i));
end