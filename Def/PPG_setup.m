function [settings] = PPG_setup(fs)

    f_nyquist = fs/2;

%% BUTTERWORTH LOW PASS FILTER

    % Order of the filter
    order_lowpass = 2;

    % Cut-off frequency
    fc_lowpass = 20;  

    % Determine filter coefficients
    [settings.b_lowpass, settings.a_lowpass]= butter(order_lowpass,fc_lowpass/f_nyquist);          

%% HIGH PASS DERIVATE FILTER
    
    % Order of the filter
    order_highpass = 1;
    
    % Cut-off frequency
    fc_highpass = 0.5;   

    % Filter coefficients
    settings.b_highpass = [1 -1];
    settings.a_highpass = [1 -0.995];
    
%     Noodoplossing: butterworth
%     [settings.b_highpass,settings.a_highpass]= butter(order_highpass,fc_highpass/f_nyquist, 'high');

end

