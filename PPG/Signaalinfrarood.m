%clear

% VALUES
load('Infrarood.mat')


signal2 = Infrarood(55:595,1);
windowsize=length(signal2)
fft_signal = fft(signal2);                  % Fourier transformation 
fs = 15;                                    % Sample frequency

% Oorspronkelijk signaal
figure;
xtime = (1/fs:1/fs:length(signal2)/fs);                      % X-as def
plot(xtime, signal2), title('Infrarood oorspronkelijk');     % Niet gefilterd signaal
xlabel('Tijd (s)');

% Frequentie oorspronkelijk
figure;
xfrec=(0:fs/(length(fft_signal)-1):fs);
plot(xfrec,10*log10(abs(fft_signal))), title('Frequentie infrarood')

% High pass filter
figure;
order = 3; fc = 0.000012;
[b, a] = butter(order, fc/(fs/2),'high');
high = filter(b, a, signal2);
plot(xtime,high), title('High pass filter infrarood')

% High pass frequentie
%{
figure;
fft_signalfilter=fft(high,windowsize);
plot(xfrec,10*log10(abs(fft_signalfilter))), title('Frequentie high pass infrarood')
%}

%{
% Low pass filter
figure;
order = 2; fc = 0.00025;
[b, a] = butter(order, fc/(fs/2));
low = filter(b, a, signal2);
plot(xtime,low), title('Low pass filter infrarood')

% Low pass filter frequentie
figure;
fft_signalfilter=fft(low,windowsize);
plot(xfrec,10*log10(abs(fft_signalfilter))), title('Frequentie low pass infrarood')



peaks2 = find_peaks(high,9.66*10^5,3.5)                     % 1e stukje: 4.995*10^4

plot(peaks), title('Find peaks infra')
%}

%{
figure;
order = 3; fc = 3;                          % blauw: low pass -> klein beetje smoother, dit is nu 'oorspronkelijk signaal'                                  
[b, a] = butter(order, fc/(fs/2));
f = filter(b, a, high);
plot(xtime,f)
%}

%{
figure;
ax1 = subplot(2,2,[1,2]);                   % fc = 3: nog geen ideale waarde
order = 3; fc = 3;                          % blauw: low pass -> klein beetje smoother, dit is nu 'oorspronkelijk signaal'                                  
[b, a] = butter(order, fc/(fs/2));
f = filter(b, a, high);
order = 2; fc = 0.45;                       % oranje: low pass -> ademhaling eruit halen, amplitude = DC                            
[b, a] = butter(order, fc/(fs/2));
g = filter(b, a, high);
plot(xtime,f)
hold on;
plot(xtime,g)
legend('Signaal infrarood licht','DC component')

ax3 = subplot(2,2,[3,4]);
plot(xtime,f-g)                             % enkel kleine golfjes overhouden, pulsjes die we zoeken. amplitude = AC

linkaxes([ax1,ax3],'x')
legend('AC component')
%}


figure;
ax1 = subplot(2,2,[1,2]);                   % fc = 3: nog geen ideale waarde
order = 3; fc = 3;                          % blauw: low pass -> klein beetje smoother, dit is nu 'oorspronkelijk signaal'                                  
[b, a] = butter(order, fc/(fs/2));
f = filter(b, a, high);
order = 2; fc = 0.45;                       % oranje: low pass -> ademhaling eruit halen, amplitude = DC                            
[b, a] = butter(order, fc/(fs/2));
g = filter(b, a, high);
plot(xtime,f)
hold on;
plot(xtime,g)
legend('Signaal infrarood licht','DC component')

ax3 = subplot(2,2,[3,4]);
plot(xtime,f-g)                             % enkel kleine golfjes overhouden, pulsjes die we zoeken. amplitude = AC

linkaxes([ax1,ax3],'x')
legend('AC component')



%{
order = 3; fc = 5;                          % blauw: low pass -> klein beetje smoother, dit is nu 'oorspronkelijk signaal'                                  
[b, a] = butter(order, fc/(fs/2));
f = filter(b, a, high);
order = 2; fc = 0.45;                       % oranje: low pass -> ademhaling eruit halen, amplitude = DC                            
[b, a] = butter(order, fc/(fs/2));
g = filter(b, a, high);
%}

peaks2=find_peaks(f-g,0,0.75)                     % 1e stukje: 4.995*10^4       Van f en f-g amplitude berekenen
plot(peaks2), title('Find peaks infrarood')