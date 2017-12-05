classdef UserData < handle
    properties
        name;
        age;
        weight;
        height;
    end
    methods
        function o = UserData(struct)
            if nargin == 1
                o.name = struct.name;
                o.age = struct.age;
                o.weight = struct.weight;
                o.height = struct.height;
            end
        end
    end
end