function [filtered_signal] = ECG_filter(signal, fs, signal_start, signal_end)

%ECG_FILTER Apply the necessary filters to an ECG signal
%   Apply a notch filter at 50 Hz, a low-pass butterworth filter and a
%   high-pass derivative filter to a vector containing an ECG signal

%% Start values
    if nargin == 2
        signal_start = 1;
        signal_end = length(signal);
    elseif nargin == 3
        signal_end = length(signal); 
    end    

    f_nyquist = fs/2;

%% New signal
    signal = signal(signal_start:signal_end);
  
%% IIR notch filter

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

%% Butterworth low-pass filter

    % Order of the filter
    order_lowpass = 5;

    % Cut-off frequency
    fc_lowpass = 35;  

    % Determine filter coefficients
    [b_lowpass,a_lowpass]= butter(order_lowpass,fc_lowpass/f_nyquist);          

    % Plot frequency response of the filter 
    % figure, freqz(b_lowpass, a_lowpass, signal_length, fs)

%% High-pass derivative filter

    % Cut-off frequency
    fc_highpass = 0.5;   

    % Filter coefficients
    b_highpass = [1 -1];
    a_highpass = [1 -0.995];

    % Plot frequency response of the filter 
    % figure, freqz(b_highpass,a_highpass, signal_length, fs);

%% Apply filters to signal

filtered_signal =   filter(b_notch, a_notch, ...
                    filter(b_lowpass, a_lowpass, ...
                    filter(b_highpass, a_highpass, signal)));                         

% Plot total frequency response of the total filter
% b = conv(b_highpass, conv(b_notch, b_lowpass));
% a = conv(a_highpass, conv(a_notch, a_lowpass));
% figure, freqz(b, a, signal_length, fs);

end

