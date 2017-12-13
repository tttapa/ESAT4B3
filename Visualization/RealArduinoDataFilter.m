data = csvread('../Data/RealDataArduino.csv');
addpath('../Def');

coeff = ECG_setup(360);


% data = data(1:2*360);
filtered = ECG_filter(data, coeff);

fftd = fft(data);
fftf = fft(filtered);

figure, hold on,
plot(data);
plot(filtered);