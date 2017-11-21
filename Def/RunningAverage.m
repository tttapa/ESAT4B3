classdef RunningAverage < handle
    properties (SetAccess = private)
      counter = uint16(0);
      sum = uint32(0);
      index = uint16(1);
      length;
      buffer;
    end
       methods
          function obj = RunningAverage(length)
            assert(nargin == 1, 'Error: length argument expected');
            obj.length = length;
            obj.buffer = uint16(zeros(obj.length,1));
          end
          function reset(obj)
            obj.counter = uint16(0);
            obj.sum = uint32(0);
            obj.index = uint16(1);
            obj.buffer = uint16(zeros(obj.length,1));
          end
          function add(obj,value)
            obj.sum = obj.sum - uint32(obj.buffer(obj.index));
            obj.buffer(obj.index) = value;
            obj.sum = obj.sum + uint32(value);
            if obj.counter < obj.length
                obj.counter = obj.counter + 1;
            end
            obj.index = mod(obj.index, obj.length) + 1;
          end
          function average = getAverage(obj)
              average = double(obj.sum) / double(obj.counter);
          end
       end
end