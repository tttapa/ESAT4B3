load ('data_druk.mat')
signal = A(:, 2);

figure, plot(signal);
[steps, last] = stepcounter(signal,500);