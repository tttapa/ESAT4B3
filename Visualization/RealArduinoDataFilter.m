close all;
data = csvread('../Data/RealDataArduino.csv');
addpath('../Def');

coeff = ECG_setup(360);

data = data -250;

filtered = ECG_filter(data, coeff);

data = data(100:100+360*2);
filtered = filtered(100:100+360*2);

fftd = fft(data);
fftf = fft(filtered);

figure, hold on,
plot(data);
plot(filtered);

sq = ((filtered).^2) / 1023;
dif = filter([1 -1], 1, sq);

figure, hold on,
plot(sq);
plot(dif);
refline(0,30);
refline(0,12);
plot(-50*(sq > 30));
plot(-75*(dif > 12));
plot(-100*(dif > 12).*(sq > 30));

dif2 = filter([1 1 1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ], 20, sq);

figure, hold on,
plot(sq);
plot(dif);
plot(dif2);
refline(0,30);
refline(0,12);

%% Wavelet

wt = modwt(filtered,6,'sym4');
wtrec = zeros(size(wt));
wtrec(1:5,:) = wt(1:5,:);
wfiltered15 = imodwt(wtrec,'sym4');

wtrec = zeros(size(wt));
wtrec(2:5,:) = wt(2:5,:);
wfiltered25 = imodwt(wtrec,'sym4');

wtrec = zeros(size(wt));
wtrec(3:5,:) = wt(3:5,:);
wfiltered35 = imodwt(wtrec,'sym4');

wtrec = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:);
wfiltered45 = imodwt(wtrec,'sym4');

wtrec = zeros(size(wt));
wtrec(5,:) = wt(5,:);
wfiltered5 = imodwt(wtrec,'sym4');

figure, hold on,
plot(wt');
plot(filtered, '-o');

figure, hold on,
plot(wtrec');
plot(filtered, '-ob');
plot(wfiltered15, '-or');

figure, hold on, 
plot(wfiltered15);
plot(wfiltered25);
plot(wfiltered35);
plot(wfiltered45);
plot(wfiltered5);

%% 
wt = modwt(filtered,4,'sym4');
wtrec = zeros(size(wt));
wtrec(1:4,:) = wt(1:4,:);
wfiltered14 = imodwt(wtrec,'sym4');

wtrec = zeros(size(wt));
wtrec(2:4,:) = wt(2:4,:);
wfiltered24 = imodwt(wtrec,'sym4');

wtrec = zeros(size(wt));
wtrec(3:4,:) = wt(3:4,:);
wfiltered34 = imodwt(wtrec,'sym4');

wtrec = zeros(size(wt));
wtrec(4,:) = wt(4,:);
wfiltered4 = imodwt(wtrec,'sym4');

figure, hold on,
plot(wt');
plot(filtered, '-o');

figure, hold on,
plot(wtrec');
plot(filtered, '-ob');
plot(wfiltered14, '-or');

figure, hold on, 
plot(wfiltered14);
plot(wfiltered24);
plot(wfiltered34);
plot(wfiltered4);