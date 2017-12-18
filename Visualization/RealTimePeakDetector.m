close all;
data = csvread('../Data/RealDataArduino.csv');
addpath('../Def');

coeff = ECG_setup(360);

data = data -250;

filtered = ECG_filter(data, coeff);

data = data(100:100+360*2);
filtered = filtered(100:100+360*2);

sq = ((filtered).^2) / 1023;
difsq = filter([1 -1], 1, sq);
dif = filter([1 -1], 1, filtered);

figure, hold on,
plot(sq,'k','LineWidth',1);
plot([0, length(sq)],[30 30], '--k');
title('Square of the filtered ECG signal');
xlabel('Sample');
ylabel('Amplitude');
xlim([1 720]);

fig = figure;
left_color = [0 0 0];
right_color = [1 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
hold on;
yyaxis left,
plot(dif,'k','LineWidth',1);
ylabel('Amplitude');
yyaxis right,
plot(difsq,'r','LineWidth',1);
plot([0, length(dif)],[6 6], '--k');
title('Discrete derivative of the filtered ECG signal and the square of the filtered ECG signal');
xlabel('Sample');
ylabel('Amplitude');
xlim([1 720]);
legend('Discrete derivative of the filtered ECG signal','Discrete derivative of the square of the filtered ECG signal', 'Location','southeast');

%% PPT

figure;
plot(filtered,'k','LineWidth',1);
ylabel('Amplitude');
title('Filtered ECG signal');
xlabel('Sample');
xlim([1 720]);

figure;
plot(difsq,'k','LineWidth',1);
ylabel('Amplitude');
title('Discrete derivative of filtered ECG signal');
xlabel('Sample');
xlim([1 720]);