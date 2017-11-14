load ('data_druk.mat')
signal = A(:, 2);

plot(signal)
[steps, last] = stepcounter(signal,500);