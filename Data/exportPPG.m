load('PPG_red.mat');
load('PPG_ired.mat');

ired = ired - mean(ired);
red = red - mean(red);

maxi = max(max(abs(ired)), max(abs(red)));

ired = ired / maxi * 511;
red = red / maxi * 511;

ired = downsample(ired, 10);
red = downsample(red, 10);

ired = ired(157:151+707);
red = red(157:151+707);

ired = round(ired);
red = round(red);

ired = ired + 511;
red = red + 511;

figure, hold on, plot(ired), plot(red);

csvwrite('ir.csv', ired);
csvwrite('red.csv', red);