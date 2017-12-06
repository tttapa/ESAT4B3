classdef UserData < handle
    properties
        foldername;
        name;
        age;
        weight;
        height;
        stepGoal;
    end
    methods
        function o = UserData(struct)
            if nargin == 1
                o.foldername = struct.foldername;
                o.name = struct.name;
                o.age = struct.age;
                o.weight = struct.weight;
                o.height = struct.height;
                o.stepGoal = struct.stepGoal;
            end
        end
    end
end