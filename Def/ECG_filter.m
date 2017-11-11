function [filtered_signal] = ECG_filter(signal, settings, signal_start, signal_end)

%ECG_FILTER Apply the necessary filters to an ECG signal
%   Apply a notch filter at 50 Hz, a low-pass butterworth filter and a
%   high-pass derivative filter to a vector containing an ECG signal

%% Start values

    if nargin == 2
        % full signal
    elseif nargin == 3
        signal = signal(signal_start,:);
    elseif nargin == 4
        signal = signal(signal_start:signal_end);
    end 

%% Apply filters to signal

filtered_signal =   filter(settings.b_notch, settings.a_notch, ...
                    filter(settings.b_lowpass, settings.a_lowpass, ...
                    filter(settings.b_highpass, settings.a_highpass, signal)));
end

