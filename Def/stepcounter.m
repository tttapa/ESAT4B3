classdef StepCounter < handle
    properties (SetAccess = private)
        stepping = false;
        steps = uint16(0);
        highThres;
        lowThres;
    end
    methods
        function obj = StepCounter(highThres, lowThres)
            obj.highThres = highThres;
            obj.lowThres = lowThres;
        end
        function add(obj, value)
            if obj.stepping
                if value < obj.lowThres
                    obj.stepping = false;
                end
            else 
                if value > obj.highThres
                    obj.stepping = true;
                    obj.steps = obj.steps + 1;
                end
            end
        end
        function reset(obj)
            obj.steps = 0;
        end
    end
end
