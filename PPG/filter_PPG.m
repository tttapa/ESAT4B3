function [filtered_signal] = filter_PPG(signal, fs, signal_start, signal_end)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%
% Start values
if nargin == 2
    signal_start = 1;
    signal_end = length(signal);
elseif nargin == 3
    signal_end = length(signal); 
end    

f_nyquist = fs/2;

%%
% New signal
signal = signal(signal_start:signal_end);
  
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
[b_highpass,a_highpass]= butter(1,fc_highpass/f_nyquist, 'high');

% Plot frequency response of the filter 
% figure, freqz(b_highpass,a_highpass, signal_length, fs);

%%
% _________________________________________________________________________
% FILTERING
% _________________________________________________________________________
                        
filtered_signal = filter(b_lowpass, a_lowpass, ...
                            filter(b_highpass, a_highpass, signal));                

% Plot total frequency response of the total filter
% b = conv(b_highpass, b_lowpass);
% a = conv(a_highpass, a_lowpass);
% figure, freqz(b, a, signal_length, fs);
end

