load('100m.mat')

samplefreq = 360;
viewportwidth = samplefreq * 2; % 720 samples or 2 seconds
figure;

[cols,rows] = size(val) 
for j = 0:(rows-viewportwidth)
    if exist('t', 'var') == 0
        break
    end
    y = val(1,1+j:viewportwidth+j);
    y = waveletFilterECG(y);
    plot(y);
    pause(1.0/samplefreq)
end