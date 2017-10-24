%% Initialization
addpath('../../Data')
load('100m.mat')
samplefreq = 360;
seconds = 2;
offset = 0;
ecg = val(1,1+offset:samplefreq*seconds+offset); % Neem één frame uit de input-data
time = (0+offset:samplefreq*seconds-1+offset)/samplefreq; % de tijd in seconden van elke sample

noise = 360*sin(time*2*pi/2) + 36*sin(time*2*pi*50) + 60*wgn(samplefreq*seconds,1,0)'; % 0.5 and 50 Hz + white gaussian noise
noisy = ecg + noise;

figure
hold on
plot(time, ecg)
plot(time, noisy)

%% Wavelet transformations
wv = 'sym4'; % Symlet 4 heeft ongeveer dezelfde vorm als een QRS complex, en is orthogonaal, dus kan real-time berekend worden

wtecg = modwt(ecg, wv); % pas de discrete wavelet-transformatie toe op het ECG-signaal
wtrec = zeros(size(wtecg)); % maak een matrix met dezelfde dimensies als het resultaat en vul ze met nullen
wtrec(4:5,:) = wtecg(4:5,:); % kopiëer level 4 en 5 van het resultaat naar de nieuwe matrix
ecgfiltered = imodwt(wtrec, wv); % voer de inverse discrete wavelet-transformatie toe op de nieuwe matrix

% do the same thing for the noisy signal
wtnoisy = modwt(noisy,wv);
wtrecnoisy = zeros(size(wtnoisy));
wtrecnoisy(4:5,:) = wtnoisy(4:5,:);
noisyfiltered = imodwt(wtrecnoisy,wv);

%% Plotting
%plot(time, ecgfiltered)
%plot(time, noisyfiltered)
plot(time, ecgfiltered.^2/30)
plot(time, noisyfiltered.^2/30)

%% Energy distribution
QRSoffset = 50;
QRSlength = 54;
QRS = val(1,1+QRSoffset:QRSlength+QRSoffset) - 960; % Neem één QRS-peak uit de input-data
QRStime = (QRSoffset:QRSoffset+QRSlength-1); % / samplefreq;

figure
plot(QRStime, QRS)

wtQRS = modwt(QRS, wv);

levels = floor(log2(length(QRS))) + 1

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

%% Fourier analysis
fourierQRS = fft(QRS);
xfrequencies = (1:QRSlength) * samplefreq / QRSlength;
frequencies = xfrequencies(1:6)';
amplitudes = abs(real(fourierQRS(1:6)))';
fft_table = table(frequencies, amplitudes);
disp(fft_table)
figure
semilogy(xfrequencies(1:QRSlength/2), abs(real(fourierQRS(1:QRSlength/2))), '-o')
figure
plot(xfrequencies(1:QRSlength/2), 10*log10(abs(real(fourierQRS(1:QRSlength/2)))), '-o')