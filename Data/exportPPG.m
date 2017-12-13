load('PPG_red.mat');
load('PPG_ired.mat');

mean_IR = mean(ired)
mean_RD = mean(red)
%disp(mean_IR);
%disp(mean_RD);

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

iredV = ired*5/1023;
redV = red*5/1023;

ired = ired + 511;
red = red + 511;

figure, hold on, plot(ired), plot(red);

csvwrite('ir.csv', ired);
csvwrite('red.csv', red);

sqrt(mean(iredV.^2))
sqrt(mean(redV.^2))



