
% Sample  and Nyquist (sample freq/2) frequency 
fs = 360; 
f_nyquist = fs/2;

syms z

% Cut off frequency
fc_notch = 50;
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
%%
% __________________________________________________________²_______________
% BUTTERWORTH LOW PASS FILTER
% _________________________________________________________________________

% Order of the filter
order_lowpass = 5;

% Cut-off frequency
fc_lowpass = 35;  

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
b_highpass = [1 -1];
a_highpass = [1 -0.995];

% Plot frequency response of the filter 
% figure, freqz(b_highpass,a_highpass, signal_length, fs);
