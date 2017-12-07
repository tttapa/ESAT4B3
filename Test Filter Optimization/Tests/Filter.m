classdef Filter < handle
    properties (SetAccess = private)
        coefficients;
        values;
        ringBuffer;
        ringBufferIndex;
        MC;
        MD;
    end
    methods
        function o = Filter(coefficients)
            o.coefficients = coefficients;
            o.values = zeros(1,length(coefficients));
            o.ringBuffer = zeros(1,length(coefficients));
            o.ringBufferIndex = 0;
            o.MC = zeros(length(coefficients),length(coefficients));
            coefficients = fliplr(coefficients);
            for i = 1:length(coefficients)
                o.MC(i,1:i) = coefficients(end-i+1:end);
                o.MC(i,i+1:end) = coefficients(1:end-i);
            end
            o.MD = o.MC';
        end
        function filtered = filterA(o,value)
            o.values(2:end) = o.values(1:end-1);
            o.values(1) = value;
            filtered = o.values*o.coefficients';    
        end
        function filtered = filterB(o,value)
            o.ringBufferIndex = mod(o.ringBufferIndex, length(o.ringBuffer)) + 1;
            o.ringBuffer(o.ringBufferIndex) = value;
            filtered = 0;
            for i = 1:length(o.ringBuffer)
                filtered = filtered + o.getValue(i)*o.coefficients(i);
            end
        end
        function value = getValue(o, i)
            value = o.ringBuffer(mod(o.ringBufferIndex + i - 1, length(o.ringBuffer)) + 1);
        end
        function filtered = filterC(o,value)
            o.ringBufferIndex = mod(o.ringBufferIndex, length(o.ringBuffer)) + 1;
            o.ringBuffer(o.ringBufferIndex) = value;
            % disp(strcat('Index=',string(o.ringBufferIndex)));
            % disp(o.ringBuffer);
            filtered = 0;
            for i = 1:length(o.ringBuffer)
                filtered = filtered + o.ringBuffer(i)*o.MC(o.ringBufferIndex,i);
            end
        end
        
        function filtered = filterD(o,value)
            o.ringBufferIndex = mod(o.ringBufferIndex, length(o.ringBuffer)) + 1;
            o.ringBuffer(o.ringBufferIndex) = value;
            filtered = o.ringBuffer*o.MD(:,o.ringBufferIndex);
        end
        
        function filtered = filterZ(o,value)
            o.values(1:end-1) = o.values(2:end);
            o.values(end) = value;
            f = filter(o.coefficients,1,o.values);
            filtered = f(end);
        end
    end
end