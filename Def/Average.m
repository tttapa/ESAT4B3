classdef Average < handle
    properties (SetAccess = private)
      counter = 0;
      sum = 0;
    end
   methods
      function reset(obj)
          obj.counter = 0;
          obj.sum = 0;
      end
      function add(obj,value)
          if value ~= 0
              obj.sum = obj.sum + value;
              obj.counter = obj.counter + 1;
          end
      end
      function average = getAverage(obj)
          if obj.counter == 0
              average = 0;
          else
              average = obj.sum / obj.counter;
          end
      end
   end
end