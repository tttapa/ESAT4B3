
function [steps,mem_prev] = stepcounter(signal,threshold, mem_prev)                               %input: gefilterd s1 en gefilterd s2

steps = 0;
counter = 2;
total_count = length(signal) - 1;

if nargin == 2
    mem_prev = false;
end
    
while counter <= total_count
    mem_cur = signal(counter, 1);
    if mem_cur < threshold
        mem_cur = false;
    else
        mem_cur = true;
    end
    
    if mem_prev == false && mem_cur == true
        steps = steps +1;
    end
    
    mem_prev = mem_cur;
    counter = counter + 1;
end
end


