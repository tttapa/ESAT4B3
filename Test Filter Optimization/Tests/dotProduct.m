function product = dotProduct(a, b)
    product = 0;
    for i = 1:length(a)
        product = product + a(i) * b(i);
    end
end
