function [filtered_signal] = PPG_filter(signal, settings, signal_start, signal_end)
%PPG_Filter Apply the necessary filters to an PPG signal
%   Apply a low-pass butterworth filter and a
%   high-pass butterworth filter to a vector containing an PPG signal    

%% Start values

    if nargin == 2
        % full signal
    elseif nargin == 3
        signal = signal(signal_start:length(signal));
    elseif nargin == 4
        signal = signal(signal_start:signal_end);
    end 
    
%% Apply filters to signal
filtered_signal = filter(settings.b_lowpass, settings.a_lowpass, ...
                  filter(settings.b_highpass, settings.a_highpass, signal));                

end
