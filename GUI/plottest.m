load('100m.mat')
t = testapp

samplefreq = 360;
seconds = 2;
viewportwidth = samplefreq * seconds; % 720 samples or 2 seconds

t.UIAxes.XLim = [0, viewportwidth];
t.UIAxes.YLim = [0, 60000];

time = (0:length(val)-1)/samplefreq;

% val = val + 360*sin(time*2*pi/2) + 36*sin(time*2*pi*50) + 60*wgn(length(val),1,0)'; % 0.5 and 50 Hz + white gaussian nois

[cols,rows] = size(val) 
for j = 0:(rows-viewportwidth)
    if exist('t', 'var') == 0
        break
    end
    y = val(1,1+j:viewportwidth+j);
    y = waveletFilterECG(y).^2;
    plot(t.UIAxes, y)
    pause(0)
end