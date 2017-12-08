classdef timeUNIX < handle
    properties
        timediff;
    end
    methods
        function o = timeUNIX(dummytime)
            if nargin == 1
                dummytime = int64(posixtime(dummytime));
                o.timediff = dummytime - now;
            else
                o.timediff = 0;
            end
        end
        function timeUNIX = getTime(o)
            now = int64(posixtime(datetime('now')));
            timeUNIX = now + o.timediff;
        end
    end
end