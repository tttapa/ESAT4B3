load ('data_druk.mat')
signal = A(1:4000, 2);

plot(signal)
[steps, last]=stepcounter(signal, 500)