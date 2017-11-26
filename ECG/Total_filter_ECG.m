clear
%% 
% Importing Data
load('100m.mat');
data_number = 1;

% Sample  and Nyquist (sample freq/2) frequency 
fs = 360; 
f_nyquist = fs/2;

% Selecting Interval of the data with start and end value
signal_start  = 1500;
signal_end = 15000; 

% Signal    
signal = val(data_number, signal_start:signal_end);
signal_length = length(signal);

% Length has to be even
if rem(signal_length, 2) ~= 0 
    signal_end = signal_end -1;
    signal = val(data_number, signal_start:signal_end);
    signal_length = length(signal);  
end 
%%
% _________________________________________________________________________
% IIR-NOTCH FILTER    
% _________________________________________________________________________

syms z

% Cut off frequency
fc_notch = 60;
theta_notch = fc_notch/f_nyquist*pi;

% Determine b-coefficient
z1 = cos(theta_notch) + 1i*sin(theta_notch);
z2 = cos(theta_notch) - 1i*sin(theta_notch);

% Transfer function
H_b(z) = simplify((1-z1*z)*(1-z2*z));


% Filter characteristics 
coeff_b = coeffs(H_b(z));

% Rescale b with DC-gain
b_notch = double(coeff_b./H_b(1));                                                              
a_notch = 1;

% Plot frequency response of the filter 
figure, freqz(b_notch, a_notch, signal_length, fs);

%%
% _________________________________________________________________________
% BUTTERWORTH LOW PASS FILTER
% _________________________________________________________________________

% Order of the filter
order_lowpass = 5;

% Cut-off frequency
fc_lowpass = 35;  

% Determine filter coefficients
[b_lowpass,a_lowpass]= butter(order_lowpass,fc_lowpass/f_nyquist);          

% Plot frequency response of the filter 
figure, freqz(b_lowpass, a_lowpass, signal_length, fs)

%%
% _________________________________________________________________________
% HIGH PASS DERIVATE FILTER
% _________________________________________________________________________

% Cut-off frequency
fc_highpass = 0.5;   

% Filter coefficients
b_highpass = [1 -1];
a_highpass = [1 -0.995];

% Plot frequency response of the filter 
figure, freqz(b_highpass,a_highpass, signal_length, fs);

%%
% _________________________________________________________________________
% FILTERING
% _________________________________________________________________________

filtered_signal =   filter(b_notch, a_notch, ...
                    filter(b_lowpass, a_lowpass, ...
                    filter(b_highpass, a_highpass, signal)));                         

filtered_signal_length = length(filtered_signal);

% Plot total frequency response of the total filter
b = conv(b_highpass, conv(b_notch, b_lowpass));
a = conv(a_highpass, conv(a_notch, a_lowpass));
figure, freqz(b, a, signal_length, fs);

%%
% _________________________________________________________________________               
% Plot filtered and non filtered signal
% _________________________________________________________________________
% 
% % Define x for signal plot
% x = (1:1:signal_length)./fs;   
% 
% % Plot non-filtered signal
% figure;
% subplot(3,1,1);
% plot(x,signal);          
% title('Non-filtered signal');
% xlabel('Time (s)');
% 
% % Plot filtered signal
% subplot(3,1,2);                                                             
% plot(x,filtered_signal, 'red');     
% title('Filtered signal');
% xlabel('Time (s)');
% 
% % Plot filtered and non filtered 
% subplot (3,1,3);
% plot(x,signal);          
% hold on;                             
% plot(x,filtered_signal, 'red');
% title('Filtered and non-filtered signal');
% xlabel('Tijd (s)');
% legend('Non filtered signal', 'Filtered signal');

%%
% _________________________________________________________________________
% Plot Fourier transformed signal
% _________________________________________________________________________
% 
% % Fft_signal + rescale
% fft_signal = fft(signal);       
% fft_signal = fft_signal(1:signal_length/2+1);
% fft_signal = (1/(fs*signal_length)) * abs(fft_signal).^2;
% fft_signal(2:end-1) = 2*fft_signal(2:end-1);
% 
% % Fft_filtered_signal + rescale
% fft_filtered_signal = fft(filtered_signal);       
% fft_filtered_signal = fft_filtered_signal(1:filtered_signal_length/2+1);
% fft_filtered_signal = (1/(fs*filtered_signal_length)) ...
%                         *abs(fft_filtered_signal).^2;
% fft_filtered_signal(2:end-1) = 2*fft_filtered_signal(2:end-1);
% 
% % Define x for fft_signal plot
% x_freq = 0:fs/signal_length:fs/2; 
% 
% % Define x for fft_signal plot
% x_freq_fft = 0:fs/signal_length:fs/2; 

