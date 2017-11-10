%clear
% VALUES
load('Rood.mat')

signal = Rood(55:595,1);                  %'gewoon': 55:595,1           '1e vakje' 55:150
windowsize=length(signal);

fft_signal = fft(signal,windowsize);      % Fourier transformation 
fs = 15;                                  % Sample frequency

% SIGNAL (Data)
% Oorspronkelijk signaal

figure;
xtime = (1/fs:1/fs:length(signal)/fs);                  % X-as def
plot(xtime, signal), title('Rood oorspronkelijk');
xlabel('Tijd (s)');

% Frequentie oorspronkelijk
figure;
xfrec=(0:fs/(length(fft_signal)-1):fs);
plot(xfrec,10*log10(abs(fft_signal))), title('Frequentie rood');

% High pass filter om 'foute' schuine lijn eruit te halen
figure;
order = 3; fc = 0.0003;                                % cut-off waarde schatten        
[b, a] = butter(order, fc/(fs/2),'high');
high = filter(b, a, signal);
plot(xtime,high), title('High pass filter rood')

% High pass filter die schuine lijn eruit haalt en direct naar beneden
% trekt (-> AC)
%{
figure;
order = 1; fc = 0.5;                                % cut-off waarde schatten        
[b, a] = butter(order, fc/(fs/2),'high');
high = filter(b, a, signal);
plot(xtime,high), title('High pass filter rood')
%}

% High pass frequentie
%{
figure;
fft_signalfilter=fft(high,windowsize);
plot(xfrec,10*log10(abs(fft_signalfilter))), title('Frequentie high pass rood');
%}

figure;
ax1 = subplot(2,2,[1,2]);
order = 3; fc = 5;                          % blauw: low pass -> klein beetje gladder, dit is nu 'oorspronkelijk signaal'                                  
[b, a] = butter(order, fc/(fs/2));
f = filter(b, a, high);
order = 2; fc = 0.45;                       % oranje: low pass -> ademhaling eruit halen, amplitude = DC                            
[b, a] = butter(order, fc/(fs/2));
g = filter(b, a, high);
plot(xtime,f)
hold on;
plot(xtime,g)
legend('Signaal rood licht','DC component')

ax3 = subplot(2,2,[3,4]);
plot(xtime,f-g)                             % enkel kleine golfjes overhouden, pulsjes die we zoeken. amplitude = AC

linkaxes([ax1,ax3],'x')
legend('AC component')

%peaks1=find_peaks(f-g,-20,1)                     % 1e stukje: 4.995*10^4       Van f en f-g amplitude berekenen
%plot(peaks1), title('Find peaks rood')

median(g)
median(f)



%{
% Low pass filter
figure;
order = 2; fc = 0.0003;                                    % cut-off waarde schatten        
[b, a] = butter(order, fc/(fs/2));
low = filter(b, a, signal);
plot(xtime,low), title('Low pass filter rood');

% Low pass filter frequentie
figure;
fft_signalfilter=fft(low,windowsize);
plot(xfrec,10*log10(abs(fft_signalfilter))), title('Frequentie low pass rood');
%}

%peaks1=find_peaks(f-g,-20,1)                     % 1e stukje: 4.995*10^4       Van f en f-g amplitude berekenen
%plot(peaks1), title('Find peaks rood')
