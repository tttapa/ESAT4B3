load('TEST_PPGSignal.mat');
signal = TEST_PPGSignal(1:50000);
fs=500;
signal_length = length(signal);
 
fft_signal = fft(signal);       
fft_signal = fft_signal(1:signal_length/2+1);
fft_signal = (1/(fs*signal_length)) * abs(fft_signal).^2;
fft_signal(2:end-1) = 2*fft_signal(2:end-1);

x_freq = 0:fs/signal_length:fs/2; 
settings=PPG_setup(fs);
filtered=PPG_filter(signal, settings);

fft_fsignal = fft(filtered);       
fft_fsignal = fft_fsignal(1:signal_length/2+1);
fft_fsignal = (1/(fs*signal_length)) * abs(fft_fsignal).^2;
fft_fsignal(2:end-1) = 2*fft_fsignal(2:end-1);

figure
plot(x_freq,10*log10(abs(fft_signal)), 'color', [0 0 0]+0.75);
hold on;
plot(x_freq,10*log10(abs(fft_fsignal)),'color', [0 0 0]);
title('Non-filtered Fourier transformed signal');
xlabel('Frequentie (Hz)');
ylabel('Magnitude (dB)');
 
figure
subplot 211
plot(signal)
subplot 212
plot(filtered);

b = conv(settings.b_highpass, settings.b_lowpass);
a = conv(settings.a_highpass, settings.a_lowpass);
figure, freqz(b, a, signal_length, fs);

% b = conv([1 -1], settings.b_lowpass);
% a = conv([1 -0.995], settings.a_lowpass);
% 
% b = [1 -1];
% a = [1 -0.995];
% figure, freqz(b, a, signal_length, fs);
% 
% [b,a]=butter(1,0.5/(fs/2), 'high');
% figure, freqz(b, a, signal_length, fs);
