load('100m.mat')
t = testapp

samplefreq = 360;
viewportwidth = samplefreq * 2; % 720 samples or 2 seconds

[cols,rows] = size(val) 
for j = 0:(rows-viewportwidth)
    if exist('t', 'var') == 0
        break
    end
    y = val(1,1+j:viewportwidth+j);
    plot(t.UIAxes,y)
    pause(1.0/samplefreq)
end