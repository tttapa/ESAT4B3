classdef FIRFilter < handle
    properties (SetAccess = private)
        b;
        x;
        i_b;
        M_b;
    end
    methods
        function o = FIRFilter(b)
            o.b = b;
            o.x = zeros(1,length(b));
            o.i_b = 0;
            o.M_b = zeros(length(b),length(b));
            b = fliplr(b);
            for i = 1:length(b)
                o.M_b(i,1:i) = b(end-i+1:end);
                o.M_b(i,i+1:end) = b(1:end-i);
            end
            o.M_b = o.M_b';
        end
        function filtered = filter(o,value)
            o.i_b = mod(o.i_b, length(o.x)) + 1;
            o.x(o.i_b) = value;
            filtered = o.x*o.M_b(:,o.i_b);
        end
    end
end