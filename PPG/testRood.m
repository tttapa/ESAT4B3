clear
% Importing Data
load('Rood.mat');
data_number = 2;

% Selecting Interval of the data with start and end value
signal_start  = 55;
signal_end = 305; 

% Sample  and Nyquist (sample freq/2) frequency 
fs = 15; 
f_nyquist = fs/2;

% Signal    
signal = S1(signal_start:signal_end);
signal_length = length(signal);

% Length has to be even
if rem(signal_length, 2) ~= 0 
    signal_end = signal_end -1;
    signal = S1(signal_start:signal_end);
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
% figure, freqz(b_notch, a_notch, signal_length, fs);

%%
% _________________________________________________________________________
% BUTTERWORTH LOW PASS FILTER
% _________________________________________________________________________

% Order of the filter
order_lowpass = 4;

% Cut-off frequency
fc_lowpass = 3;  

% Determine filter coefficients
[b_lowpass,a_lowpass]= butter(order_lowpass,fc_lowpass/f_nyquist);          

% Plot frequency response of the filter 
% figure, freqz(b_lowpass, a_lowpass, signal_length, fs)

%%
% _________________________________________________________________________
% HIGH PASS DERIVATE FILTER
% _________________________________________________________________________

% Cut-off frequency
fc_highpass = 0.5;   

% Filter coefficients
%b_highpass = [1 -1];
% a_highpass = [1 -0.999999999];
[b_highpass,a_highpass]= butter(1,fc_highpass/f_nyquist, 'high');
% Plot frequency response of the filter 
% figure, freqz(b_highpass,a_highpass, signal_length, fs);

%%
% _________________________________________________________________________
% FILTERING
% _________________________________________________________________________                       
filtered_signal = filter(b_lowpass, a_lowpass,filter(b_highpass, a_highpass, signal));                
filtered_signal_length = length(filtered_signal);

%%
% _________________________________________________________________________
% Plot without first segment (no start-up noise)
% _________________________________________________________________________
noise_end = 50;
red_signal_start = signal_start + noise_end;

% Define reduced x for signal plot
red_x = (1:1:length(signal(red_signal_start:end)))./fs; 

% Define reduced x for fft_signal plot
red_x_freq = 0:fs/length(signal(red_signal_start:end)):fs/2; 

% Define reduced x for fft_signal plot
red_x_freq_fft = 0:fs/length(signal(red_signal_start:end)):fs/2; 

% Fft_signal + rescale
red_fft_signal = fft(signal(red_signal_start:end));       
red_fft_signal = red_fft_signal(1:length(signal(red_signal_start:end))/2+1);
red_fft_signal = (1/(fs*(signal_length-noise_end)))*abs(red_fft_signal).^2;
red_fft_signal(2:end-1) = 2*red_fft_signal(2:end-1);

% Fft_filtered_signal + rescale
red_fft_filtered_signal =fft(filtered_signal(red_signal_start:end));       
red_fft_filtered_signal =red_fft_filtered_signal(1:...
                                length(filtered_signal(red_signal_start:end))/2+1);
red_fft_filtered_signal =(1/(fs*(length(filtered_signal(red_signal_start:end))))) ...
                        *abs(red_fft_filtered_signal).^2;
red_fft_filtered_signal(2:end-1) = 2*red_fft_filtered_signal(2:end-1);

% Signal and filtered signal plot
figure;                           
plot(red_x,filtered_signal(red_signal_start:end), 'red');
title('Filtered and non-filtered signal');
xlabel('Tijd (s)');
legend('Filtered signal');

hold on;

[peaks, locations, ac, dc] = analyzePPG(signal(red_signal_start:end), filtered_signal(red_signal_start:end), fs, 120);

disp(ac);
disp(dc);

markerSize = 50;
markerEdgeColor = [0 0 0];
markerFaceColor = [1 0 0];
markerLineWidth = 1;

scatter(locations/fs, filtered_signal(red_signal_start + locations - 1), ...
    markerSize, 'MarkerEdgeColor', markerEdgeColor, 'MarkerFaceColor', markerFaceColor, 'LineWidth', markerLineWidth);

hold off;
