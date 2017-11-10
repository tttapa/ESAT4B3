%% Initialization
close all
addpath('../../Data')
load('100m.mat')
samplefreq = 360;
seconds = 4;
samples = samplefreq * seconds;
offset = 0;
ecg = val(1,1+offset:samples+offset); % Neem één frame uit de input-data
time = (0+offset:samples-1+offset)/samplefreq; % de tijd in seconden van elke sample

dcoffset = 1023;

noise = 360*sin(time*2*pi/10+pi/6);% + 9*sin(time*2*pi*50) + 2*wgn(samplefreq*seconds,1,0)'; % 0.5 and 50 Hz + white gaussian noise
noisy = ecg + noise;

edges = 40;
%% Wavelet transformations
wv = 'sym4'; % Symlet 4 heeft ongeveer dezelfde vorm als een QRS complex, en is orthogonaal, dus kan real-time berekend worden

wtecg = modwt(ecg, wv); % pas de discrete wavelet-transformatie toe op het ECG-signaal
wtrec = zeros(size(wtecg)); % maak een matrix met dezelfde dimensies als het resultaat en vul ze met nullen
wtrec(4:5,:) = wtecg(4:5,:); % kopiëer level 4 en 5 van het resultaat naar de nieuwe matrix
ecgfiltered = imodwt(wtrec, wv); % voer de inverse discrete wavelet-transformatie toe op de nieuwe matrix

% do the same thing for the noisy signal
wtnoisy = modwt(noisy,wv);
wtrecnoisy = zeros(size(wtnoisy));
wtrecnoisy(3:5,:) = wtnoisy(3:5,:);
noisyfiltered = imodwt(wtrecnoisy,wv);

%% Plotting

figure
hold on
%plot(time, ecg)
plot(time(edges:samples-edges-1), noisy(edges:samples-edges-1))

%plot(time, ecgfiltered)
%plot(time, noisyfiltered)
%plot(time, ecgfiltered.^2/30)

plot(time(edges:samples-edges-1), noisyfiltered(edges:samples-edges-1),'r')
%plot(time, noisyfiltered.^2/30)
xlabel('Time (s)');
ylabel('Aplitude');
title('Wavelet filtering of the ECG signal');
legend('Raw ECG signal','ECG signal after wavelet filter');


%%
fourier = fft(noisyfiltered);
frequencies = ((1:samples)-1) * samplefreq / samples;

figure
axis tight
plot(frequencies, fourier)


