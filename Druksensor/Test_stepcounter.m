load ('data_druk.mat')
signal = A(1:1300, 2);
signal_length = length(signal);
fs = 30;
x = (1:1:signal_length)./fs;
%figure;
%plot(x,signal);
[steps, last] = stepcounter(signal,500);



figure;
plot(x,signal);
title('Druksignaal stappenteller')
xlim([0,43])
xlabel('Tijd (s)')
ylabel('Druk')
set(gca, 'PlotBoxAspectRatio', [1 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);
hold on
plot(x,ones(size(x)) *400)
%plot(x,ones(size(x)) * DC_red);
%xlim([0,40])
%xlabel('Tijd (s)')
%ylabel('PPG')
set(gca, 'PlotBoxAspectRatio', [1 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);
hold on
plot(x,ones(size(x)) *600)
set(gca, 'PlotBoxAspectRatio', [1 1 1], ...
    'LineWidth', 1, ...
    'Box', 'on', ...
    'FontSize', 16);