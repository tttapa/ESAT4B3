addpath('../ECG/')
addpath('../Wavelets/')

load('100m.mat')
t = testapp

samplefreq = 360;
seconds = 2;
viewportwidth = samplefreq * seconds; % 720 samples or 2 seconds

t.UIAxes.YLim = [0, 60000];

time = (0:length(val)-1)/samplefreq;

% val = val + 360*sin(time*2*pi/2) + 36*sin(time*2*pi*50) + 60*wgn(length(val),1,0)'; % 0.5 and 50 Hz + white gaussian nois

%%
[cols,rows] = size(val) 
for j = 0:(rows-viewportwidth)
    x = time(1,1+j:viewportwidth+j);
    t.UIAxes.XLim = [x(1), x(viewportwidth)];
    y = val(1,1+j:viewportwidth+j);
    y = waveletFilterECG(y).^2;
    plot(t.UIAxes, x, y)
    pause(0)
end
%%
tic;
for j = 0:((rows/100)-viewportwidth)
    y = val(1,1+j:viewportwidth+j);
    y = waveletFilterECG(y).^2;
end
timeElapsed = toc;
timeElapsed / ((rows/100)-viewportwidth)

%%

bufferlen = 3;
newbufferlen = 0.1;

figure
buffer = zeros(1,bufferlen * samplefreq);
newbuffer = zeros(1, newbufferlen * samplefreq);
counter = 1;
filled = 0;
filling = true;

while 1

for i = 1:(newbufferlen * samplefreq)
    newvalue = val(1,counter);
    newbuffer(i) = newvalue;
    counter = counter + 1;
end
if filled > bufferlen * samplefreq
    filled = bufferlen * samplefreq;
    filling = false;
end
if filling
    filled = filled + newbufferlen * samplefreq;
end
buffer(1:(bufferlen * samplefreq)-(newbufferlen * samplefreq)) = buffer((newbufferlen * samplefreq)+1:(bufferlen * samplefreq));
buffer((bufferlen * samplefreq)-(newbufferlen * samplefreq)+1:(bufferlen * samplefreq)) = newbuffer;
% plot(buffer)
waveletfilteredbuffer = waveletFilterECG(buffer);

buffertje = buffer((bufferlen * samplefreq)-(filled)+1:(bufferlen * samplefreq))
plot(waveletfilteredbuffer(buffertje).^2)

% Wavelet transformation
% Peak detection
% Return average bpm

pause (newbufferlen)
end