clear
% Importing Data
load('Rood.mat');
load('Infrarood.mat');
data_number = 2;

% Selecting Interval of the data with start and end value
signal_start  = 55;
signal_end = 305; 

% Sample  and Nyquist (sample freq/2) frequency 
fs = 15; 
f_nyquist = fs/2;

% Signal    
signal = S1(signal_start:signal_end);
signal2 = S2(signal_start:signal_end);
signal_length = length(signal);

% Length has to be even
if rem(signal_length, 2) ~= 0 
    signal_end = signal_end -1;
    signal = S1(signal_start:signal_end);
    signal2 = S2(signal_start:signal_end);
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
filtered_signal2 = filter(b_lowpass, a_lowpass, filter(b_highpass, a_highpass, signal2));
filtered_signal_length = length(filtered_signal);

%%
% _________________________________________________________________________
% Plot without first segment (no start-up noise)
% _________________________________________________________________________
noise_end = 50;
red_signal_start = signal_start + noise_end;

% Define reduced x for signal plot
red_x = (1:1:length(signal(red_signal_start:end)))./fs; 

% Signal and filtered signal plot
figure;                           
plot(red_x,filtered_signal(red_signal_start:end), 'red');
hold on;
plot(red_x,filtered_signal2(red_signal_start:end), 'blue');
title('Filtered and non-filtered signal');
xlabel('Tijd (s)');
legend('Filtered Rood', 'Filtered Infrarood');

[peaks, locations, ac, dc] = analyzePPG(signal(red_signal_start:end), filtered_signal(red_signal_start:end), fs, 120);
[peaks2, locations2, ac2, dc2] = analyzePPG(signal2(red_signal_start:end), filtered_signal2(red_signal_start:end), fs, 120);

disp("O2 Saturation:");
disp(ac);
disp(dc);
disp(ac2);
disp(dc2);
disp(110 - 25 * (ac/ac2) * (dc2/dc))


markerSize = 50;
markerEdgeColor = [0 0 0];
markerFaceColor = [1 0 0];
markerLineWidth = 1;

scatter(locations/fs, filtered_signal(red_signal_start + locations - 1), ...
    markerSize, 'MarkerEdgeColor', markerEdgeColor, 'MarkerFaceColor', markerFaceColor, 'LineWidth', markerLineWidth);
scatter(locations2/fs, filtered_signal2(red_signal_start + locations2 - 1), ...
    markerSize, 'MarkerEdgeColor', markerEdgeColor, 'MarkerFaceColor', markerFaceColor, 'LineWidth', markerLineWidth);

hold off;
