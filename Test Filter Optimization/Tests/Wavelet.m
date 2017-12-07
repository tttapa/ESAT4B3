h_coef_dec = [  -0.07576571478927333
                -0.02963552764599851
                 0.49761866763201545
                 0.8037387518059161
                 0.29785779560527736
                -0.09921954357684722
                -0.012603967262037833
                 0.0322231006040427  ]';

a = 1:100;
b = 201:300;

disp('*');
tic;
for i = 1:1000000
    c = a * b';
end
toc

disp('dotProduct');
tic;
for i = 1:1000000
    c = dotProduct(a,b);
end
toc

%%
disp('FilterA');                       
f = Filter(h_coef_dec);
tic;
for i = 1:10000
    for j = 1:8
        fa = f.filterA(j);
    end
end
toc

disp('FilterB');                       
f = Filter(h_coef_dec);
tic;
for i = 1:10000
    for j = 1:8
        fb = f.filterB(j);
    end
end
toc

%%

disp('FilterC');
f = Filter(h_coef_dec);
tic;
for i = 1:100000
    for j = 1:8
        fc = f.filterC(j);
    end
end
disp(toc/10000);

disp('FilterD');
f = Filter(h_coef_dec);
tic;
for i = 1:100000
    for j = 1:8
        fd = f.filterD(j);
    end
end
disp(toc/10000);

disp('Filter');
vector = zeros(8,1);
tic;
for i = 1:100000
    for j = 1:8
        vector(1:end-1) = vector(2:end);
        vector(end) = j;
        ff = filter(h_coef_dec,1,vector);
    end
end
disp(toc/10000);

fc
fd
ff(end)
