close all;

%% ECG

load('../Data/100m.mat');
samplefreq = 360;
timeduration = 10.4; 
samples = samplefreq*timeduration;
offset = 54;
ecg = val(1,1+offset:samples+offset); % Neem één frame uit de input-data
time = (0+offset:samples-1+offset)/samplefreq; % de tijd in seconden van elke sample

noise = 360*sin(time*2*pi/timeduration) + 9*sin(time*2*pi*50) + 2*wgn(samplefreq*timeduration,1,0)'; % 0.5 and 50 Hz + white gaussian noise
noisy = ecg + round(noise);

ECG_arduino = int16(noisy / 2); % map from 11 bit to 10 bit
figure, plot(time, ECG_arduino);



%% PPG

load('0009_8min.mat');
samplefreq = 300;
offset = 34;
timeduration = 3.64-offset/samplefreq; 
samples = round(samplefreq*timeduration);
ppg = signal.pleth.y(1+offset:samples+offset); % Neem één frame uit de input-data
time = (0+offset:samples-1+offset)/samplefreq; % de tijd in seconden van elke sample

PPG_arduino = int16((ppg - min(ppg))*1023/(max(ppg)-min(ppg))); % map from [-10, 10] to [0, 1023]
figure, plot(time, PPG_arduino);
figure, plot(cat(1, PPG_arduino, PPG_arduino));