function [settings] = ECG_setup(fs)

%% Notch filter
    f_nyquist = fs/2;

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
    settings.a_notch = 1;
    settings.b_notch = double(coeff_b./H_b(1));
    
%% Butterworth low-pass filter

    % Order of the filter
    order_lowpass = 5;

    % Cut-off frequency
    fc_lowpass = 35;  

    % Determine filter coefficients
    [settings.b_lowpass,settings.a_lowpass] = butter(order_lowpass,fc_lowpass/f_nyquist);

%% High-pass derivative filter

    % Cut-off frequency
    % fc_highpass = 0.5;   

    % Filter coefficients
    settings.a_highpass = [1 -0.995];
    settings.b_highpass = [1 -1];

end