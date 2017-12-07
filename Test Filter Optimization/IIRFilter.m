classdef IIRFilter < handle
    properties (SetAccess = private)
        b;
        a;
        a0;
        x;
        y;
        i_b;
        i_a;
        M_b;
        M_a;
    end
    methods
        function o = IIRFilter(b, a)
            o.b = b;
            o.x = zeros(1,length(b));
            o.i_b = 0;
            o.M_b = zeros(length(b),length(b));
            b = fliplr(b); % TODO
            for i = 1:length(b)
                o.M_b(i,1:i) = b(end-i+1:end);
                o.M_b(i,i+1:end) = b(1:end-i);
            end
            o.M_b = o.M_b'; % TODO
            
            o.a0 = a(1);
            a = a(2:end);
            o.a = a;
            o.y = zeros(1,length(a));
            o.i_a = 0;
            o.M_a = zeros(length(a),length(a));
            a = fliplr(a); % TODO
            for i = 1:length(a)
                o.M_a(i,1:i-1) = a(end-i+2:end);
                o.M_a(i,i:end) = a(1:end-i+1);
            end
            o.M_a = o.M_a'; % TODO
        end
        function filtered = filter(o,value)
            o.i_b = mod(o.i_b, length(o.x)) + 1;
            o.i_a = mod(o.i_a, length(o.y)) + 1;
            o.x(o.i_b) = value;
            b_terms = o.x*o.M_b(:,o.i_b);
            a_terms = o.y*o.M_a(:,o.i_a);
            filtered = (b_terms - a_terms) / o.a0;
            o.y(o.i_a) = filtered;
        end
    end
end