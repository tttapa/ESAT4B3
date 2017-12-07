addpath('..');

coefficients = 1:6;
MM = zeros(length(coefficients),length(coefficients));
MA = zeros(length(coefficients),length(coefficients));
MB = zeros(length(coefficients),length(coefficients));
for i = 1:length(coefficients)
    MM(end-i+1,1:i) = coefficients(end-i+1:end);
    MM(end-i+1,i+1:end) = coefficients(1:end-i);
    MA(i,1:i) = coefficients(end-i+1:end);
    MA(i,i+1:end) = coefficients(1:end-i);
    MB(i,1:i-1) = coefficients(end-i+2:end);
    MB(i,i:end) = coefficients(1:end-i+1);
end
MM
MA
MB

%%

b = 1:4;

M_b = zeros(length(b),length(b));
b = fliplr(b); % TODO
for i = 1:length(b)
    M_b(i,1:i) = b(end-i+1:end);
    M_b(i,i+1:end) = b(1:end-i);
end
%M_b = M_b'; % TODO

M_b

b = 1:4;

M_b = zeros(length(b),length(b));
b = fliplr(b); % TODO
for i = 1:length(b)
    M_b(1:i,i) = b(end-i+1:end);
    M_b(i+1:end,i) = b(1:end-i);
end

M_b

a = 1:4;
M_a = zeros(length(a),length(a));
a = fliplr(a); % TODO
for i = 1:length(a)
    M_a(i,1:i-1) = a(end-i+2:end);
    M_a(i,i:end) = a(1:end-i+1);
end
%M_a = M_a'; % TODO

M_a

%%

coef = 1:8;
             
f = Filter(coef);
fc = double.empty();
for j = 1:8
    fc = [fc f.filterC(j)];
end
fc
ff = filter(coef,1,1:8);
ff
fftest = filter(coef,1,[1 1 2 2 3 3 1:8]);
fftest


%%
b = [3 3 2];
a = [4 3 5];
f = IIRFilter(b, a);
fc = double.empty();
for j = 1:8
    fc = [fc f.filter(j)];
end
fc
ff = filter(b,a,1:8)