% % Plot non-filtered Fourier signal
% figure;
% subplot(3,1,1);
% plot(x_freq,10*log10(abs(fft_signal)), 'color', [0 0 0] + 0.75); % Grey        
% title('Non-filtered Fourier transformed signal');
% xlabel('Frequentie (Hz)');
% ylabel('Magnitude (dB)');
% 
% % Plot filtered Fourier signal
% subplot(3,1,2);                                                             
% plot(x_freq_fft,10*log10(((abs(fft_filtered_signal)))), ...
%             'color',[0 0 0]+0.05);  
% title('Filtered Fourier transformed signal');
% xlabel('Frequentie (Hz)');
% ylabel('Magnitude (dB)');
% 
% % Plot filtered and non filtered Fourier signal
% subplot (3,1,3);
% plot(x_freq,10*log10(abs(fft_signal)), 'color', [0 0 0] + 0.75 ); % Grey 
% hold on;                             
% plot(x_freq_fft,10*log10(((abs(fft_filtered_signal)))), ...
%             'color',[0 0 0]+0.05); % Black
% title('Filtered and non-filtered Fourier transformed signal');
% xlabel('Frequentie (Hz)');
% ylabel('Magnitude (dB)');
% legend('Non filtered Fourier transformed signal',... 
%         'Filtered Fourier transformed signal');
% 
% %%
% % _________________________________________________________________________
% % Plot without first segment (no start-up noise)
% % _________________________________________________________________________
% noise_end = 1001;
% red_signal_start = signal_start + noise_end;
% 
% % Define reduced x for signal plot
% red_x = (1:1:length(signal(red_signal_start:end)))./fs; 
% 
% % Define reduced x for fft_signal plot
% red_x_freq = 0:fs/length(signal(red_signal_start:end)):fs/2; 
% 
% % Define reduced x for fft_signal plot
% red_x_freq_fft = 0:fs/length(signal(red_signal_start:end)):fs/2; 
% 
% % Fft_signal + rescale
% red_fft_signal = fft(signal(red_signal_start:end));       
% red_fft_signal = red_fft_signal(1:length(signal(red_signal_start:end))/2+1);
% red_fft_signal = (1/(fs*(signal_length-noise_end)))*abs(red_fft_signal).^2;
% red_fft_signal(2:end-1) = 2*red_fft_signal(2:end-1);
% 
% % Fft_filtered_signal + rescale
% red_fft_filtered_signal =fft(filtered_signal(red_signal_start:end));       
% red_fft_filtered_signal =red_fft_filtered_signal(1:...
%                                 length(filtered_signal(red_signal_start:end))/2+1);
% red_fft_filtered_signal =(1/(fs*(length(filtered_signal(red_signal_start:end))))) ...
%                         *abs(red_fft_filtered_signal).^2;
% red_fft_filtered_signal(2:end-1) = 2*red_fft_filtered_signal(2:end-1);
% 
% % Signal and filtered signal plot
% figure; 
% plot(red_x,signal(red_signal_start:end)-700, 'color', [0 0 0] + 0.05 );          
% hold on;                             
% plot(red_x,filtered_signal(red_signal_start:end), 'red');
% title('Filtered and non-filtered signal');
% xlabel('Tijd (s)');
% legend('Non filtered signal', 'Filtered signal');    
% 
% % Fft signal en fft filtered signal plot
% figure;    
% plot(red_x_freq,10*log10(abs(red_fft_signal)),'color',[0 0 0]+0.75); % Grey 
% hold on;                             
% plot(red_x_freq_fft,10*log10(((abs(red_fft_filtered_signal)))), ...
%             'color',[0 0 0]+0.05); % Black
% title('Filtered and non-filtered Fourier transformed signal');
% xlabel('Frequentie (Hz)');
% ylabel('Magnitude (dB)');
% legend('Non filtered Fourier transformed signal',... 
%         'Filtered Fourier transformed signal');
